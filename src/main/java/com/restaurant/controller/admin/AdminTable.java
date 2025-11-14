package com.restaurant.controller.admin;

import com.restaurant.model.TableRestaurant;
import com.restaurant.service.AuthenticationService;
import com.restaurant.dao.TableRestaurantDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/tables")
public class AdminTable extends HttpServlet {
    private AuthenticationService authService = new AuthenticationService();
    private TableRestaurantDAO tableDAO = new TableRestaurantDAO();

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
                // Lister toutes les tables
                List<TableRestaurant> tables = tableDAO.findAll();
                request.setAttribute("tables", tables);
                request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                // Afficher le formulaire d'édition
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    Long id = Long.parseLong(idParam);
                    Optional<TableRestaurant> tableOpt = tableDAO.findById(id);
                    if (tableOpt.isPresent()) {
                        request.setAttribute("table", tableOpt.get());
                        request.getRequestDispatcher("/views/admin/edit-table.jsp").forward(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Table non trouvée");
                    }
                }

            } else if ("create".equals(action)) {
                // Afficher le formulaire de création
                request.getRequestDispatcher("/views/admin/create-table.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
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
                createTable(request, response);
            } else if ("update".equals(action)) {
                updateTable(request, response);
            } else if ("delete".equals(action)) {
                deleteTable(request, response);
            } else if ("changeStatus".equals(action)) {
                changeTableStatus(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void createTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String numero = request.getParameter("numero");
        Integer capacite = Integer.parseInt(request.getParameter("capacite"));

        TableRestaurant table = new TableRestaurant(numero, capacite);
        tableDAO.save(table);

        response.sendRedirect(request.getContextPath() + "/admin/tables?success=Table créée avec succès");
    }

    private void updateTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String numero = request.getParameter("numero");
        Integer capacite = Integer.parseInt(request.getParameter("capacite"));

        Optional<TableRestaurant> tableOpt = tableDAO.findById(id);
        if (tableOpt.isPresent()) {
            TableRestaurant table = tableOpt.get();
            table.setNumero(numero);
            table.setCapacite(capacite);
            tableDAO.update(table);
        }

        response.sendRedirect(request.getContextPath() + "/admin/tables?success=Table modifiée avec succès");
    }

    private void deleteTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        tableDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/tables?success=Table supprimée avec succès");
    }

    private void changeTableStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String newStatus = request.getParameter("newStatus");

        Optional<TableRestaurant> tableOpt = tableDAO.findById(id);
        if (tableOpt.isPresent()) {
            TableRestaurant table = tableOpt.get();
            table.setStatut(TableRestaurant.StatutTable.valueOf(newStatus));
            tableDAO.update(table);
        }

        response.sendRedirect(request.getContextPath() + "/admin/tables?success=Statut de la table modifié");
    }
}