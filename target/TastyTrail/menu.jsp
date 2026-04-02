<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Restaurant, com.tastytrail.model.MenuItem,
                 com.tastytrail.model.CartItem, java.util.*, java.util.Map.Entry" %>
<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    Map<String, List<MenuItem>> menuByCategory =
        (Map<String, List<MenuItem>>) request.getAttribute("menuByCategory");

    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    Map<Integer, Integer> cartQtyMap = new HashMap<>();
    if (currentCart != null) {
        for (CartItem ci : currentCart) cartQtyMap.put(ci.getMenuItemId(), ci.getQuantity());
    }

    String[] bgClasses = {"bg-food-1","bg-food-2","bg-food-3","bg-food-4","bg-food-5"};
    int catIdx = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= restaurant.getName() %> — TastyTrail</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script>var contextPath = '${pageContext.request.contextPath}';</script>
</head>
<body>

<div class="page-loader"><div class="spinner-brand"></div></div>
<div id="toastContainer" class="toast-container"></div>

<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<!-- Restaurant Header -->
<div class="restaurant-header">
  <div class="container">
    <nav aria-label="breadcrumb" style="margin-bottom:16px;">
      <ol class="breadcrumb" style="font-size:0.85rem;background:none;padding:0;margin:0;">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color:#CB202D;">Home</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/restaurants" style="color:#CB202D;">Restaurants</a></li>
        <li class="breadcrumb-item active" style="color:#686b78;"><%= restaurant.getName() %></li>
      </ol>
    </nav>

    <div class="d-flex align-items-start gap-3 flex-wrap">
      <!-- Restaurant icon/image -->
      <div style="width:90px;height:90px;border-radius:12px;overflow:hidden;
                  background:linear-gradient(135deg,#CB202D,#FC8019);
                  display:flex;align-items:center;justify-content:center;
                  font-size:2.5rem;flex-shrink:0;box-shadow:0 4px 15px rgba(0,0,0,0.15);">
        <%= getMenuEmoji(restaurant.getCuisine()) %>
      </div>

      <div class="flex-grow-1">
        <div class="d-flex align-items-center gap-2 flex-wrap">
          <h1 class="h3 fw-bold mb-0" style="color:#1C1C1C;"><%= restaurant.getName() %></h1>
          <% if (restaurant.isVeg()) { %>
          <span class="badge-veg">VEG ONLY</span>
          <% } %>
        </div>
        <p style="color:#686b78;margin:4px 0 8px;font-size:0.9rem;"><%= restaurant.getCuisine() %></p>
        <p style="color:#686b78;margin:0;font-size:0.85rem;">
          <i class="bi bi-geo-alt me-1" style="color:#CB202D;"></i><%= restaurant.getAddress() %>, <%= restaurant.getCity() %>
        </p>

        <div class="restaurant-header-meta">
          <span class="rating-pill">
            <i class="bi bi-star-fill me-1" style="font-size:0.8rem;"></i><%= restaurant.getRating() %>
          </span>
          <span class="meta-pill">
            <i class="bi bi-clock me-1" style="color:#CB202D;"></i><%= restaurant.getDeliveryTime() %> mins
          </span>
          <span class="meta-pill">
            <i class="bi bi-bag me-1" style="color:#CB202D;"></i>Min ₹<%= restaurant.getMinOrder() %>
          </span>
          <span class="meta-pill" style="<%= restaurant.getDeliveryFee()==0 ? "color:#3d9970;background:#d4edda;" : "" %>">
            <i class="bi bi-bicycle me-1"></i><%= restaurant.getDeliveryFeeDisplay() %> delivery
          </span>
          <% if (!restaurant.isOpen()) { %>
          <span class="meta-pill" style="background:#f8d7da;color:#721c24;">CLOSED</span>
          <% } else { %>
          <span class="meta-pill" style="background:#d4edda;color:#155724;">
            <i class="bi bi-circle-fill me-1" style="font-size:0.5rem;"></i>Open Now
          </span>
          <% } %>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Menu Content -->
<div class="container my-4">
  <div class="row g-4">

    <!-- LEFT: Category Sidebar -->
    <div class="col-lg-3 d-none d-lg-block">
      <div class="menu-sidebar">
        <h6 style="font-weight:700;color:#1C1C1C;margin-bottom:12px;text-transform:uppercase;
                   font-size:0.75rem;letter-spacing:1px;">Menu</h6>
        <div class="list-group list-group-flush">
          <% boolean first = true; for (String cat : menuByCategory.keySet()) {
             String catId = cat.replaceAll("[^a-zA-Z0-9]","_"); %>
          <button type="button"
                  class="list-group-item list-group-item-action <%= first ? "active" : "" %>"
                  data-target="<%= catId %>">
            <%= cat %>
            <span style="float:right;font-size:0.75rem;color:#686b78;">
              <%= menuByCategory.get(cat).size() %>
            </span>
          </button>
          <% first = false; } %>
        </div>
      </div>
    </div>

    <!-- RIGHT: Menu Items -->
    <div class="col-lg-9">
      <% if (menuByCategory.isEmpty()) { %>
      <div class="text-center py-5">
        <div style="font-size:4rem;opacity:0.3;">🍽️</div>
        <h5 class="mt-3">Menu not available yet</h5>
        <p style="color:#686b78;">Check back soon!</p>
      </div>
      <% } %>

      <% for (Entry<String, List<MenuItem>> entry : menuByCategory.entrySet()) {
         String cat = entry.getKey();
         String catId = cat.replaceAll("[^a-zA-Z0-9]","_");
         List<MenuItem> items = entry.getValue();
      %>
      <div class="menu-category-section" id="section-<%= catId %>" style="margin-bottom:32px;">
        <h5 style="font-weight:700;color:#1C1C1C;margin-bottom:16px;padding-bottom:8px;
                   border-bottom:2px solid #e8e8e8;font-size:1.1rem;">
          <%= cat %>
          <span style="font-size:0.8rem;color:#686b78;font-weight:500;">(<%= items.size() %> items)</span>
        </h5>

        <% for (MenuItem item : items) {
           Integer qty = cartQtyMap.get(item.getId());
        %>
        <div class="menu-item-card">
          <!-- Veg/Non-veg indicator -->
          <div class="veg-dot <%= item.isVeg() ? "veg" : "non-veg" %>"></div>

          <!-- Item details -->
          <div class="menu-item-details">
            <div class="menu-item-name"><%= item.getName() %></div>
            <div class="menu-item-price"><%= item.getPriceFormatted() %></div>
            <% if (item.getDescription() != null && !item.getDescription().isEmpty()) { %>
            <div class="menu-item-desc mt-1"><%= item.getDescription() %></div>
            <% } %>
          </div>

          <!-- Food emoji/image + Add button -->
          <div class="menu-item-action" style="min-width:90px;text-align:center;">
            <div style="font-size:2rem;margin-bottom:8px;">
              <%= item.isVeg() ? "🥗" : "🍗" %>
            </div>
            <% if (qty != null && qty > 0) { %>
            <!-- Already in cart: show qty control -->
            <div class="qty-control" data-item-id="<%= item.getId() %>">
              <button class="qty-btn btn-qty-minus"
                      data-item-id="<%= item.getId() %>"
                      data-restaurant-id="<%= restaurant.getId() %>">−</button>
              <span class="qty-num"><%= qty %></span>
              <button class="qty-btn btn-qty-plus"
                      data-item-id="<%= item.getId() %>"
                      data-restaurant-id="<%= restaurant.getId() %>"
                      data-item-name="<%= item.getName() %>">+</button>
            </div>
            <% } else { %>
            <button class="btn-add btn-add-to-cart"
                    data-item-id="<%= item.getId() %>"
                    data-restaurant-id="<%= restaurant.getId() %>"
                    data-item-name="<%= item.getName() %>">
              ADD
            </button>
            <% } %>
          </div>
        </div>
        <% } %>
      </div>
      <% } %>
    </div>
  </div>
</div>

<!-- Floating cart button (mobile) -->
<div id="floatingCart" style="display:none;position:fixed;bottom:24px;right:24px;z-index:999;">
  <a href="${pageContext.request.contextPath}/cart"
     style="background:#CB202D;color:white;border-radius:50px;
            padding:14px 24px;display:flex;align-items:center;gap:10px;
            box-shadow:0 8px 25px rgba(203,32,45,0.4);font-weight:700;
            text-decoration:none;font-family:Poppins,sans-serif;">
    <i class="bi bi-bag-fill" style="font-size:1.1rem;"></i>
    <span>View Cart</span>
    <span id="floatCartCount" style="background:rgba(255,255,255,0.25);
           border-radius:20px;padding:2px 8px;font-size:0.85rem;"></span>
  </a>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
$(document).ready(function() {
  // Show/update floating cart button when items are added
  function updateFloatingCart(count) {
    if (count > 0) {
      $('#floatingCart').fadeIn();
      $('#floatCartCount').text(count + ' item' + (count > 1 ? 's' : ''));
    } else {
      $('#floatingCart').hide();
    }
  }

  // Check initial cart count
  var initCount = parseInt($('#navCartCount').text()) || 0;
  updateFloatingCart(initCount);

  // Override cart count update to also update floating button
  var origUpdate = window.showToast;
  $(document).on('ajaxSuccess', function(event, xhr, settings) {
    try {
      var res = JSON.parse(xhr.responseText);
      if (res.cartCount !== undefined) {
        updateFloatingCart(res.cartCount);
      }
    } catch(e) {}
  });
});
</script>
</body>
</html>
<%!
  private String getMenuEmoji(String cuisine) {
    if (cuisine == null) return "🍽️";
    cuisine = cuisine.toLowerCase();
    if (cuisine.contains("pizza") || cuisine.contains("italian")) return "🍕";
    if (cuisine.contains("burger")) return "🍔";
    if (cuisine.contains("biryani")) return "🍲";
    if (cuisine.contains("chinese")) return "🍜";
    if (cuisine.contains("south indian")) return "🥘";
    if (cuisine.contains("indian")) return "🍛";
    if (cuisine.contains("dessert") || cuisine.contains("bakery")) return "🎂";
    if (cuisine.contains("healthy") || cuisine.contains("salad")) return "🥗";
    return "🍽️";
  }
%>
