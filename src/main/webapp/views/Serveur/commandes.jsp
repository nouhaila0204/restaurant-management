<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.Commande" %>
<%
    String contextPath = request.getContextPath();
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) session.getAttribute("successMessage");
    String baseUrl = contextPath + "/serveur/commandes";
    List<Commande> commandes = (List<Commande>) request.getAttribute("commandes");
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Commandes";

    // Nettoyer le message de succès de la session après l'avoir récupéré
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - Tablaino Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

        /* Commande Cards */
        .commande-card {
            background: white;
            border-radius: 15px;
            padding: 1.75rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            transition: all 0.3s ease;
            border-left: 4px solid var(--gold);
            margin-bottom: 1.5rem;
        }

        .commande-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(184, 147, 92, 0.2);
        }

        .statut-badge {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .statut-en-attente {
            background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
            color: white;
        }

        .statut-en-preparation {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
        }

        .statut-prete {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
            color: white;
        }

        .statut-servie {
            background: linear-gradient(135deg, #6f42c1 0%, #5a2d91 100%);
            color: white;
        }

        .statut-payee {
            background: linear-gradient(135deg, #6c757d 0%, #545b62 100%);
            color: white;
        }

        .commande-icon {
            font-size: 2.5rem;
            color: var(--burgundy);
            margin-bottom: 0.75rem;
        }

        .commande-numero {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--burgundy);
            margin-bottom: 0.25rem;
        }

        .commande-date {
            color: var(--wood);
            font-size: 0.85rem;
        }

        .montant-total {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--burgundy);
        }

        .table-badge {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
        }

        .action-btn {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 5px 15px rgba(184, 147, 92, 0.3);
        }

        .action-btn.primary {
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
        }

        .action-btn.success {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
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
            <jsp:param name="activePage" value="commandes" />
        </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">
                        <i class="bi bi-receipt me-2"></i><%= pageTitle %>
                    </h1>
                    <p class="page-subtitle mb-0">Gestion des commandes restaurant</p>
                </div>
                <div class="d-flex gap-2">
                    <span class="time-badge">
                        <i class="bi bi-clock-fill me-2"></i>
                        <span id="current-time"></span>
                    </span>
                    <a href="<%= baseUrl %>/en-cours" class="action-btn">
                        <i class="bi bi-clock"></i>En Cours
                    </a>
                    <a href="<%= baseUrl %>/nouvelle" class="action-btn primary">
                        <i class="bi bi-plus-circle"></i>Nouvelle Commande
                    </a>
                </div>
            </div>
        </div>

        <!-- Message de succès -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Message d'erreur -->
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Liste des Commandes -->
        <div class="content-card">
            <div class="card-header-custom d-flex justify-content-between align-items-center">
                <span><i class="bi bi-receipt"></i> Liste des Commandes</span>
                <div class="d-flex gap-2">
                    <span class="badge bg-light text-dark fs-6">
                        <%= commandes != null ? commandes.size() : "0" %> commande(s)
                    </span>
                </div>
            </div>

            <div class="p-4">
                <% if (commandes != null && !commandes.isEmpty()) { %>
                    <div class="row g-4">
                        <% for (Commande commande : commandes) { %>
                            <div class="col-12">
                                <div class="commande-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <div class="d-flex align-items-center">
                                                <div class="bg-light rounded p-3 me-3">
                                                    <i class="bi bi-receipt commande-icon"></i>
                                                </div>
                                                <div>
                                                    <h5 class="commande-numero"><%= commande.getNumero() %></h5>
                                                    <small class="commande-date">
                                                        <%= commande.getDateCommande() != null ?
                                                            commande.getDateCommande().toString() : "Date inconnue" %>
                                                    </small>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="text-center">
                                                <h6 class="fw-semibold mb-1">Table</h6>
                                                <span class="table-badge">
                                                    <%
                                                        // CORRECTION: Utiliser directement les getters
                                                        if (commande.getTable() != null && commande.getTable().getNumero() != null) {
                                                    %>
                                                        Table <%= commande.getTable().getNumero() %>
                                                    <% } else { %>
                                                        N/A
                                                    <% } %>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="text-center">
                                                <h6 class="fw-semibold mb-1">Montant</h6>
                                                <span class="montant-total">
                                                    <%= commande.getMontantTotal() != null ?
                                                        String.format("%.2f", commande.getMontantTotal()) + " DHs" : "0.00 DHs" %>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="text-center">
                                                <h6 class="fw-semibold mb-1">Statut</h6>
                                                <%
                                                    String statutClass = "statut-en-attente";
                                                    String statutText = "En Attente";

                                                    if (commande.getStatut() != null) {
                                                        switch (commande.getStatut().toString()) {
                                                            case "EN_ATTENTE":
                                                                statutClass = "statut-en-attente";
                                                                statutText = "En Attente";
                                                                break;
                                                            case "EN_PREPARATION":
                                                                statutClass = "statut-en-preparation";
                                                                statutText = "En Préparation";
                                                                break;
                                                            case "PRETE":
                                                                statutClass = "statut-prete";
                                                                statutText = "Prête";
                                                                break;
                                                            case "SERVIE":
                                                                statutClass = "statut-servie";
                                                                statutText = "Servie";
                                                                break;
                                                            case "PAYEE":
                                                                statutClass = "statut-payee";
                                                                statutText = "Payée";
                                                                break;
                                                        }
                                                    }
                                                %>
                                                <span class="statut-badge <%= statutClass %>"><%= statutText %></span>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="text-center">
                                                <h6 class="fw-semibold mb-1">Serveur</h6>
                                                <span class="text-muted">
                                                    <%
                                                        // CORRECTION: Utiliser directement les getters
                                                        if (commande.getServeur() != null && commande.getServeur().getNom() != null) {
                                                    %>
                                                        <%= commande.getServeur().getNom() %>
                                                    <% } else { %>
                                                        N/A
                                                    <% } %>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="col-md-1">
                                            <div class="d-flex gap-2 justify-content-end">
                                                <%
                                                    // SUPPRESSION: Bouton détails supprimé
                                                    boolean peutChangerStatut = true;
                                                    if (commande.getStatut() != null && "PAYEE".equals(commande.getStatut().toString())) {
                                                        peutChangerStatut = false;
                                                    }

                                                    if (peutChangerStatut) {
                                                %>
                                                    <button class="action-btn"
                                                            onclick="changerStatut(<%= commande.getId() %>)">
                                                        <i class="bi bi-arrow-clockwise"></i>Statut
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
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h4 class="text-muted mt-3">Aucune commande</h4>
                        <p class="text-muted mb-4">
                            Aucune commande trouvée pour les critères sélectionnés.
                        </p>
                        <a href="<%= baseUrl %>/nouvelle" class="action-btn primary">
                            <i class="bi bi-plus-circle me-1"></i>Créer une commande
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Modal pour changer le statut -->
    <div class="modal fade" id="statutModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Changer le statut</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="statutForm">
                        <input type="hidden" id="commandeId" name="commandeId">
                        <div class="mb-3">
                            <label class="form-label">Nouveau statut</label>
                            <select class="form-select" id="nouveauStatut" name="statut">
                                <option value="EN_ATTENTE">En Attente</option>
                                <option value="EN_PREPARATION">En Préparation</option>
                                <option value="PRETE">Prête</option>
                                <option value="SERVIE">Servie</option>
                                <option value="PAYEE">Payée</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" onclick="confirmerChangementStatut()">Confirmer</button>
                </div>
            </div>
        </div>
    </div>

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

        // Functions for status change
        let currentCommandeId = null;

        function changerStatut(commandeId) {
            currentCommandeId = commandeId;
            document.getElementById('commandeId').value = commandeId;
            new bootstrap.Modal(document.getElementById('statutModal')).show();
        }

        function confirmerChangementStatut() {
            const statut = document.getElementById('nouveauStatut').value;
            fetch('<%= baseUrl %>/statut', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'commandeId=' + currentCommandeId + '&statut=' + statut
            }).then(response => {
                if (response.ok) location.reload();
                else alert('Erreur lors du changement de statut');
            }).catch(error => {
                console.error('Error:', error);
                alert('Erreur lors du changement de statut');
            });
        }
    </script>
</body>
</html>