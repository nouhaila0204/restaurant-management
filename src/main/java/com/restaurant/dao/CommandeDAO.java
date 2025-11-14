package com.restaurant.dao;

import com.restaurant.model.Commande;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 📋 DAO COMMANDE - Gère les commandes du restaurant
 */
public class CommandeDAO extends GenericDAO<Commande> {

    public CommandeDAO() {
        super(Commande.class);
    }

    /**
     * 📋 TOUTES LES COMMANDES AVEC RELATIONS - Charge les commandes avec tables et serveurs
     * Utilisé pour : Affichage dans l'admin
     */
    public List<Commande> findAllWithRelations() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT DISTINCT c FROM Commande c " +
                    "LEFT JOIN FETCH c.table " +
                    "LEFT JOIN FETCH c.serveur " +
                    "LEFT JOIN FETCH c.client " +
                    "ORDER BY c.dateCommande DESC";
            Query<Commande> query = session.createQuery(hql, Commande.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 📊 COMMANDES PAR STATUT - Liste les commandes selon leur statut
     */
    public List<Commande> findByStatut(Commande.StatutCommande statut) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Commande c WHERE c.statut = :statut ORDER BY c.dateCommande";
            Query<Commande> query = session.createQuery(hql, Commande.class);
            query.setParameter("statut", statut);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 🔢 COMMANDES RÉCENTES - Les dernières commandes
     * Utilisé pour : Dashboard, suivi en temps réel
     */
    public List<Commande> findCommandesRecentes(int limit) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Commande c ORDER BY c.dateCommande DESC";
            Query<Commande> query = session.createQuery(hql, Commande.class);
            query.setMaxResults(limit);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 👤 COMMANDES PAR CLIENT - Historique des commandes d'un client
     * Utilisé pour : Fidélisation, historique client
     */
    public List<Commande> findByClient(Long clientId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Commande c WHERE c.client.id = :clientId ORDER BY c.dateCommande DESC";
            Query<Commande> query = session.createQuery(hql, Commande.class);
            query.setParameter("clientId", clientId);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 📅 COMMANDES DU JOUR - Commandes de la journée en cours
     * Utilisé pour : Chiffre d'affaires du jour, statistiques
     */
    public List<Commande> findCommandesDuJour() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Commande c WHERE DATE(c.dateCommande) = CURRENT_DATE ORDER BY c.dateCommande DESC";
            Query<Commande> query = session.createQuery(hql, Commande.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 💰 CHIFFRE D'AFFAIRE TOTAL - Somme de tous les montants totaux des commandes
     * Utilisé pour : Dashboard admin, statistiques financières
     */
    public Double getChiffreAffaireTotal() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT SUM(c.montantTotal) FROM Commande c WHERE c.montantTotal IS NOT NULL";
            Query<Double> query = session.createQuery(hql, Double.class);
            Double result = query.uniqueResult();
            return result != null ? result : 0.0;
        } finally {
            session.close();
        }
    }

    /**
     * 📈 CHIFFRE D'AFFAIRE PAR PÉRIODE - CA entre deux dates
     * Utilisé pour : Statistiques par période
     */
    public Double getChiffreAffaireParPeriode(java.sql.Date dateDebut, java.sql.Date dateFin) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT SUM(c.montantTotal) FROM Commande c " +
                    "WHERE c.dateCommande BETWEEN :dateDebut AND :dateFin " +
                    "AND c.montantTotal IS NOT NULL";
            Query<Double> query = session.createQuery(hql, Double.class);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            Double result = query.uniqueResult();
            return result != null ? result : 0.0;
        } finally {
            session.close();
        }
    }

    /**
     * 📊 NOMBRE DE COMMANDES PAR STATUT - Comptage groupé par statut
     * Utilisé pour : Dashboard, suivi des commandes
     */
    public Map<String, Long> getCommandesCountByStatus() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT c.statut, COUNT(c) FROM Commande c GROUP BY c.statut";
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            List<Object[]> results = query.list();

            Map<String, Long> stats = new HashMap<>();
            for (Object[] result : results) {
                Commande.StatutCommande statut = (Commande.StatutCommande) result[0];
                Long count = (Long) result[1];
                stats.put(statut.name(), count);
            }
            return stats;
        } finally {
            session.close();
        }
    }

    public Long countAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT COUNT(c) FROM Commande c";
            Query<Long> query = session.createQuery(hql, Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            session.close();
        }
    }
}