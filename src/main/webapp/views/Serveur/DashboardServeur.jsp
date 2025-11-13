<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Serveur - Tablaino Restaurant</title>

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
            transition: margin-left 0.3s ease;
        }

        /* Menu Toggle Button */
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

        /* Top Bar */
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

        .time-badge {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            color: white;
            padding: 0.6rem 1.2rem;
            border-radius: 10px;
            font-weight: 600;
            box-shadow: 0 3px 8px rgba(184, 147, 92, 0.3);
        }

        /* Stat Cards */
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.75rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            transition: all 0.3s ease;
            border-left: 4px solid var(--gold);
            height: 100%;
            position: relative;
        }

        .stat-card.primary { border-left-color: var(--burgundy); }
        .stat-card.success { border-left-color: #28a745; }
        .stat-card.warning { border-left-color: #ffc107; }
        .stat-card.info { border-left-color: var(--gold); }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(184, 147, 92, 0.2);
        }

        .stat-number {
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--burgundy);
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--wood);
            font-size: 0.95rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-icon {
            font-size: 3rem;
            opacity: 0.15;
            position: absolute;
            right: 1.5rem;
            top: 50%;
            transform: translateY(-50%);
        }

        /* Content Cards */
        .content-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            overflow: hidden;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
            color: white;
            padding: 1.25rem 1.75rem;
            border: none;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .list-group-item-custom {
            border: none;
            border-bottom: 1px solid #f0ebe5;
            padding: 1.25rem 1.75rem;
            transition: all 0.3s ease;
        }

        .list-group-item-custom:hover {
            background: #fafaf9;
            transform: translateX(5px);
        }

        .badge-statut {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.8rem;
        }

        .badge-en-cours {
            background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
            color: white;
        }

        .table-item {
            background: white;
            border-radius: 12px;
            padding: 1.25rem;
            text-align: center;
            border: 2px solid #e8e4df;
            transition: all 0.3s ease;
            height: 100%;
            border-left: 4px solid #28a745;
        }

        .table-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .table-icon {
            font-size: 2.5rem;
            color: #28a745;
            margin-bottom: 0.75rem;
        }

        .table-numero {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--burgundy);
            margin-bottom: 0.25rem;
        }

        .table-capacite {
            color: var(--wood);
            font-size: 0.85rem;
        }

        .action-btn {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            border: none;
            color: white;
            padding: 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
        }

        .action-btn:hover {
            transform: translateY(-5px);
            color: white;
        }

        .action-btn.primary {
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
        }

        .action-btn.success {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
        }

        .action-btn.info {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        }

        .action-btn.warning {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
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

        .view-all-btn {
            background: transparent;
            border: 2px solid var(--gold);
            color: var(--gold);
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .view-all-btn:hover {
            background: var(--gold);
            color: white;
        }

        /* Overlay for mobile */
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

        .sidebar-overlay.show {
            display: block;
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
    <jsp:include page="includes/serveur-sidebar.jsp">
        <jsp:param name="activePage" value="dashboard" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Dashboard Serveur</h1>
                    <p class="page-subtitle mb-0">Bienvenue, <%= request.getAttribute("serveurNom") != null ? request.getAttribute("serveurNom") : "Serveur" %> - Gérez vos services efficacement</p>
                </div>
                <div>
                    <span class="time-badge">
                        <i class="bi bi-clock-fill me-2"></i>
                        <span id="current-time"></span>
                    </span>
                </div>
            </div>
        </div>

        <!-- Message d'erreur -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("errorMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Statistiques -->
        <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card primary">
                    <div class="stat-number">
                        <%= request.getAttribute("nombreComm") != null ? request.getAttribute("nombreComm") : "0" %>
                    </div>
                    <div class="stat-label">Commandes Aujourd'hui</div>
                    <i class="bi bi-receipt-cutoff stat-icon"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card warning">
                    <div class="stat-number">
                        <%= request.getAttribute("commandesEnCoursCount") != null ? request.getAttribute("commandesEnCoursCount") : "0" %>
                    </div>
                    <div class="stat-label">Commandes En Cours</div>
                    <i class="bi bi-hourglass-split stat-icon"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card success">
                    <div class="stat-number">
                        <%= request.getAttribute("tablesDisponiblesCount") != null ? request.getAttribute("tablesDisponiblesCount") : "0" %>
                    </div>
                    <div class="stat-label">Tables Disponibles</div>
                    <i class="bi bi-check-circle-fill stat-icon"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card info">
                    <div class="stat-number">
                        <%= request.getAttribute("platsDisponiblesCount") != null ? request.getAttribute("platsDisponiblesCount") : "0" %>
                    </div>
                    <div class="stat-label">Plats au Menu</div>
                    <i class="bi bi-egg-fried stat-icon"></i>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Commandes en Cours -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-list-check"></i>Commandes en Cours</span>
                        <a href="http://localhost:8080/Restaurant_management/serveur/commandes" class="view-all-btn" style="border-color: white; color: white;">
                            Voir Tout
                        </a>
                    </div>
                    <%
                        List<?> commandesEnCours = (List<?>) request.getAttribute("commandesEnCours");
                        if (commandesEnCours != null && !commandesEnCours.isEmpty()) {
                    %>
                        <div class="list-group list-group-flush">
                            <%
                                int maxCommandes = Math.min(commandesEnCours.size(), 5);
                                for (int i = 0; i < maxCommandes; i++) {
                            %>
                                <div class="list-group-item-custom d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1 fw-bold" style="color: var(--burgundy);">
                                            <i class="bi bi-hash"></i>Commande #<%= i + 1 %>
                                        </h6>
                                        <small class="text-muted">
                                            <i class="bi bi-clock me-1"></i>En traitement
                                        </small>
                                    </div>
                                    <span class="badge-statut badge-en-cours">EN COURS</span>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="empty-state">
                            <i class="bi bi-check-circle"></i>
                            <p>Aucune commande en cours</p>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Tables Disponibles -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-table"></i>Tables Disponibles</span>
                        <a href="http://localhost:8080/Restaurant_management/serveur/tables" class="view-all-btn" style="border-color: white; color: white;">
                            Voir Tout
                        </a>
                    </div>
                    <div class="p-3">
                        <%
                            List<?> tablesDisponibles = (List<?>) request.getAttribute("tablesDisponibles");
                            if (tablesDisponibles != null && !tablesDisponibles.isEmpty()) {
                        %>
                            <div class="row g-3">
                                <%
                                    int maxTables = Math.min(tablesDisponibles.size(), 6);
                                    for (int i = 0; i < maxTables; i++) {
                                %>
                                    <div class="col-md-4 col-6">
                                        <div class="table-item">
                                            <i class="bi bi-table table-icon"></i>
                                            <div class="table-numero">Table <%= i + 1 %></div>
                                            <div class="table-capacite">
                                                <i class="bi bi-people-fill me-1"></i>4 places
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="empty-state">
                                <i class="bi bi-exclamation-triangle"></i>
                                <p>Aucune table disponible</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Actions Rapides -->
        <div class="content-card">
            <div class="card-header-custom">
                <i class="bi bi-lightning-charge-fill"></i>Actions Rapides
            </div>
            <div class="p-4">
                <div class="row g-4">
                    <div class="col-lg-3 col-md-6">
                        <a href="http://localhost:8080/Restaurant_management/serveur/commandes/nouvelle" class="action-btn primary">
                            <i class="bi bi-plus-circle-fill"></i>
                            <span>Nouvelle Commande</span>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <a href="<%= request.getContextPath() %>/serveur/tables" class="action-btn success">
                            <i class="bi bi-eye-fill"></i>
                            <span>Voir Tables</span>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <a href="<%= request.getContextPath() %>/carte-plats" class="action-btn info">
                            <i class="bi bi-menu-button-wide-fill"></i>
                            <span>Carte des Plats</span>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <a href="<%= request.getContextPath() %>/serveur/clients/nouveau" class="action-btn warning">
                            <i class="bi bi-person-plus-fill"></i>
                            <span>Nouveau Client</span>
                        </a>
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

        // Close sidebar on mobile when clicking links
        if (window.innerWidth <= 768) {
            document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                link.addEventListener('click', () => {
                    if (sidebar.classList.contains('open')) {
                        toggleSidebar();
                    }
                });
            });
        }

        // Update time
        function updateTime() {
            document.getElementById('current-time').textContent =
                new Date().toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
        }
        setInterval(updateTime, 1000);
        updateTime();
    </script>
</body>
</html>