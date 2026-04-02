package com.tastytrail.model;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private int restaurantId;
    private String restaurantName;
    private String restaurantImage;
    private double totalAmount;
    private String deliveryAddress;
    private String status;
    private String paymentMethod;
    private Timestamp createdAt;
    private List<OrderItem> items;

    public Order() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    public String getRestaurantImage() { return restaurantImage; }
    public void setRestaurantImage(String restaurantImage) { this.restaurantImage = restaurantImage; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public String getTotalFormatted() {
        return String.format("₹%.0f", totalAmount);
    }

    public String getStatusBadgeClass() {
        switch (status) {
            case "PLACED": return "badge-warning";
            case "CONFIRMED": return "badge-info";
            case "PREPARING": return "badge-primary";
            case "OUT_FOR_DELIVERY": return "badge-info";
            case "DELIVERED": return "badge-success";
            case "CANCELLED": return "badge-danger";
            default: return "badge-secondary";
        }
    }

    public String getStatusDisplay() {
        switch (status) {
            case "PLACED": return "Order Placed";
            case "CONFIRMED": return "Confirmed";
            case "PREPARING": return "Being Prepared";
            case "OUT_FOR_DELIVERY": return "Out for Delivery";
            case "DELIVERED": return "Delivered";
            case "CANCELLED": return "Cancelled";
            default: return status;
        }
    }

    // Inner class for order items
    public static class OrderItem {
        private int id;
        private int menuItemId;
        private String itemName;
        private int quantity;
        private double price;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public int getMenuItemId() { return menuItemId; }
        public void setMenuItemId(int menuItemId) { this.menuItemId = menuItemId; }

        public String getItemName() { return itemName; }
        public void setItemName(String itemName) { this.itemName = itemName; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }

        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }

        public String getSubtotalFormatted() {
            return String.format("₹%.0f", price * quantity);
        }
    }
}
