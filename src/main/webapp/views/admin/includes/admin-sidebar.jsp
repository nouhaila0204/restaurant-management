<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String activePage = request.getParameter("activePage");
    String userNom = (String) session.getAttribute("userNom");
    if (userNom == null) userNom = "Administrateur";
%>
<style>
    /* Sidebar Styles - Version Admin */
    .sidebar {
        background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
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
        border-bottom: 2px solid rgba(52, 152, 219, 0.3);
        text-align: center;
    }

    .sidebar-logo {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        border: 3px solid #3498db;
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
        color: #3498db;
        margin-bottom: 0.25rem;
    }

    .user-role {
        font-size: 0.85rem;
        color: rgba(52, 152, 219, 0.8);
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
        background: rgba(52, 152, 219, 0.2);
        color: #3498db;
        transform: translateX(5px);
        border-left-color: #3498db;
    }

    .sidebar .nav-link.active {
        background: linear-gradient(90deg, rgba(52, 152, 219, 0.3), transparent);
        color: #3498db;
        font-weight: 700;
        border-left-color: #3498db;
    }

    .sidebar .nav-link i {
        font-size: 1.2rem;
        margin-right: 0.75rem;
        width: 25px;
        text-align: center;
    }

    .sidebar-footer {
        padding: 1rem;
        border-top: 2px solid rgba(52, 152, 219, 0.3);
        margin-top: auto;
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
            <div class="user-role">Administrateur</div>
        </div>
    </div>

    <nav class="nav flex-column mt-3">
        <a class="nav-link <%= "dashboard".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/admin/dashboard">
            <i class="bi bi-speedometer2"></i>Dashboard
        </a>
        <a class="nav-link <%= "users".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/admin/users">
            <i class="bi bi-people-fill"></i>Utilisateurs
        </a>
        <a class="nav-link <%= "commandes".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/admin/commandes">
            <i class="bi bi-receipt"></i>Commandes
        </a>
        <a class="nav-link <%= "plats".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/admin/plats">
            <i class="bi bi-egg-fried"></i>Gestion des Plats
        </a>
        <a class="nav-link <%= "categories".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/admin/categories">
            <i class="bi bi-tags"></i>Catégories
        </a>
        <a class="nav-link <%= "tables".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/admin/tables">
            <i class="bi bi-table"></i>Tables
        </a>
        <a class="nav-link <%= "statistiques".equals(activePage) ? "active" : "" %>"
           href="<%= contextPath %>/admin/statistiques">
            <i class="bi bi-graph-up"></i>Statistiques
        </a>
    </nav>

    <div class="sidebar-footer">
        <a class="nav-link" href="<%= contextPath %>/admin/profile">
            <i class="bi bi-person-circle"></i>Mon Profil
        </a>
        <a class="nav-link" href="<%= contextPath %>/logout" style="color: #3498db;">
            <i class="bi bi-box-arrow-right"></i>Déconnexion
        </a>
    </div>
</div>