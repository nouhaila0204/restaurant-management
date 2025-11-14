package com.restaurant.controller.admin;

import com.restaurant.service.AuthenticationService;
import com.restaurant.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/profile")
public class AdminProfile extends HttpServlet {
    private AuthenticationService authService = new AuthenticationService();
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String userNom = (String) session.getAttribute("userNom");
            String userEmail = (String) session.getAttribute("userEmail");

            request.setAttribute("userNom", userNom);
            request.setAttribute("userEmail", userEmail);
            request.setAttribute("userId", userId);

            request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du profil: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("updateProfile".equals(action)) {
                // Mise à jour du profil
                String nouveauNom = request.getParameter("nom");
                String nouvelEmail = request.getParameter("email");

                var user = userService.mettreAJourProfil(userId, nouveauNom, nouvelEmail);

                // Mettre à jour la session
                session.setAttribute("userNom", user.getNom());
                session.setAttribute("userEmail", user.getEmail());

                request.setAttribute("success", "Profil mis à jour avec succès!");

            } else if ("changePassword".equals(action)) {
                // Changement de mot de passe
                String ancienMotDePasse = request.getParameter("ancienMotDePasse");
                String nouveauMotDePasse = request.getParameter("nouveauMotDePasse");
                String confirmerMotDePasse = request.getParameter("confirmerMotDePasse");

                if (!nouveauMotDePasse.equals(confirmerMotDePasse)) {
                    request.setAttribute("error", "Les mots de passe ne correspondent pas");
                } else {
                    userService.changerMotDePasse(userId, ancienMotDePasse, nouveauMotDePasse);
                    request.setAttribute("success", "Mot de passe changé avec succès!");
                }
            }

            // Recharger les données
            request.setAttribute("userNom", session.getAttribute("userNom"));
            request.setAttribute("userEmail", session.getAttribute("userEmail"));
            request.setAttribute("userId", userId);

            request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
        }
    }
}