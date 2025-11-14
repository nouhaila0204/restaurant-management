package com.restaurant.controller.admin;

import com.restaurant.model.Commande;
import com.restaurant.service.AuthenticationService;
import com.restaurant.dao.CommandeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/commandes")
public class AdminCommande extends HttpServlet {
    private AuthenticationService authService = new AuthenticationService();
    private CommandeDAO commandeDAO = new CommandeDAO();

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
            if (action == null) {
                // Lister toutes les commandes AVEC LES RELATIONS
                List<Commande> commandes = commandeDAO.findAllWithRelations(); // CHANGEMENT ICI

                // LOGS DE DÉBOGAGE
                System.out.println("=== 🚀 AdminCommande ===");
                System.out.println("✅ Nombre de commandes récupérées: " + (commandes != null ? commandes.size() : "null"));
                if (commandes != null && !commandes.isEmpty()) {
                    for (Commande cmd : commandes) {
                        System.out.println("📦 Commande #" + cmd.getNumero() +
                                " - Table: " + (cmd.getTable() != null ? cmd.getTable().getNumero() : "N/A") +
                                " - Serveur: " + (cmd.getServeur() != null ? cmd.getServeur().getNom() : "N/A") +
                                " - " + cmd.getMontantTotal() + "€ - " + cmd.getStatut());
                    }
                }

                request.setAttribute("commandes", commandes);
                request.getRequestDispatcher("/views/admin/commandes.jsp").forward(request, response);

            } else if ("view".equals(action)) {
                // Voir les détails d'une commande
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    Long id = Long.parseLong(idParam);
                    Optional<Commande> commandeOpt = commandeDAO.findById(id);
                    if (commandeOpt.isPresent()) {
                        request.setAttribute("commande", commandeOpt.get());
                        request.getRequestDispatcher("/views/admin/commande-details.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Commande non trouvée");
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("❌ Erreur dans AdminCommande: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/commandes.jsp").forward(request, response);
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
            if ("updateStatus".equals(action)) {
                updateCommandeStatus(request, response);
            } else if ("delete".equals(action)) {
                deleteCommande(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void updateCommandeStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String newStatus = request.getParameter("newStatus");

        Optional<Commande> commandeOpt = commandeDAO.findById(id);
        if (commandeOpt.isPresent()) {
            Commande commande = commandeOpt.get();
            commande.setStatut(Commande.StatutCommande.valueOf(newStatus));
            commandeDAO.update(commande);
        }

        response.sendRedirect(request.getContextPath() + "/admin/commandes?success=Statut de la commande mis à jour");
    }

    private void deleteCommande(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        commandeDAO.delete(id);

        response.sendRedirect(request.getContextPath() + "/admin/commandes?success=Commande supprimée avec succès");
    }
}