<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Order, com.tastytrail.model.User, java.util.List" %>
<%
  List<Order> orders = (List<Order>) request.getAttribute("orders");
  User driver = (User) request.getAttribute("driver");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Driver Dashboard — TastyTrail</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    *{font-family:'Poppins',sans-serif}body{background:#f0f2f5}
    .topbar{background:#1C1C1C;padding:14px 24px;display:flex;justify-content:space-between;align-items:center;position:sticky;top:0;z-index:99}
    .topbar-brand{font-size:1.2rem;font-weight:700;color:#CB202D}
    .topbar-brand span{color:#FC8019}
    .driver-badge{background:#d1ecf1;color:#0c5460;padding:3px 12px;border-radius:20px;font-size:0.75rem;font-weight:700;}
    .stat-card{background:white;border-radius:12px;padding:20px;box-shadow:0 1px 10px rgba(0,0,0,0.06);text-align:center}
    .stat-num{font-size:2rem;font-weight:700}
    .order-card{background:white;border-radius:12px;padding:20px;box-shadow:0 1px 10px rgba(0,0,0,0.06);margin-bottom:12px}
    .status-PLACED{background:#fff3cd;color:#856404}
    .status-CONFIRMED{background:#cce5ff;color:#004085}
    .status-PREPARING{background:#d4edda;color:#155724}
    .status-OUT_FOR_DELIVERY{background:#d1ecf1;color:#0c5460}
    .status-DELIVERED{background:#d4edda;color:#155724}
    .status-CANCELLED{background:#f8d7da;color:#721c24}
  </style>
</head>
<body>

<div class="topbar">
  <div class="topbar-brand">Tasty<span>Trail</span> <span class="driver-badge ms-2">DRIVER</span></div>
  <div class="d-flex align-items-center gap-3">
    <div style="color:white;font-size:0.9rem;">
      <i class="bi bi-person-circle me-1"></i>
      <%= driver != null ? driver.getName() : "" %>
    </div>
    <a href="${pageContext.request.contextPath}/logout"
       style="background:#CB202D;color:white;border:none;border-radius:8px;padding:7px 16px;font-size:0.85rem;font-weight:600;text-decoration:none;">
      Logout
    </a>
  </div>
</div>

<div class="container py-4">
  <h4 class="fw-bold mb-4">
    <i class="bi bi-bicycle me-2" style="color:#CB202D;"></i>My Deliveries
  </h4>

  <!-- Stats -->
  <div class="row g-3 mb-4">
    <div class="col-4">
      <div class="stat-card">
        <div class="stat-num" style="color:#f59e0b;"><%= request.getAttribute("pendingCount") %></div>
        <div style="font-size:0.82rem;color:#686b78;">Pending</div>
      </div>
    </div>
    <div class="col-4">
      <div class="stat-card">
        <div class="stat-num" style="color:#0c5460;"><%= request.getAttribute("inDeliveryCount") %></div>
        <div style="font-size:0.82rem;color:#686b78;">In Delivery</div>
      </div>
    </div>
    <div class="col-4">
      <div class="stat-card">
        <div class="stat-num" style="color:#155724;"><%= request.getAttribute("deliveredCount") %></div>
        <div style="font-size:0.82rem;color:#686b78;">Delivered</div>
      </div>
    </div>
  </div>

  <!-- Active Deliveries -->
  <h6 class="fw-bold mb-3" style="text-transform:uppercase;font-size:0.78rem;color:#686b78;letter-spacing:1px;">
    Active Deliveries
  </h6>

  <% boolean hasActive = false;
     if (orders != null) { for (Order o : orders) {
       if ("DELIVERED".equals(o.getStatus()) || "CANCELLED".equals(o.getStatus())) continue;
       hasActive = true;
  %>
  <div class="order-card">
    <div class="d-flex justify-content-between align-items-start mb-3">
      <div>
        <div class="fw-bold" style="font-size:1rem;">#<%= o.getId() %> — <%= o.getRestaurantName() %></div>
        <div style="font-size:0.82rem;color:#686b78;margin-top:2px;">
          <i class="bi bi-clock me-1"></i>
          <%= new java.text.SimpleDateFormat("dd MMM, hh:mm a").format(o.getCreatedAt()) %>
        </div>
      </div>
      <span class="status-<%= o.getStatus() %>" style="padding:4px 12px;border-radius:20px;font-size:0.75rem;font-weight:700;">
        <%= o.getStatusDisplay() %>
      </span>
    </div>

    <div style="background:#f9f9f9;border-radius:8px;padding:12px;margin-bottom:14px;">
      <div style="font-size:0.78rem;font-weight:700;color:#686b78;text-transform:uppercase;letter-spacing:0.5px;margin-bottom:6px;">
        Delivery Address
      </div>
      <div style="font-size:0.9rem;color:#1C1C1C;">
        <i class="bi bi-geo-alt me-1" style="color:#CB202D;"></i><%= o.getDeliveryAddress() %>
      </div>
    </div>

    <div class="d-flex justify-content-between align-items-center">
      <div style="font-size:0.9rem;font-weight:700;color:#1C1C1C;">
        Total: <%= o.getTotalFormatted() %> · <%= o.getPaymentMethod() %>
      </div>
      <div class="d-flex gap-2">
        <% if ("CONFIRMED".equals(o.getStatus()) || "PREPARING".equals(o.getStatus())) { %>
        <form action="${pageContext.request.contextPath}/driver/dashboard" method="post" style="display:inline;">
          <input type="hidden" name="action" value="accept">
          <input type="hidden" name="orderId" value="<%= o.getId() %>">
          <button type="submit" class="btn btn-sm"
                  style="background:#0c5460;color:white;border:none;border-radius:8px;font-weight:600;font-size:0.82rem;padding:6px 16px;">
            <i class="bi bi-truck me-1"></i>Accept & Pick Up
          </button>
        </form>
        <% } else if ("OUT_FOR_DELIVERY".equals(o.getStatus())) { %>
        <form action="${pageContext.request.contextPath}/driver/dashboard" method="post" style="display:inline;">
          <input type="hidden" name="action" value="deliver">
          <input type="hidden" name="orderId" value="<%= o.getId() %>">
          <button type="submit" class="btn btn-sm"
                  style="background:#155724;color:white;border:none;border-radius:8px;font-weight:600;font-size:0.82rem;padding:6px 16px;">
            <i class="bi bi-check-circle me-1"></i>Mark Delivered
          </button>
        </form>
        <% } %>
      </div>
    </div>
  </div>
  <% } } %>

  <% if (!hasActive) { %>
  <div style="text-align:center;padding:60px 20px;background:white;border-radius:12px;">
    <div style="font-size:4rem;opacity:0.3;">🛵</div>
    <h5 class="mt-3 fw-bold">No active deliveries</h5>
    <p style="color:#686b78;">New orders will appear here when assigned.</p>
  </div>
  <% } %>

  <!-- Delivery History -->
  <% boolean hasHistory = false;
     if (orders != null) { for (Order o : orders) {
       if (!"DELIVERED".equals(o.getStatus())) continue;
       if (!hasHistory) { hasHistory = true; %>
  <h6 class="fw-bold mt-4 mb-3" style="text-transform:uppercase;font-size:0.78rem;color:#686b78;letter-spacing:1px;">
    Delivery History
  </h6>
  <% } %>
  <div style="background:white;border-radius:10px;padding:14px 16px;margin-bottom:8px;box-shadow:0 1px 6px rgba(0,0,0,0.05);display:flex;justify-content:space-between;align-items:center;">
    <div>
      <div class="fw-semibold" style="font-size:0.9rem;">#<%= o.getId() %> — <%= o.getRestaurantName() %></div>
      <div style="font-size:0.78rem;color:#686b78;"><%= new java.text.SimpleDateFormat("dd MMM, hh:mm a").format(o.getCreatedAt()) %></div>
    </div>
    <div style="text-align:right;">
      <div class="fw-bold" style="font-size:0.95rem;"><%= o.getTotalFormatted() %></div>
      <span style="background:#d4edda;color:#155724;padding:2px 8px;border-radius:10px;font-size:0.7rem;font-weight:700;">Delivered</span>
    </div>
  </div>
  <% } } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
