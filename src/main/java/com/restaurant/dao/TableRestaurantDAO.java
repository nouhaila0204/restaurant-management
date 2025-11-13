package com.restaurant.dao;

import com.restaurant.model.TableRestaurant;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;
import java.util.Optional;

/**
 * 🪑 DAO TABLE - Gère les tables du restaurant
 */
public class TableRestaurantDAO extends GenericDAO<TableRestaurant> {

    public TableRestaurantDAO() {
        super(TableRestaurant.class);
    }

    /**
     * 📊 TABLES PAR STATUT - Liste les tables selon leur statut
     * Utilisé pour : Voir les tables libres/occupées, gestion du service
     */
    public List<TableRestaurant> findByStatut(TableRestaurant.StatutTable statut) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM TableRestaurant t WHERE t.statut = :statut ORDER BY t.numero";
            Query<TableRestaurant> query = session.createQuery(hql, TableRestaurant.class);
            query.setParameter("statut", statut);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 📊 TOUTES LES TABLES TRIÉES - Liste toutes les tables triées par numéro
     * Utilisé pour : Affichage complet de la gestion des tables
     */
    public List<TableRestaurant> findAllOrdered() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM TableRestaurant t ORDER BY t.numero";
            Query<TableRestaurant> query = session.createQuery(hql, TableRestaurant.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * ✅ TABLES LIBRES - Liste seulement les tables disponibles
     * Utilisé pour : Attribution de table à une nouvelle commande
     */
    public List<TableRestaurant> findTablesLibres() {
        return findByStatut(TableRestaurant.StatutTable.LIBRE);
    }

    /**
     * 🔢 TROUVER PAR NUMÉRO - Recherche rapide d'une table
     * Utilisé pour : Navigation rapide, vérification disponibilité
     */
    public Optional<TableRestaurant> findByNumero(String numero) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM TableRestaurant t WHERE t.numero = :numero";
            Query<TableRestaurant> query = session.createQuery(hql, TableRestaurant.class);
            query.setParameter("numero", numero);
            return query.uniqueResultOptional();
        } finally {
            session.close();
        }
    }
}