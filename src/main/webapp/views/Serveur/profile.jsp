<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.restaurant.model.User" %>
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
            margin-bottom: 2rem;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
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
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            margin: 0 auto 1.5rem;
            border: 4px solid white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .info-item {
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: var(--wood);
            margin-bottom: 0.25rem;
        }

        .info-value {
            color: #333;
            font-size: 1.1rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(184, 147, 92, 0.3);
        }

        .form-control:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 0.25rem rgba(184, 147, 92, 0.15);
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
        <jsp:param name="activePage" value="profile" />
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Mon Profil</h1>
                    <p class="page-subtitle mb-0">Gérez vos informations personnelles et votre mot de passe</p>
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

        <div class="row" style="margin-left: 70px; margin-right: 70px;">
            <!-- Informations personnelles -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-person-circle me-2"></i>Informations Personnelles
                    </div>
                    <div class="p-4">
                        <%
                            User user = (User) request.getAttribute("user");
                            if (user != null) {
                        %>
                            <div class="profile-avatar">
                                <i class="bi bi-person-fill"></i>
                            </div>

                            <div class="info-item">
                                <div class="info-label">Nom complet</div>
                                <div class="info-value"><%= user.getNom() %></div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">Email</div>
                                <div class="info-value"><%= user.getEmail() %></div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">Rôle</div>
                                <div class="info-value">
                                    <span class="badge bg-primary">
                                        <%= user.getRole().toString() %>
                                    </span>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">ID Utilisateur</div>
                                <div class="info-value text-muted"><code><%= user.getId() %></code></div>
                            </div>
                        <% } else { %>
                            <div class="text-center text-muted py-4">
                                <i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i>
                                <p class="mt-3">Impossible de charger les informations du profil</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Changement de mot de passe -->
            <div class="col-lg-6">
                <div class="content-card">
                    <div class="card-header-custom">
                        <i class="bi bi-shield-lock me-2"></i>Changer le Mot de Passe
                    </div>
                    <div class="p-4">
                        <form action="<%= request.getContextPath() %>/serveur/profile" method="POST">
                            <input type="hidden" name="action" value="changer-motdepasse">

                            <div class="mb-3">
                                <label for="ancienMotDePasse" class="form-label">
                                    <i class="bi bi-lock-fill me-2"></i>Ancien mot de passe
                                </label>
                                <input type="password"
                                       class="form-control"
                                       id="ancienMotDePasse"
                                       name="ancienMotDePasse"
                                       required
                                       placeholder="Entrez votre ancien mot de passe">
                            </div>

                            <div class="mb-3">
                                <label for="nouveauMotDePasse" class="form-label">
                                    <i class="bi bi-key-fill me-2"></i>Nouveau mot de passe
                                </label>
                                <input type="password"
                                       class="form-control"
                                       id="nouveauMotDePasse"
                                       name="nouveauMotDePasse"
                                       required
                                       placeholder="Entrez votre nouveau mot de passe"
                                       minlength="8">
                                <div class="form-text">
                                    Le mot de passe doit contenir au moins 8 caractères.
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="confirmationMotDePasse" class="form-label">
                                    <i class="bi bi-key me-2"></i>Confirmer le nouveau mot de passe
                                </label>
                                <input type="password"
                                       class="form-control"
                                       id="confirmationMotDePasse"
                                       name="confirmationMotDePasse"
                                       required
                                       placeholder="Confirmez votre nouveau mot de passe">
                            </div>

                            <button type="submit" class="btn btn-primary-custom w-100 text-white">
                                <i class="bi bi-check-circle me-2"></i>
                                Changer le mot de passe
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Informations de sécurité -->
                <div class="content-card mt-4">
                    <div class="card-header-custom">
                        <i class="bi bi-info-circle me-2"></i>Conseils de Sécurité
                    </div>
                    <div class="p-4">
                        <div class="alert alert-info border-0">
                            <h6 class="alert-heading">
                                <i class="bi bi-lightbulb me-2"></i>Pour votre sécurité :
                            </h6>
                            <ul class="mb-0 ps-3">
                                <li>Utilisez un mot de passe unique</li>
                                <li>Ne partagez jamais votre mot de passe</li>
                                <li>Changez régulièrement votre mot de passe</li>
                                <li>Déconnectez-vous après chaque session</li>
                            </ul>
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

        // Validation du formulaire de changement de mot de passe
        document.querySelector('form')?.addEventListener('submit', function(e) {
            const nouveauMotDePasse = document.getElementById('nouveauMotDePasse').value;
            const confirmationMotDePasse = document.getElementById('confirmationMotDePasse').value;

            if (nouveauMotDePasse !== confirmationMotDePasse) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas.');
                return false;
            }

            if (nouveauMotDePasse.length < 8) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins 8 caractères.');
                return false;
            }
        });
    </script>
</body>
</html>