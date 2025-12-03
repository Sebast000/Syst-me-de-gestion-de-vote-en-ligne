package com.vote.dao;

import java.sql.*;
import com.vote.model.User;
import org.mindrot.jbcrypt.BCrypt; // **NÉCESSITE LA LIBRAIRIE jBCrypt DANS VOTRE PROJET**

/**
 * DAO pour les opérations liées à l'entité User (Inscription, Connexion).
 */
public class UserDAO {

    /**
     * Enregistre un nouvel utilisateur. Hache le mot de passe avant insertion.
     * @param user L'objet User (avec le mot de passe en clair dans son setter temporaire).
     * @param plainPassword Le mot de passe en clair soumis par l'utilisateur.
     * @return true si l'insertion a réussi, false sinon.
     * @throws SQLException Si une erreur SQL (par exemple, email dupliqué) survient.
     */
    public boolean registerUser(User user, String plainPassword) throws SQLException {
        // Hachage du mot de passe
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

        // Requête standard pour votre table (ajustée aux colonnes fournies dans RegisterServlet)
        final String SQL = "INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role) VALUES (?, ?, ?, ?, ?)";
        
        // Utilisation du try-with-resources pour fermer automatiquement Connection et PreparedStatement
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL)) {
            
            // NOTE: Votre RegisterServlet utilise 'nom' et 'prenom'
            // Assurez-vous que votre modèle User a aussi 'prenom' si nécessaire,
            // sinon il faut modifier le RegisterServlet. Ici, on utilise nom + email + hachage.
            ps.setString(1, user.getName());
            ps.setString(2, user.getName()); // Simuler le prénom (ou changer le modèle/servlet)
            ps.setString(3, user.getEmail());
            ps.setString(4, hashedPassword); // Sauvegarde du mot de passe haché
            ps.setString(5, "electeur"); // Rôle par défaut
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            // Log de l'erreur SQL
            System.err.println("Erreur SQL lors de l'enregistrement de l'utilisateur: " + e.getMessage());
            throw e; // Renvoyer l'exception pour la gérer dans le Servlet (ex: email dupliqué)
        }
    }

    /**
     * Tente de connecter un utilisateur.
     * @param email Email de l'utilisateur.
     * @param plainPassword Mot de passe en clair.
     * @return L'objet User s'il est authentifié, sinon null.
     */
    public User login(String email, String plainPassword) {
        User user = null;
        // La colonne 'mot_de_passe' contient le hachage. On ne compare plus directement.
        final String SQL = "SELECT id_utilisateur, nom, email, mot_de_passe, role FROM utilisateurs WHERE email=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("mot_de_passe");
                    
                    // 1. Vérifier si le mot de passe en clair correspond au hachage stocké
                    if (BCrypt.checkpw(plainPassword, storedHash)) {
                        user = new User();
                        user.setId(rs.getInt("id_utilisateur"));
                        user.setName(rs.getString("nom"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        // NOTE: On ne stocke jamais le mot de passe dans l'objet User après login
                    }
                }
            } // rs est fermé
        } catch (Exception e) {
            System.err.println("Erreur lors de la tentative de connexion: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }
}