<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Restaurant, java.util.List" %>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String selectedCuisine = (String) request.getAttribute("selectedCuisine");
    Boolean vegFilter = (Boolean) request.getAttribute("vegFilter");

    String[] bgClasses = {"bg-food-1","bg-food-2","bg-food-3","bg-food-4","bg-food-5","bg-food-6","bg-food-7","bg-food-8"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Restaurants — TastyTrail</title>
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

<!-- Page Header -->
<div style="background:linear-gradient(135deg,#1a1a2e,#0f3460);padding:40px 0;">
  <div class="container">
    <h1 style="color:white;font-weight:700;font-size:1.8rem;margin-bottom:16px;">
      <% if (searchQuery != null) { %>
        Results for "<%= searchQuery %>"
      <% } else if (selectedCuisine != null) { %>
        <%= selectedCuisine %> Restaurants
      <% } else if (vegFilter != null && vegFilter) { %>
        Pure Veg Restaurants
      <% } else { %>
        All Restaurants
      <% } %>
    </h1>
    <!-- Search bar -->
    <form action="${pageContext.request.contextPath}/restaurants" method="get">
      <div style="background:white;border-radius:10px;padding:6px;display:flex;
                  align-items:center;gap:8px;max-width:500px;">
        <i class="bi bi-search" style="color:#aaa;padding-left:8px;"></i>
        <input type="text" name="q" class="border-0 flex-grow-1"
               style="outline:none;font-family:Poppins,sans-serif;font-size:0.9rem;"
               placeholder="Search restaurants, cuisines..."
               value="<%= searchQuery != null ? searchQuery : "" %>">
        <button type="submit"
                style="background:#CB202D;color:white;border:none;border-radius:7px;
                       padding:8px 18px;font-weight:600;font-family:Poppins,sans-serif;cursor:pointer;">
          Search
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Filters -->
<div style="background:white;border-bottom:1px solid #e8e8e8;padding:12px 0;sticky top:64px;">
  <div class="container">
    <div class="d-flex align-items-center gap-2 flex-wrap">
      <span style="font-size:0.85rem;font-weight:600;color:#686b78;">Filter by:</span>
      <a href="${pageContext.request.contextPath}/restaurants"
         class="filter-pill <%= (searchQuery == null && selectedCuisine == null && vegFilter == null) ? "active" : "" %>"
         style="padding:6px 14px;border-radius:20px;font-size:0.82rem;font-weight:600;
                border:1.5px solid <%= (searchQuery == null && selectedCuisine == null && vegFilter == null) ? "#CB202D" : "#e8e8e8" %>;
                color:<%= (searchQuery == null && selectedCuisine == null && vegFilter == null) ? "#CB202D" : "#3D4152" %>;
                background:<%= (searchQuery == null && selectedCuisine == null && vegFilter == null) ? "#f8d7da" : "white" %>;
                text-decoration:none;">
        All
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?filter=veg"
         style="padding:6px 14px;border-radius:20px;font-size:0.82rem;font-weight:600;
                border:1.5px solid <%= vegFilter != null ? "#3d9970" : "#e8e8e8" %>;
                color:<%= vegFilter != null ? "#3d9970" : "#3D4152" %>;
                background:<%= vegFilter != null ? "#d4edda" : "white" %>;
                text-decoration:none;">
        🥦 Pure Veg
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Pizza"
         style="padding:6px 14px;border-radius:20px;font-size:0.82rem;font-weight:600;
                border:1.5px solid #e8e8e8;color:#3D4152;background:white;text-decoration:none;">
        🍕 Pizza
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Burgers"
         style="padding:6px 14px;border-radius:20px;font-size:0.82rem;font-weight:600;
                border:1.5px solid #e8e8e8;color:#3D4152;background:white;text-decoration:none;">
        🍔 Burgers
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Biryani"
         style="padding:6px 14px;border-radius:20px;font-size:0.82rem;font-weight:600;
                border:1.5px solid #e8e8e8;color:#3D4152;background:white;text-decoration:none;">
        🍲 Biryani
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Chinese"
         style="padding:6px 14px;border-radius:20px;font-size:0.82rem;font-weight:600;
                border:1.5px solid #e8e8e8;color:#3D4152;background:white;text-decoration:none;">
        🍜 Chinese
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Desserts"
         style="padding:6px 14px;border-radius:20px;font-size:0.82rem;font-weight:600;
                border:1.5px solid #e8e8e8;color:#3D4152;background:white;text-decoration:none;">
        🍰 Desserts
      </a>
    </div>
  </div>
</div>

<!-- Results -->
<div class="container my-4">
  <p style="color:#686b78;font-size:0.9rem;margin-bottom:20px;">
    <strong style="color:#3D4152;"><%= totalCount != null ? totalCount : 0 %></strong> restaurants found
  </p>

  <% if (restaurants != null && !restaurants.isEmpty()) { %>
  <div class="row g-3">
    <% int idx = 0; for (Restaurant r : restaurants) { %>
    <div class="col-lg-3 col-md-4 col-sm-6">
      <a href="${pageContext.request.contextPath}/menu?id=<%= r.getId() %>"
         style="display:block;height:100%;text-decoration:none;">
        <div class="restaurant-card">
          <div class="restaurant-img-wrap">
            <div class="img-placeholder <%= bgClasses[idx % bgClasses.length] %>">
              <%= getEmoji(r.getCuisine()) %>
            </div>
            <% if (r.getDeliveryFee() == 0) { %>
            <div class="restaurant-badge">FREE Delivery</div>
            <% } %>
            <% if (r.isVeg()) { %>
            <div class="veg-only-badge">VEG ONLY</div>
            <% } %>
            <% if (!r.isOpen()) { %>
            <div style="position:absolute;inset:0;background:rgba(0,0,0,0.5);
                        display:flex;align-items:center;justify-content:center;">
              <span style="color:white;font-weight:700;font-size:1rem;">CLOSED</span>
            </div>
            <% } %>
          </div>
          <div class="restaurant-info">
            <div class="restaurant-name"><%= r.getName() %></div>
            <div class="restaurant-cuisine"><%= r.getCuisine() %></div>
            <div style="font-size:0.8rem;color:#686b78;margin-bottom:6px;">
              <i class="bi bi-geo-alt me-1" style="color:#CB202D;"></i><%= r.getCity() %>
            </div>
            <div class="restaurant-meta">
              <span class="rating">
                <i class="bi bi-star-fill" style="font-size:0.7rem;"></i>
                <%= r.getRating() %>
              </span>
              <span class="delivery-time">
                <i class="bi bi-clock me-1"></i><%= r.getDeliveryTime() %> min
              </span>
              <span class="delivery-fee"><%= r.getDeliveryFeeDisplay() %></span>
            </div>
          </div>
        </div>
      </a>
    </div>
    <% idx++; } %>
  </div>

  <% } else { %>
  <div class="text-center py-5 my-4">
    <div style="font-size:5rem;opacity:0.3;">🍽️</div>
    <h4 class="mt-3 fw-bold">No restaurants found</h4>
    <p style="color:#686b78;">
      <% if (searchQuery != null) { %>
      No results for "<%= searchQuery %>". Try a different search.
      <% } else { %>
      No restaurants available with the selected filter.
      <% } %>
    </p>
    <a href="${pageContext.request.contextPath}/restaurants"
       class="btn-outline-primary-custom mt-2">View All Restaurants</a>
  </div>
  <% } %>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
<%!
  private String getEmoji(String cuisine) {
    if (cuisine == null) return "🍽️";
    cuisine = cuisine.toLowerCase();
    if (cuisine.contains("pizza") || cuisine.contains("italian")) return "🍕";
    if (cuisine.contains("burger") || cuisine.contains("american")) return "🍔";
    if (cuisine.contains("biryani") || cuisine.contains("mughlai")) return "🍲";
    if (cuisine.contains("chinese") || cuisine.contains("asian")) return "🍜";
    if (cuisine.contains("south indian")) return "🥘";
    if (cuisine.contains("indian") || cuisine.contains("north")) return "🍛";
    if (cuisine.contains("dessert") || cuisine.contains("bakery")) return "🎂";
    if (cuisine.contains("healthy") || cuisine.contains("salad")) return "🥗";
    return "🍽️";
  }
%>
