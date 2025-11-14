package com.restaurant.controller.admin;

import com.restaurant.model.Plat;
import com.restaurant.model.Categorie;
import com.restaurant.service.AuthenticationService;
import com.restaurant.dao.PlatDAO;
import com.restaurant.dao.CategorieDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/plats")
public class AdminPlat extends HttpServlet {
    private AuthenticationService authService = new AuthenticationService();
    private PlatDAO platDAO = new PlatDAO();
    private CategorieDAO categorieDAO = new CategorieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        // Vérification simplifiée pour debug
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            System.out.println("=== 🚀 AdminPlat doGet ===");
            System.out.println("✅ Action: " + action);

            if (action == null) {
                // Lister tous les plats AVEC LES CATÉGORIES
                List<Plat> plats = platDAO.findAllWithCategories();

                // Logs de débogage
                System.out.println("✅ Nombre de plats récupérés: " + (plats != null ? plats.size() : "null"));
                if (plats != null && !plats.isEmpty()) {
                    for (Plat plat : plats) {
                        System.out.println("🍽️ Plat: " + plat.getNom() +
                                " - Catégorie: " + (plat.getCategorie() != null ? plat.getCategorie().getNom() : "N/A"));
                    }
                }

                request.setAttribute("plats", plats);
                request.getRequestDispatcher("/views/admin/plats.jsp").forward(request, response);

            } else if ("edit".equals(action)) {
                // Afficher le formulaire d'édition
                String idParam = request.getParameter("id");
                System.out.println("✏️ Édition du plat ID: " + idParam);
                System.out.println("📁 Chemin JSP: /views/admin/edit-plat.jsp");

                if (idParam != null) {
                    try {
                        Long id = Long.parseLong(idParam);
                        Optional<Plat> platOpt = platDAO.findById(id);
                        System.out.println("🔍 Plat trouvé en base: " + platOpt.isPresent());

                        if (platOpt.isPresent()) {
                            List<Categorie> categories = categorieDAO.findAll();
                            System.out.println("✅ Catégories trouvées: " + categories.size());

                            request.setAttribute("plat", platOpt.get());
                            request.setAttribute("categories", categories);

                            // Vérifier si le forward fonctionne
                            try {
                                request.getRequestDispatcher("/views/admin/edit-plat.jsp").forward(request, response);
                                System.out.println("✅ Forward réussi vers edit-plat.jsp");
                            } catch (Exception e) {
                                System.err.println("❌ Erreur forward edit: " + e.getMessage());
                                e.printStackTrace();
                            }
                        } else {
                            System.err.println("❌ Plat non trouvé pour ID: " + id);
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Plat non trouvé");
                        }
                    } catch (NumberFormatException e) {
                        System.err.println("❌ Format ID invalide: " + idParam);
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
                    }
                } else {
                    System.err.println("❌ Paramètre ID manquant");
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID manquant");
                }

            } else if ("create".equals(action)) {
                // Afficher le formulaire de création
                System.out.println("➕ Affichage formulaire création - DEBUT");
                System.out.println("📁 Chemin JSP: /views/admin/create-plat.jsp");

                List<Categorie> categories = categorieDAO.findAll();
                System.out.println("✅ Catégories trouvées: " + (categories != null ? categories.size() : "null"));

                request.setAttribute("categories", categories);

                // Vérifier si le forward fonctionne
                try {
                    request.getRequestDispatcher("/views/admin/create-plat.jsp").forward(request, response);
                    System.out.println("✅ Forward réussi vers create-plat.jsp");
                } catch (Exception e) {
                    System.err.println("❌ Erreur forward: " + e.getMessage());
                    e.printStackTrace();
                }

            } else {
                // Action non reconnue, retour à la liste
                System.out.println("❌ Action non reconnue: " + action);
                response.sendRedirect(request.getContextPath() + "/admin/plats");
            }

        } catch (Exception e) {
            System.err.println("❌ Erreur dans AdminPlat: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/plats.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null || !authService.estAdmin(userId)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            System.out.println("=== 🚀 AdminPlat doPost ===");
            System.out.println("✅ Action POST: " + action);

            if ("create".equals(action)) {
                createPlat(request, response);
            } else if ("update".equals(action)) {
                updatePlat(request, response);
            } else if ("delete".equals(action)) {
                deletePlat(request, response);
            } else if ("toggleDisponibility".equals(action)) {
                toggleDisponibility(request, response);
            } else {
                // Action non reconnue
                response.sendRedirect(request.getContextPath() + "/admin/plats");
            }

        } catch (Exception e) {
            System.err.println("❌ Erreur POST dans AdminPlat: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void createPlat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("➕ Création d'un nouveau plat");

            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            Double prix = Double.parseDouble(request.getParameter("prix"));
            Long categorieId = Long.parseLong(request.getParameter("categorieId"));

            System.out.println("📝 Données reçues - Nom: " + nom + ", Prix: " + prix + ", Catégorie: " + categorieId);

            Plat plat = new Plat();
            plat.setNom(nom);
            plat.setDescription(description);
            plat.setPrix(prix);
            plat.setDisponible(true);

            Optional<Categorie> categorieOpt = categorieDAO.findById(categorieId);
            if (categorieOpt.isPresent()) {
                plat.setCategorie(categorieOpt.get());
                System.out.println("✅ Catégorie trouvée: " + categorieOpt.get().getNom());
            } else {
                System.out.println("❌ Catégorie non trouvée pour ID: " + categorieId);
            }

            platDAO.save(plat);
            System.out.println("✅ Plat créé avec succès: " + plat.getNom());

            response.sendRedirect(request.getContextPath() + "/admin/plats?success=Plat créé avec succès");

        } catch (Exception e) {
            System.err.println("❌ Erreur création plat: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/plats?action=create&error=Erreur lors de la création: " + e.getMessage());
        }
    }

    private void updatePlat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            Double prix = Double.parseDouble(request.getParameter("prix"));
            Long categorieId = Long.parseLong(request.getParameter("categorieId"));

            System.out.println("✏️ Mise à jour plat ID: " + id);

            Optional<Plat> platOpt = platDAO.findById(id);
            if (platOpt.isPresent()) {
                Plat plat = platOpt.get();
                plat.setNom(nom);
                plat.setDescription(description);
                plat.setPrix(prix);

                Optional<Categorie> categorieOpt = categorieDAO.findById(categorieId);
                if (categorieOpt.isPresent()) {
                    plat.setCategorie(categorieOpt.get());
                }

                platDAO.update(plat);
                System.out.println("✅ Plat mis à jour: " + plat.getNom());
            }

            response.sendRedirect(request.getContextPath() + "/admin/plats?success=Plat modifié avec succès");

        } catch (Exception e) {
            System.err.println("❌ Erreur mise à jour plat: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/plats?action=edit&id=" + request.getParameter("id") + "&error=Erreur lors de la modification: " + e.getMessage());
        }
    }

    private void deletePlat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        platDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/plats?success=Plat supprimé avec succès");
    }

    private void toggleDisponibility(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        Optional<Plat> platOpt = platDAO.findById(id);
        if (platOpt.isPresent()) {
            Plat plat = platOpt.get();
            plat.setDisponible(!plat.isDisponible());
            platDAO.update(plat);
        }

        response.sendRedirect(request.getContextPath() + "/admin/plats?success=Disponibilité modifiée");
    }
}