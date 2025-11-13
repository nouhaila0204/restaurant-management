package com.restaurant.dao;

import com.restaurant.model.Plat;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

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
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Utiliser JOIN FETCH pour charger la catégorie immédiatement
            String hql = "SELECT p FROM Plat p LEFT JOIN FETCH p.categorie WHERE p.disponible = true ORDER BY p.categorie.nom, p.nom";
            return session.createQuery(hql, Plat.class).getResultList();
        } catch (Exception e) {
            System.err.println("Erreur recherche plats disponibles: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * 📁 PLATS PAR CATÉGORIE - Liste les plats d'une catégorie spécifique
     * Utilisé pour : Filtrer le menu par catégorie (pizzas, desserts, etc.)
     */
    public List<Plat> findByCategorie(Long categorieId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // AJOUT: LEFT JOIN FETCH pour charger la catégorie
            String hql = "SELECT p FROM Plat p LEFT JOIN FETCH p.categorie WHERE p.categorie.id = :categorieId AND p.disponible = true";
            Query<Plat> query = session.createQuery(hql, Plat.class);
            query.setParameter("categorieId", categorieId);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Erreur recherche plats par catégorie: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * 🔍 RECHERCHE PAR NOM - Trouve les plats contenant un mot dans le nom
     * Utilisé pour : Barre de recherche dans le menu
     */
    public List<Plat> searchByName(String searchTerm) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // AJOUT: LEFT JOIN FETCH pour charger la catégorie
            String hql = "SELECT p FROM Plat p LEFT JOIN FETCH p.categorie WHERE LOWER(p.nom) LIKE LOWER(:searchTerm) AND p.disponible = true";
            Query<Plat> query = session.createQuery(hql, Plat.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Erreur recherche plats par nom: " + e.getMessage());
            return new ArrayList<>();
        }
    }
}