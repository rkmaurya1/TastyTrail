package com.tastytrail.dao;

import com.tastytrail.model.MenuItem;

import java.sql.*;
import java.util.*;

public class MenuDAO {

    public List<MenuItem> getMenuByRestaurant(int restaurantId) {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT mi.*, mc.name AS category_name FROM menu_items mi " +
                     "LEFT JOIN menu_categories mc ON mi.category_id = mc.id " +
                     "WHERE mi.restaurant_id = ? AND mi.is_available = TRUE " +
                     "ORDER BY mc.display_order, mi.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, List<MenuItem>> getMenuGroupedByCategory(int restaurantId) {
        List<MenuItem> items = getMenuByRestaurant(restaurantId);
        Map<String, List<MenuItem>> grouped = new LinkedHashMap<>();
        for (MenuItem item : items) {
            String category = item.getCategoryName() != null ? item.getCategoryName() : "Others";
            grouped.computeIfAbsent(category, k -> new ArrayList<>()).add(item);
        }
        return grouped;
    }

    public MenuItem getMenuItemById(int id) {
        String sql = "SELECT mi.*, mc.name AS category_name FROM menu_items mi " +
                     "LEFT JOIN menu_categories mc ON mi.category_id = mc.id " +
                     "WHERE mi.id = ?";
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

    private MenuItem mapResultSet(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();
        item.setId(rs.getInt("id"));
        item.setRestaurantId(rs.getInt("restaurant_id"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setCategoryName(rs.getString("category_name"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getDouble("price"));
        item.setImage(rs.getString("image"));
        item.setVeg(rs.getBoolean("is_veg"));
        item.setAvailable(rs.getBoolean("is_available"));
        return item;
    }
}
