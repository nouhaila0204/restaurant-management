package com.restaurant.controller;

import com.restaurant.service.UserService;
import com.restaurant.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/serveur/profile")
public class ProfilServeurServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
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

        try {
            // Récupérer les informations de l'utilisateur
            User user = userService.getUtilisateurParId(userId, userId);

            // Préparer les données pour la vue
            request.setAttribute("user", user);
            request.setAttribute("activePage", "profile");

            // Afficher la page de profil
            request.getRequestDispatcher("/views/Serveur/profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors du chargement du profil: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/serveur/dashboard");
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
        String action = request.getParameter("action");

        try {
            if ("changer-motdepasse".equals(action)) {
                changerMotDePasse(request, response, userId);
            } else {
                session.setAttribute("errorMessage", "Action non reconnue");
                response.sendRedirect(request.getContextPath() + "/serveur/profile");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/serveur/profile");
        }
    }

    private void changerMotDePasse(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws IOException {

        String ancienMotDePasse = request.getParameter("ancienMotDePasse");
        String nouveauMotDePasse = request.getParameter("nouveauMotDePasse");
        String confirmationMotDePasse = request.getParameter("confirmationMotDePasse");

        HttpSession session = request.getSession();

        // Validation des champs
        if (ancienMotDePasse == null || ancienMotDePasse.trim().isEmpty()) {
            session.setAttribute("errorMessage", "L'ancien mot de passe est requis");
            response.sendRedirect(request.getContextPath() + "/serveur/profile");
            return;
        }

        if (nouveauMotDePasse == null || nouveauMotDePasse.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Le nouveau mot de passe est requis");
            response.sendRedirect(request.getContextPath() + "/serveur/profile");
            return;
        }

        if (!nouveauMotDePasse.equals(confirmationMotDePasse)) {
            session.setAttribute("errorMessage", "Les nouveaux mots de passe ne correspondent pas");
            response.sendRedirect(request.getContextPath() + "/serveur/profile");
            return;
        }

        if (nouveauMotDePasse.length() < 4) {
            session.setAttribute("errorMessage", "Le nouveau mot de passe doit contenir au moins 4 caractères");
            response.sendRedirect(request.getContextPath() + "/serveur/profile");
            return;
        }

        // Changer le mot de passe
        userService.changerMotDePasse(userId, ancienMotDePasse, nouveauMotDePasse);

        session.setAttribute("successMessage", "Mot de passe changé avec succès");
        response.sendRedirect(request.getContextPath() + "/serveur/profile");
    }
}
