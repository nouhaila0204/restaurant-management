<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%
    String contextPath = request.getContextPath();

    // Récupérer les données depuis les attributs de requête
    Map<String, Long> userStats = (Map<String, Long>) request.getAttribute("userStats");
    Long totalCommandes = (Long) request.getAttribute("totalCommandes");
    Long totalPlats = (Long) request.getAttribute("totalPlats");
    Long totalClients = (Long) request.getAttribute("totalClients");
    Long tablesDisponiblesCount = (Long) request.getAttribute("tablesDisponiblesCount");
    Double chiffreAffaire = (Double) request.getAttribute("chiffreAffaire");
    String userNom = (String) request.getAttribute("userNom");

    // Valeurs par défaut si null
    if (userStats == null) {
        userStats = java.util.Map.of("total", 0L, "administrateurs", 0L, "serveurs", 0L);
    }
    if (totalCommandes == null) totalCommandes = 0L;
    if (totalPlats == null) totalPlats = 0L;
    if (totalClients == null) totalClients = 0L;
    if (tablesDisponiblesCount == null) tablesDisponiblesCount = 0L;
    if (chiffreAffaire == null) chiffreAffaire = 0.0;
    if (userNom == null) userNom = "Administrateur";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Tablaino Restaurant</title>

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
            --admin-light: #ecf0f1;
        }

        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: margin-left 0.3s ease;
        }

        /* Menu Toggle Button */
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

        .menu-toggle:hover {
            background: var(--admin-secondary);
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
            border-left: 4px solid var(--admin-accent);
            margin-left: 70px;
        }

        .page-title {
            color: var(--admin-primary);
            font-weight: 800;
            font-size: 1.8rem;
            margin-bottom: 0.25rem;
        }

        .page-subtitle {
            color: var(--admin-secondary);
            font-size: 0.95rem;
        }

        .time-badge {
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
            color: white;
            padding: 0.6rem 1.2rem;
            border-radius: 10px;
            font-weight: 600;
            box-shadow: 0 3px 8px rgba(52, 152, 219, 0.3);
        }

        /* Stat Cards */
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.75rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            transition: all 0.3s ease;
            border-left: 4px solid var(--admin-accent);
            height: 100%;
            position: relative;
        }

        .stat-card.primary { border-left-color: var(--admin-primary); }
        .stat-card.success { border-left-color: var(--admin-success); }
        .stat-card.warning { border-left-color: var(--admin-warning); }
        .stat-card.danger { border-left-color: var(--admin-danger); }
        .stat-card.info { border-left-color: var(--admin-accent); }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.2);
        }

        .stat-number {
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--admin-primary);
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--admin-secondary);
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
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-secondary) 100%);
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
            background: linear-gradient(135deg, var(--admin-warning) 0%, #e67e22 100%);
            color: white;
        }

        .badge-termine {
            background: linear-gradient(135deg, var(--admin-success) 0%, #229954 100%);
            color: white;
        }

        .action-btn {
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
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
            background: linear-gradient(135deg, var(--admin-primary) 0%, var(--admin-secondary) 100%);
        }

        .action-btn.success {
            background: linear-gradient(135deg, var(--admin-success) 0%, #218838 100%);
        }

        .action-btn.info {
            background: linear-gradient(135deg, var(--admin-accent) 0%, #138496 100%);
        }

        .action-btn.warning {
            background: linear-gradient(135deg, var(--admin-warning) 0%, #e0a800 100%);
        }

        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--admin-accent);
            opacity: 0.5;
            margin-bottom: 1rem;
        }

        .view-all-btn {
            background: transparent;
            border: 2px solid var(--admin-accent);
            color: var(--admin-accent);
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .view-all-btn:hover {
            background: var(--admin-accent);
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
    <jsp:include page="includes/admin-sidebar.jsp">
        <jsp:param name="activePage" value="dashboard" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Dashboard Administrateur</h1>
                    <p class="page-subtitle mb-0">Bienvenue, <%= userNom %> - Supervisez l'ensemble du restaurant</p>
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
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Statistiques -->
        <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card primary">
                    <div class="stat-number">
                         <%= userStats.get("total") != null ? userStats.get("total") : 0 %>
                    </div>
                    <div class="stat-label">Utilisateurs Total</div>
                    <i class="bi bi-people-fill stat-icon"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card success">
                    <div class="stat-number">
                        <%= totalCommandes %>
                    </div>
                    <div class="stat-label">Commandes Total</div>
                    <i class="bi bi-receipt stat-icon"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card info">
                    <div class="stat-number">
                        <%= totalPlats %>
                    </div>
                    <div class="stat-label">Plats au Menu</div>
                    <i class="bi bi-egg-fried stat-icon"></i>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card warning">
                    <div class="stat-number">
                        <%= String.format("%.2f", chiffreAffaire) %> DH
                    </div>
                    <div class="stat-label">Chiffre d'Affaire</div>
                    <i class="bi bi-currency-euro stat-icon"></i>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Derniers Utilisateurs -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-person-plus"></i>Derniers Utilisateurs</span>
                        <a href="<%= contextPath %>/admin/users" class="view-all-btn" style="border-color: white; color: white;">
                            Voir Tout
                        </a>
                    </div>
                    <div class="list-group list-group-flush">
                        <div class="list-group-item-custom d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-1 fw-bold" style="color: var(--admin-primary);">
                                    <i class="bi bi-person-fill me-2"></i>Administrateurs
                                </h6>
                                <small class="text-muted">
                                    <%= userStats.get("administrateurs") != null ? userStats.get("administrateurs") : 0 %> compte(s)
                                </small>
                            </div>
                            <span class="badge-statut badge-en-cours">ADMIN</span>
                        </div>
                        <div class="list-group-item-custom d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-1 fw-bold" style="color: var(--admin-primary);">
                                    <i class="bi bi-person-badge me-2"></i>Serveurs
                                </h6>
                                <small class="text-muted">
                                    <%= userStats.get("serveurs") != null ? userStats.get("serveurs") : 0 %> compte(s)
                                </small>
                            </div>
                            <span class="badge-statut badge-termine">SERVEUR</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistiques Rapides -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-graph-up"></i>Aperçu du Restaurant</span>
                        <a href="<%= contextPath %>/admin/statistiques" class="view-all-btn" style="border-color: white; color: white;">
                            Détails
                        </a>
                    </div>
                    <div class="p-3">
                        <div class="row g-3 text-center">
                            <div class="col-6">
                                <div class="p-3">
                                    <div class="fw-bold fs-4" style="color: var(--admin-primary);">
                                        <%= totalClients %>
                                    </div>
                                    <small class="text-muted">Clients</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-3">
                                    <div class="fw-bold fs-4" style="color: var(--admin-success);">
                                       <%= tablesDisponiblesCount %>
                                    </div>
                                    <small class="text-muted">Tables Libres</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Actions Rapides Admin -->
        <div class="content-card">
            <div class="card-header-custom">
                <i class="bi bi-lightning-charge-fill"></i>Actions Administratives
            </div>
            <div class="p-4">
                <div class="row g-4">
                    <div class="col-lg-3 col-md-6">
                        <a href="<%= contextPath %>/admin/users" class="action-btn primary">
                            <i class="bi bi-people-fill"></i>
                            <span>Gérer Utilisateurs</span>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <a href="<%= contextPath %>/admin/plats" class="action-btn success">
                            <i class="bi bi-egg-fried"></i>
                            <span>Gérer Plats</span>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <a href="<%= contextPath %>/admin/commandes" class="action-btn info">
                            <i class="bi bi-receipt"></i>
                            <span>Voir Commandes</span>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <a href="<%= contextPath %>/admin/statistiques" class="action-btn warning">
                            <i class="bi bi-graph-up"></i>
                            <span>Statistiques</span>
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