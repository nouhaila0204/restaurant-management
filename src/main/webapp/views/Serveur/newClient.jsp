<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Client - Tablaino Restaurant</title>

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
            max-width: 1400px;
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
                    <h1 class="page-title">Nouveau Client</h1>
                    <p class="page-subtitle mb-0">Ajouter un nouveau client au système</p>
                </div>
                <div>
                    <a href="http://localhost:8080/Restaurant_management/serveur/clients" class="btn-secondary-custom">
                        <i class="bi bi-arrow-left me-2"></i>Retour à la liste
                    </a>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin-left: 70px; max-width: 1200px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("errorMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Formulaire -->
        <div class="form-card">
            <div class="card-header-custom">
                <i class="bi bi-person-plus-fill me-2"></i>Informations du Client
            </div>
            <div class="p-4">
                <form action="creer" method="POST">
                    <!-- Nom -->
                    <div class="mb-4">
                        <label for="nom" class="form-label required-field">Nom complet</label>
                        <input type="text"
                               class="form-control form-control-custom"
                               id="nom"
                               name="nom"
                               value="<%= request.getAttribute("nom") != null ? request.getAttribute("nom") : "" %>"
                               placeholder="Entrez le nom complet du client"
                               required>
                        <div class="form-text">Le nom du client est obligatoire.</div>
                    </div>

                    <!-- Téléphone -->
                    <div class="mb-4">
                        <label for="telephone" class="form-label">Numéro de téléphone</label>
                        <input type="tel"
                               class="form-control form-control-custom"
                               id="telephone"
                               name="telephone"
                               value="<%= request.getAttribute("telephone") != null ? request.getAttribute("telephone") : "" %>"
                               placeholder="Ex: +212 6 23 45 67 89">
                        <div class="form-text">Le numéro de téléphone est optionnel mais recommandé.</div>
                    </div>

                    <!-- Email -->
                    <div class="mb-4">
                        <label for="email" class="form-label">Adresse email</label>
                        <input type="email"
                               class="form-control form-control-custom"
                               id="email"
                               name="email"
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                               placeholder="Ex: client@example.com">
                        <div class="form-text">L'adresse email est optionnelle.</div>
                    </div>

                    <!-- Boutons -->
                    <div class="d-flex gap-3 justify-content-end pt-3">
                        <a href="<%= request.getContextPath() %>/serveur/clients" class="btn-secondary-custom">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="submit" class="btn-primary-custom">
                            <i class="bi bi-check-circle me-2"></i>Créer le Client
                        </button>
                    </div>
                </form>
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
            menuToggle.querySelector('i').className = isOpen ? 'bi bi-x' : 'bi bi-list';
        }

        menuToggle.addEventListener('click', toggleSidebar);

        // Validation du formulaire
        document.querySelector('form').addEventListener('submit', function(e) {
            const nom = document.getElementById('nom').value.trim();
            if (!nom) {
                e.preventDefault();
                alert('Veuillez saisir le nom du client');
                document.getElementById('nom').focus();
            }
        });

        // Format automatique du téléphone
        document.getElementById('telephone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 0) {
                value = value.match(/.{1,2}/g).join(' ');
            }
            e.target.value = value;
        });
    </script>
</body>
</html>