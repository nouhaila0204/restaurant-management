package com.restaurant.controller;

import com.restaurant.service.CommandeService;
import com.restaurant.service.TableService;
import com.restaurant.service.PlatService;
import com.restaurant.model.Commande;
import com.restaurant.model.Plat;
import com.restaurant.model.TableRestaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Enumeration; // AJOUT: Import manquant
import com.restaurant.service.ClientService;
import com.restaurant.model.Client;


@WebServlet("/serveur/commandes/*")
public class CommandeServlet extends HttpServlet {
    private CommandeService commandeService;
    private TableService tableService;
    private PlatService platService;
    private ClientService clientService; // Ajout

    @Override
    public void init() throws ServletException {
        try {
            this.commandeService = new CommandeService();
            this.tableService = new TableService();
            this.platService = new PlatService();
            this.clientService = new ClientService(); // Ajout
            System.out.println("✅ CommandeServlet initialisé");
        } catch (Exception e) {
            System.err.println("❌ Erreur init CommandeServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void afficherFormulaireNouvelleCommande(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔍 Récupération des tables, plats et clients...");
            List<TableRestaurant> tablesDisponibles = tableService.getTablesLibres(userId);
            List<Plat> platsDisponibles = platService.getMenuDisponible();
            List<Client> clients = clientService.getTousClients(userId); // Ajout

            request.setAttribute("tablesDisponibles", tablesDisponibles != null ? tablesDisponibles : new ArrayList<>());
            request.setAttribute("platsDisponibles", platsDisponibles != null ? platsDisponibles : new ArrayList<>());
            request.setAttribute("clients", clients != null ? clients : new ArrayList<>()); // Ajout
            request.setAttribute("pageTitle", "Nouvelle Commande");

            System.out.println("➡️ Forwarding to: /views/Serveur/newCommande.jsp");
            request.getRequestDispatcher("/views/Serveur/newCommande.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Error in afficherFormulaireNouvelleCommande: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement du formulaire", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== COMMANDE SERVLET DOGET ===");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        String pathInfo = request.getPathInfo();

        System.out.println("Path Info: " + pathInfo);
        System.out.println("User ID: " + userId);

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                System.out.println("Loading commandes list...");
                afficherCommandesDuJour(request, response, userId);

            } else if (pathInfo.equals("/nouvelle")) {
                System.out.println("Loading new command form...");
                afficherFormulaireNouvelleCommande(request, response, userId);

            } else if (pathInfo.equals("/en-cours")) {
                System.out.println("Loading commandes en cours...");
                afficherCommandesEnCours(request, response, userId);

            } else if (pathInfo.equals("/detail")) {
                System.out.println("Loading command detail...");
                String commandeIdParam = request.getParameter("id");
                if (commandeIdParam != null) {
                    Long commandeId = Long.parseLong(commandeIdParam);
                    afficherDetailCommande(request, response, userId, commandeId);
                } else {
                    response.sendError(400, "ID de commande manquant");
                }

            } else {
                System.out.println("Unknown path: " + pathInfo);
                response.sendError(404, "Page non trouvée: " + pathInfo);
            }

        } catch (Exception e) {
            System.err.println("❌ ERROR in CommandeServlet: " + e.getMessage());
            e.printStackTrace();

            // En cas d'erreur, afficher une page avec des données vides
            request.setAttribute("commandes", new ArrayList<>());
            request.setAttribute("pageTitle", "Commandes");
            request.setAttribute("errorMessage", "Erreur de chargement: " + e.getMessage());
            request.getRequestDispatcher("/views/Serveur/commandes.jsp").forward(request, response);
        }
    }

