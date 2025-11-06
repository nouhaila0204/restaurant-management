package com.restaurant.service;

import com.restaurant.dao.UserDAO;
import com.restaurant.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.restaurant.util.HibernateUtil;

import java.util.List;

/**
 * 👥 Service de gestion des utilisateurs
 */
public class UserService {
    private UserDAO userDAO = new UserDAO();
    private AuthenticationService authService = new AuthenticationService();

    /**
     * Mettre à jour le profil d'un utilisateur
     */
    public User mettreAJourProfil(Long userId, String nouveauNom, String nouvelEmail) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            User user = userDAO.findById(userId)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

            // Validation email
            if (!user.getEmail().equals(nouvelEmail) && authService.emailExiste(nouvelEmail)) {
                throw new RuntimeException("Cet email est déjà utilisé");
            }

            user.setNom(nouveauNom);
            user.setEmail(nouvelEmail);

            session.update(user);
            transaction.commit();
            return user;

        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Erreur mise à jour profil: " + e.getMessage(), e);
        }
    }

    /**
     * Changer le mot de passe
     */
    public void changerMotDePasse(Long userId, String ancienMotDePasse, String nouveauMotDePasse) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            User user = userDAO.findById(userId)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

            // Vérifier ancien mot de passe
            if (!user.getMotDePasse().equals(ancienMotDePasse)) {
                throw new RuntimeException("Ancien mot de passe incorrect");
            }

            user.setMotDePasse(nouveauMotDePasse);
            session.update(user);
            transaction.commit();

        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Erreur changement mot de passe: " + e.getMessage(), e);
        }
    }

    /**
     * Mettre à jour le rôle d'un utilisateur (seul l'admin peut le faire)
     */
    public User changerRoleUtilisateur(Long adminId, Long userId, User.RoleUser nouveauRole) {
        // Vérifier que l'initiateur est un admin
        if (!authService.estAdmin(adminId)) {
            throw new RuntimeException("Seul l'administrateur peut modifier les rôles");
        }

        // Empêcher de se retirer ses propres droits d'admin
        if (adminId.equals(userId) && nouveauRole == User.RoleUser.SERVEUR) {
            throw new RuntimeException("Vous ne pouvez pas retirer vos propres droits d'administrateur");
        }

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            User user = userDAO.findById(userId)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

            user.setRole(nouveauRole);
            session.update(user);
            transaction.commit();
            return user;

        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw new RuntimeException("Erreur changement rôle: " + e.getMessage(), e);
        }
    }

    /**
     * Créer un nouvel utilisateur (admin seulement)
     */
    public User creerUtilisateur(Long adminId, String nom, String email, String password, User.RoleUser role) {
        if (!authService.estAdmin(adminId)) {
            throw new RuntimeException("Seul l'administrateur peut créer des utilisateurs");
        }

        return authService.creerUser(nom, email, password, role);
    }
    /**
     * Récupère tous les utilisateurs - Permission: ADMIN seulement
     */
    public List<User> getTousUtilisateurs(Long adminId) {
        if (!authService.aPermission(adminId, AuthenticationService.Permission.USER_VOIR_TOUS)) {
            throw new RuntimeException("❌ Permission refusée : Voir tous les utilisateurs (Admin seulement)");
        }
        return userDAO.findAll();
    }

    /**
     * Récupère un utilisateur par son ID - Permission: ADMIN ou l'utilisateur lui-même
     */
    public User getUtilisateurParId(Long userId, Long targetUserId) {
        // L'utilisateur peut voir son propre profil, l'admin peut voir tous
        if (!userId.equals(targetUserId) && !authService.estAdmin(userId)) {
            throw new RuntimeException("❌ Permission refusée : Consultation utilisateur");
        }
        return userDAO.findById(targetUserId)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
    }

    /**
     * Supprime un utilisateur - Permission: ADMIN seulement
     */
    public void supprimerUtilisateur(Long adminId, Long userId) {
        if (!authService.aPermission(adminId, AuthenticationService.Permission.USER_MODIFIER)) {
            throw new RuntimeException("❌ Permission refusée : Suppression utilisateur (Admin seulement)");
        }

        // Empêcher l'auto-suppression
        if (adminId.equals(userId)) {
            throw new RuntimeException("❌ Vous ne pouvez pas supprimer votre propre compte");
        }

        User user = userDAO.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

        userDAO.delete(userId);
    }
}