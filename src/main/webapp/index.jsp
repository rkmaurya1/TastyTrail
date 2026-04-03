<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.dao.MenuDAO, com.tastytrail.dao.RestaurantDAO,
                 com.tastytrail.model.MenuItem, com.tastytrail.model.Restaurant,
                 java.util.List, java.util.Map" %>
<%
    final int RESTAURANT_ID = 1;
    RestaurantDAO rDao = new RestaurantDAO();
    MenuDAO mDao = new MenuDAO();
    Restaurant restaurant = rDao.getRestaurantById(RESTAURANT_ID);
    Map<String, List<MenuItem>> menuByCategory = mDao.getMenuGroupedByCategory(RESTAURANT_ID);

    // Featured items: first 6 available items
    List<MenuItem> featuredItems = new java.util.ArrayList<>();
    for (List<MenuItem> items : menuByCategory.values()) {
        for (MenuItem item : items) {
            if (item.isAvailable() && featuredItems.size() < 6) featuredItems.add(item);
        }
        if (featuredItems.size() >= 6) break;
    }

    // Category images map
    java.util.Map<String, String> catImages = new java.util.LinkedHashMap<>();
    catImages.put("Starters",      "https://images.unsplash.com/photo-1541014741259-de529411b96a?w=120&h=120&fit=crop&q=80");
    catImages.put("Main Course",   "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=120&h=120&fit=crop&q=80");
    catImages.put("Pizza",         "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=120&h=120&fit=crop&q=80");
    catImages.put("Burgers",       "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=120&h=120&fit=crop&q=80");
    catImages.put("Biryani",       "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=120&h=120&fit=crop&q=80");
    catImages.put("Rice & Biryani","https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=120&h=120&fit=crop&q=80");
    catImages.put("Pasta",         "https://images.unsplash.com/photo-1563245372-f21724e3856d?w=120&h=120&fit=crop&q=80");
    catImages.put("Breads",        "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=120&h=120&fit=crop&q=80");
    catImages.put("Desserts",      "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=120&h=120&fit=crop&q=80");
    catImages.put("Beverages",     "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=120&h=120&fit=crop&q=80");
    catImages.put("Sides",         "https://images.unsplash.com/photo-1561758033-7e924f619b47?w=120&h=120&fit=crop&q=80");
    String defaultCatImg = "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=120&h=120&fit=crop&q=80";

    // Item image map by name keywords
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TastyTrail — Order Food Online</title>
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

<!-- ===================== HERO ===================== -->
<section class="hero">
  <div class="hero-bg-overlay"></div>
  <div class="container">
    <div class="row align-items-center g-4">
      <div class="col-lg-6 hero-content">
        <div class="hero-badge" data-aos="fade-down" data-aos-delay="100">
          <i class="bi bi-lightning-charge-fill"></i> Free delivery on all orders
        </div>
        <h1 data-aos="fade-up" data-aos-delay="150">
          Sab kuch ek jagah,<br><span>TastyTrail pe!</span>
        </h1>
        <p data-aos="fade-up" data-aos-delay="200">
          North Indian, Pizza, Burgers, Biryani, Chinese aur bahut kuch — fresh ghar tak
        </p>

        <div class="hero-actions" data-aos="fade-up" data-aos-delay="250">
          <a href="${pageContext.request.contextPath}/menu" class="btn-hero-primary">
            <i class="bi bi-menu-button-wide me-2"></i> Order Now
          </a>
          <a href="#categories" class="btn-hero-secondary">
            Browse Menu <i class="bi bi-arrow-down ms-2"></i>
          </a>
        </div>

        <div class="hero-stats" data-aos="fade-up" data-aos-delay="300">
          <div class="hero-stat">
            <span class="num"><%= menuByCategory.values().stream().mapToInt(List::size).sum() %>+</span>
            <span class="label">Menu Items</span>
          </div>
          <div class="hero-stat-divider"></div>
          <div class="hero-stat">
            <span class="num"><%= restaurant != null ? restaurant.getDeliveryTime() : 30 %> min</span>
            <span class="label">Avg Delivery</span>
          </div>
          <div class="hero-stat-divider"></div>
          <div class="hero-stat">
            <span class="num">FREE</span>
            <span class="label">Delivery</span>
          </div>
        </div>
      </div>

      <div class="col-lg-6 d-none d-lg-block" data-aos="fade-left" data-aos-delay="200">
        <div class="hero-img-container">
          <img src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600&q=85&fit=crop"
               alt="TastyTrail Food" class="hero-main-img">
          <div class="hero-float-card top-right">
            <i class="bi bi-star-fill" style="color:#f7b731;font-size:1.2rem;"></i>
            <div>
              <div style="font-weight:700;font-size:0.9rem;"><%= restaurant != null ? restaurant.getRating() : "4.8" %> Rating</div>
              <div style="font-size:0.72rem;color:#686b78;">Customer Rating</div>
            </div>
          </div>
          <div class="hero-float-card bottom-left">
            <div class="delivery-icon-wrap"><i class="bi bi-bicycle" style="color:#CB202D;font-size:1.2rem;"></i></div>
            <div>
              <div style="font-weight:700;font-size:0.9rem;">Free Delivery</div>
              <div style="font-size:0.72rem;color:#686b78;">On every order</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== CATEGORIES ===================== -->
