package com.restaurant.service;

import com.restaurant.dao.CategorieDAO;
import com.restaurant.model.Categorie;
import java.util.List;

/**
 * 📂 Service de gestion des catégories de plats
 */
public class CategorieService {
    private CategorieDAO categorieDAO = new CategorieDAO();

    /**
     * Crée une nouvelle catégorie
     */
    public Categorie creerCategorie(String nom, String description) {
        if (nom == null || nom.trim().isEmpty()) {
            throw new RuntimeException("Le nom de la catégorie est obligatoire");
        }

        // Vérifier si une catégorie avec ce nom existe déjà
        if (categorieDAO.findByNom(nom).isPresent()) {
            throw new RuntimeException("Une catégorie avec ce nom existe déjà");
        }

        Categorie categorie = new Categorie(nom, description);
        return categorieDAO.save(categorie);
    }

    /**
     * Récupère toutes les catégories
     */
    public List<Categorie> getToutesCategories() {
        return categorieDAO.findAll();
    }

    /**
     * Récupère les catégories qui ont des plats disponibles
     */
    public List<Categorie> getCategoriesAvecPlats() {
        return categorieDAO.findCategoriesAvecPlats();
    }
}