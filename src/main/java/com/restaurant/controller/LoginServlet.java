package com.restaurant.controller;

import com.restaurant.service.AuthenticationService;
import com.restaurant.model.User;
import com.restaurant.model.User.RoleUser; // Import de l'Enum

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AuthenticationService authService;

    @Override
    public void init() throws ServletException {
        this.authService = new AuthenticationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            // Convertir le String stocké en session vers l'Enum
            String roleString = (String) session.getAttribute("userRole");
            RoleUser role = RoleUser.valueOf(roleString);
            redirectByRole(role, request, response);
            return;
        }
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Optional<User> userOpt = authService.authentifier(email, password);

            if (userOpt.isPresent()) {
                User user = userOpt.get();
                RoleUser role = user.getRole();

                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("userNom", user.getNom());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userRole", role.name()); // Stocker le nom de l'Enum
                session.setMaxInactiveInterval(30 * 60);

                redirectByRole(role, request, response);

            } else {
                request.setAttribute("errorMessage", "Email ou mot de passe incorrect");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de l'authentification: " + e.getMessage());
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    // Méthode modifiée pour accepter l'Enum
    private void redirectByRole(RoleUser role, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String contextPath = request.getContextPath();

        switch (role) {
            case ADMIN:
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case SERVEUR:
                response.sendRedirect(contextPath + "/serveur/dashboard");
                break;
            default:
                response.sendRedirect(contextPath + "/dashboard");
        }
    }
}