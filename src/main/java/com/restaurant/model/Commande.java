package com.restaurant.model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "commandes")
public class Commande {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String numero;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_commande")
    private Date dateCommande;

    @Enumerated(EnumType.STRING)
    private StatutCommande statut = StatutCommande.EN_ATTENTE;

    @Column(name = "montant_total")
    private Double montantTotal = 0.0;

    // === RELATIONS ===
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id")
    private Client client;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "table_id")
    private TableRestaurant table;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "serveur_id")
    private User serveur;

    @OneToMany(mappedBy = "commande", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LigneCommande> lignes = new ArrayList<>();

    // === CONSTRUCTEURS ===
    public Commande() {
        this.dateCommande = new Date();
        this.numero = genererNumero();
    }

    public Commande(Client client, TableRestaurant table, User serveur) {
        this();
        this.client = client;
        this.table = table;
        this.serveur = serveur;
    }

    // === MÉTHODES UTILES ===
    private String genererNumero() {
        return "CMD-" + System.currentTimeMillis();
    }

    public void ajouterLigne(Plat plat, int quantite) {
        LigneCommande ligne = new LigneCommande(this, plat, quantite);
        lignes.add(ligne);
        calculerMontantTotal();
    }

    public void calculerMontantTotal() {
        this.montantTotal = 0.0;
        for (LigneCommande ligne : lignes) {
            this.montantTotal += ligne.getSousTotal();
        }
    }

    // === GETTERS & SETTERS ===
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public Date getDateCommande() { return dateCommande; }
    public void setDateCommande(Date dateCommande) { this.dateCommande = dateCommande; }

    public StatutCommande getStatut() { return statut; }
    public void setStatut(StatutCommande statut) { this.statut = statut; }

    public Double getMontantTotal() { return montantTotal; }
    public void setMontantTotal(Double montantTotal) { this.montantTotal = montantTotal; }

    public Client getClient() { return client; }
    public void setClient(Client client) { this.client = client; }

    public TableRestaurant getTable() { return table; }
    public void setTable(TableRestaurant table) { this.table = table; }

    public User getServeur() { return serveur; }
    public void setServeur(User serveur) { this.serveur = serveur; }

    public List<LigneCommande> getLignes() { return lignes; }
    public void setLignes(List<LigneCommande> lignes) { this.lignes = lignes; }

    @Override
    public String toString() {
        return "Commande{" +
                "id=" + id +
                ", numero='" + numero + '\'' +
                ", dateCommande=" + dateCommande +
                ", statut=" + statut +
                ", montantTotal=" + montantTotal +
                '}';
    }
}

