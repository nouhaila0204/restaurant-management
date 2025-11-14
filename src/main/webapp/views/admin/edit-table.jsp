<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.restaurant.model.TableRestaurant" %>
<%
    String contextPath = request.getContextPath();
    TableRestaurant table = (TableRestaurant) request.getAttribute("table");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier la Table - Tablaino Restaurant</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        :root {
            --admin-primary: #2c3e50;
            --admin-secondary: #34495e;
            --admin-accent: #3498db;
        }

        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .menu-toggle {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1001;
            background: var(--admin-primary);
            border: none;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .main-content {
            padding: 2rem;
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }

        .main-content.sidebar-open {
            margin-left: 260px;
        }

        .top-bar {
            background: white;
            padding: 1.5rem 2rem;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border-left: 4px solid var(--admin-accent);
            margin-left: 70px;
        }

        .page-title {
            color: var(--admin-primary);
            font-weight: 800;
            font-size: 1.8rem;
            margin-bottom: 0.25rem;
        }

        .content-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            overflow: hidden;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-secondary) 100%);
            color: white;
            padding: 1.25rem 1.75rem;
            border: none;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .btn-admin {
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
            border: none;
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--admin-accent);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .table-preview {
            width: 120px;
            height: 120px;
            border-radius: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            margin: 0 auto;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
            display: none;
        }

        @media (max-width: 768px) {
            .main-content.sidebar-open {
                margin-left: 0;
            }
            .top-bar {
                margin-left: 0;
            }
            .menu-toggle {
                top: 15px;
                left: 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Menu Toggle Button -->
    <button class="menu-toggle" id="menuToggle">
        <i class="bi bi-list"></i>
    </button>

    <!-- Sidebar Overlay for Mobile -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- Sidebar -->
    <jsp:include page="includes/admin-sidebar.jsp">
        <jsp:param name="activePage" value="tables" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Modifier la Table</h1>
                    <p class="page-subtitle mb-0">Modifier les informations de <%= table.getNumero() %></p>
                </div>
                <a href="<%= contextPath %>/admin/tables" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour
                </a>
            </div>
        </div>

        <!-- Formulaire d'édition -->
        <div class="row">
            <div class="col-lg-8">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-pencil me-2"></i>Modifier les informations
                    </div>
                    <div class="p-4">
                        <form method="post" action="<%= contextPath %>/admin/tables">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= table.getId() %>">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="numero" class="form-label">Numéro de table *</label>
                                    <input type="text" class="form-control" id="numero" name="numero"
                                           value="<%= table.getNumero() %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="capacite" class="form-label">Capacité *</label>
                                    <input type="number" class="form-control" id="capacite" name="capacite"
                                           min="1" max="20" value="<%= table.getCapacite() %>" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Statut actuel</label>
                                <div class="form-control bg-light">
                                    <span class="badge
                                        <%
                                            String badgeClass = "";
                                            switch(table.getStatut()) {
                                                case LIBRE: badgeClass = "bg-success"; break;
                                                case OCCUPEE: badgeClass = "bg-warning"; break;
                                                case RESERVEE: badgeClass = "bg-primary"; break;
                                            }
                                        %>
                                        <%= badgeClass %>">
                                        <%= table.getStatut() %>
                                    </span>
                                    <small class="text-muted ms-2">
                                        (Modifier via la liste des tables)
                                    </small>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="<%= contextPath %>/admin/tables" class="btn btn-outline-secondary">
                                    <i class="bi bi-x-circle me-2"></i>Annuler
                                </a>
                                <button type="submit" class="btn-admin">
                                    <i class="bi bi-check-circle me-2"></i>Enregistrer
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-info-circle me-2"></i>Informations
                    </div>
                    <div class="p-4 text-center">
                        <div class="table-preview mb-3"
                             style="background: linear-gradient(135deg,
                                 <%
                                     String gradient = "";
                                     switch(table.getStatut()) {
                                         case LIBRE: gradient = "#27ae60, #229954"; break;
                                         case OCCUPEE: gradient = "#f39c12, #e67e22"; break;
                                         case RESERVEE: gradient = "#3498db, #2980b9"; break;
                                     }
                                 %>
                                 var(--admin-<%= table.getStatut().name().toLowerCase() %>) 0%, <%= gradient %> 100%);">
                            <i class="bi bi-table display-4"></i>
                            <small class="mt-2 fw-bold"><%= table.getNumero() %></small>
                        </div>
                        <div class="table-info">
                            <div class="mb-2">
                                <i class="bi bi-people me-2"></i>
                                <span><%= table.getCapacite() %> places</span>
                            </div>
                            <div class="mb-2">
                                <i class="bi bi-hash me-2"></i>
                                <span>ID: #<%= table.getId() %></span>
                            </div>
                            <div class="badge <%= badgeClass %>">
                                <i class="bi bi-<%= table.getStatut() == TableRestaurant.StatutTable.LIBRE ? "check-circle" :
                                                  table.getStatut() == TableRestaurant.StatutTable.OCCUPEE ? "person-check" : "calendar-check" %> me-1"></i>
                                <%= table.getStatut() %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Sidebar Toggle
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');
        const sidebarOverlay = document.getElementById('sidebarOverlay');

        function toggleSidebar() {
            const isOpen = sidebar.classList.toggle('open');
            mainContent.classList.toggle('sidebar-open', isOpen);
            sidebarOverlay.classList.toggle('show', isOpen);
            menuToggle.querySelector('i').className = isOpen ? 'bi bi-x' : 'bi bi-list';
        }

        menuToggle.addEventListener('click', toggleSidebar);
        sidebarOverlay.addEventListener('click', toggleSidebar);

        if (window.innerWidth <= 768) {
            document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                link.addEventListener('click', () => {
                    if (sidebar.classList.contains('open')) {
                        toggleSidebar();
                    }
                });
            });
        }
    </script>
</body>
</html>