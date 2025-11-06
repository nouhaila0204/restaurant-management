package com.restaurant.service;

import com.restaurant.dao.PlatDAO;
import com.restaurant.dao.CategorieDAO;
import com.restaurant.model.Plat;
import com.restaurant.model.Categorie;
import java.util.List;

/**
 * 🍽️ Service de gestion du menu et des plats
 */
public class PlatService {
    private PlatDAO platDAO = new PlatDAO();
    private CategorieDAO categorieDAO = new CategorieDAO();
    private AuthenticationService authService = new AuthenticationService();

    /**
     * Crée un nouveau plat avec validation - Permission: ADMIN seulement
     */
    public Plat creerPlat(Long userId, String nom, String description, Double prix, Long categorieId) {
        // Vérification permission ADMIN
        if (!authService.aPermission(userId, AuthenticationService.Permission.PLAT_CREER)) {
            throw new RuntimeException("❌ Permission refusée : Création plat (Admin seulement)");
        }

        // Validation
        if (nom == null || nom.trim().isEmpty()) {
            throw new RuntimeException("Le nom du plat est obligatoire");
        }
        if (prix == null || prix <= 0) {
            throw new RuntimeException("Le prix doit être positif");
        }

        // Vérifier que la catégorie existe
        Categorie categorie = categorieDAO.findById(categorieId)
                .orElseThrow(() -> new RuntimeException("Catégorie non trouvée"));

        // Créer le plat
        Plat plat = new Plat(nom, description, prix, categorie);
        return platDAO.save(plat);
    }

    /**
     * Met à jour un plat existant - Permission: ADMIN seulement
     */
    public Plat modifierPlat(Long userId, Long platId, String nom, String description, Double prix, Long categorieId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.PLAT_MODIFIER)) {
            throw new RuntimeException("❌ Permission refusée : Modification plat (Admin seulement)");
        }

        Plat plat = platDAO.findById(platId)
                .orElseThrow(() -> new RuntimeException("Plat non trouvé"));

        if (nom != null && !nom.trim().isEmpty()) {
            plat.setNom(nom);
        }
        if (description != null) {
            plat.setDescription(description);
        }
        if (prix != null && prix > 0) {
            plat.setPrix(prix);
        }
        if (categorieId != null) {
            Categorie categorie = categorieDAO.findById(categorieId)
                    .orElseThrow(() -> new RuntimeException("Catégorie non trouvée"));
            plat.setCategorie(categorie);
        }

        return platDAO.save(plat);
    }

    /**
     * Change la disponibilité d'un plat - Permission: ADMIN seulement
     */
    public Plat changerDisponibilitePlat(Long userId, Long platId, boolean disponible) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.PLAT_DISPONIBILITE)) {
            throw new RuntimeException("❌ Permission refusée : Changer disponibilité plat (Admin seulement)");
        }

        Plat plat = platDAO.findById(platId)
                .orElseThrow(() -> new RuntimeException("Plat non trouvé"));

        plat.setDisponible(disponible);
        return platDAO.save(plat);
    }

    /**
     * Récupère les plats disponibles pour le menu - Permission: PUBLIC
     */
    public List<Plat> getMenuDisponible() {
        // Pas de vérification de permission - accessible à tous
        return platDAO.findPlatsDisponibles();
    }

    /**
     * Recherche des plats par nom - Permission: SERVEUR ou ADMIN
     */
    public List<Plat> rechercherPlats(Long userId, String searchTerm) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.PLAT_RECHERCHER)) {
            throw new RuntimeException("❌ Permission refusée : Recherche plats");
        }

        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getMenuDisponible();
        }
        return platDAO.searchByName(searchTerm);
    }

    /**
     * Récupère les plats d'une catégorie - Permission: SERVEUR ou ADMIN
     */
    public List<Plat> getPlatsParCategorie(Long userId, Long categorieId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.PLAT_VOIR_CATEGORIE)) {
            throw new RuntimeException("❌ Permission refusée : Voir plats par catégorie");
        }
        return platDAO.findByCategorie(categorieId);
    }

    /**
     * Supprime un plat - Permission: ADMIN seulement
     */
    public void supprimerPlat(Long userId, Long platId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.PLAT_SUPPRIMER)) {
            throw new RuntimeException("❌ Permission refusée : Suppression plat (Admin seulement)");
        }

        Plat plat = platDAO.findById(platId)
                .orElseThrow(() -> new RuntimeException("Plat non trouvé"));

        platDAO.delete(platId);
    }
}