package com.restaurant.controller;

import com.restaurant.service.ClientService;
import com.restaurant.model.Client;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/serveur/clients/*")
public class ClientServlet extends HttpServlet {
    private ClientService clientService;

    @Override
    public void init() throws ServletException {
        this.clientService = new ClientService();
        System.out.println("✅ ClientServlet initialisé");
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        String pathInfo = request.getPathInfo();

        System.out.println("🔍 ClientServlet - Path Info: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Liste de tous les clients AVEC recherche
                afficherListeClients(request, response, userId);

            } else if (pathInfo.equals("/nouveau")) {
                // Formulaire nouveau client
                afficherFormulaireNouveauClient(request, response, userId);

            } else {
                response.sendError(404, "Page non trouvée: " + pathInfo);
            }

        } catch (Exception e) {
            System.err.println("❌ ERROR in ClientServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/Serveur/clients.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        String pathInfo = request.getPathInfo();

        System.out.println("🔍 ClientServlet POST - Path Info: " + pathInfo);

        try {
            if (pathInfo != null && pathInfo.equals("/creer")) {
                creerClient(request, response, userId);
            } else {
                System.err.println("❌ PATH INFO POST NON RECONNU: " + pathInfo);
                response.sendError(405, "Méthode non supportée: " + pathInfo);
            }

        } catch (Exception e) {
            System.err.println("❌ ERROR in ClientServlet POST: " + e.getMessage());
            e.printStackTrace();

            // En cas d'erreur, retourner au formulaire avec les données saisies
            request.setAttribute("errorMessage", "Erreur lors de la création: " + e.getMessage());
            request.setAttribute("nom", request.getParameter("nom"));
            request.setAttribute("telephone", request.getParameter("telephone"));
            request.setAttribute("email", request.getParameter("email"));
            afficherFormulaireNouveauClient(request, response, userId);
        }
    }

    private void afficherListeClients(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔍 Récupération des clients...");

            // Récupérer le terme de recherche s'il existe
            String searchTerm = request.getParameter("search");
            List<Client> clients;

            System.out.println("📊 Paramètre search reçu: '" + searchTerm + "'");

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                System.out.println("🔍 Lancement recherche avec terme: '" + searchTerm + "'");
                clients = clientService.rechercherClients(userId, searchTerm);
                request.setAttribute("searchTerm", searchTerm);
                request.setAttribute("pageTitle", "Résultats de recherche pour: " + searchTerm);
                System.out.println("✅ Recherche terminée - " + clients.size() + " résultats");
            } else {
                System.out.println("📋 Affichage de tous les clients (pas de recherche)");
                clients = clientService.getTousClients(userId);
                request.setAttribute("pageTitle", "Gestion des Clients");
            }

            request.setAttribute("clients", clients);
            request.setAttribute("activePage", "clients");

            System.out.println("✅ Total clients à afficher: " + clients.size());

            // Log de débogage détaillé
            for (Client client : clients) {
                System.out.println("👤 Client trouvé: " + client.getNom() +
                        " | Tél: " + (client.getTelephone() != null ? client.getTelephone() : "N/A") +
                        " | Email: " + (client.getEmail() != null ? client.getEmail() : "N/A"));
            }

            System.out.println("➡️ Forwarding to: /views/Serveur/clients.jsp");
            request.getRequestDispatcher("/views/Serveur/clients.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Erreur dans afficherListeClients: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des clients", e);
        }
    }

    private void afficherFormulaireNouveauClient(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            request.setAttribute("pageTitle", "Nouveau Client");
            request.setAttribute("activePage", "clients");

            System.out.println("➡️ Forwarding to: /views/Serveur/nouveau-client.jsp");
            request.getRequestDispatcher("/views/Serveur/newClient.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur lors du chargement du formulaire", e);
        }
    }


    private void creerClient(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🆕 Création nouveau client...");

            String nom = request.getParameter("nom");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");

            // Validation des données
            if (nom == null || nom.trim().isEmpty()) {
                throw new RuntimeException("Le nom du client est obligatoire");
            }

            // Vérifier si le client existe déjà par téléphone
            if (telephone != null && !telephone.trim().isEmpty()) {
                var clientExistant = clientService.trouverClientParTelephone(userId, telephone);
                if (clientExistant.isPresent()) {
                    throw new RuntimeException("Un client avec ce numéro de téléphone existe déjà");
                }
            }

            Client nouveauClient = clientService.creerClient(userId, nom, telephone, email);
            System.out.println("✅ Client créé: " + nouveauClient.getId());

            // Redirection avec message de succès
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "✅ Client créé avec succès: " + nouveauClient.getNom());

            response.sendRedirect(request.getContextPath() + "/serveur/clients");

        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la création du client: " + e.getMessage());
        }
    }

}