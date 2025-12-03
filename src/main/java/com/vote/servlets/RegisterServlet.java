package com.vote.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

import com.vote.dao.UserDAO;
import com.vote.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

/**
 * Gère l'inscription des nouveaux utilisateurs.
 * Mappe : /registerServlet
 */
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom"); // Non utilisé par le DAO mis à jour, mais conservé pour cohérence
        String email = request.getParameter("email");
        String password = request.getParameter("password"); 

        if (nom == null || email == null || password == null || nom.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 1. Création de l'objet Modèle
        User newUser = new User();
        newUser.setName(nom + " " + prenom); // Concaténation Nom + Prénom
        newUser.setEmail(email);
        newUser.setRole("electeur");

        try {
            // 2. Appel du DAO pour l'enregistrement (qui gère le hachage Bcrypt)
            boolean success = userDAO.registerUser(newUser, password);

            if (success) {
                request.setAttribute("success", "Compte créé avec succès ! Veuillez vous connecter.");
                response.sendRedirect("login.jsp"); // Redirection vers login pour éviter le double POST
            } else {
                 request.setAttribute("error", "Échec de l'inscription. Réessayez.");
                 request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch(SQLIntegrityConstraintViolationException e) {
             // Gestion spécifique si l'email existe déjà (clé unique)
             request.setAttribute("error", "Erreur : Cet email est déjà utilisé.");
             request.getRequestDispatcher("register.jsp").forward(request, response);
        } catch(SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            request.setAttribute("error", "Erreur de base de données lors de l'inscription. Vérifiez la structure de votre table.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } catch(Exception e) {
            // Gérer les autres exceptions (ex: erreur BCrypt)
            e.printStackTrace();
            request.setAttribute("error", "Une erreur inattendue est survenue.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}