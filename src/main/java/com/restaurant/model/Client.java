package com.restaurant.model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "clients")
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom;

    private String telephone;

    private String email;

    @OneToMany(mappedBy = "client", fetch = FetchType.LAZY)
    private List<Commande> commandes = new ArrayList<>();

    // === CONSTRUCTEURS ===
    public Client() {}

    public Client(String nom, String telephone, String email) {
        this.nom = nom;
        this.telephone = telephone;
        this.email = email;
    }

    // === GETTERS & SETTERS ===
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public List<Commande> getCommandes() { return commandes; }
    public void setCommandes(List<Commande> commandes) { this.commandes = commandes; }

    @Override
    public String toString() {
        return "Client{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", telephone='" + telephone + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}