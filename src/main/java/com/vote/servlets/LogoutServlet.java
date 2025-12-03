package com.vote.servlets;

import java.io.IOException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Gère la déconnexion de l'utilisateur.
 * Mappe : /logout
 * NOTE: Normalement, le logout.jsp suffit, mais ce servlet est plus propre.
 */
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false); // Récupérer la session existante, ne pas en créer
        
        if (session != null) {
            session.invalidate(); // Invalider la session
        }
        
        // Rediriger vers la page de connexion (ou la page d'accueil par défaut)
        response.sendRedirect("login.jsp");
    }
}