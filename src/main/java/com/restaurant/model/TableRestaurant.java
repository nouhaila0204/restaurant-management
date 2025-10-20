package com.restaurant.model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tables_restaurant")
public class TableRestaurant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String numero;

    @Column(nullable = false)
    private Integer capacite;

    @Enumerated(EnumType.STRING)
    private StatutTable statut = StatutTable.LIBRE;

    @OneToMany(mappedBy = "table", fetch = FetchType.LAZY)
    private List<Commande> commandes = new ArrayList<>();

    // === CONSTRUCTEURS ===
    public TableRestaurant() {}

    public TableRestaurant(String numero, Integer capacite) {
        this.numero = numero;
        this.capacite = capacite;
    }

    // === GETTERS & SETTERS ===
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public Integer getCapacite() { return capacite; }
    public void setCapacite(Integer capacite) { this.capacite = capacite; }

    public StatutTable getStatut() { return statut; }
    public void setStatut(StatutTable statut) { this.statut = statut; }

    public List<Commande> getCommandes() { return commandes; }
    public void setCommandes(List<Commande> commandes) { this.commandes = commandes; }

    // === MÉTHODES UTILES ===
    public boolean isLibre() {
        return this.statut == StatutTable.LIBRE;
    }

    public boolean isOccupee() {
        return this.statut == StatutTable.OCCUPEE;
    }

    @Override
    public String toString() {
        return "TableRestaurant{" +
                "id=" + id +
                ", numero='" + numero + '\'' +
                ", capacite=" + capacite +
                ", statut=" + statut +
                '}';
    }
}

