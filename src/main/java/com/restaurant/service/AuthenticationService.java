package com.restaurant.service;

import com.restaurant.dao.UserDAO;
import com.restaurant.model.User;

import java.util.*;

/**
 * 🔐 Service d'authentification et gestion des utilisateurs
 */
public class AuthenticationService {
    private UserDAO userDAO = new UserDAO();

    /**
     * Authentifie un utilisateur avec email/mot de passe
     */
    public Optional<User> authentifier(String email, String password) {
        return userDAO.findByEmailAndPassword(email, password);
    }

    /**
     * Vérifie si un email existe déjà
     */
    public boolean emailExiste(String email) {
        return userDAO.findByEmail(email).isPresent();
    }

    /**
     * Crée un nouvel utilisateur avec validation
     */
    public User creerUser(String nom, String email, String password, User.RoleUser role) {
        // Validation des données
        if (nom == null || nom.trim().isEmpty()) {
            throw new RuntimeException("Le nom est obligatoire");
        }
        if (email == null || !email.contains("@")) {
            throw new RuntimeException("Email invalide");
        }
        if (emailExiste(email)) {
            throw new RuntimeException("Cet email est déjà utilisé");
        }

        // Création de l'utilisateur
        User user = new User(nom, email, password, role);
        return userDAO.save(user);
    }

