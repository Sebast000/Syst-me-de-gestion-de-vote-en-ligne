package com.vote.servlets;

import com.vote.dao.ElectionDAO;
import com.vote.model.Election;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

/**
 * Gère l'ajout d'une nouvelle élection.
 * Mappe : /addElection
 */
public class ElectionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ElectionDAO electionDAO = new ElectionDAO();

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
        String titre = request.getParameter("titre");
        String description = request.getParameter("description");
        String dateDebutParam = request.getParameter("date_debut");
        String dateFinParam = request.getParameter("date_fin");
        
        // Validation basique
        if (titre == null || titre.trim().isEmpty() || dateDebutParam == null || dateFinParam == null) {
            request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
            request.getRequestDispatcher("addElection.jsp").forward(request, response);
            return;
        }

        try {
            // Conversion des String en Date SQL
            Date dateDebut = Date.valueOf(dateDebutParam);
            Date dateFin = Date.valueOf(dateFinParam);
            
            // 1. Création de l'objet Modèle
            Election election = new Election();
            election.setTitle(titre);
            election.setDescription(description);
            election.setStartDate(dateDebut);
            election.setEndDate(dateFin);

            // 2. Appel du DAO pour la persistance
            boolean success = electionDAO.addElection(election);

            if (success) {
           
            	
                request.setAttribute("success", "L'élection '" + titre + "' a été ajoutée avec succès !");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);


            } else {
                request.setAttribute("error", "Erreur lors de l'ajout de l'élection. Réessayez.");
                request.getRequestDispatcher("addElection.jsp").forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Format de date invalide. Utilisez YYYY-MM-DD.");
            request.getRequestDispatcher("addElection.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            request.setAttribute("error", "Erreur de base de données : Problème lors de l'insertion.");
            request.getRequestDispatcher("addElection.jsp").forward(request, response);
        }
    }
}