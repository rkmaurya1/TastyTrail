<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Order" %>
<%
    Order order = (Order) request.getAttribute("order");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Order #<%= order.getId() %> — TastyTrail</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script>var contextPath = '${pageContext.request.contextPath}';</script>
</head>
<body>
<div class="page-loader"><div class="spinner-brand"></div></div>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container my-4" style="max-width:700px;">
  <nav aria-label="breadcrumb" style="margin-bottom:20px;">
    <ol class="breadcrumb" style="font-size:0.85rem;background:none;padding:0;margin:0;">
      <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/orders" style="color:#CB202D;">My Orders</a></li>
      <li class="breadcrumb-item active">Order #<%= order.getId() %></li>
    </ol>
  </nav>

  <div style="background:white;border-radius:16px;padding:28px;box-shadow:0 2px 20px rgba(0,0,0,0.08);">
    <div class="d-flex justify-content-between align-items-start mb-4">
      <div>
        <h4 style="font-weight:700;color:#1C1C1C;margin-bottom:4px;">
          Order #<%= order.getId() %>
        </h4>
        <div style="font-size:0.85rem;color:#686b78;">
          Placed on <%= new java.text.SimpleDateFormat("dd MMMM yyyy 'at' hh:mm a").format(order.getCreatedAt()) %>
        </div>
      </div>
      <span class="order-status-badge status-<%= order.getStatus() %>" style="font-size:0.85rem;padding:6px 14px;">
        <%= order.getStatusDisplay() %>
      </span>
    </div>

    <!-- Restaurant -->
    <div style="background:#f9f9f9;border-radius:10px;padding:14px;margin-bottom:20px;">
      <div style="font-weight:600;color:#1C1C1C;margin-bottom:2px;">🏪 <%= order.getRestaurantName() %></div>
      <div style="font-size:0.82rem;color:#686b78;">Restaurant</div>
    </div>

    <!-- Order items -->
    <h6 style="font-weight:700;color:#1C1C1C;margin-bottom:12px;">Items Ordered</h6>
    <% if (order.getItems() != null) { for (Order.OrderItem item : order.getItems()) { %>
    <div style="display:flex;justify-content:space-between;align-items:center;
                padding:10px 0;border-bottom:1px solid #f5f5f5;">
      <div>
        <div style="font-weight:600;font-size:0.9rem;"><%= item.getItemName() %></div>
        <div style="font-size:0.8rem;color:#686b78;">Qty: <%= item.getQuantity() %> × ₹<%= Math.round(item.getPrice()) %></div>
      </div>
      <div style="font-weight:700;color:#1C1C1C;"><%= item.getSubtotalFormatted() %></div>
    </div>
    <% } } %>

    <!-- Bill summary -->
    <div style="margin-top:16px;padding-top:16px;border-top:2px dashed #e8e8e8;">
      <h6 style="font-weight:700;color:#1C1C1C;margin-bottom:12px;">Bill Summary</h6>
      <div style="display:flex;justify-content:space-between;font-size:0.85rem;margin-bottom:6px;">
        <span style="color:#686b78;">Item Total</span>
        <span>₹<%= String.format("%.0f", order.getTotalAmount()) %></span>
      </div>
      <div style="display:flex;justify-content:space-between;font-weight:700;
                  font-size:1rem;padding-top:10px;border-top:1px solid #e8e8e8;margin-top:6px;">
        <span>Total Paid</span>
        <span style="color:#CB202D;"><%= order.getTotalFormatted() %></span>
      </div>
      <div style="font-size:0.8rem;color:#686b78;margin-top:4px;">
        Paid via <%= order.getPaymentMethod() %>
      </div>
    </div>

    <!-- Delivery address -->
    <div style="margin-top:20px;background:#f9f9f9;border-radius:10px;padding:14px;">
      <div style="font-size:0.75rem;font-weight:700;color:#686b78;text-transform:uppercase;
                  letter-spacing:0.5px;margin-bottom:6px;">Delivery Address</div>
      <div style="font-size:0.9rem;color:#1C1C1C;"><%= order.getDeliveryAddress() %></div>
    </div>

    <div class="d-flex gap-2 mt-4">
      <a href="${pageContext.request.contextPath}/orders"
         class="btn-outline-primary-custom">← Back to Orders</a>
      <% if ("DELIVERED".equals(order.getStatus())) { %>
      <a href="${pageContext.request.contextPath}/menu?id=<%= order.getRestaurantId() %>"
         class="btn-primary-custom" style="display:inline-block;padding:8px 20px;">
        Reorder
      </a>
      <% } %>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
