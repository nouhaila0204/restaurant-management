package com.restaurant.controller;

import com.restaurant.service.TableService;
import com.restaurant.model.TableRestaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/serveur/tables/*")
public class TableServlet extends HttpServlet {
    private TableService tableService;

    @Override
    public void init() throws ServletException {
        try {
            this.tableService = new TableService();
            System.out.println("✅ TableServlet initialisé avec succès");
        } catch (Exception e) {
            System.err.println("❌ Erreur initialisation TableServlet: " + e.getMessage());
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🎯 TableServlet.doGet() appelé");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        String pathInfo = request.getPathInfo();

        System.out.println("👤 User ID: " + userId);
        System.out.println("📁 Path Info: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                afficherListeTables(request, response, userId);
            } else {
                response.sendError(404, "Page non trouvée: " + pathInfo);
            }

        } catch (Exception e) {
            System.err.println("❌ ERROR in TableServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du chargement: " + e.getMessage());
            request.getRequestDispatcher("/views/Serveur/tables.jsp").forward(request, response);
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
            if (pathInfo != null && pathInfo.equals("/changer-statut")) {
                changerStatutTable(request, response, userId);
            } else {
                response.sendError(404, "Action non supportée: " + pathInfo);
            }

        } catch (Exception e) {
            System.err.println("❌ ERROR in TableServlet POST: " + e.getMessage());
            e.printStackTrace();

            // En cas d'erreur, retourner à la liste avec message d'erreur
            session.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/serveur/tables");
        }
    }

    private void afficherListeTables(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔍 Début afficherListeTables...");

            // Récupérer le filtre de statut
            String statutFilter = request.getParameter("statut");
            System.out.println("📊 Filtre statut reçu: '" + statutFilter + "'");

            List<TableRestaurant> tables;
            String pageTitle = "Gestion des Tables";

            if (statutFilter != null && !statutFilter.isEmpty()) {
                try {
                    TableRestaurant.StatutTable statut = TableRestaurant.StatutTable.valueOf(statutFilter);
                    tables = tableService.getTablesByStatut(userId, statut);
                    pageTitle = "Tables " + getStatutLabel(statut);
                    request.setAttribute("selectedStatut", statutFilter);
                    System.out.println("✅ Filtrage par statut: " + statut + " - " + tables.size() + " résultats");
                } catch (IllegalArgumentException e) {
                    System.err.println("❌ Statut invalide: " + statutFilter);
                    tables = tableService.getToutesTables(userId);
                    request.setAttribute("errorMessage", "Statut de filtre invalide");
                }
            } else {
                tables = tableService.getToutesTables(userId);
                System.out.println("📋 Affichage de toutes les tables - " + tables.size() + " résultats");
            }

            // Préparer les données pour la vue
            request.setAttribute("tables", tables);
            request.setAttribute("pageTitle", pageTitle);
            request.setAttribute("activePage", "tables");
            request.setAttribute("statuts", TableRestaurant.StatutTable.values());

            // Statistiques pour les badges
            long totalTables = tables.size();
            long tablesLibres = tables.stream()
                    .filter(t -> t.getStatut() == TableRestaurant.StatutTable.LIBRE)
                    .count();
            long tablesOccupees = tables.stream()
                    .filter(t -> t.getStatut() == TableRestaurant.StatutTable.OCCUPEE)
                    .count();

            request.setAttribute("totalTables", totalTables);
            request.setAttribute("tablesLibres", tablesLibres);
            request.setAttribute("tablesOccupees", tablesOccupees);

            System.out.println("✅ Données prêtes - Tables: " + tables.size());
            System.out.println("📊 Stats - Libres: " + tablesLibres + ", Occupées: " + tablesOccupees);

            String jspPath = "/views/Serveur/tables.jsp";
            System.out.println("➡️ Forwarding to: " + jspPath);

            request.getRequestDispatcher(jspPath).forward(request, response);
            System.out.println("✅ Forwarding réussi");

        } catch (Exception e) {
            System.err.println("❌ Erreur critique dans afficherListeTables: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des tables", e);
        }
    }

    private void changerStatutTable(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔄 Changement statut table...");

            String tableIdParam = request.getParameter("tableId");
            String nouveauStatutParam = request.getParameter("nouveauStatut");

            System.out.println("📋 Paramètres - TableID: " + tableIdParam + ", Statut: " + nouveauStatutParam);

            if (tableIdParam == null || nouveauStatutParam == null) {
                throw new RuntimeException("Données manquantes pour changer le statut");
            }

            Long tableId = Long.parseLong(tableIdParam);
            TableRestaurant.StatutTable nouveauStatut = TableRestaurant.StatutTable.valueOf(nouveauStatutParam);

            // Changer le statut
            TableRestaurant table = tableService.changerStatutTable(userId, tableId, nouveauStatut);

            // Message de succès
            HttpSession session = request.getSession();
            session.setAttribute("successMessage",
                    "✅ Statut de la table " + table.getNumero() + " changé à: " + getStatutLabel(nouveauStatut));

            System.out.println("✅ Statut changé pour table: " + tableId + " -> " + nouveauStatut);

            // Redirection vers la liste des tables
            response.sendRedirect(request.getContextPath() + "/serveur/tables");

        } catch (NumberFormatException e) {
            throw new RuntimeException("Format d'ID de table invalide");
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Statut de table invalide");
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du changement de statut: " + e.getMessage());
        }
    }

    private String getStatutLabel(TableRestaurant.StatutTable statut) {
        switch (statut) {
            case LIBRE: return "Libres";
            case OCCUPEE: return "Occupées";
            case RESERVEE: return "Réservées";
            default: return statut.toString();
        }
    }
}