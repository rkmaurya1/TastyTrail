<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Order, java.util.List" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    boolean successOrder = "true".equals(request.getParameter("success"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Orders — TastyTrail</title>
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

<div class="container my-4" style="max-width:860px;">
  <h2 style="font-weight:700;color:#1C1C1C;margin-bottom:8px;">
    <i class="bi bi-bag-check me-2" style="color:#CB202D;"></i>My Orders
  </h2>
  <p style="color:#686b78;margin-bottom:24px;">Track and manage your orders</p>

  <!-- Success message when order placed -->
  <% if (successOrder) { %>
  <div class="alert alert-success d-flex align-items-center gap-2" style="border-radius:12px;">
    <i class="bi bi-check-circle-fill fs-5"></i>
    <div>
      <strong>Order placed successfully!</strong> We're preparing your food.
      Your order will arrive in 30-45 minutes.
    </div>
  </div>
  <% } %>

  <% if (orders == null || orders.isEmpty()) { %>
  <!-- No orders -->
  <div class="empty-cart text-center py-5">
    <div class="icon">📦</div>
    <h4>No orders yet</h4>
    <p style="color:#686b78;">When you place an order, it will appear here.</p>
    <a href="${pageContext.request.contextPath}/restaurants"
       style="display:inline-block;background:#CB202D;color:white;padding:12px 32px;
              border-radius:8px;font-weight:700;text-decoration:none;margin-top:16px;">
      Order Now
    </a>
  </div>

  <% } else { %>

  <% for (Order order : orders) { %>
  <div class="order-card">
    <!-- Header -->
    <div class="order-card-header">
      <div style="font-size:2.2rem;flex-shrink:0;">🍽️</div>
      <div class="flex-grow-1">
        <div style="font-weight:700;color:#1C1C1C;font-size:1rem;">
          <%= order.getRestaurantName() %>
        </div>
        <div style="font-size:0.82rem;color:#686b78;margin-top:2px;">
          Order #<%= order.getId() %> &bull;
          <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(order.getCreatedAt()) %>
        </div>
        <div style="font-size:0.82rem;color:#686b78;margin-top:2px;">
          <%= order.getItems() != null ? order.getItems().size() : 0 %> item(s) &bull;
          <strong style="color:#1C1C1C;"><%= order.getTotalFormatted() %></strong> &bull;
          <%= order.getPaymentMethod() %>
        </div>
      </div>
      <div class="text-end">
        <span class="order-status-badge status-<%= order.getStatus() %>">
          <%= order.getStatusDisplay() %>
        </span>
      </div>
    </div>

    <!-- Items list -->
    <% if (order.getItems() != null && !order.getItems().isEmpty()) { %>
    <div style="margin-bottom:16px;">
      <% for (Order.OrderItem item : order.getItems()) { %>
      <div style="display:flex;justify-content:space-between;font-size:0.85rem;
                  padding:4px 0;border-bottom:1px dashed #f5f5f5;">
        <span><%= item.getQuantity() %>x <%= item.getItemName() %></span>
        <span style="color:#686b78;"><%= item.getSubtotalFormatted() %></span>
      </div>
      <% } %>
    </div>
    <% } %>

    <!-- Order Tracking -->
    <% if (!"CANCELLED".equals(order.getStatus())) { %>
    <div style="margin:12px 0;">
      <div style="font-size:0.78rem;font-weight:600;color:#686b78;
                  text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;">
        Order Tracking
      </div>
      <div class="order-tracking">
        <%
          String[] steps = {"PLACED","CONFIRMED","PREPARING","OUT_FOR_DELIVERY","DELIVERED"};
          String[] labels = {"Placed","Confirmed","Preparing","On the way","Delivered"};
          String[] icons = {"✓","🏪","👨‍🍳","🛵","✅"};
          String currentStatus = order.getStatus();
          int currentIdx = 0;
          for (int s = 0; s < steps.length; s++) {
              if (steps[s].equals(currentStatus)) { currentIdx = s; break; }
          }
          for (int s = 0; s < steps.length; s++) {
              boolean isDone = s < currentIdx;
              boolean isActive = s == currentIdx;
        %>
        <% if (s > 0) { %>
        <div class="track-line <%= isDone || isActive ? "done" : "" %>" style="flex:1;"></div>
        <% } %>
        <div class="track-step">
          <div class="track-circle <%= isDone ? "done" : (isActive ? "active" : "") %>">
            <%= isDone ? "✓" : icons[s] %>
          </div>
          <div class="track-label"><%= labels[s] %></div>
        </div>
        <% } %>
      </div>
    </div>
    <% } %>

    <!-- Footer actions -->
    <div style="display:flex;justify-content:space-between;align-items:center;
                padding-top:12px;border-top:1px solid #f5f5f5;">
      <div style="font-size:0.82rem;color:#686b78;">
        <i class="bi bi-geo-alt me-1"></i>
        <%= order.getDeliveryAddress().length() > 50
            ? order.getDeliveryAddress().substring(0,50)+"..." : order.getDeliveryAddress() %>
      </div>
      <div class="d-flex gap-2">
        <% if ("DELIVERED".equals(order.getStatus())) { %>
        <a href="${pageContext.request.contextPath}/menu?id=<%= order.getRestaurantId() %>"
           class="btn-outline-primary-custom" style="font-size:0.8rem;padding:6px 14px;">
          Reorder
        </a>
        <% } %>
        <a href="${pageContext.request.contextPath}/orders?id=<%= order.getId() %>"
           style="background:none;border:1.5px solid #e8e8e8;color:#3D4152;
                  border-radius:8px;padding:6px 14px;font-size:0.8rem;font-weight:600;
                  text-decoration:none;transition:all 0.2s;"
           onmouseover="this.style.borderColor='#CB202D';this.style.color='#CB202D';"
           onmouseout="this.style.borderColor='#e8e8e8';this.style.color='#3D4152';">
          View Details
        </a>
      </div>
    </div>
  </div>
  <% } %>

  <% } %>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