<section class="section" id="categories">
  <div class="container">
    <div class="text-center mb-4" data-aos="fade-up">
      <h2 class="section-title">What's on your mind?</h2>
      <p style="color:#686b78;">Browse by category and order your favourite</p>
    </div>
    <div class="cuisine-scroll" data-aos="fade-up" data-aos-delay="100">
      <% for (String catName : menuByCategory.keySet()) {
         String catImg = catImages.containsKey(catName) ? catImages.get(catName) : defaultCatImg;
         String catId = catName.replaceAll("[^a-zA-Z0-9]", "_");
      %>
      <a href="${pageContext.request.contextPath}/menu#section-<%= catId %>" class="cuisine-card">
        <div class="cuisine-icon-img">
          <img src="<%= catImg %>" alt="<%= catName %>">
        </div>
        <div class="cuisine-name"><%= catName %></div>
      </a>
      <% } %>
    </div>
  </div>
</section>

<!-- ===================== FEATURED ITEMS ===================== -->
<section class="section section-alt">
  <div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4" data-aos="fade-up">
      <div>
        <h2 class="section-title mb-1">Popular <span>Items</span></h2>
        <p style="color:#686b78;font-size:0.9rem;margin:0;">Our customers' favourites</p>
      </div>
      <a href="${pageContext.request.contextPath}/menu" class="btn-outline-primary-custom">
        Full Menu <i class="bi bi-arrow-right ms-1"></i>
      </a>
    </div>

    <div class="row g-3">
      <% int idx = 0; for (MenuItem item : featuredItems) { %>
      <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="<%= (idx % 3) * 80 %>">
        <div class="menu-featured-card">
          <div class="menu-featured-img">
            <img src="<%= getItemImage(item.getName(), item.isVeg()) %>"
                 alt="<%= item.getName() %>"
                 onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=180&fit=crop&q=80'">
            <div class="featured-veg-dot <%= item.isVeg() ? "veg" : "nonveg" %>"></div>
          </div>
          <div class="menu-featured-info">
            <div class="menu-featured-name"><%= item.getName() %></div>
            <% if (item.getDescription() != null && !item.getDescription().isEmpty()) { %>
            <div class="menu-featured-desc"><%= item.getDescription() %></div>
            <% } %>
            <div class="menu-featured-bottom">
              <span class="menu-featured-price"><%= item.getPriceFormatted() %></span>
              <button class="btn-featured-add btn-add-to-cart"
                      data-item-id="<%= item.getId() %>"
                      data-restaurant-id="1"
                      data-item-name="<%= item.getName() %>">
                <i class="bi bi-plus-lg"></i> Add
              </button>
            </div>
          </div>
        </div>
      </div>
      <% idx++; } %>
    </div>
  </div>
</section>

