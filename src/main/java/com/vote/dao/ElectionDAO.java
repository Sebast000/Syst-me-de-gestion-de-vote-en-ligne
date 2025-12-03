package com.vote.dao;

import com.vote.model.Election;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour les opérations liées à l'entité Election.
 */
public class ElectionDAO {

    /**
     * Ajoute une nouvelle élection à la base de données.
     * @param election L'objet Election à ajouter.
     * @return true si l'ajout a réussi, false sinon.
     * @throws SQLException En cas d'erreur de base de données.
     */
    public boolean addElection(Election election) throws SQLException {
        final String SQL = "INSERT INTO elections (titre, description, date_debut, date_fin) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL)) {
            
            ps.setString(1, election.getTitle());
            ps.setString(2, election.getDescription());
            ps.setDate(3, election.getStartDate());
            ps.setDate(4, election.getEndDate());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de l'ajout de l'élection: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Récupère toutes les élections actives (date_fin >= aujourd'hui).
     * @return Liste d'objets Election.
     */
     public List<Election> getActiveElections() throws SQLException {
        List<Election> elections = new ArrayList<>();
        // Utilisez CURDATE() ou NOW() pour comparer les dates
        final String SQL = "SELECT id_election, titre, description, date_debut, date_fin FROM elections WHERE date_fin >= CURDATE() ORDER BY date_fin ASC";
        
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SQL)) {
            
            while (rs.next()) {
                Election e = new Election();
                e.setId(rs.getInt("id_election"));
                e.setTitle(rs.getString("titre"));
                e.setDescription(rs.getString("description"));
                e.setStartDate(rs.getDate("date_debut"));
                e.setEndDate(rs.getDate("date_fin"));
                elections.add(e);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des élections: " + e.getMessage());
            throw e;
        }
        return elections;
    }
}