package com.tastytrail.listener;

import com.tastytrail.dao.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        createDefaultUserIfNotExists("Admin", "admin@tastytrail.com", "admin123", "9999999999", "ADMIN");
        createDefaultUserIfNotExists("Rahul Driver", "driver@tastytrail.com", "driver123", "8888888888", "DRIVER");
    }

    private void createDefaultUserIfNotExists(String name, String email, String password, String phone, String role) {
        String checkSql = "SELECT id FROM users WHERE email = ?";
        String insertSql = "INSERT INTO users (name, email, password, phone, city, role) VALUES (?, ?, ?, ?, 'Delhi', ?)";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement check = conn.prepareStatement(checkSql);
            check.setString(1, email);
            ResultSet rs = check.executeQuery();
            if (!rs.next()) {
                String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
                PreparedStatement insert = conn.prepareStatement(insertSql);
                insert.setString(1, name);
                insert.setString(2, email);
                insert.setString(3, hashed);
                insert.setString(4, phone);
                insert.setString(5, role);
                insert.executeUpdate();
                System.out.println("[TastyTrail] Created default " + role + " account: " + email);
            } else {
                // Update role just in case
                PreparedStatement update = conn.prepareStatement("UPDATE users SET role=? WHERE email=?");
                update.setString(1, role);
                update.setString(2, email);
                update.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
