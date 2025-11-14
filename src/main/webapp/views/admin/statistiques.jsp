<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDate" %>
<%
    String contextPath = request.getContextPath();

    // Récupérer les données depuis les attributs de requête
    Map<String, Long> userStats = (Map<String, Long>) request.getAttribute("userStats");
    Long totalCommandes = (Long) request.getAttribute("totalCommandes");
    Long totalPlats = (Long) request.getAttribute("totalPlats");
    Long totalClients = (Long) request.getAttribute("totalClients");
    Long tablesDisponiblesCount = (Long) request.getAttribute("tablesDisponiblesCount");
    Double chiffreAffaireTotal = (Double) request.getAttribute("chiffreAffaireTotal");
    Double chiffreAffairePeriode = (Double) request.getAttribute("chiffreAffairePeriode");
    Map<String, Long> commandesParStatut = (Map<String, Long>) request.getAttribute("commandesParStatut");
    Map<String, Long> platsPopulaires = (Map<String, Long>) request.getAttribute("platsPopulaires");
    LocalDate dateDebut = (LocalDate) request.getAttribute("dateDebut");
    LocalDate dateFin = (LocalDate) request.getAttribute("dateFin");
    String userNom = (String) request.getAttribute("userNom");

    // Valeurs par défaut si null
    if (userStats == null) {
        userStats = java.util.Map.of("total", 0L, "administrateurs", 0L, "serveurs", 0L);
    }
    if (totalCommandes == null) totalCommandes = 0L;
    if (totalPlats == null) totalPlats = 0L;
    if (totalClients == null) totalClients = 0L;
    if (tablesDisponiblesCount == null) tablesDisponiblesCount = 0L;
    if (chiffreAffaireTotal == null) chiffreAffaireTotal = 0.0;
    if (chiffreAffairePeriode == null) chiffreAffairePeriode = 0.0;
    if (userNom == null) userNom = "Administrateur";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques - Tablaino Restaurant</title>

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
            --admin-info: #17a2b8;
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

        .page-subtitle {
            color: var(--admin-secondary);
            font-size: 0.95rem;
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

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            border: none;
            transition: all 0.3s ease;
            border-left: 4px solid var(--admin-accent);
            height: 100%;
        }

        .stat-card.primary { border-left-color: var(--admin-primary); }
        .stat-card.success { border-left-color: var(--admin-success); }
        .stat-card.warning { border-left-color: var(--admin-warning); }
        .stat-card.info { border-left-color: var(--admin-info); }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--admin-primary);
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--admin-secondary);
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-icon {
            font-size: 2.5rem;
            opacity: 0.15;
            position: absolute;
            right: 1.5rem;
            top: 50%;
            transform: translateY(-50%);
        }

        .progress {
            height: 8px;
            border-radius: 4px;
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
    <!-- CORRECTION : Chemin relatif correct -->
    <jsp:include page="includes/admin-sidebar.jsp">
        <jsp:param name="activePage" value="statistiques" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Statistiques du Restaurant</h1>
                    <p class="page-subtitle mb-0">Bienvenue, <%= userNom %> - Analysez les performances du restaurant</p>
                </div>
                <div>
                    <form method="get" class="d-flex gap-2">
                        <input type="date" class="form-control" name="dateDebut"
                               value="<%= dateDebut != null ? dateDebut : "" %>">
                        <input type="date" class="form-control" name="dateFin"
                               value="<%= dateFin != null ? dateFin : "" %>">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-filter me-2"></i>Filtrer
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Statistiques Générales -->
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
                        <%= String.format("%.2f", chiffreAffaireTotal) %> DH
                    </div>
                    <div class="stat-label">Chiffre d'Affaire Total</div>
                    <i class="bi bi-currency-euro stat-icon"></i>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Statistiques Utilisateurs -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-people-fill me-2"></i>Répartition des Utilisateurs
                    </div>
                    <div class="p-4">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-1">
                                <span>Administrateurs</span>
                                <span class="fw-bold"><%= userStats.get("administrateurs") != null ? userStats.get("administrateurs") : 0 %></span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-warning"
                                     style="width: <%= userStats.get("total") > 0 ? (userStats.get("administrateurs") * 100 / userStats.get("total")) : 0 %>%"></div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-1">
                                <span>Serveurs</span>
                                <span class="fw-bold"><%= userStats.get("serveurs") != null ? userStats.get("serveurs") : 0 %></span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-success"
                                     style="width: <%= userStats.get("total") > 0 ? (userStats.get("serveurs") * 100 / userStats.get("total")) : 0 %>%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chiffre d'Affaire Période -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-graph-up me-2"></i>Chiffre d'Affaire (Période)
                    </div>
                    <div class="p-4 text-center">
                        <div class="display-4 fw-bold text-primary mb-2">
                            <%= String.format("%.2f", chiffreAffairePeriode) %> DH
                        </div>
                        <p class="text-muted mb-0">
                            Du <%= dateDebut != null ? dateDebut : "N/A" %> au <%= dateFin != null ? dateFin : "N/A" %>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Commandes par Statut -->
        <div class="content-card mt-4">
            <div class="card-header-custom">
                <i class="bi bi-bar-chart me-2"></i>Commandes par Statut
            </div>
            <div class="p-4">
                <% if (commandesParStatut != null && !commandesParStatut.isEmpty()) { %>
                    <div class="row">
                        <% for (Map.Entry<String, Long> entry : commandesParStatut.entrySet()) { %>
                            <div class="col-md-3 col-6 mb-3">
                                <div class="text-center p-3 border rounded">
                                    <div class="fw-bold fs-4 text-primary"><%= entry.getValue() %></div>
                                    <div class="text-muted small text-uppercase"><%= entry.getKey() %></div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-3 text-muted">
                        <i class="bi bi-info-circle me-2"></i>Aucune donnée disponible
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Plats les Plus Vendus -->
        <div class="content-card mt-4">
            <div class="card-header-custom">
                <i class="bi bi-trophy me-2"></i>Plats les Plus Vendus
            </div>
            <div class="p-4">
                <% if (platsPopulaires != null && !platsPopulaires.isEmpty()) {
                    int maxQuantite = platsPopulaires.values().stream().mapToInt(Long::intValue).max().orElse(1);
                %>
                    <% for (Map.Entry<String, Long> entry : platsPopulaires.entrySet()) {
                         int pourcentage = maxQuantite > 0 ? (int) ((entry.getValue() * 100) / maxQuantite) : 0;
                    %>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-1">
                                <span><%= entry.getKey() %></span>
                                <span class="fw-bold"><%= entry.getValue() %> ventes</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-success" style="width: <%= pourcentage %>%"></div>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="text-center py-3 text-muted">
                        <i class="bi bi-info-circle me-2"></i>Aucune donnée de vente disponible
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