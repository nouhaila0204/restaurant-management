<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String activePage = request.getParameter("activePage");
    String userNom = (String) session.getAttribute("userNom");
    String userRole = (String) session.getAttribute("userRole");
    if (userNom == null) userNom = "Utilisateur";
    if (userRole == null) userRole = "SERVEUR";
%>
<style>
    /* VOTRE CSS EXISTANT... */
    :root {
        --gold: #B8935C;
        --burgundy: #8B1A1A;
        --dark-red: #6b1515;
        --wood: #8B5A3C;
    }

    .sidebar {
        background: linear-gradient(180deg, var(--burgundy) 0%, var(--dark-red) 100%);
        color: white;
        height: 100vh;
        box-shadow: 4px 0 15px rgba(0,0,0,0.2);
        position: fixed;
        left: -260px;
        top: 0;
        width: 260px;
        z-index: 1000;
        transition: left 0.3s ease;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
    }

    .sidebar.open {
        left: 0;
    }

    .sidebar-header {
        padding: 2rem 1.5rem;
        border-bottom: 2px solid rgba(184, 147, 92, 0.3);
        text-align: center;
    }

    .sidebar-logo {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        border: 3px solid var(--gold);
        background: white;
        padding: 8px;
        margin-bottom: 1rem;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    }

    .user-info {
        margin-top: 1rem;
    }

    .user-name {
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--gold);
        margin-bottom: 0.25rem;
    }

    .user-role {
        font-size: 0.85rem;
        color: rgba(184, 147, 92, 0.8);
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .sidebar .nav-link {
        color: rgba(255, 255, 255, 0.85);
        padding: 0.9rem 1.5rem;
        margin: 0.25rem 0.75rem;
        border-radius: 10px;
        transition: all 0.3s ease;
        font-weight: 500;
        border-left: 3px solid transparent;
        text-decoration: none;
    }

    .sidebar .nav-link:hover {
        background: rgba(184, 147, 92, 0.2);
        color: var(--gold);
        transform: translateX(5px);
        border-left-color: var(--gold);
    }

    .sidebar .nav-link.active {
        background: linear-gradient(90deg, rgba(184, 147, 92, 0.3), transparent);
        color: var(--gold);
        font-weight: 700;
        border-left-color: var(--gold);
    }

    .sidebar .nav-link i {
        font-size: 1.2rem;
        margin-right: 0.75rem;
        width: 25px;
        text-align: center;
    }

    .sidebar-footer {
        padding: 1rem;
        border-top: 2px solid rgba(184, 147, 92, 0.3);
        margin-top: auto;
    }

    .nav-link-new {
        background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
        border: 2px solid var(--gold);
        margin: 1rem 0.75rem;
        border-radius: 10px;
        transition: all 0.3s ease;
    }

    .nav-link-new:hover {
        background: linear-gradient(135deg, var(--dark-gold) 0%, var(--gold) 100%);
        transform: translateX(5px);
    }

    /* Style spécifique pour le bouton de déconnexion */
    .logout-link {
        color: #ff6b6b !important;
        border-left: 3px solid #ff6b6b !important;
    }

    .logout-link:hover {
        background: rgba(255, 107, 107, 0.2) !important;
        color: #ff8e8e !important;
    }

    @media (max-width: 768px) {
        .sidebar {
            width: 280px;
        }
    }
</style>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <img src="<%= contextPath %>/ressources/images/logoTablaino2.jpg" alt="Tablaino" class="sidebar-logo">
        <div class="user-info">
            <div class="user-name"><%= userNom %></div>
            <div class="user-role"><%= userRole %></div>
        </div>
    </div>

    <nav class="nav flex-column mt-3">
        <a class="nav-link <%= "dashboard".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/serveur/dashboard">
            <i class="bi bi-speedometer2"></i>Dashboard
        </a>

        <!-- Lien Nouvelle Commande -->
        <a class="nav-link nav-link-new <%= "nouvelle-commande".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/serveur/commandes/nouvelle"
           style="background: linear-gradient(135deg, var(--gold) 0%, #9a7b4d 100%); border: none; color: white; font-weight: 600;">
            <i class="bi bi-plus-circle-fill"></i>Nouvelle Commande
        </a>

        <a class="nav-link <%= "commandes".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/serveur/commandes">
            <i class="bi bi-receipt"></i>Liste des Commandes
        </a>
        <a class="nav-link <%= "tables".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/serveur/tables">
            <i class="bi bi-table"></i>Gestion des Tables
        </a>
        <a class="nav-link <%= "plats".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/carte-plats">
            <i class="bi bi-egg-fried"></i>Carte des Plats
        </a>
        <a class="nav-link <%= "clients".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/serveur/clients">
            <i class="bi bi-people"></i>Gestion Clients
        </a>
    </nav>

    <div class="sidebar-footer">
        <a class="nav-link" href="<%= contextPath %>/serveur/profile">
             <i class="bi bi-person-circle"></i>Mon Profil
        </a>
        <a class="nav-link logout-link" href="<%= contextPath %>/logout">
            <i class="bi bi-box-arrow-right"></i>Déconnexion
        </a>
    </div>
</div>