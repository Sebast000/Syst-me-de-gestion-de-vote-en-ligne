package com.vote.dao;

import com.vote.model.Candidate;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour les opérations liées à l'entité Candidate.
 */
public class CandidateDAO {

    /**
     * Ajoute un nouveau candidat à une élection spécifiée.
     * @param candidate L'objet Candidate à ajouter.
     * @return true si l'ajout a réussi, false sinon.
     * @throws SQLException En cas d'erreur de base de données.
     */
    public boolean addCandidate(Candidate candidate) throws SQLException {
        final String SQL = "INSERT INTO candidats (nom, parti, id_election) VALUES (?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL)) {
            
            ps.setString(1, candidate.getName());
            ps.setString(2, candidate.getParty());
            ps.setInt(3, candidate.getElectionId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de l'ajout du candidat: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Récupère tous les candidats pour une élection donnée.
     * @param electionId L'ID de l'élection.
     * @return Liste d'objets Candidate.
     */
    public List<Candidate> getCandidatesByElection(int electionId) throws SQLException {
        List<Candidate> candidates = new ArrayList<>();
        final String SQL = "SELECT id_candidat, nom, parti FROM candidats WHERE id_election = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL)) {
            
            ps.setInt(1, electionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Candidate c = new Candidate();
                    c.setId(rs.getInt("id_candidat"));
                    c.setElectionId(electionId);
                    c.setName(rs.getString("nom"));
                    c.setParty(rs.getString("parti"));
                    candidates.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des candidats: " + e.getMessage());
            throw e;
        }
        return candidates;
    }
}