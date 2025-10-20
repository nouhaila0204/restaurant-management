package com.restaurant.dao;

import com.restaurant.model.Commande;
import com.restaurant.model.StatutCommande;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;

/**
 * 📋 DAO COMMANDE - Gère les commandes du restaurant
 */
public class CommandeDAO extends GenericDAO<Commande> {

    public CommandeDAO() {
        super(Commande.class);
    }

    /**
     * 📊 COMMANDES PAR STATUT - Liste les commandes selon leur statut
     * Utilisé pour : Suivi des commandes (en attente, en préparation, etc.)
     */
    public List<Commande> findByStatut(StatutCommande statut) {
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
}