    /**
     * 🔐 Vérifie les permissions d'un utilisateur
     */
    public boolean aPermission(Long userId, String permission) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) return false;

        User user = userOpt.get();
        boolean estAdmin = user.getRole() == User.RoleUser.ADMIN;

        return switch (permission) {
            case "GERER_COMMANDES" -> estAdmin || user.getRole() == User.RoleUser.SERVEUR;
            case "GERER_PLATS" -> estAdmin;
            case "GERER_TABLES" -> estAdmin || user.getRole() == User.RoleUser.SERVEUR;
            case "VOIR_STATS" -> estAdmin;
            case "GERER_USERS" -> estAdmin; // Seul l'admin peut gérer les utilisateurs
            default -> false;
        };
    }

    /**
     * 🔐 Vérifie le rôle d'un utilisateur
     */
    public boolean estAdmin(Long userId) {
        return userDAO.findById(userId)
                .map(user -> user.getRole() == User.RoleUser.ADMIN)
                .orElse(false);
    }

    public boolean estServeur(Long userId) {
        return userDAO.findById(userId)
                .map(user -> user.getRole() == User.RoleUser.SERVEUR)
                .orElse(false);
    }

    /**
     * 📊 Statistiques utilisateurs
     */
    public java.util.Map<String, Long> getStatistiquesUtilisateurs() {
        java.util.Map<String, Long> stats = new java.util.HashMap<>();
        java.util.List<User> tousUtilisateurs = userDAO.findAll();

        stats.put("total", (long) tousUtilisateurs.size());
        stats.put("administrateurs", tousUtilisateurs.stream()
                .filter(u -> u.getRole() == User.RoleUser.ADMIN).count());
        stats.put("serveurs", tousUtilisateurs.stream()
                .filter(u -> u.getRole() == User.RoleUser.SERVEUR).count());

        return stats;
    }

    /**
     * Récupère un utilisateur par son ID
     */
    public Optional<User> trouverUtilisateurParId(Long id) {
        return userDAO.findById(id);
    }

    /**
     * Liste tous les utilisateurs
     */
    public java.util.List<User> listerTousUtilisateurs() {
        return userDAO.findAll();
    }

    /**
     * Obtenir tous les serveurs (pour assignation aux commandes)
     Votre UserDAO est parfait - il fait la conversion String → Enum automatiquement ! 🚀*/
    public java.util.List<User> getTousAdministrateurs() {
        // ✅ SOLUTION : Passer le String "ADMIN"
        return userDAO.findByRole("ADMIN");
    }

    /**
     * Obtenir tous les administrateurs
     */
    public java.util.List<User> getTousServeurs() {
        // ✅ SOLUTION : Passer le String "SERVEUR"
        return userDAO.findByRole("SERVEUR");
    }


    //- ÉNUMÉRATION COMPLÈTE DES PERMISSIONS
    public enum Permission {
        // ==================== 👥 PERMISSIONS CLIENTS ====================
        CLIENT_CREER("client:creer"),
        CLIENT_VOIR("client:voir"),
        CLIENT_MODIFIER("client:modifier"),
        CLIENT_RECHERCHER("client:rechercher"),

        // ==================== 🍽️ PERMISSIONS PLATS ====================
        PLAT_CREER("plat:creer"),
        PLAT_MODIFIER("plat:modifier"),
        PLAT_SUPPRIMER("plat:supprimer"),
        PLAT_GERER("plat:gerer"),
        PLAT_DISPONIBILITE("plat:disponibilite"),
        PLAT_RECHERCHER("plat:rechercher"),
        PLAT_VOIR_MENU("plat:voir_menu"),
        PLAT_VOIR_CATEGORIE("plat:voir_categorie"),

        // ==================== 📋 PERMISSIONS COMMANDES ====================
        COMMANDE_CREER("commande:creer"),
        COMMANDE_MODIFIER("commande:modifier"),
        COMMANDE_VOIR("commande:voir"),
        COMMANDE_STATUT("commande:statut"),
        COMMANDE_AJOUTER_PLAT("commande:ajouter_plat"),
        COMMANDE_VOIR_EN_COURS("commande:voir_en_cours"),
        COMMANDE_VOIR_DU_JOUR("commande:voir_du_jour"),
        COMMANDE_VOIR_PAR_ID("commande:voir_par_id"),

        // ==================== 🪑 PERMISSIONS TABLES ====================
        TABLE_CREER("table:creer"),
        TABLE_MODIFIER("table:modifier"),
        TABLE_VOIR("table:voir"),
        TABLE_VOIR_LIBRES("table:voir_libres"),
        TABLE_VOIR_TOUTES("table:voir_toutes"),
        TABLE_CHANGER_STATUT("table:changer_statut"),
        TABLE_LIBERER("table:liberer"),

        // ==================== 📂 PERMISSIONS CATÉGORIES ====================
        CATEGORIE_CREER("categorie:creer"),
        CATEGORIE_MODIFIER("categorie:modifier"),
        CATEGORIE_VOIR("categorie:voir"),
        CATEGORIE_VOIR_AVEC_PLATS("categorie:voir_avec_plats"),

        // ==================== 👥 PERMISSIONS UTILISATEURS ====================
        USER_CREER("user:creer"),
        USER_MODIFIER("user:modifier"),
        USER_VOIR("user:voir"),
        USER_VOIR_TOUS("user:voir_tous"),
        USER_CHANGER_ROLE("user:changer_role"),
        USER_CHANGER_MDP("user:changer_mdp"),
        USER_GERER_PROFIL("user:gerer_profil"),

        // ==================== 📊 PERMISSIONS STATISTIQUES ====================
        STATS_VOIR("stats:voir"),
        STATS_CHIFFRE_AFFAIRE("stats:chiffre_affaire"),
        STATS_UTILISATEURS("stats:utilisateurs");

        private final String code;

        Permission(String code) {
            this.code = code;
        }

        public String getCode() {
            return code;
        }
    }

    //  - Configuration complète
    private Map<User.RoleUser, Set<Permission>> getPermissionsParRole() {
        Map<User.RoleUser, Set<Permission>> permissions = new HashMap<>();

        // ==================== PERMISSIONS SERVEUR ====================
        Set<Permission> permissionsServeur = new HashSet<>(Arrays.asList(
                // Clients
                Permission.CLIENT_CREER,
                Permission.CLIENT_VOIR,
                Permission.CLIENT_RECHERCHER,

                // Plats (lecture seulement)
                Permission.PLAT_VOIR_MENU,
                Permission.PLAT_VOIR_CATEGORIE,
                Permission.PLAT_RECHERCHER,

                // Commandes
                Permission.COMMANDE_CREER,
                Permission.COMMANDE_MODIFIER,
                Permission.COMMANDE_VOIR,
                Permission.COMMANDE_STATUT,
                Permission.COMMANDE_AJOUTER_PLAT,
                Permission.COMMANDE_VOIR_EN_COURS,
                Permission.COMMANDE_VOIR_DU_JOUR,
                Permission.COMMANDE_VOIR_PAR_ID,

                // Tables (lecture seulement)
                Permission.TABLE_VOIR,
                Permission.TABLE_VOIR_LIBRES,
                Permission.TABLE_VOIR_TOUTES,
                Permission.TABLE_CHANGER_STATUT,
                Permission.TABLE_LIBERER,

                // Catégories (lecture seulement)
                Permission.CATEGORIE_VOIR,
                Permission.CATEGORIE_VOIR_AVEC_PLATS,

                // Utilisateurs (profil seulement)
                Permission.USER_GERER_PROFIL,
                Permission.USER_CHANGER_MDP
        ));
        permissions.put(User.RoleUser.SERVEUR, permissionsServeur);

        // ==================== PERMISSIONS ADMIN ====================
        Set<Permission> permissionsAdmin = new HashSet<>(Arrays.asList(Permission.values()));
        permissions.put(User.RoleUser.ADMIN, permissionsAdmin);

        return permissions;
    }

    // ==================== MÉTHODES PERMISSIONS ====================
    /**
     * 🔐 Vérifie si un utilisateur a une permission spécifique
     */
    public boolean aPermission(Long userId, Permission permission) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) return false;

        User user = userOpt.get();
        Map<User.RoleUser, Set<Permission>> permissionsParRole = getPermissionsParRole();
        Set<Permission> permissions = permissionsParRole.get(user.getRole());

        return permissions != null && permissions.contains(permission);
    }

    /**
     * 🔐 Récupère toutes les permissions d'un utilisateur
     */
    public Set<Permission> getPermissionsUser(Long userId) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) return new HashSet<>();

        User user = userOpt.get();
        Map<User.RoleUser, Set<Permission>> permissionsParRole = getPermissionsParRole();
        return permissionsParRole.getOrDefault(user.getRole(), new HashSet<>());
    }
}