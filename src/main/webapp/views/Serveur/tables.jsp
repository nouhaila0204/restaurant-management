<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.restaurant.model.TableRestaurant" %>
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
            --gold: #B8935C;
            --dark-gold: #8B6F47;
            --burgundy: #8B1A1A;
            --dark-red: #6B0F0F;
            --wood: #8B5A3C;
            --light-gold: #F5E6D3;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
            --info: #17a2b8;
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

        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            border-left: 4px solid var(--gold);
            transition: all 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .stats-label {
            color: var(--wood);
            font-size: 0.9rem;
            font-weight: 600;
        }

        .table-card {
            background: white;
            border: 2px solid #f0ebe5;
            border-radius: 12px;
            padding: 1.5rem;
            transition: all 0.3s ease;
            height: 100%;
            position: relative;
        }

        .table-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .table-numero {
            color: var(--burgundy);
            font-weight: 800;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .table-capacite {
            color: var(--wood);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .btn-statut {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            border: none;
            transition: all 0.3s ease;
            width: 100%;
        }

        .btn-libre { background: var(--success); color: white; }
        .btn-occupee { background: var(--danger); color: white; }
        .btn-reservee { background: var(--warning); color: black; }
        .btn-maintenance { background: var(--info); color: white; }

        .btn-statut:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }

        .btn-filtre {
            background: white;
            border: 2px solid var(--wood);
            color: var(--wood);
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin: 0.25rem;
            text-decoration: none;
            display: inline-block;
        }

        .btn-filtre:hover, .btn-filtre.active {
            background: var(--wood);
            color: white;
            transform: translateY(-2px);
        }

        .statut-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
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
        <jsp:param name="activePage" value="tables" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">
                        <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Gestion des Tables" %>
                    </h1>
                    <p class="page-subtitle mb-0">
                        Gérez le statut et la disponibilité des tables
                    </p>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin-left: 70px; margin-right: 70px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("errorMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <%
            String successMessage = (String) request.getSession().getAttribute("successMessage");
            if (successMessage != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="margin-left: 70px; margin-right: 70px;">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            request.getSession().removeAttribute("successMessage");
            }
        %>

        <!-- Statistiques -->
        <div class="row mb-4" style="margin-left: 70px; margin-right: 70px;">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number text-primary"><%= request.getAttribute("totalTables") != null ? request.getAttribute("totalTables") : "0" %></div>
                    <div class="stats-label">Total Tables</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number text-success"><%= request.getAttribute("tablesLibres") != null ? request.getAttribute("tablesLibres") : "0" %></div>
                    <div class="stats-label">Tables Libres</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number text-danger"><%= request.getAttribute("tablesOccupees") != null ? request.getAttribute("tablesOccupees") : "0" %></div>
                    <div class="stats-label">Tables Occupées</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number text-warning">
                        <%
                            Long total = (Long) request.getAttribute("totalTables");
                            Long libres = (Long) request.getAttribute("tablesLibres");
                            Long occupees = (Long) request.getAttribute("tablesOccupees");
                            Long autres = total - libres - occupees;
                        %>
                        <%= autres != null ? autres : "0" %>
                    </div>
                    <div class="stats-label">Autres Statuts</div>
                </div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="content-card mb-4">
            <div class="card-header-custom">
                <span><i class="bi bi-funnel-fill me-2"></i>Filtres par Statut</span>
            </div>
            <div class="p-4">
                <div class="d-flex flex-wrap gap-2">
                    <%
                        String selectedStatut = (String) request.getAttribute("selectedStatut");
                        TableRestaurant.StatutTable[] statuts = (TableRestaurant.StatutTable[]) request.getAttribute("statuts");
                    %>

                    <!-- Bouton "Tous" -->
                    <a href="<%= request.getContextPath() %>/serveur/tables"
                       class="btn-filtre <%= (selectedStatut == null) ? "active" : "" %>">
                        <i class="bi bi-grid-3x3-gap me-2"></i>Toutes les tables
                    </a>

                    <!-- Boutons statuts -->
                    <% if (statuts != null) {
                        for (TableRestaurant.StatutTable statut : statuts) {
                            String statutClass = "";
                            switch (statut) {
                                case LIBRE: statutClass = "btn-libre"; break;
                                case OCCUPEE: statutClass = "btn-occupee"; break;
                                case RESERVEE: statutClass = "btn-reservee"; break;
                            }
                    %>
                        <a href="<%= request.getContextPath() %>/serveur/tables?statut=<%= statut.name() %>"
                           class="btn-filtre <%= selectedStatut != null && selectedStatut.equals(statut.name()) ? "active" : "" %>">
                            <i class="bi bi-circle-fill me-2 <%= statutClass %>"></i><%= getStatutLabel(statut) %>
                        </a>
                    <% }
                    } %>
                </div>
            </div>
        </div>

        <!-- Liste des tables -->
        <div class="content-card">
            <div class="card-header-custom d-flex justify-content-between align-items-center">
                <span>
                    <i class="bi bi-table me-2"></i>
                    <%
                        List<TableRestaurant> tables = (List<TableRestaurant>) request.getAttribute("tables");
                        if (tables != null) {
                    %>
                        <%= tables.size() %> table(s) trouvée(s)
                    <% } else { %>
                        Chargement...
                    <% } %>
                </span>
            </div>
            <div class="p-4">
                <%
                    if (tables != null && !tables.isEmpty()) {
                %>
                    <div class="row g-4">
                        <% for (TableRestaurant table : tables) {
                            String statutClass = "";
                            String statutLabel = "";
                            switch (table.getStatut()) {
                                case LIBRE:
                                    statutClass = "btn-libre";
                                    statutLabel = "Libre";
                                    break;
                                case OCCUPEE:
                                    statutClass = "btn-occupee";
                                    statutLabel = "Occupée";
                                    break;
                                case RESERVEE:
                                    statutClass = "btn-reservee";
                                    statutLabel = "Réservée";
                                    break;
                            }
                        %>
                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="table-card">
                                    <!-- Numéro de table -->
                                    <h3 class="table-numero">
                                        <i class="bi bi-table me-2"></i><%= table.getNumero() %>
                                    </h3>

                                    <!-- Capacité -->
                                    <div class="table-capacite">
                                        <i class="bi bi-people-fill me-2"></i>Capacité: <%= table.getCapacite() %> personnes
                                    </div>

                                    <!-- Statut actuel -->
                                    <div class="mb-3">
                                        <span class="statut-badge <%= statutClass %>">
                                            <i class="bi bi-circle-fill me-1"></i><%= statutLabel %>
                                        </span>
                                    </div>

                                    <!-- Actions - Changer statut -->
                                    <form action="<%= request.getContextPath() %>/serveur/tables/changer-statut" method="POST" class="mb-3">
                                        <input type="hidden" name="tableId" value="<%= table.getId() %>">
                                        <select name="nouveauStatut" class="form-select mb-2" onchange="this.form.submit()">
                                            <option value="">Changer statut...</option>
                                            <option value="LIBRE" <%= table.getStatut() == TableRestaurant.StatutTable.LIBRE ? "disabled" : "" %>>Libre</option>
                                            <option value="OCCUPEE" <%= table.getStatut() == TableRestaurant.StatutTable.OCCUPEE ? "disabled" : "" %>>Occupée</option>
                                            <option value="RESERVEE" <%= table.getStatut() == TableRestaurant.StatutTable.RESERVEE ? "disabled" : "" %>>Réservée</option>
                                        </select>
                                    </form>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else if (tables != null) { %>
                    <div class="text-center py-5">
                        <i class="bi bi-table" style="font-size: 4rem; color: var(--gold); opacity: 0.5;"></i>
                        <h4 style="color: var(--wood);" class="mt-3">
                            <% if (selectedStatut != null) { %>
                                Aucune table avec le statut "<%= selectedStatut %>"
                            <% } else { %>
                                Aucune table disponible
                            <% } %>
                        </h4>
                        <p class="text-muted">
                            Les tables seront affichées ici une fois créées.
                        </p>
                        <a href="<%= request.getContextPath() %>/serveur/tables" class="btn btn-primary">
                            <i class="bi bi-arrow-clockwise me-2"></i>Actualiser
                        </a>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="bi bi-exclamation-triangle" style="font-size: 4rem; color: var(--danger); opacity: 0.5;"></i>
                        <h4 style="color: var(--wood);" class="mt-3">Erreur de chargement</h4>
                        <p class="text-muted">Impossible de charger les tables. Veuillez réessayer.</p>
                        <a href="<%= request.getContextPath() %>/serveur/tables" class="btn btn-primary">
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

        // Auto-close alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>

<%!
    // Méthode helper pour les labels de statut
    private String getStatutLabel(TableRestaurant.StatutTable statut) {
        switch (statut) {
            case LIBRE: return "Libres";
            case OCCUPEE: return "Occupées";
            case RESERVEE: return "Réservées";
            default: return statut.toString();
        }
    }
%>