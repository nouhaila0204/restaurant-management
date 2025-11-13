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
    private AuthenticationService authService = new AuthenticationService();


    /**
     * Crée une nouvelle commande avec toutes les validations métier - Permission: SERVEUR
     */
    public Commande creerCommande(Long userId, Long tableId, Map<Long, Integer> platsQuantites, Long serveurId, Long clientId) {
        // Vérification permission
        if (!authService.aPermission(userId, AuthenticationService.Permission.COMMANDE_CREER)) {
            throw new RuntimeException("❌ Permission refusée : Création commande (Serveur seulement)");
        }

        // Vérifier que le serveur correspond à l'utilisateur connecté
        User utilisateurConnecte = authService.trouverUtilisateurParId(userId)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

        if (!utilisateurConnecte.getId().equals(serveurId)) {
            throw new RuntimeException("❌ Vous ne pouvez créer des commandes que pour vous-même");
        }

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

            // 3. VALIDATION CLIENT
            Client client = clientDAO.findById(clientId)
                    .orElseThrow(() -> new RuntimeException("Client non trouvé"));

            // 4. VALIDATION PLATS
            if (platsQuantites == null || platsQuantites.isEmpty()) {
                throw new RuntimeException("Une commande doit contenir au moins un plat");
            }

            // 5. CRÉATION COMMANDE
            Commande commande = new Commande();
            commande.setTable(table);
            commande.setServeur(serveur);
            commande.setClient(client); // UTILISER le client sélectionné
            commande.setMontantTotal(Double.valueOf(0.0));
            commande.setStatut(Commande.StatutCommande.EN_ATTENTE);

            // 6. SAUVEGARDE DE LA COMMANDE D'ABORD
            session.save(commande);
            session.flush();

            // 7. CRÉATION ET SAUVEGARDE DES LIGNES DE COMMANDE
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
                ligne.setQuantite(Integer.valueOf(quantite));
                ligne.setPrixUnitaire(plat.getPrix());
                ligne.setSousTotal(Double.valueOf(sousTotal));

                // Sauvegarder la ligne
                session.save(ligne);
                lignes.add(ligne);
            }

            // ASSOCIER les lignes à la commande
            commande.getLignes().addAll(lignes);

            // 8. METTRE À JOUR LA COMMANDE AVEC LE MONTANT TOTAL
            commande.setMontantTotal(Double.valueOf(montantTotal));
            session.update(commande);

            // 9. MISE À JOUR TABLE (occupée)
            table.setStatut(TableRestaurant.StatutTable.OCCUPEE);
            session.update(table);

            transaction.commit();

            System.out.println("✅ Commande créée avec succès - ID: " + commande.getId());
            System.out.println("📊 Détails: " + platsQuantites.size() + " plats, Total: " + montantTotal + " €");

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
     * Change le statut d'une commande - Permission: SERVEUR ou ADMIN
     */
    public Commande changerStatutCommande(Long userId, Long commandeId, Commande.StatutCommande nouveauStatut) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.COMMANDE_STATUT)) {
            throw new RuntimeException("❌ Permission refusée : Changement statut commande");
        }

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
     * Récupère les commandes en cours - Permission: SERVEUR ou ADMIN
     */
    public List<Commande> getCommandesEnCours(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.COMMANDE_VOIR_EN_COURS)) {
            throw new RuntimeException("❌ Permission refusée : Voir commandes en cours");
        }

        List<Commande> commandes = new ArrayList<>();
        commandes.addAll(commandeDAO.findByStatut(Commande.StatutCommande.EN_ATTENTE));
        commandes.addAll(commandeDAO.findByStatut(Commande.StatutCommande.EN_PREPARATION));

        commandes.sort((c1, c2) -> c1.getDateCommande().compareTo(c2.getDateCommande()));
        return commandes;
    }

    /**
     * Récupère les commandes du jour - Permission: SERVEUR ou ADMIN
     */
    /**
     * Récupère les commandes du jour - Permission: SERVEUR ou ADMIN
     */
    public List<Commande> getCommandesDuJour(Long userId) {
        try {
            System.out.println("🔍 CommandeService.getCommandesDuJour() appelé pour user: " + userId);

            // Vérifier la permission
            if (!authService.aPermission(userId, AuthenticationService.Permission.COMMANDE_VOIR_EN_COURS)) {
                System.err.println("❌ Permission refusée pour user: " + userId);
                return new ArrayList<>();
            }

            // CORRECTION: Utiliser FETCH JOIN pour charger les relations
            Session session = HibernateUtil.getSessionFactory().openSession();

            String hql = "SELECT c FROM Commande c " +
                    "LEFT JOIN FETCH c.table " +
                    "LEFT JOIN FETCH c.serveur " +
                    "LEFT JOIN FETCH c.client " +
                    "WHERE DATE(c.dateCommande) = CURRENT_DATE " +
                    "ORDER BY c.dateCommande DESC";

            List<Commande> commandes = session.createQuery(hql, Commande.class).list();

            session.close();

            System.out.println("✅ CommandeService.getCommandesDuJour() retourne: " + commandes.size() + " commandes");

            // DEBUG: Afficher les détails des commandes
            for (Commande cmd : commandes) {
                System.out.println("📋 Commande #" + cmd.getId() +
                        " - Numéro: " + cmd.getNumero() +
                        " - Date: " + cmd.getDateCommande() +
                        " - Statut: " + cmd.getStatut() +
                        " - Montant: " + cmd.getMontantTotal() +
                        " - Table: " + (cmd.getTable() != null ? cmd.getTable().getNumero() : "null") +
                        " - Serveur: " + (cmd.getServeur() != null ? cmd.getServeur().getNom() : "null"));
            }

            return commandes;

        } catch (Exception e) {
            System.err.println("❌ Erreur dans getCommandesDuJour: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Calcule le chiffre d'affaires du jour - Permission: ADMIN seulement
     */
    public double getChiffreAffairesDuJour(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.STATS_CHIFFRE_AFFAIRE)) {
            throw new RuntimeException("❌ Permission refusée : Voir chiffre d'affaires (Admin seulement)");
        }

        return getCommandesDuJour(userId).stream()
                .filter(c -> c.getStatut() == Commande.StatutCommande.PAYEE)
                .mapToDouble(Commande::getMontantTotal)
                .sum();
    }

    /**
     * Méthode supplémentaire pour trouver une commande par ID - Permission: SERVEUR ou ADMIN
     */
    public Commande trouverCommandeParId(Long userId, Long id) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.COMMANDE_VOIR_PAR_ID)) {
            throw new RuntimeException("❌ Permission refusée : Voir commande par ID");
        }

        return commandeDAO.findById(id)
                .orElseThrow(() -> new RuntimeException("Commande non trouvée avec l'ID: " + id));
    }

    /**
     * Ajoute un plat à une commande existante - Permission: SERVEUR
     */
    public Commande ajouterPlatACommande(Long userId, Long commandeId, Long platId, int quantite) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.COMMANDE_AJOUTER_PLAT)) {
            throw new RuntimeException("❌ Permission refusée : Ajouter plat à commande (Serveur seulement)");
        }

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

    /**
     * Récupère toutes les commandes - Permission: ADMIN seulement
     */
    public List<Commande> getToutesCommandes(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.COMMANDE_VOIR)) {
            throw new RuntimeException("❌ Permission refusée : Voir toutes les commandes (Admin seulement)");
        }
        return commandeDAO.findAll();
    }
}