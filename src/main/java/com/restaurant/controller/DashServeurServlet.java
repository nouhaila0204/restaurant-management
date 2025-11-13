package com.restaurant.controller;

import com.restaurant.service.CommandeService;
import com.restaurant.service.TableService;
import com.restaurant.service.PlatService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/serveur/dashboard")
public class DashServeurServlet extends HttpServlet {
    private CommandeService commandeService;
    private TableService tableService;
    private PlatService platService;

    @Override
    public void init() throws ServletException {
        this.commandeService = new CommandeService();
        this.tableService = new TableService();
        this.platService = new PlatService();
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
        String userRole = (String) session.getAttribute("userRole");

        // Vérifier que c'est bien un serveur
        if (!"SERVEUR".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        try {
            // Initialiser avec des listes vides par défaut
            List<?> commandesEnCours = new ArrayList<>();
            List<?> tablesDisponibles = new ArrayList<>();
            List<?> platsDisponibles = new ArrayList<>();
            int nombreCommandesAujourdhui = 0;

            // Récupérer les données avec gestion d'erreur individuelle
            try {
                commandesEnCours = commandeService.getCommandesEnCours(userId);
                if (commandesEnCours == null) commandesEnCours = new ArrayList<>();
            } catch (Exception e) {
                System.err.println("❌ Erreur commandes en cours: " + e.getMessage());
                e.printStackTrace();
            }

            try {
                tablesDisponibles = tableService.getTablesLibres(userId);
                if (tablesDisponibles == null) tablesDisponibles = new ArrayList<>();
            } catch (Exception e) {
                System.err.println("❌ Erreur tables libres: " + e.getMessage());
                e.printStackTrace();
            }

            try {
                platsDisponibles = platService.getMenuDisponible();
                if (platsDisponibles == null) platsDisponibles = new ArrayList<>();
            } catch (Exception e) {
                System.err.println("❌ Erreur plats disponibles: " + e.getMessage());
                e.printStackTrace();
            }

            try {
                List<?> commandesDuJour = commandeService.getCommandesDuJour(userId);
                nombreCommandesAujourdhui = (commandesDuJour != null) ? commandesDuJour.size() : 0;
            } catch (Exception e) {
                System.err.println("❌ Erreur commandes du jour: " + e.getMessage());
                e.printStackTrace();
            }

            // ✅ CORRECTION : Utiliser les bons noms d'attributs
            request.setAttribute("nombreComm", nombreCommandesAujourdhui);
            request.setAttribute("commandesEnCoursCount", commandesEnCours.size());
            request.setAttribute("tablesDisponiblesCount", tablesDisponibles.size());
            request.setAttribute("platsDisponiblesCount", platsDisponibles.size());
            request.setAttribute("serveurNom", session.getAttribute("userNom"));

            // Passer aussi les listes complètes si nécessaire pour d'autres sections
            request.setAttribute("commandesEnCours", commandesEnCours);
            request.setAttribute("tablesDisponibles", tablesDisponibles);
            request.setAttribute("platsDisponibles", platsDisponibles);

            // Logs de débogage
            System.out.println("=== 🚀 Dashboard Serveur ===");
            System.out.println("✅ Commandes aujourd'hui: " + nombreCommandesAujourdhui);
            System.out.println("✅ Commandes en cours: " + commandesEnCours.size());
            System.out.println("✅ Tables disponibles: " + tablesDisponibles.size());
            System.out.println("✅ Plats disponibles: " + platsDisponibles.size());
            System.out.println("✅ Serveur: " + session.getAttribute("userNom"));

            request.getRequestDispatcher("/views/Serveur/DashboardServeur.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            // En cas d'erreur globale, utiliser des valeurs par défaut
            request.setAttribute("nombreComm", 0);
            request.setAttribute("commandesEnCoursCount", 0);
            request.setAttribute("tablesDisponiblesCount", 0);
            request.setAttribute("platsDisponiblesCount", 0);
            request.setAttribute("serveurNom", session.getAttribute("userNom"));
            request.setAttribute("errorMessage", "Erreur lors du chargement du dashboard: " + e.getMessage());

            request.getRequestDispatcher("/views/Serveur/DashboardServeur.jsp").forward(request, response);
        }
    }
}