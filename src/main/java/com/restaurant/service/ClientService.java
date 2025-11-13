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
    private AuthenticationService authService = new AuthenticationService();

    /**
     * Crée un nouveau client - Permission: SERVEUR ou ADMIN
     */
    public Client creerClient(Long userId, String nom, String telephone, String email) {
        // Vérification permission
        if (!authService.aPermission(userId, AuthenticationService.Permission.CLIENT_CREER)) {
            throw new RuntimeException("❌ Permission refusée : Création client");
        }

        if (nom == null || nom.trim().isEmpty()) {
            throw new RuntimeException("Le nom du client est obligatoire");
        }

        Client client = new Client(nom, telephone, email);
        return clientDAO.save(client);
    }

    /**
     * Recherche un client par téléphone - Permission: SERVEUR ou ADMIN
     */
    public Optional<Client> trouverClientParTelephone(Long userId, String telephone) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CLIENT_RECHERCHER)) {
            throw new RuntimeException("❌ Permission refusée : Recherche client");
        }
        return clientDAO.findByTelephone(telephone);
    }


    /**
     * Recherche des clients par nom ou téléphone - Permission: SERVEUR ou ADMIN
     */
    public List<Client> rechercherClients(Long userId, String searchTerm) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CLIENT_RECHERCHER)) {
            throw new RuntimeException("❌ Permission refusée : Recherche clients");
        }

        System.out.println("🔍 Service Recherche - Terme: '" + searchTerm + "'");

        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            System.out.println("🔍 Recherche vide - retourne tous les clients");
            return clientDAO.findAll();
        }

        List<Client> results = clientDAO.searchClients(searchTerm);
        System.out.println("✅ Service Recherche - " + results.size() + " résultats trouvés");

        return results;
    }

    /**
     * Récupère tous les clients - Permission: SERVEUR ou ADMIN
     */
    public List<Client> getTousClients(Long userId) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CLIENT_VOIR)) {
            throw new RuntimeException("❌ Permission refusée : Consultation clients");
        }
        return clientDAO.findAll();
    }

    /**
     * Met à jour un client - Permission: ADMIN seulement
     */
    public Client modifierClient(Long userId, Long clientId, String nom, String telephone, String email) {
        if (!authService.aPermission(userId, AuthenticationService.Permission.CLIENT_MODIFIER)) {
            throw new RuntimeException("❌ Permission refusée : Modification client (Admin seulement)");
        }

        Client client = clientDAO.findById(clientId)
                .orElseThrow(() -> new RuntimeException("Client non trouvé"));

        if (nom != null && !nom.trim().isEmpty()) {
            client.setNom(nom);
        }
        if (telephone != null) {
            client.setTelephone(telephone);
        }
        if (email != null) {
            client.setEmail(email);
        }

        return clientDAO.save(client);
    }
}