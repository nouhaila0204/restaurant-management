<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.TableRestaurant" %>
<%@ page import="com.restaurant.model.Plat" %>
<%@ page import="com.restaurant.model.Client" %>
<%
    String contextPath = request.getContextPath();
    String baseUrl = contextPath + "/serveur/commandes";

    List<TableRestaurant> tablesDisponibles = (List<TableRestaurant>) request.getAttribute("tablesDisponibles");
    List<Plat> platsDisponibles = (List<Plat>) request.getAttribute("platsDisponibles");
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    String pageTitle = (String) request.getAttribute("pageTitle");

    if (pageTitle == null) pageTitle = "Nouvelle Commande";

    if (tablesDisponibles == null) tablesDisponibles = new java.util.ArrayList<>();
    if (platsDisponibles == null) platsDisponibles = new java.util.ArrayList<>();
    if (clients == null) clients = new java.util.ArrayList<>();
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
        }

        .main-content {
            padding: 2rem;
            min-height: 100vh;
        }

        .top-bar {
            background: white;
            padding: 1.5rem 2rem;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border-left: 4px solid var(--gold);
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

        .form-section {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 1rem;
            border-left: 4px solid var(--gold);
        }

        .section-title {
            color: var(--burgundy);
            font-weight: 700;
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--light-gold);
        }

        .selection-card {
            border: 2px solid #e8e4df;
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
        }

        .selection-card:hover {
            border-color: var(--gold);
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(184, 147, 92, 0.2);
        }

        input[type="radio"]:checked + .selection-card {
            border-color: var(--burgundy);
            background: linear-gradient(135deg, rgba(139, 26, 26, 0.05), transparent);
        }

        .selection-icon {
            font-size: 2.5rem;
            color: #28a745;
            margin-bottom: 0.75rem;
        }

        .selection-numero {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--burgundy);
            margin-bottom: 0.25rem;
        }

        .selection-info {
            color: var(--wood);
            font-size: 0.9rem;
        }

        .plat-card {
            border: 2px solid #e8e4df;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .plat-card:hover {
            border-color: var(--gold);
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(184, 147, 92, 0.15);
        }

        .plat-prix {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--burgundy);
        }

        .plat-categorie {
            background: var(--gold);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .quantite-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quantite-input {
            width: 80px;
            text-align: center;
            font-weight: 600;
            border: 2px solid var(--light-gold);
            border-radius: 8px;
            padding: 0.5rem;
        }

        .action-btn {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            border: none;
            color: white;
            padding: 1rem 2rem;
            border-radius: 10px;
            font-weight: 700;
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

        .action-btn.secondary {
            background: linear-gradient(135deg, #6c757d 0%, #545b62 100%);
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

        .client-option {
            padding: 1rem;
            border: 2px solid #e8e4df;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .client-option:hover {
            border-color: var(--gold);
            background-color: rgba(184, 147, 92, 0.05);
        }

        input[type="radio"]:checked + .client-option {
            border-color: var(--burgundy);
            background: linear-gradient(135deg, rgba(139, 26, 26, 0.05), transparent);
        }

        .required-field::after {
            content: " *";
            color: var(--burgundy);
        }

        .form-alert {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
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
    </style>
</head>
<body>
<!-- Menu Toggle Button -->
    <button class="menu-toggle" id="menuToggle">
        <i class="bi bi-list"></i>
    </button>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar Overlay for Mobile -->
                <div class="sidebar-overlay" id="sidebarOverlay"></div>

                <!-- Sidebar -->
                <jsp:include page="includes/serveur-sidebar.jsp">
                    <jsp:param name="activePage" value="dashboard" />
                </jsp:include>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Top Bar -->
                <div class="top-bar">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="page-title">
                                <i class="bi bi-plus-circle me-2"></i><%= pageTitle %>
                            </h1>
                            <p class="page-subtitle mb-0">Créer une nouvelle commande</p>
                        </div>
                        <div>
                            <a href="<%= baseUrl %>" class="action-btn secondary">
                                <i class="bi bi-arrow-left me-1"></i>Retour aux commandes
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Formulaire de Commande -->
                <form id="commandeForm" action="<%= baseUrl %>/creer" method="post">

                    <!-- Section 1: Sélection du Client -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="bi bi-person-vcard me-2"></i>
                            <span class="required-field">Sélection du Client</span>
                        </h3>

                        <% if (!clients.isEmpty()) { %>
                            <div class="form-alert">
                                <i class="bi bi-info-circle me-2"></i>
                                Sélectionnez un client existant dans la liste ci-dessous
                            </div>
                            <div class="mb-3">
                                <% for (Client client : clients) {
                                    if (client != null) { %>
                                        <div class="position-relative mb-2">
                                            <input type="radio" name="clientId" value="<%= client.getId() %>"
                                                   id="client<%= client.getId() %>"
                                                   class="position-absolute opacity-0" required>
                                            <label for="client<%= client.getId() %>" class="client-option w-100">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h6 class="fw-bold mb-1"><%= client.getNom() != null ? client.getNom() : "N/A" %></h6>
                                                        <% if (client.getTelephone() != null && !client.getTelephone().isEmpty()) { %>
                                                            <small class="text-muted">
                                                                <i class="bi bi-telephone me-1"></i><%= client.getTelephone() %>
                                                            </small>
                                                        <% } %>
                                                        <% if (client.getEmail() != null && !client.getEmail().isEmpty()) { %>
                                                            <br>
                                                            <small class="text-muted">
                                                                <i class="bi bi-envelope me-1"></i><%= client.getEmail() %>
                                                            </small>
                                                        <% } %>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-primary">Client #<%= client.getId() %></span>
                                                    </div>
                                                </div>
                                            </label>
                                        </div>
                                    <% }
                                } %>
                            </div>
                        <% } else { %>
                            <div class="empty-state">
                                <i class="bi bi-people"></i>
                                <h4 class="text-muted mt-3">Aucun client enregistré</h4>
                                <p class="text-muted mb-4">Veuillez d'abord créer un client dans la section Clients.</p>
                                <a href="<%= contextPath %>/serveur/clients/nouveau" class="action-btn primary">
                                    <i class="bi bi-person-plus me-1"></i>Créer un nouveau client
                                </a>
                            </div>
                        <% } %>
                    </div>

                    <!-- Section 2: Sélection de la Table -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="bi bi-table me-2"></i>
                            <span class="required-field">Sélection de la Table</span>
                        </h3>

                        <% if (!tablesDisponibles.isEmpty()) { %>
                            <div class="form-alert">
                                <i class="bi bi-info-circle me-2"></i>
                                Sélectionnez une table disponible
                            </div>
                            <div class="row g-3">
                                <% for (TableRestaurant table : tablesDisponibles) {
                                    if (table != null && table.isLibre()) { %>
                                        <div class="col-xl-3 col-lg-4 col-md-6">
                                            <input type="radio" name="tableId" value="<%= table.getId() %>"
                                                   id="table<%= table.getId() %>"
                                                   class="d-none" required>
                                            <label for="table<%= table.getId() %>" class="selection-card">
                                                <i class="bi bi-table selection-icon"></i>
                                                <div class="selection-numero">Table <%= table.getNumero() %></div>
                                                <div class="selection-info">
                                                    <i class="bi bi-people-fill me-1"></i>
                                                    <%= table.getCapacite() %> personnes
                                                </div>
                                                <div class="mt-2">
                                                    <span class="badge bg-success">LIBRE</span>
                                                </div>
                                            </label>
                                        </div>
                                    <% }
                                } %>
                            </div>
                        <% } else { %>
                            <div class="empty-state">
                                <i class="bi bi-exclamation-triangle"></i>
                                <h4 class="text-muted mt-3">Aucune table disponible</h4>
                                <p class="text-muted mb-4">Toutes les tables sont actuellement occupées.</p>
                            </div>
                        <% } %>
                    </div>

                    <!-- Section 3: Sélection des Plats -->
                    <div class="form-section">
                        <h3 class="section-title">
                            <i class="bi bi-egg-fried me-2"></i>
                            <span class="required-field">Sélection des Plats</span>
                        </h3>

                        <% if (!platsDisponibles.isEmpty()) { %>
                            <div class="form-alert">
                                <i class="bi bi-info-circle me-2"></i>
                                Indiquez les quantités pour chaque plat (0 = non sélectionné)
                            </div>

                            <div class="mb-4">
                                <h5 class="fw-bold mb-3" style="color: var(--burgundy);">
                                    <i class="bi bi-tag me-2"></i>Menu Disponible
                                </h5>
                                <div class="row g-3">
                                    <% for (Plat plat : platsDisponibles) {
                                        if (plat != null && plat.isDisponible()) {
                                            Object categorie = plat.getCategorie();
                                            String nomCategorie = "Autres";
                                            if (categorie != null) {
                                                if (categorie instanceof String) {
                                                    nomCategorie = (String) categorie;
                                                } else {
                                                    try {
                                                        nomCategorie = categorie.toString();
                                                    } catch (Exception e) {
                                                        nomCategorie = "Catégorie";
                                                    }
                                                }
                                            }
                                    %>
                                            <div class="col-12">
                                                <div class="plat-card">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-6">
                                                            <h6 class="fw-bold mb-1"><%= plat.getNom() != null ? plat.getNom() : "Plat sans nom" %></h6>

                                                            <div class="d-flex gap-2 align-items-center">
                                                                <span class="plat-prix">
                                                                    <%= plat.getPrix() != null ? String.format("%.2f", plat.getPrix()) + " DHs" : "0.00 DHs" %>
                                                                </span>
                                                                <span class="badge bg-success">Disponible</span>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="d-flex align-items-center justify-content-end gap-3">
                                                                <div class="quantite-controls">
                                                                    <label class="form-label fw-semibold me-2">Quantité:</label>
                                                                    <input type="number"
                                                                           name="quantite_<%= plat.getId() %>"
                                                                           class="form-control quantite-input"
                                                                           value="0"
                                                                           min="0"
                                                                           max="20">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        <% }
                                    } %>
                                </div>
                            </div>

                        <% } else { %>
                            <div class="empty-state">
                                <i class="bi bi-exclamation-triangle"></i>
                                <h4 class="text-muted mt-3">Aucun plat disponible</h4>
                                <p class="text-muted mb-4">Le menu est actuellement vide ou aucun plat n'est disponible.</p>
                            </div>
                        <% } %>
                    </div>

                    <!-- Section 4: Instructions de Validation -->
                    <div class="form-section">
                        <div class="alert alert-info">
                            <h6 class="alert-heading">
                                <i class="bi bi-lightbulb me-2"></i>Instructions importantes
                            </h6>
                            <ul class="mb-0">
                                <li>Tous les champs marqués d'un <span class="text-danger">*</span> sont obligatoires</li>
                                <li>Vous devez sélectionner au moins un plat avec une quantité supérieure à 0</li>
                                <li>Vérifiez les informations avant de créer la commande</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Section 5: Validation -->
                    <div class="form-section">
                        <div class="row">
                            <div class="col-12">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="fw-semibold mb-1">Validation de la commande</h6>
                                        <p class="text-muted mb-0">Vérifiez les informations avant de créer la commande</p>
                                    </div>
                                    <div class="d-flex gap-3">
                                        <a href="<%= baseUrl %>" class="action-btn secondary">
                                            <i class="bi bi-x-circle me-1"></i>Annuler
                                        </a>
                                        <button type="submit" class="action-btn primary">
                                            <i class="bi bi-check-circle me-1"></i>Créer la Commande
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>