package com.vote.model;

import java.sql.Date;

/**
 * Modèle (POJO) pour représenter une Élection.
 */
public class Election {
    private int id;
    private String title;
    private String description;
    private Date startDate;
    private Date endDate;

    // Constructeur par défaut
    public Election() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
}