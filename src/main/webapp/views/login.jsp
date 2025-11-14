<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tablaino - Connexion</title>

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
        }

        body {
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 50%, #2C1810 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            padding: 2rem 0;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background:
                radial-gradient(circle at 20% 30%, rgba(184, 147, 92, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 70%, rgba(139, 26, 26, 0.2) 0%, transparent 50%);
            pointer-events: none;
        }

        .login-container {
            position: relative;
            z-index: 1;
        }

        .login-card {
            background: linear-gradient(to bottom, #ffffff 0%, #fefdfb 100%);
            border-radius: 25px;
            box-shadow:
                0 25px 50px rgba(0, 0, 0, 0.5),
                0 0 0 1px var(--gold),
                inset 0 1px 0 rgba(255, 255, 255, 0.9);
            border: none;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .logo-section {
            text-align: center;
            padding: 3rem 2rem;
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
            position: relative;
            overflow: hidden;
        }

        .logo-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background:
                repeating-linear-gradient(
                    45deg,
                    transparent,
                    transparent 10px,
                    rgba(184, 147, 92, 0.05) 10px,
                    rgba(184, 147, 92, 0.05) 20px
                );
        }

        .logo-section::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(184, 147, 92, 0.1) 0%, transparent 70%);
        }

        .logo-wrapper {
            position: relative;
            z-index: 1;
        }

        .logo-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid var(--gold);
            box-shadow:
                0 10px 30px rgba(0, 0, 0, 0.4),
                0 0 0 8px rgba(184, 147, 92, 0.2);
            background: white;
            padding: 10px;
            margin-bottom: 1.5rem;
            animation: logoFloat 3s ease-in-out infinite;
        }

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .brand-title {
            color: var(--gold);
            font-size: 2.5rem;
            font-weight: 800;
            text-shadow:
                2px 2px 4px rgba(0, 0, 0, 0.3),
                0 0 20px rgba(184, 147, 92, 0.4);
            letter-spacing: 2px;
            margin-bottom: 0.5rem;
        }

        .brand-subtitle {
            color: var(--gold);
            opacity: 0.9;
            font-size: 1rem;
            font-weight: 300;
            letter-spacing: 1px;
        }

        .form-section {
            padding: 2.5rem;
            background: linear-gradient(to bottom, #ffffff 0%, #fefdfb 100%);
        }

        .form-label {
            color: var(--wood);
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
        }

        .form-control {
            border: 2px solid #e8e4df;
            border-radius: 12px;
            padding: 0.8rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafaf9;
        }

        .form-control:focus {
            border-color: var(--gold);
            box-shadow:
                0 0 0 0.25rem rgba(184, 147, 92, 0.15),
                0 5px 15px rgba(184, 147, 92, 0.1);
            background: white;
            transform: translateY(-2px);
        }

        .input-icon {
            color: var(--gold);
        }

        .btn-login {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            border: none;
            padding: 0.9rem;
            font-weight: 700;
            font-size: 1.1rem;
            letter-spacing: 1px;
            border-radius: 12px;
            box-shadow:
                0 8px 20px rgba(184, 147, 92, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s ease;
        }

        .btn-login:hover::before {
            left: 100%;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow:
                0 12px 30px rgba(184, 147, 92, 0.4),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            background: linear-gradient(135deg, var(--dark-gold) 0%, var(--gold) 100%);
        }

        .btn-login:active {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(184, 147, 92, 0.3);
        }

        .demo-section {
            background: linear-gradient(to bottom, #f8f6f3 0%, #f0ebe5 100%);
            border-radius: 0 0 25px 25px;
            padding: 2rem 2.5rem;
            border-top: 2px solid var(--gold);
        }

        .demo-title {
            color: var(--wood);
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 1.5rem;
        }

        .demo-account {
            background: white;
            border: 2px solid #e8e4df;
            border-radius: 12px;
            padding: 1rem;
            transition: all 0.3s ease;
            margin-bottom: 0.75rem;
        }

        .demo-account:hover {
            border-color: var(--gold);
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(184, 147, 92, 0.15);
        }

        .role-badge {
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-red) 100%);
            color: white;
            padding: 0.35rem 0.9rem;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 3px 8px rgba(139, 26, 26, 0.3);
        }

        .role-icon {
            color: var(--gold);
            font-size: 1.2rem;
        }

        .password-info {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            color: white;
            padding: 1rem;
            border-radius: 12px;
            text-align: center;
            font-size: 0.9rem;
            box-shadow: 0 5px 15px rgba(184, 147, 92, 0.3);
        }

        .alert-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
            color: white;
            border-radius: 12px;
            border-left: 4px solid #a71d2a;
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
        }

        .alert-danger .btn-close {
            filter: brightness(0) invert(1);
        }

        /* Decorative elements */
        .corner-decoration {
            position: absolute;
            width: 100px;
            height: 100px;
            opacity: 0.1;
        }

        .corner-decoration.top-left {
            top: 0;
            left: 0;
            background: linear-gradient(135deg, var(--gold) 0%, transparent 100%);
            border-radius: 0 0 100% 0;
        }

        .corner-decoration.bottom-right {
            bottom: 0;
            right: 0;
            background: linear-gradient(-45deg, var(--burgundy) 0%, transparent 100%);
            border-radius: 100% 0 0 0;
        }

        @media (max-width: 768px) {
            .brand-title {
                font-size: 2rem;
            }

            .logo-image {
                width: 100px;
                height: 100px;
            }
        }
    </style>
