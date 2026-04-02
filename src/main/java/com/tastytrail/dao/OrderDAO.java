package com.tastytrail.dao;

import com.tastytrail.model.CartItem;
import com.tastytrail.model.Order;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int placeOrder(int userId, int restaurantId, List<CartItem> cartItems,
                          String deliveryAddress, String paymentMethod) {
        String orderSql = "INSERT INTO orders (user_id, restaurant_id, total_amount, delivery_address, payment_method) " +
                          "VALUES (?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, menu_item_id, quantity, price) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Calculate total
            double total = cartItems.stream().mapToDouble(CartItem::getSubtotal).sum();

            PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setInt(1, userId);
            orderPs.setInt(2, restaurantId);
            orderPs.setDouble(3, total);
            orderPs.setString(4, deliveryAddress);
            orderPs.setString(5, paymentMethod);
            orderPs.executeUpdate();

            ResultSet keys = orderPs.getGeneratedKeys();
            int orderId = -1;
            if (keys.next()) {
                orderId = keys.getInt(1);
            }

            PreparedStatement itemPs = conn.prepareStatement(itemSql);
            for (CartItem item : cartItems) {
                itemPs.setInt(1, orderId);
                itemPs.setInt(2, item.getMenuItemId());
                itemPs.setInt(3, item.getQuantity());
                itemPs.setDouble(4, item.getPrice());
                itemPs.addBatch();
            }
            itemPs.executeBatch();

            conn.commit();
            return orderId;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return -1;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, r.name AS restaurant_name, r.image AS restaurant_image " +
                     "FROM orders o JOIN restaurants r ON o.restaurant_id = r.id " +
                     "WHERE o.user_id = ? ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSet(rs);
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public java.util.List<Order> getAllOrders() {
        java.util.List<Order> orders = new java.util.ArrayList<>();
        String sql = "SELECT o.*, r.name AS restaurant_name, r.image AS restaurant_image " +
                     "FROM orders o JOIN restaurants r ON o.restaurant_id = r.id " +
                     "ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             java.sql.Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = mapResultSet(rs);
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

    public boolean updateOrderStatus(int orderId, String status, Integer driverId) {
        String sql = driverId != null
            ? "UPDATE orders SET status=CAST(? AS order_status), driver_id=? WHERE id=?"
            : "UPDATE orders SET status=CAST(? AS order_status) WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (driverId != null) { ps.setInt(2, driverId); ps.setInt(3, orderId); }
            else { ps.setInt(2, orderId); }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public java.util.List<Order> getOrdersByDriver(int driverId) {
        java.util.List<Order> orders = new java.util.ArrayList<>();
        String sql = "SELECT o.*, r.name AS restaurant_name, r.image AS restaurant_image " +
                     "FROM orders o JOIN restaurants r ON o.restaurant_id = r.id " +
                     "WHERE o.driver_id = ? OR (o.status = 'CONFIRMED' AND o.driver_id IS NULL) " +
                     "ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { orders.add(mapResultSet(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return orders;
    }

    public long getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE status='DELIVERED'";
        try (Connection conn = DBConnection.getConnection();
             java.sql.Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             java.sql.Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, r.name AS restaurant_name, r.image AS restaurant_image " +
                     "FROM orders o JOIN restaurants r ON o.restaurant_id = r.id WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapResultSet(rs);
                order.setItems(getOrderItems(orderId));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<Order.OrderItem> getOrderItems(int orderId) {
        List<Order.OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, mi.name AS item_name FROM order_items oi " +
                     "JOIN menu_items mi ON oi.menu_item_id = mi.id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order.OrderItem item = new Order.OrderItem();
                item.setId(rs.getInt("id"));
                item.setMenuItemId(rs.getInt("menu_item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    private Order mapResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setRestaurantId(rs.getInt("restaurant_id"));
        order.setRestaurantName(rs.getString("restaurant_name"));
        order.setRestaurantImage(rs.getString("restaurant_image"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
