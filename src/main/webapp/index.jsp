<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.dao.RestaurantDAO, com.tastytrail.model.Restaurant, java.util.List" %>
<%
    RestaurantDAO dao = new RestaurantDAO();
    List<Restaurant> featuredRestaurants = dao.getAllRestaurants();
    // Limit to 6 for home page
    if (featuredRestaurants.size() > 6) {
        featuredRestaurants = featuredRestaurants.subList(0, 6);
    }

    String[] bgClasses = {"bg-food-1","bg-food-2","bg-food-3","bg-food-4","bg-food-5","bg-food-6","bg-food-7","bg-food-8"};
    String[] cuisineEmojis = {"🍕","🍔","🍛","🍣","🌮","🍜","🥗","🍰","🍟","🥘"};
    String[] cuisineNames = {"Pizza","Burgers","Indian","Sushi","Mexican","Chinese","Healthy","Desserts","Fast Food","Biryani"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TastyTrail — Order Food Online</title>
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

<!-- ===================== HERO ===================== -->
<section class="hero">
  <div class="container">
    <div class="row align-items-center g-4">
      <div class="col-lg-7 hero-content">
        <h1>Craving something<br><span>delicious?</span></h1>
        <p>Discover top restaurants near you and order in minutes</p>

        <form id="heroSearchForm" autocomplete="off">
          <div class="hero-search">
            <i class="bi bi-geo-alt-fill" style="color:#CB202D;font-size:1.2rem;padding-left:8px;flex-shrink:0;"></i>
            <input type="text" class="location-input" placeholder="Your location" id="locationInput">
            <i class="bi bi-search" style="color:#aaa;font-size:1rem;flex-shrink:0;"></i>
            <input type="text" class="food-input" id="foodSearchInput" placeholder="Search for restaurants, cuisines...">
            <button type="submit" class="btn-search">
              <i class="bi bi-search me-1"></i> Search
            </button>
          </div>
        </form>

        <div class="hero-stats">
          <div class="hero-stat">
            <span class="num">500+</span>
            <span class="label">Restaurants</span>
          </div>
          <div class="hero-stat">
            <span class="num">30 min</span>
            <span class="label">Avg Delivery</span>
          </div>
          <div class="hero-stat">
            <span class="num">10K+</span>
            <span class="label">Happy Customers</span>
          </div>
        </div>
      </div>
      <div class="col-lg-5 d-none d-lg-block hero-food-img">
        <!-- Decorative floating food illustration -->
        <div style="text-align:center;position:relative;">
          <div style="width:320px;height:320px;border-radius:50%;
                      background:rgba(255,255,255,0.07);
                      display:flex;align-items:center;justify-content:center;
                      margin:0 auto;font-size:200px;line-height:1;
                      animation:float 3s ease-in-out infinite;">
            🍕
          </div>
          <!-- Floating badges -->
          <div style="position:absolute;top:20px;right:10px;background:white;
                      border-radius:12px;padding:10px 14px;box-shadow:0 8px 25px rgba(0,0,0,0.2);
                      font-size:0.8rem;font-weight:600;color:#3D4152;">
            <i class="bi bi-star-fill" style="color:#f7b731;"></i> 4.8 Rating
          </div>
          <div style="position:absolute;bottom:40px;left:0;background:white;
                      border-radius:12px;padding:10px 14px;box-shadow:0 8px 25px rgba(0,0,0,0.2);
                      font-size:0.8rem;font-weight:600;color:#3D4152;">
            <i class="bi bi-clock" style="color:#CB202D;"></i> 25 min delivery
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== CUISINES ===================== -->
<section class="section">
  <div class="container">
    <h2 class="section-title">What's on your mind?</h2>
    <div class="cuisine-scroll">
      <% for (int i = 0; i < cuisineNames.length; i++) { %>
      <a href="${pageContext.request.contextPath}/restaurants?cuisine=<%= cuisineNames[i] %>"
         class="cuisine-card">
        <div class="cuisine-icon cuisine-bg-<%= i %>">
          <span><%= cuisineEmojis[i] %></span>
        </div>
        <div class="cuisine-name"><%= cuisineNames[i] %></div>
      </a>
      <% } %>
    </div>
  </div>
</section>

<!-- ===================== FEATURED RESTAURANTS ===================== -->
<section class="section section-alt">
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="section-title mb-0">Top Restaurants <span>Near You</span></h2>
      <a href="${pageContext.request.contextPath}/restaurants"
         class="btn-outline-primary-custom">View All</a>
    </div>

    <div class="row g-3">
      <% int bgIdx = 0; for (Restaurant r : featuredRestaurants) { %>
      <div class="col-lg-4 col-md-6">
        <a href="${pageContext.request.contextPath}/menu?id=<%= r.getId() %>"
           style="display:block;height:100%;text-decoration:none;">
          <div class="restaurant-card">
            <div class="restaurant-img-wrap">
              <div class="img-placeholder <%= bgClasses[bgIdx % bgClasses.length] %>">
                <%= getRestaurantEmoji(r.getCuisine()) %>
              </div>
              <% if (!r.isOpen()) { %>
              <div class="restaurant-badge">Closed</div>
              <% } %>
              <% if (r.isVeg()) { %>
              <div class="veg-only-badge">VEG ONLY</div>
              <% } %>
            </div>
            <div class="restaurant-info">
              <div class="restaurant-name"><%= r.getName() %></div>
              <div class="restaurant-cuisine"><%= r.getCuisine() %></div>
              <div class="restaurant-meta">
                <span class="rating">
                  <i class="bi bi-star-fill" style="font-size:0.7rem;"></i>
                  <%= r.getRating() %>
                </span>
                <span class="delivery-time">
                  <i class="bi bi-clock me-1"></i><%= r.getDeliveryTime() %> min
                </span>
                <span class="delivery-fee">
                  <%= r.getDeliveryFeeDisplay() %> delivery
                </span>
              </div>
            </div>
          </div>
        </a>
      </div>
      <% bgIdx++; } %>
    </div>

    <% if (featuredRestaurants.isEmpty()) { %>
    <div class="text-center py-5">
      <div style="font-size:4rem;">🍽️</div>
      <h4 class="mt-3">No restaurants available</h4>
      <p class="text-muted">Check back soon!</p>
    </div>
    <% } %>
  </div>
</section>

<!-- ===================== WHY TASTYTRAIL ===================== -->
<section class="section">
  <div class="container">
    <div class="text-center mb-5">
      <h2 class="section-title">Why <span>TastyTrail?</span></h2>
      <p class="text-muted">We make food ordering simple, fast, and enjoyable</p>
    </div>
    <div class="row g-4 text-center">
      <div class="col-lg-3 col-md-6">
        <div style="background:white;border-radius:16px;padding:30px 20px;box-shadow:0 2px 20px rgba(0,0,0,0.06);">
          <div style="font-size:3rem;margin-bottom:12px;">🏪</div>
          <h5 style="font-weight:700;">500+ Restaurants</h5>
          <p style="color:#686b78;font-size:0.9rem;">Choose from hundreds of top-rated restaurants near you</p>
        </div>
      </div>
      <div class="col-lg-3 col-md-6">
        <div style="background:white;border-radius:16px;padding:30px 20px;box-shadow:0 2px 20px rgba(0,0,0,0.06);">
          <div style="font-size:3rem;margin-bottom:12px;">⚡</div>
          <h5 style="font-weight:700;">Fast Delivery</h5>
          <p style="color:#686b78;font-size:0.9rem;">Hot food delivered to your door in 30 minutes or less</p>
        </div>
      </div>
      <div class="col-lg-3 col-md-6">
        <div style="background:white;border-radius:16px;padding:30px 20px;box-shadow:0 2px 20px rgba(0,0,0,0.06);">
          <div style="font-size:3rem;margin-bottom:12px;">💳</div>
          <h5 style="font-weight:700;">Easy Payment</h5>
          <p style="color:#686b78;font-size:0.9rem;">Pay with cash, UPI, card or wallet — your choice</p>
        </div>
      </div>
      <div class="col-lg-3 col-md-6">
        <div style="background:white;border-radius:16px;padding:30px 20px;box-shadow:0 2px 20px rgba(0,0,0,0.06);">
          <div style="font-size:3rem;margin-bottom:12px;">⭐</div>
          <h5 style="font-weight:700;">Top Quality</h5>
          <p style="color:#686b78;font-size:0.9rem;">Only verified restaurants with quality assurance</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== CTA ===================== -->
<section style="background:linear-gradient(135deg,#CB202D,#e85d04);padding:60px 0;">
  <div class="container text-center">
    <h2 style="color:white;font-weight:700;font-size:2rem;margin-bottom:12px;">
      Hungry? Let's get started!
    </h2>
    <p style="color:rgba(255,255,255,0.85);margin-bottom:24px;">
      Browse our menu and order your favourite food today
    </p>
    <a href="${pageContext.request.contextPath}/restaurants"
       style="background:white;color:#CB202D;font-weight:700;padding:14px 40px;
              border-radius:50px;font-size:1rem;display:inline-block;transition:transform 0.2s;
              text-decoration:none;"
       onmouseover="this.style.transform='scale(1.05)'"
       onmouseout="this.style.transform='scale(1)'">
      Order Now <i class="bi bi-arrow-right ms-2"></i>
    </a>
  </div>
</section>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
<%!
  private String getRestaurantEmoji(String cuisine) {
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
    if (cuisine.contains("sushi") || cuisine.contains("japanese")) return "🍱";
    return "🍽️";
  }
%>
