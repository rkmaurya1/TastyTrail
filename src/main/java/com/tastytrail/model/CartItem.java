package com.tastytrail.model;

public class CartItem {
    private int menuItemId;
    private String name;
    private double price;
    private int quantity;
    private String image;
    private boolean isVeg;
    private int restaurantId;

    public CartItem() {}

    public CartItem(int menuItemId, String name, double price, int quantity, String image, boolean isVeg, int restaurantId) {
        this.menuItemId = menuItemId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
        this.isVeg = isVeg;
        this.restaurantId = restaurantId;
    }

    public int getMenuItemId() { return menuItemId; }
    public void setMenuItemId(int menuItemId) { this.menuItemId = menuItemId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public boolean isVeg() { return isVeg; }
    public void setVeg(boolean veg) { isVeg = veg; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public double getSubtotal() {
        return price * quantity;
    }

    public String getSubtotalFormatted() {
        return String.format("₹%.0f", getSubtotal());
    }

    public String getPriceFormatted() {
        return String.format("₹%.0f", price);
    }
}
