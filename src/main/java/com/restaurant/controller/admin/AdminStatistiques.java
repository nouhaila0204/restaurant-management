package com.restaurant.controller.admin;

import com.restaurant.service.AuthenticationService;
import com.restaurant.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

@WebServlet("/admin/statistiques")
public class AdminStatistiques extends HttpServlet {
    private AuthenticationService authService = new AuthenticationService();
    private CommandeDAO commandeDAO = new CommandeDAO();
    private PlatDAO platDAO = new PlatDAO();
    private ClientDAO clientDAO = new ClientDAO();
    private TableRestaurantDAO tableDAO = new TableRestaurantDAO(); // ✅ AJOUT

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null || !authService.estAdmin(userId)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Récupérer les paramètres de période
            String dateDebutStr = request.getParameter("dateDebut");
            String dateFinStr = request.getParameter("dateFin");

            LocalDate dateDebut = dateDebutStr != null ? LocalDate.parse(dateDebutStr) : LocalDate.now().minusDays(30);
            LocalDate dateFin = dateFinStr != null ? LocalDate.parse(dateFinStr) : LocalDate.now();

            // ✅ RÉCUPÉRER TOUTES LES DONNÉES COMME DANS DASHBOARD
            Map<String, Long> userStats = authService.getStatistiquesUtilisateurs();
            Long totalCommandes = commandeDAO.countAll();
            Long totalPlats = platDAO.countAll();
            Long totalClients = clientDAO.countAll();
            Long tablesDisponiblesCount = tableDAO.countTablesLibres(); // ✅ AJOUT
            Double chiffreAffaireTotal = commandeDAO.getChiffreAffaireTotal();

            // Statistiques par période
            Double chiffreAffairePeriode = commandeDAO.getChiffreAffaireParPeriode(
                    java.sql.Date.valueOf(dateDebut),
                    java.sql.Date.valueOf(dateFin)
            );

            Map<String, Long> commandesParStatut = commandeDAO.getCommandesCountByStatus();
            Map<String, Long> platsPopulaires = platDAO.getPlatsLesPlusVendus(10);

            // ✅ AJOUTER L'ATTRIBUT userNom MANQUANT
            String userNom = (String) session.getAttribute("userNom");

            // Débuggage
            System.out.println("=== 📊 Statistiques Chargées ===");
            System.out.println("User Stats: " + userStats);
            System.out.println("Total Commandes: " + totalCommandes);
            System.out.println("Total Plats: " + totalPlats);
            System.out.println("Total Clients: " + totalClients);
            System.out.println("Tables Libres: " + tablesDisponiblesCount);
            System.out.println("Chiffre Affaire Total: " + chiffreAffaireTotal);
            System.out.println("Chiffre Affaire Période: " + chiffreAffairePeriode);
            System.out.println("Commandes par Statut: " + commandesParStatut);
            System.out.println("Plats Populaires: " + platsPopulaires);

            // ✅ SET TOUS LES ATTRIBUTS
            request.setAttribute("userStats", userStats);
            request.setAttribute("totalCommandes", totalCommandes);
            request.setAttribute("totalPlats", totalPlats);
            request.setAttribute("totalClients", totalClients);
            request.setAttribute("tablesDisponiblesCount", tablesDisponiblesCount); // ✅ AJOUT
            request.setAttribute("chiffreAffaireTotal", chiffreAffaireTotal);
            request.setAttribute("chiffreAffairePeriode", chiffreAffairePeriode);
            request.setAttribute("commandesParStatut", commandesParStatut);
            request.setAttribute("platsPopulaires", platsPopulaires);
            request.setAttribute("dateDebut", dateDebut);
            request.setAttribute("dateFin", dateFin);
            request.setAttribute("userNom", userNom); // ✅ AJOUT IMPORTANT

            // ✅ CORRECTION CHEMIN JSP
            request.getRequestDispatcher("/views/admin/statistiques.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des statistiques: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/statistiques.jsp").forward(request, response);
        }
    }
}