</head>
<body>
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card login-card">
                    <div class="corner-decoration top-left"></div>
                    <div class="corner-decoration bottom-right"></div>

                    <!-- Logo Section -->
                    <div class="logo-section">
                        <div class="logo-wrapper">
                            <img src="./ressources/images/logoTablaino2.jpg" alt="Tablaino Restaurant" class="logo-image">
                            <h1 class="brand-title">TABLAINO</h1>
                            <p class="brand-subtitle">RESTAURANT</p>
                        </div>
                    </div>

                    <!-- Error Message -->
                    <%
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        if (errorMessage != null && !errorMessage.isEmpty()) {
                    %>
                        <div class="alert alert-danger alert-dismissible fade show m-3 mb-0" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <%= errorMessage %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>

                    <!-- Login Form -->
                    <div class="form-section">
                        <form method="POST" action="login">
                            <div class="mb-4">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope-fill input-icon me-2"></i>Adresse Email
                                </label>
                                <input type="email"
                                       class="form-control form-control-lg"
                                       id="email"
                                       name="email"
                                       required
                                       placeholder="votre@email.com"
                                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">
                                    <i class="bi bi-lock-fill input-icon me-2"></i>Mot de passe
                                </label>
                                <input type="password"
                                       class="form-control form-control-lg"
                                       id="password"
                                       name="password"
                                       required
                                       placeholder="••••••••">
                            </div>

                            <button type="submit" class="btn btn-login btn-lg w-100 text-white">
                                <i class="bi bi-box-arrow-in-right me-2"></i>
                                SE CONNECTER
                            </button>
                        </form>
                    </div>

                    <!-- Demo Accounts Section -->
                    <div class="demo-section">
                        <h6 class="demo-title">
                            <i class="bi bi-info-circle-fill me-2"></i>Comptes de Démonstration
                        </h6>

                        <div class="demo-account">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="bi bi-shield-fill-check role-icon me-2"></i>
                                    <strong>Administrateur</strong>
                                </div>
                                <span class="role-badge">admin@restaurant.com</span>
                            </div>
                        </div>

                        <div class="demo-account">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="bi bi-person-fill role-icon me-2"></i>
                                    <strong>Serveur</strong>
                                </div>
                                <span class="role-badge">serveur@restaurant.com</span>
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
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-dismiss alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });

            // Add focus animation to form inputs
            const inputs = document.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.querySelector('.input-icon')?.classList.add('text-primary');
                });

                input.addEventListener('blur', function() {
                    this.parentElement.querySelector('.input-icon')?.classList.remove('text-primary');
                });
            });
        });
    </script>
</body>
</html>