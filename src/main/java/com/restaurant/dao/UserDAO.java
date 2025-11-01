package com.restaurant.dao;

import com.restaurant.model.User;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;
import java.util.Optional;

public class UserDAO extends GenericDAO<User> {

    public UserDAO() {
        super(User.class);
    }

    public Optional<User> findByEmail(String email) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM User u WHERE u.email = :email";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("email", email);
            return query.uniqueResultOptional();
        } finally {
            session.close();
        }
    }

    public Optional<User> findByEmailAndPassword(String email, String password) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM User u WHERE u.email = :email AND u.motDePasse = :password";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("email", email);
            query.setParameter("password", password);
            return query.uniqueResultOptional();
        } finally {
            session.close();
        }
    }

    /**
     * ⭐⭐ CORRECTION CRITIQUE - NE PAS UTILISER findByField() ⭐⭐
     */
    public List<User> findByRole(String role) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            // Conversion du String en Enum
            User.RoleUser roleEnum = User.RoleUser.valueOf(role.toUpperCase());

            String hql = "FROM User u WHERE u.role = :role";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("role", roleEnum); // ⭐ Passer l'Enum, pas le String
            return query.list();
        } catch (IllegalArgumentException e) {
            System.err.println("❌ Rôle invalide: " + role + ". Rôles valides: ADMIN, SERVEUR");
            return List.of(); // Retourne liste vide si rôle invalide
        } finally {
            session.close();
        }
    }
}