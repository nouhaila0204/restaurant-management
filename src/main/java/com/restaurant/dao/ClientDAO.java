package com.restaurant.dao;

import com.restaurant.model.Client;
import com.restaurant.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

/**
 * 👤 DAO CLIENT - Gère les clients du restaurant
 */
public class ClientDAO extends GenericDAO<Client> {

    public ClientDAO() {
        super(Client.class);
    }

    /**
     * 📞 TROUVER PAR TÉLÉPHONE - Recherche rapide d'un client
     * Utilisé pour : Prise de commande rapide, client fidèle
     */
    public Optional<Client> findByTelephone(String telephone) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Client c WHERE c.telephone = :telephone";
            Query<Client> query = session.createQuery(hql, Client.class);
            query.setParameter("telephone", telephone);
            return query.uniqueResultOptional();
        } finally {
            session.close();
        }
    }

    /**
     * 🔍 RECHERCHE CLIENT - Recherche par nom ou téléphone
     * Utilisé pour : Trouver rapidement un client existant
     */
    public List<Client> searchClients(String searchTerm) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM Client c WHERE LOWER(c.nom) LIKE LOWER(:searchTerm) OR c.telephone LIKE :searchTerm";
            Query<Client> query = session.createQuery(hql, Client.class);
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } finally {
            session.close();
        }
    }

    /**
     * 👥 CLIENTS FIDÈLES - Clients avec le plus de commandes
     * Utilisé pour : Programme de fidélité
     */
    public List<Object[]> getClientsFideles(int limit) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT c.nom, COUNT(cmd) as nbCommandes, SUM(cmd.montantTotal) as totalDepense " +
                    "FROM Client c LEFT JOIN c.commandes cmd " +
                    "GROUP BY c.id, c.nom " +
                    "ORDER BY nbCommandes DESC, totalDepense DESC";
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            query.setMaxResults(limit);
            return query.list();
        } finally {
            session.close();
        }
    }

    public Long countAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT COUNT(c) FROM Client c";
            Query<Long> query = session.createQuery(hql, Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            session.close();
        }
    }
}