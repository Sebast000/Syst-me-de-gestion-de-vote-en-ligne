package com.vote.servlets;

import com.vote.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Gère l'affichage des résultats du vote (pour tous).
 * Mappe : /results
 * NOTE: La logique de ce servlet est de récupérer les résultats et de les 
 * mettre en attribut pour que results.jsp puisse les afficher proprement.
 */
public class ResultServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Requête SQL pour obtenir le nombre de votes par candidat et par élection
        final String SQL = 
            "SELECT e.titre AS election_titre, c.nom AS candidat_nom, c.parti, COUNT(v.id_vote) AS votes " +
            "FROM candidats c " +
            "JOIN elections e ON c.id_election = e.id_election " +
            "LEFT JOIN votes v ON c.id_candidat = v.id_candidat " +
            "GROUP BY e.titre, c.nom, c.parti " +
            "ORDER BY e.titre, votes DESC";
        
        // Structure pour stocker les résultats: Map<Titre Election, List<Map<CandidatInfo>>>
        Map<String, List<Map<String, Object>>> resultsByElection = new HashMap<>();

        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SQL)) {

            while (rs.next()) {
                String electionTitle = rs.getString("election_titre");
                
                // Informations du candidat et de son score
                Map<String, Object> candidateResult = new HashMap<>();
                candidateResult.put("nom", rs.getString("candidat_nom"));
                candidateResult.put("parti", rs.getString("parti"));
                candidateResult.put("votes", rs.getInt("votes"));
                
                // Initialiser la liste pour cette élection si elle n'existe pas
                resultsByElection.computeIfAbsent(electionTitle, k -> new ArrayList<>())
                                 .add(candidateResult);
            }

            // Mettre les résultats en attribut de requête pour la page JSP
            request.setAttribute("resultsByElection", resultsByElection);
            
            // Dispatcher vers la page JSP pour l'affichage (pas de redirection)
            request.getRequestDispatcher("results.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des résultats: " + e.getMessage());
            request.setAttribute("error", "Erreur de base de données : Impossible de charger les résultats.");
            request.getRequestDispatcher("results.jsp").forward(request, response);
        }
    }
}