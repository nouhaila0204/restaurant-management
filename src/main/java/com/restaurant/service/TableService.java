package com.restaurant.service;

import com.restaurant.dao.TableRestaurantDAO;
import com.restaurant.model.TableRestaurant;
import java.util.List;

/**
 * 🪑 Service de gestion des tables
 */
public class TableService {
    private TableRestaurantDAO tableDAO = new TableRestaurantDAO();

    /**
     * Crée une nouvelle table
     */
    public TableRestaurant creerTable(String numero, Integer capacite) {
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
     * Récupère les tables libres
     */
    public List<TableRestaurant> getTablesLibres() {
        return tableDAO.findTablesLibres();
    }

    /**
     * Change le statut d'une table
     */
    public TableRestaurant changerStatutTable(Long tableId, TableRestaurant.StatutTable nouveauStatut) {
        TableRestaurant table = tableDAO.findById(tableId)
                .orElseThrow(() -> new RuntimeException("Table non trouvée"));

        table.setStatut(nouveauStatut);
        return tableDAO.save(table);
    }

    /**
     * Libère une table (marque comme libre)
     */
    public TableRestaurant libererTable(Long tableId) {
        return changerStatutTable(tableId, TableRestaurant.StatutTable.LIBRE);
    }

    /**
     * Récupère toutes les tables avec leur statut
     */
    public List<TableRestaurant> getToutesTables() {
        return tableDAO.findAll();
    }
}