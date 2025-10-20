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
}