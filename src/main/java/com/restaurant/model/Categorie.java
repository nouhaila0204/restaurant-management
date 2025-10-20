package com.restaurant.model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "categories")
public class Categorie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String nom;

    private String description;

    @OneToMany(mappedBy = "categorie", fetch = FetchType.EAGER)
    private List<Plat> plats = new ArrayList<>();

    // === CONSTRUCTEURS ===
    public Categorie() {}

    public Categorie(String nom, String description) {
        this.nom = nom;
        this.description = description;
    }

    // === GETTERS & SETTERS ===
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Plat> getPlats() { return plats; }
    public void setPlats(List<Plat> plats) { this.plats = plats; }

    // === MÉTHODES UTILES ===
    @Override
    public String toString() {
        return "Categorie{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
