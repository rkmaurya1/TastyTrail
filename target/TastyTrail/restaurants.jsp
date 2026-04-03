<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Restaurant, java.util.List" %>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String selectedCuisine = (String) request.getAttribute("selectedCuisine");
    Boolean vegFilter = (Boolean) request.getAttribute("vegFilter");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Restaurants — TastyTrail</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script>var contextPath = '${pageContext.request.contextPath}';</script>
</head>
<body>

<div class="page-loader"><div class="spinner-brand"></div></div>
<div id="toastContainer" class="toast-container"></div>

<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<!-- Page Header -->
<div class="page-hero">
  <div class="page-hero-overlay"></div>
  <div class="container" style="position:relative;z-index:1;">
    <h1 class="page-hero-title" data-aos="fade-up">
      <% if (searchQuery != null) { %>
        Results for "<%= searchQuery %>"
      <% } else if (selectedCuisine != null) { %>
        <i class="bi bi-collection me-2"></i><%= selectedCuisine %> Restaurants
      <% } else if (vegFilter != null && vegFilter) { %>
        🌿 Pure Veg Restaurants
      <% } else { %>
        <i class="bi bi-shop me-2"></i>All Restaurants
      <% } %>
    </h1>
    <form action="${pageContext.request.contextPath}/restaurants" method="get" data-aos="fade-up" data-aos-delay="100">
      <div class="page-search-bar">
        <i class="bi bi-search" style="color:#aaa;padding-left:14px;font-size:1rem;"></i>
        <input type="text" name="q"
               placeholder="Search restaurants, cuisines..."
               value="<%= searchQuery != null ? searchQuery : "" %>">
        <button type="submit">Search</button>
      </div>
    </form>
  </div>
</div>

<!-- Filters -->
<div class="filter-bar" data-aos="fade-down">
  <div class="container">
    <div class="d-flex align-items-center gap-2 flex-wrap">
      <span class="filter-label">Filter by:</span>
      <a href="${pageContext.request.contextPath}/restaurants"
         class="filter-pill <%= (searchQuery == null && selectedCuisine == null && vegFilter == null) ? "active" : "" %>">
        All
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?filter=veg"
         class="filter-pill <%= vegFilter != null ? "active-veg" : "" %>">
        🌿 Pure Veg
      </a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Pizza" class="filter-pill">🍕 Pizza</a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Burgers" class="filter-pill">🍔 Burgers</a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Biryani" class="filter-pill">🍲 Biryani</a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Chinese" class="filter-pill">🍜 Chinese</a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Indian" class="filter-pill">🍛 Indian</a>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=Desserts" class="filter-pill">🍰 Desserts</a>
    </div>
  </div>
</div>

<!-- Results -->
<div class="container my-4">
  <p class="results-count" data-aos="fade-up">
    <strong><%= totalCount != null ? totalCount : 0 %></strong> restaurants found
  </p>

  <% if (restaurants != null && !restaurants.isEmpty()) { %>
  <div class="row g-3">
    <% int idx = 0; for (Restaurant r : restaurants) { %>
    <div class="col-lg-3 col-md-4 col-sm-6" data-aos="fade-up" data-aos-delay="<%= (idx % 4) * 60 %>">
      <a href="${pageContext.request.contextPath}/menu?id=<%= r.getId() %>"
         style="display:block;height:100%;text-decoration:none;">
        <div class="restaurant-card">
          <div class="restaurant-img-wrap">
            <img src="<%= getRestaurantImage(r.getCuisine()) %>"
                 alt="<%= r.getName() %>"
                 onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=220&fit=crop&q=80'">
            <div class="img-gradient-overlay"></div>
            <% if (!r.isOpen()) { %>
            <div class="closed-overlay"><span>CLOSED</span></div>
            <% } %>
            <% if (r.isVeg()) { %>
            <div class="veg-only-badge">🌿 VEG ONLY</div>
            <% } %>
            <% if (r.getDeliveryFee() == 0) { %>
            <div class="free-delivery-badge">FREE Delivery</div>
            <% } %>
            <div class="restaurant-rating-overlay">
              <i class="bi bi-star-fill"></i> <%= r.getRating() %>
            </div>
          </div>
          <div class="restaurant-info">
            <div class="restaurant-name"><%= r.getName() %></div>
            <div class="restaurant-cuisine"><%= r.getCuisine() %></div>
            <div style="font-size:0.78rem;color:#686b78;margin-bottom:6px;">
              <i class="bi bi-geo-alt me-1" style="color:#CB202D;"></i><%= r.getCity() %>
            </div>
            <div class="restaurant-meta">
              <span class="delivery-time">
                <i class="bi bi-clock me-1"></i><%= r.getDeliveryTime() %> min
              </span>
              <span class="meta-dot">•</span>
              <span class="delivery-fee"><%= r.getDeliveryFeeDisplay() %></span>
            </div>
          </div>
        </div>
      </a>
    </div>
    <% idx++; } %>
  </div>

  <% } else { %>
  <div class="empty-state" data-aos="fade-up">
    <i class="bi bi-shop-window"></i>
    <h4>No restaurants found</h4>
    <p>
      <% if (searchQuery != null) { %>
        No results for "<%= searchQuery %>". Try a different search.
      <% } else { %>
        No restaurants available with the selected filter.
      <% } %>
    </p>
    <a href="${pageContext.request.contextPath}/restaurants" class="btn-outline-primary-custom mt-2">
      View All Restaurants
    </a>
  </div>
  <% } %>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>AOS.init({ duration: 600, once: true, offset: 50 });</script>
</body>
</html>
<%!
  private String getRestaurantImage(String cuisine) {
    if (cuisine == null) return "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=220&fit=crop&q=80";
    String c = cuisine.toLowerCase();
    if (c.contains("pizza") || c.contains("italian"))
        return "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=220&fit=crop&q=80";
    if (c.contains("burger") || c.contains("american"))
        return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=220&fit=crop&q=80";
    if (c.contains("biryani") || c.contains("mughlai"))
        return "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400&h=220&fit=crop&q=80";
    if (c.contains("chinese") || c.contains("asian"))
        return "https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400&h=220&fit=crop&q=80";
    if (c.contains("south indian"))
        return "https://images.unsplash.com/photo-1630409346517-bee4aaf50b8d?w=400&h=220&fit=crop&q=80";
    if (c.contains("indian") || c.contains("north"))
        return "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&h=220&fit=crop&q=80";
    if (c.contains("dessert") || c.contains("bakery"))
        return "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=220&fit=crop&q=80";
    if (c.contains("healthy") || c.contains("salad"))
        return "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=220&fit=crop&q=80";
    if (c.contains("sushi") || c.contains("japanese"))
        return "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&h=220&fit=crop&q=80";
    if (c.contains("mexican") || c.contains("taco"))
        return "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=220&fit=crop&q=80";
    return "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=220&fit=crop&q=80";
  }
%>
