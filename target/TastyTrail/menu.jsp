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
        <li class="breadcrumb-item active" style="color:#686b78;">Menu</li>
      </ol>
    </nav>

    <div class="d-flex align-items-start gap-3 flex-wrap">
      <!-- Restaurant logo/image -->
      <div style="width:90px;height:90px;border-radius:12px;overflow:hidden;flex-shrink:0;box-shadow:0 4px 15px rgba(0,0,0,0.15);">
        <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=90&h=90&fit=crop&q=80"
             alt="TastyTrail" style="width:100%;height:100%;object-fit:cover;">
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

          <!-- Food image + Add button -->
          <div class="menu-item-action" style="min-width:90px;text-align:center;">
            <div style="margin-bottom:8px;">
              <img src="<%= getItemImage(item.getName(), item.isVeg()) %>"
                   alt="<%= item.getName() %>"
                   style="width:80px;height:70px;object-fit:cover;border-radius:10px;display:block;"
                   onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=80&h=70&fit=crop&q=80'">
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
  private String getItemImage(String name, boolean isVeg) {
    if (name == null) return "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=160&h=120&fit=crop&q=80";
    String n = name.toLowerCase();
    if (n.contains("pizza") || n.contains("margherita") || n.contains("pepperoni") || n.contains("bbq chicken pizza") || n.contains("veggie supreme"))
        return "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=160&h=120&fit=crop&q=80";
    if (n.contains("burger") || n.contains("patty") || n.contains("smash") || n.contains("sriracha"))
        return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=160&h=120&fit=crop&q=80";
    if (n.contains("biryani"))
        return "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=160&h=120&fit=crop&q=80";
    if (n.contains("veg biryani") || n.contains("rice"))
        return "https://images.unsplash.com/photo-1596560548464-f010b9e51f0b?w=160&h=120&fit=crop&q=80";
    if (n.contains("paneer") || n.contains("palak"))
        return "https://images.unsplash.com/photo-1601050690597-df0568f70950?w=160&h=120&fit=crop&q=80";
    if (n.contains("dal") || n.contains("makhani"))
        return "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=160&h=120&fit=crop&q=80";
    if (n.contains("butter chicken") || n.contains("chicken curry"))
        return "https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=160&h=120&fit=crop&q=80";
    if (n.contains("seekh") || n.contains("kebab") || n.contains("tikka"))
        return "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=160&h=120&fit=crop&q=80";
    if (n.contains("mutton") || n.contains("rogan"))
        return "https://images.unsplash.com/photo-1545247181-516773cae754?w=160&h=120&fit=crop&q=80";
    if (n.contains("naan") || n.contains("bread") || n.contains("roti"))
        return "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=160&h=120&fit=crop&q=80";
    if (n.contains("pasta") || n.contains("penne") || n.contains("alfredo") || n.contains("arrabbiata"))
        return "https://images.unsplash.com/photo-1563245372-f21724e3856d?w=160&h=120&fit=crop&q=80";
    if (n.contains("garlic bread"))
        return "https://images.unsplash.com/photo-1619985632461-f33748ef8e6e?w=160&h=120&fit=crop&q=80";
    if (n.contains("gulab") || n.contains("jamun"))
        return "https://images.unsplash.com/photo-1627308595229-7830a5c18037?w=160&h=120&fit=crop&q=80";
    if (n.contains("cake") || n.contains("dessert") || n.contains("sweet"))
        return "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=160&h=120&fit=crop&q=80";
    if (n.contains("fries") || n.contains("loaded"))
        return "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=160&h=120&fit=crop&q=80";
    if (n.contains("onion ring"))
        return "https://images.unsplash.com/photo-1639024471283-03518883512d?w=160&h=120&fit=crop&q=80";
    if (n.contains("milkshake") || n.contains("thick"))
        return "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=160&h=120&fit=crop&q=80";
    if (n.contains("cold coffee") || n.contains("coffee"))
        return "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=160&h=120&fit=crop&q=80";
    return isVeg
        ? "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=160&h=120&fit=crop&q=80"
        : "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=160&h=120&fit=crop&q=80";
  }
%>
