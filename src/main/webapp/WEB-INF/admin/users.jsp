<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.User, java.util.List" %>
<% List<User> users = (List<User>) request.getAttribute("users"); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Users — Admin</title>
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
    .table th{font-size:0.78rem;text-transform:uppercase;color:#686b78;font-weight:600;background:#f9f9f9;border:none}
    .table td{font-size:0.85rem;vertical-align:middle}
    .avatar{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,#CB202D,#FC8019);color:white;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.85rem;flex-shrink:0}
  </style>
</head>
<body>
<div class="sidebar">
  <div class="sidebar-brand">Tasty<span>Trail</span><br><small style="background:#CB202D;color:white;font-size:0.65rem;padding:2px 8px;border-radius:10px;">ADMIN</small></div>
  <nav class="mt-3">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link"><i class="bi bi-bag-check"></i> Orders</a>
    <a href="${pageContext.request.contextPath}/admin/restaurants" class="nav-link"><i class="bi bi-shop"></i> Restaurants</a>
    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link active"><i class="bi bi-people"></i> Users</a>
    <hr style="border-color:#333;margin:12px 0;">
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="bi bi-house"></i> View Site</a>
    <a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="bi bi-box-arrow-right"></i> Logout</a>
  </nav>
</div>

<div class="main-content">
  <div style="background:white;border-radius:12px;padding:16px 20px;margin-bottom:24px;box-shadow:0 1px 10px rgba(0,0,0,0.06);">
    <h5 class="mb-0 fw-bold"><i class="bi bi-people me-2" style="color:#CB202D;"></i>All Users (<%= users != null ? users.size() : 0 %>)</h5>
  </div>
  <div class="card">
    <div class="card-body p-0">
      <table class="table table-hover mb-0">
        <thead>
          <tr><th class="ps-4">User</th><th>Email</th><th>Phone</th><th>City</th><th>Role</th><th>Joined</th></tr>
        </thead>
        <tbody>
          <% if (users != null) { for (User u : users) { %>
          <tr>
            <td class="ps-4">
              <div class="d-flex align-items-center gap-2">
                <div class="avatar"><%= u.getName().substring(0,1).toUpperCase() %></div>
                <span class="fw-semibold"><%= u.getName() %></span>
              </div>
            </td>
            <td style="color:#686b78;"><%= u.getEmail() %></td>
            <td style="font-size:0.82rem;"><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
            <td style="font-size:0.82rem;"><%= u.getCity() != null ? u.getCity() : "—" %></td>
            <td>
              <span style="padding:3px 10px;border-radius:20px;font-size:0.72rem;font-weight:700;
                background:<%= "ADMIN".equals(u.getRole()) ? "#f8d7da" : "DRIVER".equals(u.getRole()) ? "#d1ecf1" : "#d4edda" %>;
                color:<%= "ADMIN".equals(u.getRole()) ? "#721c24" : "DRIVER".equals(u.getRole()) ? "#0c5460" : "#155724" %>">
                <%= u.getRole() %>
              </span>
            </td>
            <td style="font-size:0.78rem;color:#686b78;">
              <%= u.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(u.getCreatedAt()) : "—" %>
            </td>
          </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
