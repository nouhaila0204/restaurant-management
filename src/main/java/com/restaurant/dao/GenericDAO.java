package com.restaurant.dao;

import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;
import java.util.Optional;

/**
 * ⭐ DAO GÉNÉRIQUE - Fournit les opérations CRUD de base pour toutes les entités
 * Évite la duplication de code dans tous les DAO spécifiques
 */
public class GenericDAO<T> {
    private final Class<T> type;

    public GenericDAO(Class<T> type) {
        this.type = type;
    }

    /**
     * 🆕 SAUVEGARDER - Crée ou met à jour une entité
     * Utilisé pour : Ajouter un nouveau plat, modifier un utilisateur, etc.
     */
    public T save(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.saveOrUpdate(entity);  // Crée si nouveau, met à jour si existe
            tx.commit();
            return entity;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Erreur sauvegarde " + type.getSimpleName(), e);
        } finally {
            session.close();
        }
    }

    /**
     * 🔍 TROUVER PAR ID - Récupère une entité par son identifiant
     * Utilisé pour : Voir les détails d'un plat, charger un utilisateur, etc.
     */
    public Optional<T> findById(Long id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            T entity = session.get(type, id);
            return Optional.ofNullable(entity);  // Retourne Optional pour éviter NullPointerException
        } finally {
            session.close();
        }
    }

    /**
     * 📋 TROUVER TOUT - Récupère toutes les entités
     * Utilisé pour : Lister tous les plats, tous les utilisateurs, etc.
     */
    public List<T> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM " + type.getName();  // Ex: "FROM Plat", "FROM Utilisateur"
            Query<T> query = session.createQuery(hql, type);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 🗑️ SUPPRIMER - Supprime une entité par son ID
     * Utilisé pour : Supprimer un plat, un utilisateur, etc.
     */
    public void delete(Long id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            T entity = session.get(type, id);
            if (entity != null) {
                session.delete(entity);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Erreur suppression", e);
        } finally {
            session.close();
        }
    }

    /**
     * 🔎 TROUVER PAR CHAMP - Recherche par un champ spécifique
     * Utilisé pour : Trouver les plats d'une catégorie, etc.
     */
    public List<T> findByField(String fieldName, Object value) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM " + type.getName() + " WHERE " + fieldName + " = :value";
            Query<T> query = session.createQuery(hql, type);
            query.setParameter("value", value);
            return query.list();
        } finally {
            session.close();
        }
    }


    /**
     * ✏️ METTRE À JOUR - Met à jour une entité existante
     * Utilisé pour : Modifier un utilisateur, éditer un plat, etc.
     */
    public void update(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.update(entity);  // Met à jour l'entité existante
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Erreur mise à jour " + type.getSimpleName(), e);
        } finally {
            session.close();
        }
    }

    /**
     * 🔄 FUSIONNER - Fusionne une entité détachée avec la session
     * Alternative à update() pour les entités détachées
     */
    public T merge(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            T mergedEntity = (T) session.merge(entity);
            tx.commit();
            return mergedEntity;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Erreur fusion " + type.getSimpleName(), e);
        } finally {
            session.close();
        }
    }

    /**
     * 📊 COMPTER TOUTES LES ENTITÉS - Retourne le nombre total d'entités
     * Utilisé pour : Statistiques, dashboard
     */
    public Long countAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT COUNT(*) FROM " + type.getName();
            Query<Long> query = session.createQuery(hql, Long.class);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    /**
     * 🔢 COMPTER PAR CHAMP - Retourne le nombre d'entités selon un critère
     * Utilisé pour : Statistiques filtrées
     */
    public Long countByField(String fieldName, Object value) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT COUNT(*) FROM " + type.getName() + " WHERE " + fieldName + " = :value";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("value", value);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }
}
