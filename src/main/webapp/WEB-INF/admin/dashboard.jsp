<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Order, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard — TastyTrail</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    * { font-family: 'Poppins', sans-serif; }
    body { background: #f0f2f5; }
    .sidebar { width: 240px; min-height: 100vh; background: #1C1C1C; position: fixed; top: 0; left: 0; z-index: 100; }
    .sidebar-brand { padding: 20px; font-size: 1.3rem; font-weight: 700; color: #CB202D; border-bottom: 1px solid #333; }
    .sidebar-brand span { color: #FC8019; }
    .sidebar .badge-role { background: #CB202D; color: white; font-size: 0.65rem; padding: 2px 8px; border-radius: 10px; }
    .sidebar .nav-link { color: rgba(255,255,255,0.65); padding: 10px 20px; display: flex; align-items: center; gap: 10px; transition: all 0.2s; font-size: 0.9rem; }
    .sidebar .nav-link:hover, .sidebar .nav-link.active { color: white; background: rgba(203,32,45,0.15); border-left: 3px solid #CB202D; }
    .sidebar .nav-link i { font-size: 1rem; width: 20px; }
    .main-content { margin-left: 240px; padding: 30px; }
    .topbar { background: white; border-radius: 12px; padding: 16px 20px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 10px rgba(0,0,0,0.06); }
    .stat-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 1px 10px rgba(0,0,0,0.06); height: 100%; }
    .stat-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; }
    .stat-num { font-size: 1.8rem; font-weight: 700; color: #1C1C1C; }
    .stat-label { font-size: 0.82rem; color: #686b78; }
    .table th { font-size: 0.8rem; text-transform: uppercase; color: #686b78; font-weight: 600; border: none; background: #f9f9f9; }
    .table td { font-size: 0.87rem; vertical-align: middle; }
    .card { border: none; border-radius: 12px; box-shadow: 0 1px 10px rgba(0,0,0,0.06); }
    .card-header { background: white; border-bottom: 1px solid #f0f0f0; border-radius: 12px 12px 0 0 !important; padding: 16px 20px; font-weight: 700; }
  </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
  <div class="sidebar-brand">Tasty<span>Trail</span><br><small class="badge-role">ADMIN</small></div>
  <nav class="mt-3">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
      <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link">
      <i class="bi bi-bag-check"></i> Orders
    </a>
    <a href="${pageContext.request.contextPath}/admin/restaurants" class="nav-link">
      <i class="bi bi-shop"></i> Restaurants
    </a>
    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
      <i class="bi bi-people"></i> Users
    </a>
    <hr style="border-color:#333;margin:12px 0;">
    <a href="${pageContext.request.contextPath}/" class="nav-link">
      <i class="bi bi-house"></i> View Site
    </a>
    <a href="${pageContext.request.contextPath}/logout" class="nav-link">
      <i class="bi bi-box-arrow-right"></i> Logout
    </a>
  </nav>
</div>

<!-- Main Content -->
<div class="main-content">
  <!-- Topbar -->
  <div class="topbar">
    <div>
      <h5 class="mb-0 fw-bold">Dashboard</h5>
      <small style="color:#686b78;">Welcome back, Admin!</small>
    </div>
    <div style="font-size:0.85rem;color:#686b78;">
      <i class="bi bi-calendar me-1"></i>
      <%= new java.text.SimpleDateFormat("dd MMMM yyyy").format(new java.util.Date()) %>
    </div>
  </div>

  <!-- Stat Cards -->
  <div class="row g-3 mb-4">
    <div class="col-lg-3 col-md-6">
      <div class="stat-card">
        <div class="d-flex justify-content-between align-items-start">
          <div>
            <div class="stat-num"><%= request.getAttribute("totalOrders") %></div>
            <div class="stat-label">Total Orders</div>
          </div>
          <div class="stat-icon" style="background:#fff3f3;color:#CB202D;">
            <i class="bi bi-bag-check"></i>
          </div>
        </div>
        <div style="margin-top:12px;font-size:0.78rem;color:#3d9970;">
          <i class="bi bi-arrow-up-short"></i> All time
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6">
      <div class="stat-card">
        <div class="d-flex justify-content-between align-items-start">
          <div>
            <div class="stat-num">₹<%= request.getAttribute("totalRevenue") %></div>
            <div class="stat-label">Total Revenue</div>
          </div>
          <div class="stat-icon" style="background:#e8f5e9;color:#3d9970;">
            <i class="bi bi-currency-rupee"></i>
          </div>
        </div>
        <div style="margin-top:12px;font-size:0.78rem;color:#3d9970;">
          <i class="bi bi-arrow-up-short"></i> Delivered orders
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6">
      <div class="stat-card">
        <div class="d-flex justify-content-between align-items-start">
          <div>
            <div class="stat-num"><%= request.getAttribute("totalRestaurants") %></div>
            <div class="stat-label">Restaurants</div>
          </div>
          <div class="stat-icon" style="background:#fff8e1;color:#f59e0b;">
            <i class="bi bi-shop"></i>
          </div>
        </div>
        <div style="margin-top:12px;font-size:0.78rem;color:#686b78;">Active restaurants</div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6">
      <div class="stat-card">
        <div class="d-flex justify-content-between align-items-start">
          <div>
            <div class="stat-num"><%= request.getAttribute("totalUsers") %></div>
            <div class="stat-label">Total Users</div>
          </div>
          <div class="stat-icon" style="background:#e8f0fe;color:#4285f4;">
            <i class="bi bi-people"></i>
          </div>
        </div>
        <div style="margin-top:12px;font-size:0.78rem;color:#686b78;">Registered users</div>
      </div>
    </div>
  </div>

  <!-- Recent Orders -->
  <div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
      <span><i class="bi bi-clock-history me-2" style="color:#CB202D;"></i>Recent Orders</span>
      <a href="${pageContext.request.contextPath}/admin/orders" style="font-size:0.85rem;color:#CB202D;text-decoration:none;font-weight:600;">View All</a>
    </div>
    <div class="card-body p-0">
      <table class="table table-hover mb-0">
        <thead>
          <tr>
            <th class="ps-4">Order ID</th>
            <th>Customer</th>
            <th>Restaurant</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          <% List<Order> recent = (List<Order>) request.getAttribute("recentOrders");
             if (recent != null) { for (Order o : recent) { %>
          <tr>
            <td class="ps-4 fw-semibold">#<%= o.getId() %></td>
            <td>User #<%= o.getUserId() %></td>
            <td><%= o.getRestaurantName() %></td>
            <td class="fw-semibold"><%= o.getTotalFormatted() %></td>
            <td><span class="order-status-badge status-<%= o.getStatus() %>"
                      style="padding:3px 10px;border-radius:20px;font-size:0.72rem;font-weight:700;">
              <%= o.getStatusDisplay() %>
            </span></td>
            <td style="color:#686b78;font-size:0.82rem;">
              <%= new java.text.SimpleDateFormat("dd MMM, HH:mm").format(o.getCreatedAt()) %>
            </td>
          </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<style>
  .status-PLACED{background:#fff3cd;color:#856404}
  .status-CONFIRMED{background:#cce5ff;color:#004085}
  .status-PREPARING{background:#d4edda;color:#155724}
  .status-OUT_FOR_DELIVERY{background:#d1ecf1;color:#0c5460}
  .status-DELIVERED{background:#d4edda;color:#155724}
  .status-CANCELLED{background:#f8d7da;color:#721c24}
</style>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
