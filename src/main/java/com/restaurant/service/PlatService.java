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

    /**
     * Crée un nouveau plat avec validation
     */
    public Plat creerPlat(String nom, String description, Double prix, Long categorieId) {
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
     * Met à jour un plat existant
     */
    public Plat modifierPlat(Long platId, String nom, String description, Double prix, Long categorieId) {
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
     * Change la disponibilité d'un plat
     */
    public Plat changerDisponibilitePlat(Long platId, boolean disponible) {
        Plat plat = platDAO.findById(platId)
                .orElseThrow(() -> new RuntimeException("Plat non trouvé"));

        plat.setDisponible(disponible);
        return platDAO.save(plat);
    }

    /**
     * Récupère les plats disponibles pour le menu
     */
    public List<Plat> getMenuDisponible() {
        return platDAO.findPlatsDisponibles();
    }

    /**
     * Recherche des plats par nom
     */
    public List<Plat> rechercherPlats(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getMenuDisponible();
        }
        return platDAO.searchByName(searchTerm);
    }

    /**
     * Récupère les plats d'une catégorie
     */
    public List<Plat> getPlatsParCategorie(Long categorieId) {
        return platDAO.findByCategorie(categorieId);
    }
}
