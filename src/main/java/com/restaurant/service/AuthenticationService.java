package com.restaurant.service;

import com.restaurant.dao.UserDAO;
import com.restaurant.model.User;
import java.util.Optional;

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
     */
    // Dans AuthenticationService.java
    public java.util.List<User> getTousServeurs() {
        return userDAO.findByRole("SERVEUR"); // pour enum et pas pour convertir en String
    }

    /**
     * Obtenir tous les administrateurs
     */
    public java.util.List<User> getTousAdministrateurs() {
        return userDAO.findByRole("ADMIN"); // ⭐ Directement le String en MAJUSCULES
    }
}