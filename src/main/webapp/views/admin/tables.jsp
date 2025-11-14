<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.TableRestaurant" %>
<%
    String contextPath = request.getContextPath();
    List<TableRestaurant> tables = (List<TableRestaurant>) request.getAttribute("tables");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Tables - Tablaino Restaurant</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        :root {
            --admin-primary: #2c3e50;
            --admin-secondary: #34495e;
            --admin-accent: #3498db;
            --admin-success: #27ae60;
            --admin-warning: #f39c12;
            --admin-danger: #e74c3c;
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

        .table-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            height: 100%;
        }

        .table-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .table-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 1rem;
        }

        .table-libre .table-icon {
            background: linear-gradient(135deg, var(--admin-success) 0%, #229954 100%);
            color: white;
        }

        .table-occupee .table-icon {
            background: linear-gradient(135deg, var(--admin-warning) 0%, #e67e22 100%);
            color: white;
        }

        .table-reservee .table-icon {
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
            color: white;
        }

        .badge-statut {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
        }

        .badge-libre {
            background: linear-gradient(135deg, var(--admin-success) 0%, #229954 100%);
            color: white;
        }

        .badge-occupee {
            background: linear-gradient(135deg, var(--admin-warning) 0%, #e67e22 100%);
            color: white;
        }

        .badge-reservee {
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
            color: white;
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
                    <h1 class="page-title">Gestion des Tables</h1>
                    <p class="page-subtitle mb-0">Organisez et supervisez les tables du restaurant</p>
                </div>
                <a href="<%= contextPath %>/admin/tables?action=create" class="btn-admin">
                    <i class="bi bi-plus-circle me-2"></i>Nouvelle Table
                </a>
            </div>
        </div>

        <!-- Messages -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Grille des Tables -->
        <div class="content-card">
            <div class="card-header-custom">
                <i class="bi bi-table me-2"></i>Plan des Tables
            </div>
            <div class="p-4">
                <%
                    // ✅ SUPPRIMER LA DEUXIÈME DÉCLARATION - GARDER SEULEMENT CETTE LIGNE :
                    if (tables != null && !tables.isEmpty()) {
                %>
                    <div class="row g-4">
                        <% for (TableRestaurant table : tables) {
                            String cardClass = "";
                            String badgeClass = "";
                            String statutText = "";

                            switch(table.getStatut()) {
                                case LIBRE:
                                    cardClass = "table-libre";
                                    badgeClass = "badge-libre";
                                    statutText = "Libre";
                                    break;
                                case OCCUPEE:
                                    cardClass = "table-occupee";
                                    badgeClass = "badge-occupee";
                                    statutText = "Occupée";
                                    break;
                                case RESERVEE:
                                    cardClass = "table-reservee";
                                    badgeClass = "badge-reservee";
                                    statutText = "Réservée";
                                    break;
                            }
                        %>
                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="card table-card <%= cardClass %>">
                                    <div class="card-body text-center">
                                        <div class="table-icon">
                                            <i class="bi bi-table"></i>
                                        </div>
                                        <h4 class="card-title fw-bold mb-2">Table <%= table.getNumero() %></h4>
                                        <div class="mb-3">
                                            <span class="badge-statut <%= badgeClass %>">
                                                <%= statutText %>
                                            </span>
                                        </div>
                                        <div class="table-info mb-3">
                                            <div class="mb-1">
                                                <i class="bi bi-people me-2 text-muted"></i>
                                                <span class="fw-bold"><%= table.getCapacite() %> places</span>
                                            </div>
                                            <div>
                                                <i class="bi bi-hash me-2 text-muted"></i>
                                                <small class="text-muted">ID: #<%= table.getId() %></small>
                                            </div>
                                        </div>
                                        <div class="btn-group w-100">
                                            <a href="<%= contextPath %>/admin/tables?action=edit&id=<%= table.getId() %>"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <form method="post" action="<%= contextPath %>/admin/tables"
                                                  style="display: inline;"
                                                  onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette table ?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= table.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle"
                                                        type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-gear"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li>
                                                        <form method="post" action="<%= contextPath %>/admin/tables"
                                                              style="display: block;">
                                                            <input type="hidden" name="action" value="changeStatus">
                                                            <input type="hidden" name="id" value="<%= table.getId() %>">
                                                            <input type="hidden" name="newStatus" value="LIBRE">
                                                            <button type="submit" class="dropdown-item">
                                                                <i class="bi bi-check-circle text-success me-2"></i>Libérer
                                                            </button>
                                                        </form>
                                                    </li>
                                                    <li>
                                                        <form method="post" action="<%= contextPath %>/admin/tables"
                                                              style="display: block;">
                                                            <input type="hidden" name="action" value="changeStatus">
                                                            <input type="hidden" name="id" value="<%= table.getId() %>">
                                                            <input type="hidden" name="newStatus" value="OCCUPEE">
                                                            <button type="submit" class="dropdown-item">
                                                                <i class="bi bi-person-check text-warning me-2"></i>Occuper
                                                            </button>
                                                        </form>
                                                    </li>
                                                    <li>
                                                        <form method="post" action="<%= contextPath %>/admin/tables"
                                                              style="display: block;">
                                                            <input type="hidden" name="action" value="changeStatus">
                                                            <input type="hidden" name="id" value="<%= table.getId() %>">
                                                            <input type="hidden" name="newStatus" value="RESERVEE">
                                                            <button type="submit" class="dropdown-item">
                                                                <i class="bi bi-calendar-check text-primary me-2"></i>Réserver
                                                            </button>
                                                        </form>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-table display-1 text-muted"></i>
                        <h4 class="text-muted mt-3">Aucune table trouvée</h4>
                        <p class="text-muted">Commencez par créer une nouvelle table</p>
                        <a href="<%= contextPath %>/admin/tables?action=create" class="btn-admin">
                            <i class="bi bi-plus-circle me-2"></i>Créer une Table
                        </a>
                    </div>
                <% } %>
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