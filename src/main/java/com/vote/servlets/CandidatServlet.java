package com.vote.servlets;

import com.vote.dao.CandidateDAO;
import com.vote.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Gère l'ajout d'un nouveau candidat.
 * Mappe : /addCandidate
 */
public class CandidatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CandidateDAO candidateDAO = new CandidateDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Vérification de sécurité (Admin seulement)
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Récupération des paramètres
        String nom = request.getParameter("nom");
        String parti = request.getParameter("parti");
        String idElectionParam = request.getParameter("id_election");
        
        // Validation basique
        if (nom == null || nom.trim().isEmpty() || idElectionParam == null || idElectionParam.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs (Nom et Élection).");
            request.getRequestDispatcher("addCandidate.jsp").forward(request, response);
            return;
        }

        try {
            int idElection = Integer.parseInt(idElectionParam);
            
            // 1. Création de l'objet Modèle
            Candidate candidate = new Candidate();
            candidate.setName(nom);
            candidate.setParty(parti);
            candidate.setElectionId(idElection);

            // 2. Appel du DAO pour la persistance
            boolean success = candidateDAO.addCandidate(candidate);

            if (success) {
                
            	
                request.setAttribute("success", "Le candidat '" + nom + "' a été ajouté avec succès.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response); 
           
            } else {
               
                request.setAttribute("error", "Erreur lors de l'ajout du candidat. Veuillez réessayer.");
                request.getRequestDispatcher("addCandidate.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID d'élection invalide.");
            request.getRequestDispatcher("addCandidate.jsp").forward(request, response);
        } catch (SQLException e) {


            System.err.println("SQL Error: " + e.getMessage());
            request.setAttribute("error", "Erreur de base de données : L'élection spécifiée est peut-être invalide ou déjà fermée.");
            request.getRequestDispatcher("addCandidate.jsp").forward(request, response);
        }
    }
}