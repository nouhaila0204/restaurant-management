<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.Categorie" %>
<%
    String contextPath = request.getContextPath();
    List<Categorie> categories = (List<Categorie>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Catégories - Tablaino Restaurant</title>

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

        .categorie-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }

        .categorie-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .categorie-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .badge-plats {
            background: linear-gradient(135deg, var(--admin-success) 0%, #229954 100%);
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
        <jsp:param name="activePage" value="categories" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Gestion des Catégories</h1>
                    <p class="page-subtitle mb-0">Organisez les catégories de plats du restaurant</p>
                </div>
                <!-- CORRECTION : Nouvelle catégorie -->
                <a href="<%= contextPath %>/admin/categories?action=create" class="btn-admin">
                    <i class="bi bi-plus-circle me-2"></i>Nouvelle Catégorie
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

        <!-- Grille des Catégories -->
        <div class="content-card">
            <div class="card-header-custom">
                <i class="bi bi-tags me-2"></i>Liste des Catégories
            </div>
            <div class="p-4">
                <%
                    if (categories != null && !categories.isEmpty()) {
                %>
                    <div class="row g-4">
                        <% for (Categorie categorie : categories) { %>
                            <div class="col-xl-4 col-lg-6 col-md-6">
                                <div class="card categorie-card h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-start mb-3">
                                            <div class="categorie-icon me-3">
                                                <i class="bi bi-tag"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <h5 class="card-title fw-bold mb-1"><%= categorie.getNom() %></h5>
                                                <p class="card-text text-muted small mb-2">
                                                    <%= categorie.getDescription() != null && !categorie.getDescription().isEmpty() ?
                                                        categorie.getDescription() : "Aucune description" %>
                                                </p>
                                                <span class="badge badge-plats">
                                                    <i class="bi bi-egg-fried me-1"></i>
                                                    <%= categorie.getPlats() != null ? categorie.getPlats().size() : 0 %> plats
                                                </span>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted">
                                                ID: #<%= categorie.getId() %>
                                            </small>
                                            <div class="btn-group">
                                                <a href="<%= contextPath %>/admin/categories?action=edit&id=<%= categorie.getId() %>"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <% if (categorie.getPlats() == null || categorie.getPlats().isEmpty()) { %>
                                                    <form method="post" action="<%= contextPath %>/admin/categories"
                                                          style="display: inline;"
                                                          onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette catégorie ?')">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="<%= categorie.getId() %>">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                <% } else { %>
                                                    <button class="btn btn-sm btn-outline-secondary"
                                                            title="Impossible de supprimer - Catégorie contient des plats"
                                                            disabled>
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-tags display-1 text-muted"></i>
                        <h4 class="text-muted mt-3">Aucune catégorie trouvée</h4>
                        <p class="text-muted">Commencez par créer une nouvelle catégorie</p>
                        <a href="<%= contextPath %>/admin/categories?action=create" class="btn-admin">
                            <i class="bi bi-plus-circle me-2"></i>Créer une Catégorie
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