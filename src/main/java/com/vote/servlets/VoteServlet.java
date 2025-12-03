package com.vote.servlets;

import com.vote.dao.VoteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Gère l'enregistrement du vote d'un utilisateur.
 * Mappe : /voteServlet
 */
public class VoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private VoteDAO voteDAO = new VoteDAO(); 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // 1. Vérification de session et d'authentification
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Récupération sécurisée de l'ID utilisateur
        Object userIdObj = session.getAttribute("userId");
        int userId = 0;
        try {
             userId = (Integer) userIdObj; 
        } catch (ClassCastException | NullPointerException e) {
            // Si userId n'est pas un Integer ou est null (bien que le test initial soit là)
            response.sendRedirect("login.jsp"); 
            return;
        }
        
        String idCandidatParam = request.getParameter("id_candidat_selected");
        String idElectionParam = request.getParameter("id_election"); // Requis par la JSP

        // 2. Validation des paramètres
        if (idCandidatParam == null || idCandidatParam.isEmpty() || idElectionParam == null || idElectionParam.isEmpty()) {
            request.setAttribute("error", "Erreur de sélection: Veuillez sélectionner un candidat.");
            request.getRequestDispatcher("vote.jsp").forward(request, response);
            return;
        }
        
        try {
            int idCandidat = Integer.parseInt(idCandidatParam);
            // int idElection = Integer.parseInt(idElectionParam); // Non utilisé ici mais important pour la vérification JSP
            
            // 3. Appel du DAO pour l'enregistrement du vote
            // L'ID de l'élection est récupéré par le DAO via l'ID du candidat
            boolean success = voteDAO.recordVote(userId, idCandidat); 

            if (success) {
                // ********* CORRECTION CLÉ ICI : Utilisation de FORWARD et de l'attribut de REQUÊTE *********
                request.setAttribute("voteSuccess", "Votre vote a été enregistré avec succès !");
                
                // Le RequestDispatcher exécute dashboard.jsp sans nouvelle requête HTTP,
                // garantissant que l'attribut est disponible.
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
                return;
                // *****************************************************************************************
            } else {
                // Échec si DAO.recordVote retourne false (devrait être rare)
                request.setAttribute("error", "Erreur lors de l'enregistrement du vote. Veuillez réessayer.");
                request.getRequestDispatcher("vote.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID candidat invalide.");
            request.getRequestDispatcher("vote.jsp").forward(request, response);
            return;
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            // Gestion des erreurs de base de données (ex: violation de contrainte UNIQUE = double vote)
            String errorMessage = "Erreur de base de données. Vous avez peut-être déjà voté pour cette élection.";
            if (e.getMessage() != null && (e.getMessage().contains("Duplicate entry") || e.getMessage().contains("UNIQUE constraint failed"))) {
                errorMessage = "Vous avez déjà soumis un vote pour cette élection.";
            }
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("vote.jsp").forward(request, response);
            return;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Rediriger les requêtes GET vers la page de vote
        response.sendRedirect("vote.jsp"); 
    }
}