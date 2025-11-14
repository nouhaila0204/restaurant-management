package com.restaurant.dao;

import com.restaurant.model.Plat;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 🍽️ DAO PLAT - Gère toutes les opérations liées aux plats du menu
 */
public class PlatDAO extends GenericDAO<Plat> {

    public PlatDAO() {
        super(Plat.class);
    }

    /**
     * ✅ PLATS DISPONIBLES - Liste seulement les plats disponibles à la vente
     * Utilisé pour : Afficher le menu aux clients, prise de commande
     */
    public List<Plat> findPlatsDisponibles() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Plat p WHERE p.disponible = true ORDER BY p.categorie.nom, p.nom";
            Query<Plat> query = session.createQuery(hql, Plat.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 📁 PLATS PAR CATÉGORIE - Liste les plats d'une catégorie spécifique
     * Utilisé pour : Filtrer le menu par catégorie (pizzas, desserts, etc.)
     */
    public List<Plat> findByCategorie(Long categorieId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Plat p WHERE p.categorie.id = :categorieId AND p.disponible = true";
            Query<Plat> query = session.createQuery(hql, Plat.class);
            query.setParameter("categorieId", categorieId);
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 🔍 RECHERCHE PAR NOM - Trouve les plats contenant un mot dans le nom
     * Utilisé pour : Barre de recherche dans le menu
     */
    public List<Plat> searchByName(String searchTerm) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Plat p WHERE LOWER(p.nom) LIKE LOWER(:searchTerm) AND p.disponible = true";
            Query<Plat> query = session.createQuery(hql, Plat.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 🍽️ PLATS LES PLUS VENDUS - Top des plats par quantité vendue
     * Utilisé pour : Statistiques, gestion du menu
     */
    public Map<String, Long> getPlatsLesPlusVendus(int limit) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT lc.plat.nom, SUM(lc.quantite) " +
                    "FROM LigneCommande lc " +
                    "GROUP BY lc.plat.id, lc.plat.nom " +
                    "ORDER BY SUM(lc.quantite) DESC";
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            query.setMaxResults(limit);
            List<Object[]> results = query.list();

            Map<String, Long> topPlats = new LinkedHashMap<>();
            for (Object[] result : results) {
                String nomPlat = (String) result[0];
                Long quantite = (Long) result[1];
                topPlats.put(nomPlat, quantite);
            }
            return topPlats;
        } finally {
            session.close();
        }
    }

    public Long countAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT COUNT(p) FROM Plat p";
            Query<Long> query = session.createQuery(hql, Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            session.close();
        }
    }

    /**
     * 📋 TOUS LES PLATS AVEC CATÉGORIES - Charge les plats avec leurs catégories
     * Utilisé pour : Affichage dans l'admin
     */
    public List<Plat> findAllWithCategories() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT DISTINCT p FROM Plat p LEFT JOIN FETCH p.categorie ORDER BY p.categorie.nom, p.nom";
            Query<Plat> query = session.createQuery(hql, Plat.class);
            return query.list();
        } finally {
            session.close();
        }
    }


}
