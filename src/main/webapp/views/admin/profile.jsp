<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String userNom = (String) request.getAttribute("userNom");
    String userEmail = (String) request.getAttribute("userEmail");
    Long userId = (Long) request.getAttribute("userId");

    if (userNom == null) userNom = "Administrateur";
    if (userEmail == null) userEmail = "";
    if (userId == null) userId = 0L;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Tablaino Restaurant</title>

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

        .profile-card {
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

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            margin: 0 auto 1.5rem;
            border: 5px solid white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .form-control:focus {
            border-color: var(--admin-accent);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--admin-accent) 0%, #2980b9 100%);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
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
        <jsp:param name="activePage" value="profile" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Mon Profil</h1>
                    <p class="page-subtitle mb-0">Gérez vos informations personnelles</p>
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

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= request.getAttribute("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- Informations du Profil -->
            <div class="col-lg-6">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <i class="bi bi-person-circle me-2"></i>Informations du Profil
                    </div>
                    <div class="p-4">
                        <div class="profile-avatar">
                            <i class="bi bi-person-fill"></i>
                        </div>

                        <form method="post" action="<%= contextPath %>/admin/profile">
                            <input type="hidden" name="action" value="updateProfile">

                            <div class="mb-3">
                                <label class="form-label fw-bold">ID Utilisateur</label>
                                <input type="text" class="form-control" value="<%= userId %>" readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Nom</label>
                                <input type="text" class="form-control" name="nom" value="<%= userNom %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Email</label>
                                <input type="email" class="form-control" name="email" value="<%= userEmail %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Rôle</label>
                                <input type="text" class="form-control" value="Administrateur" readonly>
                            </div>

                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-check-circle me-2"></i>Mettre à jour le profil
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Changement de Mot de Passe -->
            <div class="col-lg-6">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <i class="bi bi-shield-lock me-2"></i>Changement de Mot de Passe
                    </div>
                    <div class="p-4">
                        <form method="post" action="<%= contextPath %>/admin/profile">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Ancien mot de passe</label>
                                <input type="password" class="form-control" name="ancienMotDePasse" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Nouveau mot de passe</label>
                                <input type="password" class="form-control" name="nouveauMotDePasse" required
                                       minlength="6" placeholder="Minimum 6 caractères">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Confirmer le mot de passe</label>
                                <input type="password" class="form-control" name="confirmerMotDePasse" required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-key me-2"></i>Changer le mot de passe
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Actions Rapides -->
                <div class="profile-card mt-4">
                    <div class="card-header-custom">
                        <i class="bi bi-lightning-charge me-2"></i>Actions Rapides
                    </div>
                    <div class="p-4">
                        <div class="d-grid gap-2">
                            <a href="<%= contextPath %>/admin/dashboard" class="btn btn-outline-primary">
                                <i class="bi bi-speedometer2 me-2"></i>Retour au Dashboard
                            </a>
                            <a href="<%= contextPath %>/logout" class="btn btn-outline-danger"
                               onclick="return confirm('Êtes-vous sûr de vouloir vous déconnecter ?')">
                                <i class="bi bi-box-arrow-right me-2"></i>Déconnexion
                            </a>
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

        if (window.innerWidth <= 768) {
            document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                link.addEventListener('click', () => {
                    if (sidebar.classList.contains('open')) {
                        toggleSidebar();
                    }
                });
            });
        }

        // Auto-dismiss alerts after 5 seconds
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