<!-- ===================== WHY TASTYTRAIL ===================== -->
<section class="section" style="background:linear-gradient(135deg,#1a1a2e 0%,#16213e 60%,#0f3460 100%);position:relative;overflow:hidden;">
  <div class="features-bg-dots"></div>
  <div class="container" style="position:relative;z-index:1;">
    <div class="text-center mb-5" data-aos="fade-up">
      <h2 class="section-title" style="color:white;">Why <span>TastyTrail?</span></h2>
      <p style="color:rgba(255,255,255,0.65);">Ghar baitha order karo, fresh khana pao</p>
    </div>
    <div class="row g-4">
      <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="0">
        <div class="feature-card">
          <div class="feature-icon" style="background:linear-gradient(135deg,#FF6B6B,#ee5a24);">
            <i class="bi bi-collection-fill"></i>
          </div>
          <h5><%= menuByCategory.values().stream().mapToInt(List::size).sum() %>+ Menu Items</h5>
          <p>North Indian se leke Pizza, Burgers, Chinese — sab ek hi jagah</p>
        </div>
      </div>
      <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
        <div class="feature-card">
          <div class="feature-icon" style="background:linear-gradient(135deg,#45aaf2,#2d98da);">
            <i class="bi bi-lightning-charge-fill"></i>
          </div>
          <h5>Fast Delivery</h5>
          <p>30 minutes mein garam khana aapke darwaze par</p>
        </div>
      </div>
      <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
        <div class="feature-card">
          <div class="feature-icon" style="background:linear-gradient(135deg,#26de81,#20bf6b);">
            <i class="bi bi-bicycle"></i>
          </div>
          <h5>FREE Delivery</h5>
          <p>Har order par free delivery — koi hidden charge nahi</p>
        </div>
      </div>
      <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
        <div class="feature-card">
          <div class="feature-icon" style="background:linear-gradient(135deg,#a55eea,#8854d0);">
            <i class="bi bi-shield-check"></i>
          </div>
          <h5>Fresh & Quality</h5>
          <p>Har dish fresh ingredients se banayi jaati hai</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== FOOD GALLERY ===================== -->
<section class="food-gallery-strip">
  <div class="gallery-track">
    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1563245372-f21724e3856d?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=220&h=150&fit=crop&q=80" alt="">
    <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=220&h=150&fit=crop&q=80" alt="">
  </div>
</section>

<!-- ===================== CTA ===================== -->
<section class="cta-section" data-aos="fade-up">
  <div class="container text-center">
    <div class="cta-inner">
      <img src="https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=100&h=100&fit=crop&q=80"
           alt="" class="cta-food-img">
      <h2>Bhook lagi hai? Abhi order karo!</h2>
      <p>Fresh khana, free delivery, 30 minutes mein</p>
      <a href="${pageContext.request.contextPath}/menu" class="btn-cta">
        <i class="bi bi-bag-fill me-2"></i> Order Now
      </a>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>AOS.init({ duration: 650, once: true, offset: 60 });</script>
</body>
</html>
<%!
  private String getItemImage(String name, boolean isVeg) {
    if (name == null) return "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=180&fit=crop&q=80";
    String n = name.toLowerCase();
    if (n.contains("pizza") || n.contains("margherita") || n.contains("pepperoni"))
        return "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&h=180&fit=crop&q=80";
    if (n.contains("burger") || n.contains("patty") || n.contains("smash"))
        return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=180&fit=crop&q=80";
    if (n.contains("biryani") || n.contains("rice"))
        return "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300&h=180&fit=crop&q=80";
    if (n.contains("paneer") || n.contains("palak") || n.contains("dal") || n.contains("makhani"))
        return "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=300&h=180&fit=crop&q=80";
    if (n.contains("chicken") || n.contains("mutton") || n.contains("kebab") || n.contains("seekh"))
        return "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=300&h=180&fit=crop&q=80";
    if (n.contains("naan") || n.contains("bread") || n.contains("roti"))
        return "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&h=180&fit=crop&q=80";
    if (n.contains("pasta") || n.contains("penne") || n.contains("alfredo"))
        return "https://images.unsplash.com/photo-1563245372-f21724e3856d?w=300&h=180&fit=crop&q=80";
    if (n.contains("cake") || n.contains("gulab") || n.contains("dessert") || n.contains("sweet"))
        return "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=300&h=180&fit=crop&q=80";
    if (n.contains("fries") || n.contains("onion ring") || n.contains("sides"))
        return "https://images.unsplash.com/photo-1561758033-7e924f619b47?w=300&h=180&fit=crop&q=80";
    if (n.contains("coffee") || n.contains("milkshake") || n.contains("drink") || n.contains("cold"))
        return "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=300&h=180&fit=crop&q=80";
    return isVeg
        ? "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=180&fit=crop&q=80"
        : "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=180&fit=crop&q=80";
  }
%>
