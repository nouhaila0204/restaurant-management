package com.restaurant.dao;

import com.restaurant.model.Categorie;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;
import java.util.Optional;

/**
 * 📂 DAO CATÉGORIE - Gère les catégories de plats
 */
public class CategorieDAO extends GenericDAO<Categorie> {

    public CategorieDAO() {
        super(Categorie.class);
    }

    /**
     * 🔍 TROUVER PAR NOM - Recherche une catégorie par son nom
     * Utilisé pour : Éviter les doublons, recherche rapide
     */
    public Optional<Categorie> findByNom(String nom) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Categorie c WHERE c.nom = :nom";
            Query<Categorie> query = session.createQuery(hql, Categorie.class);
            query.setParameter("nom", nom);
            return query.uniqueResultOptional();
        } finally {
            session.close();
        }
    }

    /**
     * 📊 CATÉGORIES AVEC PLATS - Liste les catégories qui ont des plats
     * Utilisé pour : Menu dynamique (ne montrer que les catégories non vides)
     */
    public List<Categorie> findCategoriesAvecPlats() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT DISTINCT c FROM Categorie c JOIN c.plats p WHERE p.disponible = true";
            Query<Categorie> query = session.createQuery(hql, Categorie.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 📋 TOUTES LES CATÉGORIES AVEC LEURS PLATS - Charge les catégories avec leurs plats associés
     * Utilisé pour : Dashboard admin, gestion des catégories
     */
    public List<Categorie> findAllWithPlats() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            // Utilisation de JOIN FETCH pour charger les plats en une seule requête
            String hql = "SELECT DISTINCT c FROM Categorie c LEFT JOIN FETCH c.plats ORDER BY c.nom";
            Query<Categorie> query = session.createQuery(hql, Categorie.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 🔍 CATÉGORIE AVEC PLATS PAR ID - Charge une catégorie spécifique avec ses plats
     * Utilisé pour : Édition de catégorie, vérification avant suppression
     */
    public Optional<Categorie> findByIdWithPlats(Long id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT c FROM Categorie c LEFT JOIN FETCH c.plats WHERE c.id = :id";
            Query<Categorie> query = session.createQuery(hql, Categorie.class);
            query.setParameter("id", id);
            return query.uniqueResultOptional();
        } finally {
            session.close();
        }
    }


}