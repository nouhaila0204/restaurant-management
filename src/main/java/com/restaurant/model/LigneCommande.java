package com.restaurant.model;

import javax.persistence.*;

@Entity
@Table(name = "lignes_commande")
public class LigneCommande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer quantite;

    @Column(name = "prix_unitaire", nullable = false)
    private Double prixUnitaire;

    @Column(name = "sous_total", nullable = false)
    private Double sousTotal;

    // === RELATIONS ===
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plat_id", nullable = false)
    private Plat plat;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "commande_id", nullable = false)
    private Commande commande;

    // === CONSTRUCTEURS ===
    public LigneCommande() {}

    public LigneCommande(Commande commande, Plat plat, Integer quantite) {
        this.commande = commande;
        this.plat = plat;
        this.quantite = quantite;
        this.prixUnitaire = plat.getPrix();
        this.sousTotal = prixUnitaire * quantite;
    }

    // === GETTERS & SETTERS ===
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Integer getQuantite() { return quantite; }
    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
        calculerSousTotal();
    }

    public Double getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(Double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
        calculerSousTotal();
    }

    public Double getSousTotal() { return sousTotal; }
    public void setSousTotal(Double sousTotal) { this.sousTotal = sousTotal; }

    public Plat getPlat() { return plat; }
    public void setPlat(Plat plat) {
        this.plat = plat;
        if (plat != null) {
            this.prixUnitaire = plat.getPrix();
            calculerSousTotal();
        }
    }

    public Commande getCommande() { return commande; }
    public void setCommande(Commande commande) { this.commande = commande; }

    // === MÉTHODES UTILES ===
    private void calculerSousTotal() {
        if (this.prixUnitaire != null && this.quantite != null) {
            this.sousTotal = this.prixUnitaire * this.quantite;
        }
    }

    @Override
    public String toString() {
        return "LigneCommande{" +
                "id=" + id +
                ", plat=" + (plat != null ? plat.getNom() : "null") +
                ", quantite=" + quantite +
                ", sousTotal=" + sousTotal +
                '}';
    }
}
