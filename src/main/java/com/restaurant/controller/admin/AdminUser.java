package com.restaurant.controller.admin;

import com.restaurant.model.User;
import com.restaurant.service.AuthenticationService;
import com.restaurant.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/users")
public class AdminUser extends HttpServlet {
    private AuthenticationService authService = new AuthenticationService();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        // Vérifier l'authentification et les permissions
        if (userId == null || !authService.estAdmin(userId)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action == null) {
                // Lister tous les utilisateurs
                List<User> users = authService.listerTousUtilisateurs();
                request.setAttribute("users", users);
                request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);

            } else if ("edit".equals(action)) {
                // Afficher le formulaire d'édition
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    Long id = Long.parseLong(idParam);
                    Optional<User> userOpt = authService.trouverUtilisateurParId(id);
                    if (userOpt.isPresent()) {
                        request.setAttribute("user", userOpt.get());
                        request.getRequestDispatcher("/views/admin/edit-user.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Utilisateur non trouvé");
                    }
                }

            } else if ("create".equals(action)) {
                // Afficher le formulaire de création
                request.getRequestDispatcher("/views/admin/create-user.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
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
            if ("create".equals(action)) {
                createUser(request, response);
            } else if ("update".equals(action)) {
                updateUser(request, response);
            } else if ("delete".equals(action)) {
                deleteUser(request, response);
            } else if ("changeRole".equals(action)) {
                changeUserRole(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleStr = request.getParameter("role");

        User.RoleUser role = User.RoleUser.valueOf(roleStr);

        User newUser = authService.creerUser(nom, email, password, role);
        request.setAttribute("success", "Utilisateur cree avec succes: " + newUser.getNom());

        // Rediriger vers la liste
        response.sendRedirect(request.getContextPath() + "/admin/users?success=Utilisateur cree avec succes");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String roleStr = request.getParameter("role");

        Optional<User> userOpt = userDAO.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setNom(nom);
            user.setEmail(email);
            user.setRole(User.RoleUser.valueOf(roleStr));

            userDAO.update(user);
            request.setAttribute("success", "Utilisateur modifie avec succes");
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?success=Utilisateur modifie avec succes");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));

        // Empêcher la suppression de soi-même
        Long currentUserId = (Long) request.getSession().getAttribute("userId");
        if (id.equals(currentUserId)) {
            request.setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte");
            doGet(request, response);
            return;
        }

        userDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/users?success=Utilisateur supprime avec succes");
    }

    private void changeUserRole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String newRole = request.getParameter("newRole");

        Optional<User> userOpt = userDAO.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setRole(User.RoleUser.valueOf(newRole));
            userDAO.update(user);
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?success=Rôle modifie avec succes");
    }
}