    private void afficherCommandesDuJour(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔍 Récupération des commandes du jour pour user: " + userId);
            List<Commande> commandes = commandeService.getCommandesDuJour(userId);
            System.out.println("✅ Commandes récupérées: " + (commandes != null ? commandes.size() : "null"));

            request.setAttribute("commandes", commandes != null ? commandes : new ArrayList<>());
            request.setAttribute("pageTitle", "Commandes du Jour");

            System.out.println("➡️ Forwarding to: /views/Serveur/commandes.jsp");
            request.getRequestDispatcher("/views/Serveur/commandes.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Error in afficherCommandesDuJour: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des commandes", e);
        }
    }



    private void afficherCommandesEnCours(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔍 Récupération des commandes en cours pour user: " + userId);
            List<Commande> commandesEnCours = commandeService.getCommandesEnCours(userId);
            System.out.println("✅ Commandes en cours: " + (commandesEnCours != null ? commandesEnCours.size() : "null"));

            request.setAttribute("commandes", commandesEnCours != null ? commandesEnCours : new ArrayList<>());
            request.setAttribute("pageTitle", "Commandes en Cours");

            System.out.println("➡️ Forwarding to: /views/Serveur/commandes.jsp");
            request.getRequestDispatcher("/views/Serveur/commandes.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Error in afficherCommandesEnCours: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des commandes en cours", e);
        }
    }

    private void afficherDetailCommande(HttpServletRequest request, HttpServletResponse response, Long userId, Long commandeId)
            throws ServletException, IOException {
        try {
            System.out.println("🔍 Récupération détail commande: " + commandeId);
            Commande commande = commandeService.trouverCommandeParId(userId, commandeId);
            List<Plat> platsDisponibles = platService.getMenuDisponible();

            request.setAttribute("commande", commande);
            request.setAttribute("platsDisponibles", platsDisponibles != null ? platsDisponibles : new ArrayList<>());
            request.setAttribute("pageTitle", "Détail Commande #" + commandeId);

            System.out.println("➡️ Forwarding to: /views/Serveur/detail-commande.jsp");
            request.getRequestDispatcher("/views/Serveur/detail-commande.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Error in afficherDetailCommande: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement du détail de la commande", e);
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

        try {
            if (pathInfo == null) {
                response.sendError(400, "Action non spécifiée");
                return;
            }

            if (pathInfo.equals("/creer")) {
                creerNouvelleCommande(request, response, userId);

            } else if (pathInfo.equals("/statut")) {
                changerStatutCommande(request, response, userId);

            } else {
                response.sendError(404, "Action non supportée: " + pathInfo);
            }

        } catch (Exception e) {
            System.err.println("❌ ERROR in CommandeServlet POST: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/serveur/commandes");
        }
    }

    private void creerNouvelleCommande(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🆕 Création nouvelle commande...");

            // Récupérer les paramètres de base
            String clientIdParam = request.getParameter("clientId");
            String tableIdParam = request.getParameter("tableId");

            if (clientIdParam == null || tableIdParam == null) {
                throw new RuntimeException("Client et table sont obligatoires");
            }

            Long tableId = Long.parseLong(tableIdParam);
            Long clientId = Long.parseLong(clientIdParam);

            Map<Long, Integer> platsQuantites = new HashMap<>();

            // Parcourir tous les paramètres pour trouver les quantités
            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                System.out.println("🔍 Paramètre: " + paramName + " = " + request.getParameter(paramName));

                if (paramName.startsWith("quantite_")) {
                    try {
                        Long platId = Long.parseLong(paramName.substring(9)); // Extraire l'ID du plat
                        String quantiteStr = request.getParameter(paramName);

                        if (quantiteStr != null && !quantiteStr.trim().isEmpty()) {
                            int quantite = Integer.parseInt(quantiteStr);

                            if (quantite > 0) {
                                platsQuantites.put(platId, quantite);
                                System.out.println("📦 Plat " + platId + " - Quantité: " + quantite);
                            }
                        }
                    } catch (NumberFormatException e) {
                        System.err.println("❌ Format invalide pour le paramètre: " + paramName);
                    }
                }
            }

            System.out.println("📊 Total plats sélectionnés: " + platsQuantites.size());

            if (platsQuantites.isEmpty()) {
                throw new RuntimeException("Veuillez sélectionner au moins un plat avec une quantité supérieure à 0");
            }

            // AJOUT: Passer le clientId à la méthode creerCommande
            Commande commande = commandeService.creerCommande(userId, tableId, platsQuantites, userId, clientId);
            System.out.println("✅ Commande créée: " + commande.getId());

            // CORRECTION: Rediriger vers la liste des commandes avec un message de succès
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "✅ Commande créée avec succès! Numéro: " + commande.getNumero());

            response.sendRedirect(request.getContextPath() + "/serveur/commandes");

        } catch (NumberFormatException e) {
            throw new RuntimeException("Données invalides: " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la création de la commande: " + e.getMessage());
        }
    }

    private void changerStatutCommande(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔄 Changement statut commande...");

            String commandeIdParam = request.getParameter("commandeId");
            if (commandeIdParam == null) {
                throw new RuntimeException("ID de commande manquant");
            }

            Long commandeId = Long.parseLong(commandeIdParam);
            String statutParam = request.getParameter("statut");

            if (statutParam == null) {
                throw new RuntimeException("Statut manquant");
            }

            Commande.StatutCommande nouveauStatut = Commande.StatutCommande.valueOf(statutParam);
            commandeService.changerStatutCommande(userId, commandeId, nouveauStatut);

            System.out.println("✅ Statut changé pour commande: " + commandeId);
            response.sendRedirect(request.getContextPath() + "/serveur/commandes");

        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du changement de statut: " + e.getMessage());
        }
    }


}