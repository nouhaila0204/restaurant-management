<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.restaurant.model.Client" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Clients - Tablaino Restaurant</title>

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

            .form-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: none;
                overflow: hidden;
                margin-left: 70px;
                max-width: 600px;
            }

            .card-header-custom {
                background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
                color: white;
                padding: 1.25rem 1.75rem;
                border: none;
                font-weight: 700;
                font-size: 1.1rem;
            }

            .form-label {
                font-weight: 600;
                color: var(--burgundy);
                margin-bottom: 0.5rem;
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
                padding: 0.75rem 2rem;
                border-radius: 10px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(184, 147, 92, 0.4);
            }

            .btn-secondary-custom {
                background: transparent;
                border: 2px solid var(--wood);
                color: var(--wood);
                padding: 0.75rem 2rem;
                border-radius: 10px;
                font-weight: 600;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            .btn-secondary-custom:hover {
                background: var(--wood);
                color: white;
            }

            .required-field::after {
                content: " *";
                color: var(--burgundy);
            }

            @media (max-width: 768px) {
                .main-content.sidebar-open {
                    margin-left: 0;
                }
                .top-bar, .form-card {
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
        <jsp:param name="activePage" value="clients" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Gestion des Clients</h1>
                    <p class="page-subtitle mb-0">Liste de tous les clients enregistrés</p>
                </div>
                <div>
                    <a href="http://localhost:8080/Restaurant_management/serveur/clients/nouveau" class="btn-primary-custom">
                        <i class="bi bi-person-plus-fill me-2"></i>Nouveau Client
                    </a>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <% if (session.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="margin-left: 70px; max-width: 100%;">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= session.getAttribute("successMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("successMessage"); %>
        <% } %>

        <!-- Contenu de la liste des clients -->
        <div class="content-card" style="margin-left: 70px;">
            <div class="card-header-custom d-flex justify-content-between align-items-center">
                <span><i class="bi bi-people-fill"></i>
                    <%
                        String searchTerm = request.getParameter("search");
                        if (searchTerm != null && !searchTerm.isEmpty()) {
                    %>
                        Résultats de recherche
                    <% } else { %>
                        Liste des Clients
                    <% } %>
                </span>
                <!-- FORMULAIRE CORRIGÉ -->
                <form action="" method="GET" class="d-flex">
                    <input type="text"
                           name="search"
                           class="form-control form-control-custom me-2"
                           placeholder="Rechercher un client..."
                           value="<%= searchTerm != null ? searchTerm : "" %>">
                    <button type="submit" class="btn-primary-custom">
                        <i class="bi bi-search"></i>
                    </button>
                </form>
            </div>
            <div class="p-4">
                <%
                    List<Client> clients = (List<Client>) request.getAttribute("clients");
                    if (clients != null && !clients.isEmpty()) {
                %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Téléphone</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Client client : clients) { %>
                                    <tr>
                                        <td class="fw-bold" style="color: var(--burgundy);">
                                            <i class="bi bi-person-circle me-2"></i><%= client.getNom() %>
                                        </td>
                                        <td><%= client.getTelephone() != null ? client.getTelephone() : "Non renseigné" %></td>
                                        <td><%= client.getEmail() != null ? client.getEmail() : "Non renseigné" %></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye"></i> Voir
                                            </button>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="empty-state text-center py-5">
                        <i class="bi bi-people display-1" style="color: var(--gold); opacity: 0.5;"></i>
                        <h4 class="mt-3" style="color: var(--wood);">
                            <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
                                Aucun client trouvé pour "<%= searchTerm %>"
                            <% } else { %>
                                Aucun client trouvé
                            <% } %>
                        </h4>
                        <p class="text-muted">
                            <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
                                Essayez avec d'autres termes de recherche.
                            <% } else { %>
                                Commencez par ajouter votre premier client.
                            <% } %>
                        </p>
                        <a href="<%= request.getContextPath() %>/serveur/clients/nouveau" class="btn-primary-custom">
                            <i class="bi bi-person-plus-fill me-2"></i>Ajouter un client
                        </a>
                    </div>
                <% } %>
            </div>
        </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Scripts pour la sidebar (identique à nouveau-client.jsp)
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');

        function toggleSidebar() {
            const isOpen = sidebar.classList.toggle('open');
            mainContent.classList.toggle('sidebar-open', isOpen);
            menuToggle.querySelector('i').className = isOpen ? 'bi bi-x' : 'bi bi-list';
        }

        menuToggle.addEventListener('click', toggleSidebar);
    </script>
</body>
</html>