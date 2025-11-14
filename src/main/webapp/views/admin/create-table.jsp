<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer une Table - Tablaino Restaurant</title>

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
            background: linear-gradient(135deg, var(--admin-success) 0%, #229954 100%);
            border-radius: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            margin: 0 auto;
            box-shadow: 0 5px 15px rgba(34, 153, 84, 0.3);
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
                    <h1 class="page-title">Créer une Table</h1>
                    <p class="page-subtitle mb-0">Ajouter une nouvelle table au restaurant</p>
                </div>
                <a href="<%= contextPath %>/admin/tables" class="btn btn-outline-secondary">

                    <i class="bi bi-arrow-left me-2"></i>Retour
                </a>
            </div>
        </div>

        <!-- Formulaire de création -->
        <div class="row">
            <div class="col-lg-8">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-plus-circle me-2"></i>Informations de la table
                    </div>
                    <div class="p-4">
                        <form method="post" action="<%= contextPath %>/admin/tables">
                            <input type="hidden" name="action" value="create">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="numero" class="form-label">Numéro de table *</label>
                                    <input type="text" class="form-control" id="numero" name="numero"
                                           placeholder="Ex: T01, Table 1, A1..." required>
                                    <div class="form-text">Le numéro doit être unique.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="capacite" class="form-label">Capacité *</label>
                                    <input type="number" class="form-control" id="capacite" name="capacite"
                                           min="1" max="20" value="4" required>
                                    <div class="form-text">Nombre maximum de personnes.</div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="<%= contextPath %>/admin/tables" class="btn btn-outline-secondary">

                                    <i class="bi bi-x-circle me-2"></i>Annuler
                                </a>
                                <button type="submit" class="btn-admin">
                                    <i class="bi bi-check-circle me-2"></i>Créer la table
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-eye me-2"></i>Aperçu
                    </div>
                    <div class="p-4 text-center">
                        <div class="table-preview mb-3">
                            <i class="bi bi-table display-4"></i>
                            <small class="mt-2 fw-bold" id="preview-numero">T01</small>
                        </div>
                        <div class="table-info">
                            <div class="mb-2">
                                <i class="bi bi-people me-2"></i>
                                <span id="preview-capacite">4 places</span>
                            </div>
                            <div class="badge bg-success">
                                <i class="bi bi-check-circle me-1"></i>Libre
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

        // Mise à jour en temps réel de l'aperçu
        document.getElementById('numero').addEventListener('input', function() {
            document.getElementById('preview-numero').textContent = this.value || 'T01';
        });

        document.getElementById('capacite').addEventListener('input', function() {
            document.getElementById('preview-capacite').textContent = this.value + ' places';
        });

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