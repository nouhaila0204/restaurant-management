package com.restaurant.service;

import com.restaurant.dao.*;
import com.restaurant.model.*;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.restaurant.util.HibernateUtil;

import java.util.*;

/**
 * 📋 Service de gestion des commandes - CŒUR du métier restaurant
 */
public class CommandeService {
    private CommandeDAO commandeDAO = new CommandeDAO();
    private TableRestaurantDAO tableDAO = new TableRestaurantDAO();
    private PlatDAO platDAO = new PlatDAO();
    private ClientDAO clientDAO = new ClientDAO();
    private UserDAO userDAO = new UserDAO();

    /**
     * Crée une nouvelle commande avec toutes les validations métier - VERSION CORRIGÉE
     */
    public Commande creerCommande(Long tableId, Map<Long, Integer> platsQuantites, Long serveurId) {
        Transaction transaction = null;
        Session session = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            // 1. VALIDATION TABLE
            TableRestaurant table = tableDAO.findById(tableId)
                    .orElseThrow(() -> new RuntimeException("Table non trouvée"));

            if (!table.isLibre()) {
                throw new RuntimeException("La table " + table.getNumero() + " est déjà occupée");
            }

            // 2. VALIDATION SERVEUR
            User serveur = userDAO.findById(serveurId)
                    .orElseThrow(() -> new RuntimeException("Serveur non trouvé"));

            if (serveur.getRole() != User.RoleUser.SERVEUR) {
                throw new RuntimeException("L'utilisateur n'est pas un serveur");
            }

            // 3. VALIDATION PLATS
            if (platsQuantites == null || platsQuantites.isEmpty()) {
                throw new RuntimeException("Une commande doit contenir au moins un plat");
            }

            // 4. CRÉATION COMMANDE
            Commande commande = new Commande();
            commande.setTable(table);
            commande.setServeur(serveur);
            commande.setClient(clientDAO.findById(1L).orElse(null));
            commande.setMontantTotal(Double.valueOf(0.0)); // ✅ Correction: Double au lieu de double
            commande.setStatut(Commande.StatutCommande.EN_ATTENTE);

            // 5. SAUVEGARDE DE LA COMMANDE D'ABORD
            session.save(commande);
            session.flush();

            // 6. CRÉATION ET SAUVEGARDE DES LIGNES DE COMMANDE
            double montantTotal = 0;
            List<LigneCommande> lignes = new ArrayList<>();

            for (Map.Entry<Long, Integer> entry : platsQuantites.entrySet()) {
                Plat plat = platDAO.findById(entry.getKey())
                        .orElseThrow(() -> new RuntimeException("Plat non trouvé - ID: " + entry.getKey()));

                if (!plat.isDisponible()) {
                    throw new RuntimeException("Le plat '" + plat.getNom() + "' n'est pas disponible");
                }

                int quantite = entry.getValue();
                if (quantite <= 0) {
                    throw new RuntimeException("Quantité invalide pour le plat '" + plat.getNom() + "'");
                }

                // Calcul du sous-total
                double sousTotal = plat.getPrix() * quantite;
                montantTotal += sousTotal;

                // Création de la ligne de commande
                LigneCommande ligne = new LigneCommande();
                ligne.setCommande(commande);
                ligne.setPlat(plat);
                ligne.setQuantite(Integer.valueOf(quantite)); // ✅ Correction: Integer au lieu de int
                ligne.setPrixUnitaire(plat.getPrix());
                ligne.setSousTotal(Double.valueOf(sousTotal)); // ✅ Correction: Double au lieu de double

                // Sauvegarder la ligne
                session.save(ligne);
                lignes.add(ligne);
            }

            // ✅ CORRECTION : ASSOCIER les lignes à la commande
            commande.getLignes().addAll(lignes);

            // 7. METTRE À JOUR LA COMMANDE AVEC LE MONTANT TOTAL
            commande.setMontantTotal(Double.valueOf(montantTotal)); // ✅ Correction: Double au lieu de double
            session.update(commande);

            // 8. MISE À JOUR TABLE (occupée)
            table.setStatut(TableRestaurant.StatutTable.OCCUPEE);
            session.update(table);

            transaction.commit();
            return commande;

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur création commande: " + e.getMessage(), e);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Change le statut d'une commande - MÉTHODE MANQUANTE
     */
    public Commande changerStatutCommande(Long commandeId, Commande.StatutCommande nouveauStatut) {
        Transaction transaction = null;
        Session session = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            Commande commande = commandeDAO.findById(commandeId)
                    .orElseThrow(() -> new RuntimeException("Commande non trouvée"));

            // Validation transition de statut
            if (nouveauStatut == Commande.StatutCommande.PAYEE) {
                // Libérer la table quand la commande est payée
                TableRestaurant table = commande.getTable();
                table.setStatut(TableRestaurant.StatutTable.LIBRE);
                session.update(table);
            }

            commande.setStatut(nouveauStatut);
            session.update(commande);

            transaction.commit();
            return commande;

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur changement statut: " + e.getMessage(), e);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère les commandes en cours
     */
    public List<Commande> getCommandesEnCours() {
        List<Commande> commandes = new ArrayList<>();
        commandes.addAll(commandeDAO.findByStatut(Commande.StatutCommande.EN_ATTENTE));
        commandes.addAll(commandeDAO.findByStatut(Commande.StatutCommande.EN_PREPARATION));

        commandes.sort((c1, c2) -> c1.getDateCommande().compareTo(c2.getDateCommande()));
        return commandes;
    }

    /**
     * Récupère les commandes du jour
     */
    public List<Commande> getCommandesDuJour() {
        return commandeDAO.findCommandesDuJour();
    }

    /**
     * Calcule le chiffre d'affaires du jour
     */
    public double getChiffreAffairesDuJour() {
        return getCommandesDuJour().stream()
                .filter(c -> c.getStatut() == Commande.StatutCommande.PAYEE)
                .mapToDouble(Commande::getMontantTotal)
                .sum();
    }

    /**
     * Méthode supplémentaire pour trouver une commande par ID
     */
    public Commande trouverCommandeParId(Long id) {
        return commandeDAO.findById(id)
                .orElseThrow(() -> new RuntimeException("Commande non trouvée avec l'ID: " + id));
    }

    /**
     * Ajoute un plat à une commande existante
     */
    /**
     * Ajoute un plat à une commande existante - VERSION CORRIGÉE
     */
    public Commande ajouterPlatACommande(Long commandeId, Long platId, int quantite) {
        Transaction transaction = null;
        Session session = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            // ⭐ CORRECTION : Charger la commande AVEC les lignes (FETCH JOIN)
            String hql = "SELECT c FROM Commande c LEFT JOIN FETCH c.lignes WHERE c.id = :commandeId";
            Commande commande = session.createQuery(hql, Commande.class)
                    .setParameter("commandeId", commandeId)
                    .uniqueResultOptional()
                    .orElseThrow(() -> new RuntimeException("Commande non trouvée"));

            Plat plat = platDAO.findById(platId)
                    .orElseThrow(() -> new RuntimeException("Plat non trouvé"));

            if (!plat.isDisponible()) {
                throw new RuntimeException("Le plat '" + plat.getNom() + "' n'est pas disponible");
            }

            // Vérifier si le plat existe déjà dans la commande
            boolean platExisteDeja = false;
            for (LigneCommande ligne : commande.getLignes()) {
                if (ligne.getPlat().getId().equals(platId)) {
                    ligne.setQuantite(Integer.valueOf(ligne.getQuantite() + quantite));
                    ligne.calculerSousTotal();
                    session.update(ligne);
                    platExisteDeja = true;
                    break;
                }
            }

            // Si nouveau plat, créer une nouvelle ligne
            if (!platExisteDeja) {
                LigneCommande nouvelleLigne = new LigneCommande();
                nouvelleLigne.setCommande(commande);
                nouvelleLigne.setPlat(plat);
                nouvelleLigne.setQuantite(Integer.valueOf(quantite));
                nouvelleLigne.setPrixUnitaire(plat.getPrix());
                nouvelleLigne.calculerSousTotal();

                session.save(nouvelleLigne);
                commande.getLignes().add(nouvelleLigne);
            }

            // Recalculer le montant total
            commande.calculerMontantTotal();
            session.update(commande);

            transaction.commit();
            return commande;

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw new RuntimeException("Erreur ajout plat: " + e.getMessage(), e);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}