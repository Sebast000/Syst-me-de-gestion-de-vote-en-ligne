package com.vote.dao;

import java.sql.*;

/**
 * DAO pour les opérations liées aux Votes.
 */
public class VoteDAO {

    /**
     * Enregistre un vote pour un utilisateur et un candidat donnés.
     * @param userId L'ID de l'utilisateur votant.
     * @param candidateId L'ID du candidat sélectionné.
     * @return true si le vote a été enregistré, false sinon.
     * @throws SQLException En cas d'erreur de base de données.
     */
    public boolean recordVote(int userId, int candidateId) throws SQLException {
        final String SQL = 
            "INSERT INTO votes (id_utilisateur, id_candidat, id_election) " +
            "VALUES (?, ?, (SELECT id_election FROM candidats WHERE id_candidat = ?))"; 
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, candidateId);
            ps.setInt(3, candidateId); // Utilisé pour récupérer l'ID de l'élection
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de l'enregistrement du vote: " + e.getMessage());
            throw e; // L'exception est relancée et capturée par le VoteServlet
        }
    }
    
    // Le reste du code (hasUserVoted) n'est pas utilisé directement par le servlet, 
    // mais est conservé si vous en avez besoin ailleurs.
}