package com.vote.model;

/**
 * Modèle (POJO) pour représenter un Utilisateur.
 * Rôle: "admin" ou "electeur".
 */
public class User {
    private int id;
    private String name;
    private String email;
    private String hashedPassword; // Stocke le mot de passe HACHÉ
    private String role; // admin ou electeur

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getHashedPassword() { return hashedPassword; }
    // NOTE: Pour la sécurité, on utilise un setter pour le hachage uniquement
    public void setHashedPassword(String hashedPassword) { this.hashedPassword = hashedPassword; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    // Ancien setter 'setPassword' retiré pour forcer l'utilisation de HASHEDPassword
}