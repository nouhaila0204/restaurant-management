package com.restaurant.service;

import com.restaurant.dao.TableRestaurantDAO;
import com.restaurant.model.TableRestaurant;
import java.util.List;

/**
 * 🪑 Service de gestion des tables
 */
public class TableService {
    private TableRestaurantDAO tableDAO = new TableRestaurantDAO();
    private AuthenticationService authService = new AuthenticationService();

    /**
     * Crée une nouvelle table - Permission: ADMIN seulement
     */
    public TableRestaurant creerTable(Long userId, String numero, Integer capacite) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.TABLE_CREER)) {
            throw new RuntimeException("❌ Permission refusée : Création table (Admin seulement)");
        }

        // Validation
        if (numero == null || numero.trim().isEmpty()) {
            throw new RuntimeException("Le numéro de table est obligatoire");
        }
        if (capacite == null || capacite <= 0) {
            throw new RuntimeException("La capacité doit être positive");
        }

        // Vérifier si le numéro existe déjà
        if (tableDAO.findByNumero(numero).isPresent()) {
            throw new RuntimeException("Une table avec ce numéro existe déjà");
        }

        TableRestaurant table = new TableRestaurant(numero, capacite);
        return tableDAO.save(table);
    }

    /**
     * Récupère les tables libres - Permission: SERVEUR ou ADMIN
     */
    public List<TableRestaurant> getTablesLibres(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.TABLE_VOIR_LIBRES)) {
            throw new RuntimeException("❌ Permission refusée : Voir tables libres");
        }
        return tableDAO.findTablesLibres();
    }

    /**
     * Change le statut d'une table - Permission: SERVEUR ou ADMIN
     */
    public TableRestaurant changerStatutTable(Long userId, Long tableId, TableRestaurant.StatutTable nouveauStatut) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.TABLE_CHANGER_STATUT)) {
            throw new RuntimeException("❌ Permission refusée : Changer statut table");
        }

        TableRestaurant table = tableDAO.findById(tableId)
                .orElseThrow(() -> new RuntimeException("Table non trouvée"));

        table.setStatut(nouveauStatut);
        return tableDAO.save(table);
    }

    /**
     * Libère une table - Permission: SERVEUR ou ADMIN
     */
    public TableRestaurant libererTable(Long userId, Long tableId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.TABLE_LIBERER)) {
            throw new RuntimeException("❌ Permission refusée : Libérer table");
        }
        return changerStatutTable(userId, tableId, TableRestaurant.StatutTable.LIBRE);
    }

    /**
     * Récupère toutes les tables - Permission: SERVEUR ou ADMIN
     */
    public List<TableRestaurant> getToutesTables(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.TABLE_VOIR_TOUTES)) {
            throw new RuntimeException("❌ Permission refusée : Voir toutes les tables");
        }
        return tableDAO.findAll();
    }

    /**
     * Récupère une table par son ID - Permission: SERVEUR ou ADMIN
     */
    public TableRestaurant getTableById(Long userId, Long tableId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.TABLE_VOIR)) {
            throw new RuntimeException("❌ Permission refusée : Voir table");
        }
        return tableDAO.findById(tableId)
                .orElseThrow(() -> new RuntimeException("Table non trouvée"));
    }

    /**
     * Modifie une table existante - Permission: ADMIN seulement
     */
    public TableRestaurant modifierTable(Long userId, Long tableId, String numero, Integer capacite) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.TABLE_MODIFIER)) {
            throw new RuntimeException("❌ Permission refusée : Modification table (Admin seulement)");
        }

        TableRestaurant table = tableDAO.findById(tableId)
                .orElseThrow(() -> new RuntimeException("Table non trouvée"));

        if (numero != null && !numero.trim().isEmpty()) {
            // Vérifier unicité du numéro (sauf pour la table actuelle)
            tableDAO.findByNumero(numero).ifPresent(existingTable -> {
                if (!existingTable.getId().equals(tableId)) {
                    throw new RuntimeException("Une table avec ce numéro existe déjà");
                }
            });
            table.setNumero(numero);
        }

        if (capacite != null && capacite > 0) {
            table.setCapacite(capacite);
        }

        return tableDAO.save(table);
    }
}