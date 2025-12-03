package com.vote.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe utilitaire pour la gestion de la connexion à la base de données.
 * Utilise les constantes fournies par l'utilisateur.
 */
public class DBConnection {
    // Les informations de connexion peuvent rester statiques (final)
    private static final String URL = "jdbc:mysql://localhost:3306/vote_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        // Enregistrement du driver une seule fois au chargement de la classe
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("Driver MySQL non trouvé. Vérifiez le JAR dans WEB-INF/lib.");
            e.printStackTrace();
            // On pourrait lancer une RuntimeException ici si l'application ne peut pas démarrer sans driver
        }
    }

    /**
     * Retourne une NOUVELLE connexion à la base de données.
     * @return Connection une nouvelle connexion ouverte.
     * @throws SQLException si une erreur de base de données survient.
     */
    public static Connection getConnection() throws SQLException {
        // On ne gère plus Class.forName() dans cette méthode, car il est géré dans le bloc static.
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}