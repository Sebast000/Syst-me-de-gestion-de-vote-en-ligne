package com.vote.servlets;

import java.io.IOException;
import com.vote.dao.UserDAO;
import com.vote.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

/**
 * Gère l'authentification des utilisateurs (login).
 * Mappe : /loginServlet
 */
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez entrer votre email et mot de passe.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // 1. Appel du DAO pour la connexion et la vérification BCrypt
        User user = userDAO.login(email, password);

        if (user != null) {
            // Connexion réussie
            HttpSession session = request.getSession(true); // Créer une session si elle n'existe pas
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole()); // "admin" ou "electeur"

            // Redirection en fonction du rôle
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }
        } else {
            // Échec de la connexion
            request.setAttribute("error", "Email ou mot de passe incorrect.");
            // Rediriger vers la page de login pour ré-afficher le formulaire
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}