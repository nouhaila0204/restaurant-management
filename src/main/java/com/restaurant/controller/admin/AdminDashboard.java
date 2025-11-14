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
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboard extends HttpServlet {
    private AuthenticationService authService;
    private CommandeDAO commandeDAO;
    private PlatDAO platDAO;
    private ClientDAO clientDAO;
    private TableRestaurantDAO tableDAO;

    @Override
    public void init() throws ServletException {
        this.authService = new AuthenticationService();
        this.commandeDAO = new CommandeDAO();
        this.platDAO = new PlatDAO();
        this.clientDAO = new ClientDAO();
        this.tableDAO = new TableRestaurantDAO();
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

        // Vérifier que c'est bien un admin
        if (!authService.estAdmin(userId)) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        try {
            // Initialiser avec des valeurs par défaut
            Map<String, Long> userStats = null;
            Long totalCommandes = 0L;
            Long totalPlats = 0L;
            Long totalClients = 0L;
            Long tablesDisponiblesCount = 0L;
            Double chiffreAffaire = 0.0;

            // Récupérer les données avec gestion d'erreur individuelle
            try {
                userStats = authService.getStatistiquesUtilisateurs();
                if (userStats == null) {
                    userStats = java.util.Map.of(
                            "total", 0L,
                            "administrateurs", 0L,
                            "serveurs", 0L
                    );
                }
            } catch (Exception e) {
                System.err.println("❌ Erreur statistiques utilisateurs: " + e.getMessage());
                e.printStackTrace();
                userStats = java.util.Map.of(
                        "total", 0L,
                        "administrateurs", 0L,
                        "serveurs", 0L
                );
            }

            try {
                totalCommandes = commandeDAO.countAll();
                if (totalCommandes == null) totalCommandes = 0L;
            } catch (Exception e) {
                System.err.println("❌ Erreur nombre de commandes: " + e.getMessage());
                e.printStackTrace();
                totalCommandes = 0L;
            }

            try {
                totalPlats = platDAO.countAll();
                if (totalPlats == null) totalPlats = 0L;
            } catch (Exception e) {
                System.err.println("❌ Erreur nombre de plats: " + e.getMessage());
                e.printStackTrace();
                totalPlats = 0L;
            }

            try {
                totalClients = clientDAO.countAll();
                if (totalClients == null) totalClients = 0L;
            } catch (Exception e) {
                System.err.println("❌ Erreur nombre de clients: " + e.getMessage());
                e.printStackTrace();
                totalClients = 0L;
            }

            try {
                tablesDisponiblesCount = tableDAO.countTablesLibres();
                if (tablesDisponiblesCount == null) tablesDisponiblesCount = 0L;
            } catch (Exception e) {
                System.err.println("❌ Erreur tables libres: " + e.getMessage());
                e.printStackTrace();
                tablesDisponiblesCount = 0L;
            }

            try {
                chiffreAffaire = commandeDAO.getChiffreAffaireTotal();
                if (chiffreAffaire == null) chiffreAffaire = 0.0;
            } catch (Exception e) {
                System.err.println("❌ Erreur chiffre d'affaire: " + e.getMessage());
                e.printStackTrace();
                chiffreAffaire = 0.0;
            }

            // ✅ Préparer les données pour la vue
            request.setAttribute("userStats", userStats);
            request.setAttribute("totalCommandes", totalCommandes);
            request.setAttribute("totalPlats", totalPlats);
            request.setAttribute("totalClients", totalClients);
            request.setAttribute("tablesDisponiblesCount", tablesDisponiblesCount);
            request.setAttribute("chiffreAffaire", chiffreAffaire);
            request.setAttribute("userNom", session.getAttribute("userNom"));

            // Logs de débogage
            System.out.println("=== 🚀 Dashboard Admin ===");
            System.out.println("✅ Utilisateurs total: " + userStats.get("total"));
            System.out.println("✅ Administrateurs: " + userStats.get("administrateurs"));
            System.out.println("✅ Serveurs: " + userStats.get("serveurs"));
            System.out.println("✅ Commandes total: " + totalCommandes);
            System.out.println("✅ Plats total: " + totalPlats);
            System.out.println("✅ Clients total: " + totalClients);
            System.out.println("✅ Tables libres: " + tablesDisponiblesCount);
            System.out.println("✅ Chiffre d'affaire: " + chiffreAffaire);
            System.out.println("✅ Admin: " + session.getAttribute("userNom"));

            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            // En cas d'erreur globale, utiliser des valeurs par défaut
            Map<String, Long> defaultStats = java.util.Map.of(
                    "total", 0L,
                    "administrateurs", 0L,
                    "serveurs", 0L
            );

            request.setAttribute("userStats", defaultStats);
            request.setAttribute("totalCommandes", 0L);
            request.setAttribute("totalPlats", 0L);
            request.setAttribute("totalClients", 0L);
            request.setAttribute("tablesDisponiblesCount", 0L);
            request.setAttribute("chiffreAffaire", 0.0);
            request.setAttribute("userNom", session.getAttribute("userNom"));
            request.setAttribute("error", "Erreur lors du chargement du dashboard: " + e.getMessage());

            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        }
    }
}