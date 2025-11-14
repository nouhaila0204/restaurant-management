package com.restaurant.controller.admin;

import com.restaurant.model.Categorie;
import com.restaurant.service.AuthenticationService;
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

@WebServlet("/admin/categories")
public class AdminCategorie extends HttpServlet {
    private AuthenticationService authService = new AuthenticationService();
    private CategorieDAO categorieDAO = new CategorieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null || !authService.estAdmin(userId)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            System.out.println("=== 🚀 AdminCategorie doGet ===");
            System.out.println("✅ Action: " + action);

            if (action == null) {
                // Lister toutes les catégories avec leurs plats
                System.out.println("📋 Liste des catégories");
                List<Categorie> categories = categorieDAO.findAllWithPlats();
                System.out.println("✅ Catégories trouvées: " + (categories != null ? categories.size() : "null"));

                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);

            } else if ("edit".equals(action)) {
                // Afficher le formulaire d'édition
                String idParam = request.getParameter("id");
                System.out.println("✏️ Édition catégorie ID: " + idParam);

                if (idParam != null) {
                    Long id = Long.parseLong(idParam);
                    Optional<Categorie> categorieOpt = categorieDAO.findById(id);
                    if (categorieOpt.isPresent()) {
                        request.setAttribute("categorie", categorieOpt.get());
                        request.getRequestDispatcher("/views/admin/edit-categorie.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Catégorie non trouvée");
                    }
                }

            } else if ("create".equals(action)) {
                // Afficher le formulaire de création
                System.out.println("➕ Formulaire création catégorie");
                request.getRequestDispatcher("/views/admin/create-categorie.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("❌ Erreur AdminCategorie: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);
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
            System.out.println("=== 🚀 AdminCategorie doPost ===");
            System.out.println("✅ Action POST: " + action);

            if ("create".equals(action)) {
                createCategorie(request, response);
            } else if ("update".equals(action)) {
                updateCategorie(request, response);
            } else if ("delete".equals(action)) {
                deleteCategorie(request, response);
            }

        } catch (Exception e) {
            System.err.println("❌ Erreur POST AdminCategorie: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void createCategorie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");

            System.out.println("➕ Création catégorie: " + nom);

            Categorie categorie = new Categorie(nom, description);
            categorieDAO.save(categorie);

            response.sendRedirect(request.getContextPath() + "/admin/categories?success=Catégorie créée avec succès");

        } catch (Exception e) {
            System.err.println("❌ Erreur création catégorie: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/categories?action=create&error=Erreur: " + e.getMessage());
        }
    }

    private void updateCategorie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");

            System.out.println("✏️ Mise à jour catégorie ID: " + id);

            Optional<Categorie> categorieOpt = categorieDAO.findById(id);
            if (categorieOpt.isPresent()) {
                Categorie categorie = categorieOpt.get();
                categorie.setNom(nom);
                categorie.setDescription(description);
                categorieDAO.update(categorie);
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories?success=Catégorie modifiée avec succès");

        } catch (Exception e) {
            System.err.println("❌ Erreur mise à jour catégorie: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/categories?action=edit&id=" + request.getParameter("id") + "&error=Erreur: " + e.getMessage());
        }
    }

    private void deleteCategorie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            System.out.println("🗑️ Suppression catégorie ID: " + id);

            // Vérifier si la catégorie contient des plats
            Optional<Categorie> categorieOpt = categorieDAO.findByIdWithPlats(id);
            if (categorieOpt.isPresent() && !categorieOpt.get().getPlats().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/categories?error=Impossible de supprimer: la catégorie contient des plats");
                return;
            }

            categorieDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/categories?success=Catégorie supprimée avec succès");

        } catch (Exception e) {
            System.err.println("❌ Erreur suppression catégorie: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=Erreur lors de la suppression: " + e.getMessage());
        }
    }
}