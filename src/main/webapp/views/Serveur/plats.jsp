<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.restaurant.model.Plat, com.restaurant.model.Categorie" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carte des Plats - Tablaino Restaurant</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
            :root {
                --gold: #B8935C;
                --dark-gold: #8B6F47;
                --burgundy: #8B1A1A;
                --dark-red: #6B0F0F;
                --wood: #8B5A3C;
                --light-gold: #F5E6D3;
            }

            body {
                background: #f8f6f3;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .menu-toggle {
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: var(--burgundy);
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

            .menu-toggle:hover {
                background: var(--dark-red);
                transform: scale(1.1);
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
                border-left: 4px solid var(--gold);
                margin-left: 70px;
            }

            .page-title {
                color: var(--burgundy);
                font-weight: 800;
                font-size: 1.8rem;
                margin-bottom: 0.25rem;
            }

            .page-subtitle {
                color: var(--wood);
                font-size: 0.95rem;
            }

            .content-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: none;
                overflow: hidden;
                margin-left: 70px;
            }

            .card-header-custom {
                background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
                color: white;
                padding: 1.25rem 1.75rem;
                border: none;
                font-weight: 700;
                font-size: 1.1rem;
            }

            .form-control-custom {
                border: 2px solid #e8e4df;
                border-radius: 10px;
                padding: 0.75rem 1rem;
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            .form-control-custom:focus {
                border-color: var(--gold);
                box-shadow: 0 0 0 0.2rem rgba(184, 147, 92, 0.25);
            }

            .btn-primary-custom {
                background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
                border: none;
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 10px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(184, 147, 92, 0.4);
            }

            .btn-outline-custom {
                background: transparent;
                border: 2px solid var(--gold);
                color: var(--gold);
                padding: 0.5rem 1.25rem;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }

            .btn-outline-custom:hover {
                background: var(--gold);
                color: white;
            }

            .btn-categorie {
                background: white;
                border: 2px solid var(--wood);
                color: var(--wood);
                padding: 0.75rem 1.5rem;
                border-radius: 10px;
                font-weight: 600;
                transition: all 0.3s ease;
                margin: 0.25rem;
                text-decoration: none;
                display: inline-block;
            }

            .btn-categorie:hover, .btn-categorie.active {
                background: var(--wood);
                color: white;
                transform: translateY(-2px);
            }

            .plat-card {
                background: white;
                border: 2px solid #f0ebe5;
                border-radius: 12px;
                padding: 1.5rem;
                transition: all 0.3s ease;
                height: 100%;
                position: relative;
            }

            .plat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                border-color: var(--gold);
            }

            .plat-nom {
                color: var(--burgundy);
                font-weight: 700;
                font-size: 1.2rem;
                margin-bottom: 0.5rem;
            }

            .plat-description {
                color: var(--wood);
                font-size: 0.9rem;
                margin-bottom: 1rem;
                line-height: 1.4;
            }

            .plat-prix {
                background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-weight: 700;
                font-size: 1.1rem;
                position: absolute;
                bottom: 1.5rem;
                right: 1.5rem;
            }

            .plat-categorie {
                background: var(--light-gold);
                color: var(--dark-gold);
                padding: 0.25rem 0.75rem;
                border-radius: 6px;
                font-size: 0.8rem;
                font-weight: 600;
                display: inline-block;
                margin-bottom: 0.75rem;
            }

            .empty-state {
                text-align: center;
                padding: 3rem 1rem;
            }

            .empty-state i {
                font-size: 4rem;
                color: var(--gold);
                opacity: 0.5;
                margin-bottom: 1rem;
            }

            @media (max-width: 768px) {
                .main-content.sidebar-open {
                    margin-left: 0;
                }
                .top-bar, .content-card {
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

    <!-- Sidebar -->
    <jsp:include page="includes/serveur-sidebar.jsp">
        <jsp:param name="activePage" value="plats" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">
                        <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Carte des Plats" %>
                    </h1>
                    <p class="page-subtitle mb-0">
                        <%
                            // CORRECTION : Utiliser à la fois request.getParameter et request.getAttribute
                            String searchTerm = request.getParameter("search");
                            if (searchTerm == null) {
                                searchTerm = (String) request.getAttribute("searchTerm");
                            }

                            Long selectedCategorieId = (Long) request.getAttribute("selectedCategorieId");
                            if (selectedCategorieId == null) {
                                String categorieIdParam = request.getParameter("categorieId");
                                if (categorieIdParam != null && !categorieIdParam.isEmpty()) {
                                    try {
                                        selectedCategorieId = Long.parseLong(categorieIdParam);
                                    } catch (NumberFormatException e) {
                                        // Ignorer l'erreur
                                    }
                                }
                            }

                            if (searchTerm != null && !searchTerm.isEmpty()) {
                        %>
                            Recherche: "<%= searchTerm %>"
                        <% } else if (selectedCategorieId != null) { %>
                            Filtrage par catégorie
                        <% } else { %>
                            Découvrez tous nos plats disponibles
                        <% } %>
                    </p>
                </div>
                <div>
                    <a href="<%= request.getContextPath() %>/serveur/commandes/nouvelle" class="btn-primary-custom">
                        <i class="bi bi-plus-circle me-2"></i>Nouvelle Commande
                    </a>
                </div>
            </div>
        </div>

        <!-- Messages d'erreur -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin-left: 70px; margin-right: 70px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("errorMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Filtres et Recherche -->
        <div class="content-card mb-4">
            <div class="card-header-custom d-flex justify-content-between align-items-center">
                <span><i class="bi bi-funnel-fill"></i> Filtres & Recherche</span>
            </div>
            <div class="p-4">
                <!-- Barre de recherche -->
                <form action="<%= request.getContextPath() %>/carte-plats" method="GET" class="mb-4">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-6">
                            <label class="form-label fw-bold" style="color: var(--burgundy);">
                                <i class="bi bi-search me-2"></i>Rechercher un plat
                            </label>
                            <input type="text"
                                   name="search"
                                   class="form-control form-control-custom"
                                   placeholder="Entrez le nom d'un plat..."
                                   value="<%= searchTerm != null ? searchTerm : "" %>">
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn-primary-custom w-100">
                                <i class="bi bi-search me-2"></i>Rechercher
                            </button>
                        </div>
                        <div class="col-md-2">
                            <a href="<%= request.getContextPath() %>/carte-plats" class="btn-outline-custom w-100">
                                <i class="bi bi-arrow-clockwise me-2"></i>Réinitialiser
                            </a>
                        </div>
                    </div>
                </form>

                <!-- Filtres par catégorie -->
                <%
                    List<Categorie> categories = (List<Categorie>) request.getAttribute("categories");
                    if (categories != null && !categories.isEmpty()) {
                %>
                    <div>
                        <label class="form-label fw-bold mb-3" style="color: var(--burgundy);">
                            <i class="bi bi-tags me-2"></i>Filtrer par catégorie
                        </label>
                        <div class="d-flex flex-wrap gap-2">
                            <!-- Bouton "Tous" -->
                            <a href="<%= request.getContextPath() %>/carte-plats"
                               class="btn-categorie <%= (selectedCategorieId == null && (searchTerm == null || searchTerm.isEmpty())) ? "active" : "" %>">
                                <i class="bi bi-grid-3x3-gap me-2"></i>Tous les plats
                            </a>

                            <!-- Boutons catégories -->
                            <% for (Categorie categorie : categories) { %>
                                <a href="<%= request.getContextPath() %>/carte-plats?categorieId=<%= categorie.getId() %>"
                                   class="btn-categorie <%= selectedCategorieId != null && selectedCategorieId.equals(categorie.getId()) ? "active" : "" %>">
                                    <i class="bi bi-tag me-2"></i><%= categorie.getNom() %>
                                </a>
                            <% } %>
                        </div>
                    </div>
                <% } else { %>
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        Aucune catégorie disponible
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Liste des plats -->
        <div class="content-card">
            <div class="card-header-custom d-flex justify-content-between align-items-center">
                <span>
                    <i class="bi bi-egg-fried me-2"></i>
                    <%
                        List<Plat> plats = (List<Plat>) request.getAttribute("plats");
                        if (plats != null) {
                    %>
                        <%= plats.size() %> plat(s) trouvé(s)
                    <% } else { %>
                        Chargement...
                    <% } %>
                </span>
            </div>
            <div class="p-4">
                <%
                    if (plats != null && !plats.isEmpty()) {
                %>
                    <div class="row g-4">
                        <% for (Plat plat : plats) { %>
                            <div class="col-xl-4 col-lg-6 col-md-6">
                                <div class="plat-card">
                                    <!-- Catégorie -->
                                    <div class="plat-categorie">
                                        <i class="bi bi-tag me-1"></i>
                                        <%= plat.getCategorie() != null ? plat.getCategorie().getNom() : "Non catégorisé" %>
                                    </div>

                                    <!-- Nom du plat -->
                                    <h3 class="plat-nom">
                                        <i class="bi bi-egg-fried me-2"></i><%= plat.getNom() %>
                                    </h3>

                                    <!-- Description -->
                                    <% if (plat.getDescription() != null && !plat.getDescription().isEmpty()) { %>
                                        <p class="plat-description"><%= plat.getDescription() %></p>
                                    <% } %>

                                    <!-- Prix -->
                                    <div class="plat-prix">
                                        <%= String.format("%.2f", plat.getPrix()) %> DH
                                    </div>

                                    <!-- Statut disponibilité -->
                                    <div class="position-absolute top-0 end-0 m-3">
                                        <% if (plat.isDisponible()) { %>
                                            <span class="badge bg-success">
                                                <i class="bi bi-check-circle me-1"></i>Disponible
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-danger">
                                                <i class="bi bi-x-circle me-1"></i>Indisponible
                                            </span>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else if (plats != null) { %>
                    <div class="empty-state">
                        <i class="bi bi-egg-fried"></i>
                        <h4 style="color: var(--wood);">
                            <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
                                Aucun plat trouvé pour "<%= searchTerm %>"
                            <% } else if (selectedCategorieId != null) { %>
                                Aucun plat disponible dans cette catégorie
                            <% } else { %>
                                Aucun plat disponible
                            <% } %>
                        </h4>
                        <p class="text-muted">
                            <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
                                Essayez avec d'autres termes de recherche.
                            <% } else { %>
                                Les plats seront bientôt disponibles.
                            <% } %>
                        </p>
                        <a href="<%= request.getContextPath() %>/carte-plats" class="btn-primary-custom">
                            <i class="bi bi-arrow-clockwise me-2"></i>Voir tous les plats
                        </a>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <i class="bi bi-exclamation-triangle"></i>
                        <h4 style="color: var(--wood);">Erreur de chargement</h4>
                        <p class="text-muted">Impossible de charger les plats. Veuillez réessayer.</p>
                        <a href="<%= request.getContextPath() %>/carte-plats" class="btn-primary-custom">
                            <i class="bi bi-arrow-clockwise me-2"></i>Réessayer
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

        function toggleSidebar() {
            const isOpen = sidebar.classList.toggle('open');
            mainContent.classList.toggle('sidebar-open', isOpen);
            menuToggle.querySelector('i').className = isOpen ? 'bi bi-x' : 'bi bi-list';
        }

        menuToggle.addEventListener('click', toggleSidebar);

        // Auto-submit du formulaire de recherche avec Enter
        const searchInput = document.querySelector('input[name="search"]');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    this.form.submit();
                }
            });
        }
    </script>
</body>
</html>