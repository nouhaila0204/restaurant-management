package com.restaurant.service;

import com.restaurant.dao.CategorieDAO;
import com.restaurant.model.Categorie;
import java.util.List;

/**
 * 📂 Service de gestion des catégories de plats
 */
public class CategorieService {
    private CategorieDAO categorieDAO = new CategorieDAO();
    private AuthenticationService authService = new AuthenticationService();

    /**
     * Crée une nouvelle catégorie - Permission: ADMIN seulement
     */
    public Categorie creerCategorie(Long userId, String nom, String description) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CATEGORIE_CREER)) {
            throw new RuntimeException("❌ Permission refusée : Création catégorie (Admin seulement)");
        }

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
     * Récupère toutes les catégories - Permission: SERVEUR ou ADMIN
     */
    public List<Categorie> getToutesCategories(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CATEGORIE_VOIR)) {
            throw new RuntimeException("❌ Permission refusée : Voir catégories");
        }
        return categorieDAO.findAll();
    }

    /**
     * Récupère les catégories qui ont des plats disponibles - Permission: SERVEUR ou ADMIN
     */
    public List<Categorie> getCategoriesAvecPlats(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CATEGORIE_VOIR_AVEC_PLATS)) {
            throw new RuntimeException("❌ Permission refusée : Voir catégories avec plats");
        }
        return categorieDAO.findCategoriesAvecPlats();
    }

    /**
     * Modifie une catégorie existante - Permission: ADMIN seulement
     */
    public Categorie modifierCategorie(Long userId, Long categorieId, String nom, String description) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CATEGORIE_MODIFIER)) {
            throw new RuntimeException("❌ Permission refusée : Modification catégorie (Admin seulement)");
        }

        Categorie categorie = categorieDAO.findById(categorieId)
                .orElseThrow(() -> new RuntimeException("Catégorie non trouvée"));

        if (nom != null && !nom.trim().isEmpty()) {
            // Vérifier unicité du nom (sauf pour la catégorie actuelle)
            categorieDAO.findByNom(nom).ifPresent(existingCat -> {
                if (!existingCat.getId().equals(categorieId)) {
                    throw new RuntimeException("Une catégorie avec ce nom existe déjà");
                }
            });
            categorie.setNom(nom);
        }

        if (description != null) {
            categorie.setDescription(description);
        }

        return categorieDAO.save(categorie);
    }

    /**
     * Récupère une catégorie par son ID - permission: SERVEUR ou ADMIN
     */
    public Categorie getCategorieById(Long userId, Long categorieId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CATEGORIE_VOIR)) {
            throw new RuntimeException("❌ Permission refusée : Voir catégorie");
        }
        return categorieDAO.findById(categorieId)
                .orElseThrow(() -> new RuntimeException("Catégorie non trouvée"));
    }
}