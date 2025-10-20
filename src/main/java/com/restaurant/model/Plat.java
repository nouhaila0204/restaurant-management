package com.restaurant.model;

import javax.persistence.*;

@Entity
@Table(name = "plats")
public class Plat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom;

    private String description;

    @Column(nullable = false)
    private Double prix;

    private String image;

    @Column(name = "disponible")
    private boolean disponible = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categorie_id")
    private Categorie categorie;

    // === CONSTRUCTEURS ===
    public Plat() {}

    public Plat(String nom, String description, Double prix, Categorie categorie) {
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.categorie = categorie;
    }

    // === GETTERS & SETTERS ===
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Double getPrix() { return prix; }
    public void setPrix(Double prix) { this.prix = prix; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public boolean isDisponible() { return disponible; }
    public void setDisponible(boolean disponible) { this.disponible = disponible; }

    public Categorie getCategorie() { return categorie; }
    public void setCategorie(Categorie categorie) { this.categorie = categorie; }

    // === MÉTHODES UTILES ===
    @Override
    public String toString() {
        return "Plat{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prix=" + prix +
                ", disponible=" + disponible +
                '}';
    }
}