package com.tastytrail.dao;

import com.tastytrail.model.Restaurant;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {

    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM restaurants WHERE is_open = TRUE ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Restaurant> searchRestaurants(String query) {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM restaurants WHERE is_open = TRUE AND " +
                     "(name LIKE ? OR cuisine LIKE ? OR city LIKE ?) ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + query + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Restaurant> getRestaurantsByCuisine(String cuisine) {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM restaurants WHERE is_open = TRUE AND cuisine LIKE ? ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + cuisine + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Restaurant> getVegRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM restaurants WHERE is_open = TRUE AND is_veg = TRUE ORDER BY rating DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addRestaurant(Restaurant r) {
        String sql = "INSERT INTO restaurants (name, description, cuisine, address, city, phone, rating, delivery_time, min_order, delivery_fee, is_veg) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (java.sql.Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getName()); ps.setString(2, r.getDescription());
            ps.setString(3, r.getCuisine()); ps.setString(4, r.getAddress());
            ps.setString(5, r.getCity()); ps.setString(6, r.getPhone());
            ps.setDouble(7, r.getRating()); ps.setInt(8, r.getDeliveryTime());
            ps.setInt(9, r.getMinOrder()); ps.setInt(10, r.getDeliveryFee());
            ps.setBoolean(11, r.isVeg());
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateRestaurant(Restaurant r) {
        String sql = "UPDATE restaurants SET name=?,description=?,cuisine=?,address=?,city=?,phone=?,delivery_time=?,min_order=?,delivery_fee=?,is_veg=?,is_open=? WHERE id=?";
        try (java.sql.Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getName()); ps.setString(2, r.getDescription());
            ps.setString(3, r.getCuisine()); ps.setString(4, r.getAddress());
            ps.setString(5, r.getCity()); ps.setString(6, r.getPhone());
            ps.setInt(7, r.getDeliveryTime()); ps.setInt(8, r.getMinOrder());
            ps.setInt(9, r.getDeliveryFee()); ps.setBoolean(10, r.isVeg());
            ps.setBoolean(11, r.isOpen()); ps.setInt(12, r.getId());
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteRestaurant(int id) {
        String sql = "DELETE FROM restaurants WHERE id=?";
        try (java.sql.Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (java.sql.SQLException e) { e.printStackTrace(); return false; }
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM restaurants";
        try (java.sql.Connection conn = DBConnection.getConnection();
             java.sql.Statement stmt = conn.createStatement();
             java.sql.ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (java.sql.SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Restaurant getRestaurantById(int id) {
        String sql = "SELECT * FROM restaurants WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Restaurant mapResultSet(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setId(rs.getInt("id"));
        r.setName(rs.getString("name"));
        r.setDescription(rs.getString("description"));
        r.setCuisine(rs.getString("cuisine"));
        r.setAddress(rs.getString("address"));
        r.setCity(rs.getString("city"));
        r.setPhone(rs.getString("phone"));
        r.setImage(rs.getString("image"));
        r.setRating(rs.getDouble("rating"));
        r.setDeliveryTime(rs.getInt("delivery_time"));
        r.setMinOrder(rs.getInt("min_order"));
        r.setDeliveryFee(rs.getInt("delivery_fee"));
        r.setVeg(rs.getBoolean("is_veg"));
        r.setOpen(rs.getBoolean("is_open"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
