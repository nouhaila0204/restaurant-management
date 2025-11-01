package com.restaurant.service;

import com.restaurant.dao.ClientDAO;
import com.restaurant.model.Client;
import java.util.List;
import java.util.Optional;

/**
 * 👤 Service de gestion des clients
 */
public class ClientService {
    private ClientDAO clientDAO = new ClientDAO();

    /**
     * Crée un nouveau client
     */
    public Client creerClient(String nom, String telephone, String email) {
        if (nom == null || nom.trim().isEmpty()) {
            throw new RuntimeException("Le nom du client est obligatoire");
        }

        Client client = new Client(nom, telephone, email);
        return clientDAO.save(client);
    }

    /**
     * Recherche un client par téléphone
     */
    public Optional<Client> trouverClientParTelephone(String telephone) {
        return clientDAO.findByTelephone(telephone);
    }

    /**
     * Recherche des clients par nom ou téléphone
     */
    public List<Client> rechercherClients(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return clientDAO.findAll();
        }
        return clientDAO.searchClients(searchTerm);
    }

    /**
     * Récupère tous les clients
     */
    public List<Client> getTousClients() {
        return clientDAO.findAll();
    }
}
