<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Order, com.tastytrail.model.User, java.util.List" %>
<%
  List<Order> orders = (List<Order>) request.getAttribute("orders");
  List<User> drivers = (List<User>) request.getAttribute("drivers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Orders — Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    *{font-family:'Poppins',sans-serif}body{background:#f0f2f5}
    .sidebar{width:240px;min-height:100vh;background:#1C1C1C;position:fixed;top:0;left:0;z-index:100}
    .sidebar-brand{padding:20px;font-size:1.3rem;font-weight:700;color:#CB202D;border-bottom:1px solid #333}
    .sidebar-brand span{color:#FC8019}
    .sidebar .nav-link{color:rgba(255,255,255,0.65);padding:10px 20px;display:flex;align-items:center;gap:10px;transition:all 0.2s;font-size:0.9rem;text-decoration:none}
    .sidebar .nav-link:hover,.sidebar .nav-link.active{color:white;background:rgba(203,32,45,0.15);border-left:3px solid #CB202D}
    .main-content{margin-left:240px;padding:30px}
    .card{border:none;border-radius:12px;box-shadow:0 1px 10px rgba(0,0,0,0.06)}
    .card-header{background:white;border-bottom:1px solid #f0f0f0;border-radius:12px 12px 0 0!important;padding:16px 20px;font-weight:700}
    .table th{font-size:0.78rem;text-transform:uppercase;color:#686b78;font-weight:600;border:none;background:#f9f9f9}
    .table td{font-size:0.85rem;vertical-align:middle}
    .status-PLACED{background:#fff3cd;color:#856404}
    .status-CONFIRMED{background:#cce5ff;color:#004085}
    .status-PREPARING{background:#d4edda;color:#155724}
    .status-OUT_FOR_DELIVERY{background:#d1ecf1;color:#0c5460}
    .status-DELIVERED{background:#d4edda;color:#155724}
    .status-CANCELLED{background:#f8d7da;color:#721c24}
  </style>
</head>
<body>
<div class="sidebar">
  <div class="sidebar-brand">Tasty<span>Trail</span><br><small style="background:#CB202D;color:white;font-size:0.65rem;padding:2px 8px;border-radius:10px;">ADMIN</small></div>
  <nav class="mt-3">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link active"><i class="bi bi-bag-check"></i> Orders</a>
    <a href="${pageContext.request.contextPath}/admin/restaurants" class="nav-link"><i class="bi bi-shop"></i> Restaurants</a>
    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><i class="bi bi-people"></i> Users</a>
    <hr style="border-color:#333;margin:12px 0;">
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="bi bi-house"></i> View Site</a>
    <a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="bi bi-box-arrow-right"></i> Logout</a>
  </nav>
</div>

<div class="main-content">
  <div style="background:white;border-radius:12px;padding:16px 20px;margin-bottom:24px;box-shadow:0 1px 10px rgba(0,0,0,0.06);">
    <h5 class="mb-0 fw-bold"><i class="bi bi-bag-check me-2" style="color:#CB202D;"></i>Manage Orders</h5>
  </div>

  <% if ("true".equals(request.getParameter("updated"))) { %>
  <div class="alert alert-success alert-dismissible fade show">Order status updated successfully! <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
  <% } %>

  <div class="card">
    <div class="card-body p-0">
      <table class="table table-hover mb-0">
        <thead>
          <tr>
            <th class="ps-4">#ID</th>
            <th>Restaurant</th>
            <th>Customer</th>
            <th>Amount</th>
            <th>Payment</th>
            <th>Status</th>
            <th>Driver</th>
            <th>Date</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <% if (orders != null) { for (Order o : orders) { %>
          <tr>
            <td class="ps-4 fw-semibold">#<%= o.getId() %></td>
            <td><%= o.getRestaurantName() %></td>
            <td>User #<%= o.getUserId() %></td>
            <td class="fw-semibold"><%= o.getTotalFormatted() %></td>
            <td><small><%= o.getPaymentMethod() %></small></td>
            <td><span class="badge status-<%= o.getStatus() %>" style="padding:4px 10px;border-radius:20px;font-size:0.72rem;font-weight:700;"><%= o.getStatusDisplay() %></span></td>
            <td style="font-size:0.8rem;color:#686b78;">—</td>
            <td style="font-size:0.78rem;color:#686b78;"><%= new java.text.SimpleDateFormat("dd MMM, HH:mm").format(o.getCreatedAt()) %></td>
            <td>
              <button class="btn btn-sm btn-outline-danger" style="font-size:0.75rem;border-radius:6px;"
                      data-bs-toggle="modal" data-bs-target="#updateModal"
                      data-order-id="<%= o.getId() %>"
                      data-current-status="<%= o.getStatus() %>">
                Update
              </button>
            </td>
          </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:12px;border:none;">
      <div class="modal-header"><h5 class="modal-title fw-bold">Update Order Status</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form action="${pageContext.request.contextPath}/admin/orders" method="post">
        <div class="modal-body">
          <input type="hidden" name="orderId" id="modalOrderId">
          <div class="mb-3">
            <label class="form-label fw-semibold">New Status</label>
            <select name="status" id="modalStatus" class="form-select">
              <option value="PLACED">Order Placed</option>
              <option value="CONFIRMED">Confirmed</option>
              <option value="PREPARING">Preparing</option>
              <option value="OUT_FOR_DELIVERY">Out for Delivery</option>
              <option value="DELIVERED">Delivered</option>
              <option value="CANCELLED">Cancelled</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label fw-semibold">Assign Driver (optional)</label>
            <select name="driverId" class="form-select">
              <option value="">No Driver</option>
              <% if (drivers != null) { for (User d : drivers) { %>
              <option value="<%= d.getId() %>"><%= d.getName() %> (<%= d.getPhone() %>)</option>
              <% } } %>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Update Status</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('updateModal').addEventListener('show.bs.modal', function(e) {
  var btn = e.relatedTarget;
  document.getElementById('modalOrderId').value = btn.getAttribute('data-order-id');
  document.getElementById('modalStatus').value = btn.getAttribute('data-current-status');
});
</script>
</body></html>
