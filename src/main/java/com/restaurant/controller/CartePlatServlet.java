package com.restaurant.controller;

import com.restaurant.service.PlatService;
import com.restaurant.service.CategorieService;
import com.restaurant.model.Plat;
import com.restaurant.model.Categorie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/carte-plats")
public class CartePlatServlet extends HttpServlet {
    private PlatService platService;
    private CategorieService categorieService;

    @Override
    public void init() throws ServletException {
        try {
            this.platService = new PlatService();
            this.categorieService = new CategorieService();
            System.out.println("✅ CartePlatServlet initialisé avec succès");
        } catch (Exception e) {
            System.err.println("❌ Erreur initialisation CartePlatServlet: " + e.getMessage());
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🎯 CartePlatServlet.doGet() appelé");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        System.out.println("👤 User ID: " + userId);

        try {
            afficherCartePlats(request, response, userId);
        } catch (Exception e) {
            System.err.println("❌ ERROR in CartePlatServlet: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("errorMessage", "Erreur lors du chargement: " + e.getMessage());
            request.getRequestDispatcher("/views/Serveur/plats.jsp").forward(request, response);
        }
    }

    private void afficherCartePlats(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        try {
            System.out.println("🔍 Début afficherCartePlats...");

            // ÉTAPE 1: Récupération des paramètres de la requête
            String searchTerm = request.getParameter("search");
            String categorieIdParam = request.getParameter("categorieId");

            System.out.println("📊 Paramètres reçus - Search: '" + searchTerm + "', Catégorie: " + categorieIdParam);

            List<Plat> plats;
            List<Categorie> categories;

            // ÉTAPE 2: Récupération des catégories
            try {
                categories = categorieService.getToutesCategories(userId);
                System.out.println("✅ Catégories récupérées: " + categories.size());
            } catch (Exception e) {
                System.err.println("❌ Erreur récupération catégories: " + e.getMessage());
                categories = List.of();
            }

            // ÉTAPE 3: Conversion et validation des paramètres
            Long categorieId = null;
            if (categorieIdParam != null && !categorieIdParam.isEmpty()) {
                try {
                    categorieId = Long.parseLong(categorieIdParam);
                } catch (NumberFormatException e) {
                    System.err.println("❌ Format ID catégorie invalide: " + categorieIdParam);
                }
            }

            // ÉTAPE 4: Logique de filtrage/recherche
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                System.out.println("🔍 Recherche plats avec terme: '" + searchTerm + "'");
                try {
                    plats = platService.rechercherPlats(userId, searchTerm);
                    request.setAttribute("searchTerm", searchTerm);
                    request.setAttribute("pageTitle", "Résultats pour: " + searchTerm);
                    System.out.println("✅ Recherche terminée - " + plats.size() + " résultats");
                } catch (Exception e) {
                    System.err.println("❌ Erreur recherche: " + e.getMessage());
                    plats = List.of();
                    request.setAttribute("errorMessage", "Erreur recherche: " + e.getMessage());
                }
            } else if (categorieId != null) {
                System.out.println("📁 Filtrage par catégorie: " + categorieId);
                try {
                    plats = platService.getPlatsParCategorie(userId, categorieId);

                    // CORRECTION: Variable final pour lambda expression
                    final Long finalCategorieId = categorieId;
                    String nomCategorie = categories.stream()
                            .filter(c -> c.getId().equals(finalCategorieId))
                            .findFirst()
                            .map(Categorie::getNom)
                            .orElse("Catégorie");

                    request.setAttribute("selectedCategorieId", categorieId);
                    request.setAttribute("pageTitle", nomCategorie);
                    System.out.println("✅ Filtrage terminé - " + plats.size() + " résultats");
                } catch (Exception e) {
                    System.err.println("❌ Erreur filtrage: " + e.getMessage());
                    plats = List.of();
                    request.setAttribute("errorMessage", "Erreur filtrage: " + e.getMessage());
                }
            } else {
                System.out.println("📋 Affichage de tous les plats disponibles");
                try {
                    plats = platService.getMenuDisponible();
                    request.setAttribute("pageTitle", "Carte des Plats");
                    System.out.println("✅ Tous les plats récupérés: " + plats.size());
                } catch (Exception e) {
                    System.err.println("❌ Erreur récupération plats: " + e.getMessage());
                    plats = List.of();
                    request.setAttribute("errorMessage", "Erreur chargement plats: " + e.getMessage());
                }
            }

            // ÉTAPE 5: Préparation des données pour le JSP
            request.setAttribute("plats", plats);
            request.setAttribute("categories", categories);
            request.setAttribute("activePage", "plats");

            // ÉTAPE 6: Transmission au JSP
            System.out.println("✅ Données prêtes - Plats: " + plats.size() + ", Catégories: " + categories.size());

            String jspPath = "/views/Serveur/plats.jsp";
            System.out.println("➡️ Forwarding to: " + jspPath);

            request.getRequestDispatcher(jspPath).forward(request, response);
            System.out.println("✅ Forwarding réussi");

        } catch (Exception e) {
            System.err.println("❌ Erreur critique dans afficherCartePlats: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement de la carte des plats", e);
        }
    }
}