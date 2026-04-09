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
    .role-select{font-size:0.78rem;padding:3px 8px;border-radius:20px;border:1px solid #dee2e6;cursor:pointer;font-weight:600}
    .btn-save-role{font-size:0.75rem;padding:3px 10px;border-radius:20px}
    .btn-delete{font-size:0.75rem;padding:3px 10px;border-radius:20px}
    .toast-container{position:fixed;top:20px;right:20px;z-index:9999}
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

  <!-- Toast notifications -->
  <div class="toast-container">
    <% if ("true".equals(request.getParameter("roleUpdated"))) { %>
    <div class="toast align-items-center text-bg-success border-0 show" role="alert">
      <div class="d-flex"><div class="toast-body"><i class="bi bi-check-circle me-2"></i>Role updated successfully</div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
    </div>
    <% } else if ("true".equals(request.getParameter("deleted"))) { %>
    <div class="toast align-items-center text-bg-danger border-0 show" role="alert">
      <div class="d-flex"><div class="toast-body"><i class="bi bi-trash me-2"></i>User deleted successfully</div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
    </div>
    <% } %>
  </div>

  <!-- Header -->
  <div style="background:white;border-radius:12px;padding:16px 20px;margin-bottom:24px;box-shadow:0 1px 10px rgba(0,0,0,0.06);display:flex;align-items:center;justify-content:space-between;">
    <h5 class="mb-0 fw-bold"><i class="bi bi-people me-2" style="color:#CB202D;"></i>All Users (<%= users != null ? users.size() : 0 %>)</h5>
    <!-- Search Bar -->
    <div style="position:relative;width:280px;">
      <i class="bi bi-search" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:#686b78;font-size:0.85rem;"></i>
      <input type="text" id="searchInput" class="form-control form-control-sm"
             placeholder="Search by name, email, city..."
             style="padding-left:34px;border-radius:20px;border:1px solid #dee2e6;font-size:0.85rem;"
             oninput="filterUsers()">
    </div>
  </div>

  <div class="card">
    <div class="card-body p-0">
      <table class="table table-hover mb-0" id="usersTable">
        <thead>
          <tr>
            <th class="ps-4">User</th>
            <th>Email</th>
            <th>Phone</th>
            <th>City</th>
            <th>Role</th>
            <th>Joined</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (users != null) { for (User u : users) {
               String role = u.getRole();
               String roleBg = "ADMIN".equals(role) ? "#f8d7da" : "DRIVER".equals(role) ? "#d1ecf1" : "OWNER".equals(role) ? "#fff3cd" : "#d4edda";
               String roleColor = "ADMIN".equals(role) ? "#721c24" : "DRIVER".equals(role) ? "#0c5460" : "OWNER".equals(role) ? "#856404" : "#155724";
          %>
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
              <span style="padding:3px 10px;border-radius:20px;font-size:0.72rem;font-weight:700;background:<%= roleBg %>;color:<%= roleColor %>">
                <%= role %>
              </span>
            </td>
            <td style="font-size:0.78rem;color:#686b78;">
              <%= u.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(u.getCreatedAt()) : "—" %>
            </td>
            <td>
              <div class="d-flex align-items-center gap-2">
                <!-- Change Role -->
                <form method="post" action="${pageContext.request.contextPath}/admin/users" class="d-flex align-items-center gap-1">
                  <input type="hidden" name="action" value="changeRole">
                  <input type="hidden" name="userId" value="<%= u.getId() %>">
                  <select name="role" class="role-select">
                    <option value="USER" <%= "USER".equals(role) ? "selected" : "" %>>USER</option>
                    <option value="DRIVER" <%= "DRIVER".equals(role) ? "selected" : "" %>>DRIVER</option>
                    <option value="OWNER" <%= "OWNER".equals(role) ? "selected" : "" %>>OWNER</option>
                    <option value="ADMIN" <%= "ADMIN".equals(role) ? "selected" : "" %>>ADMIN</option>
                  </select>
                  <button type="submit" class="btn btn-sm btn-outline-primary btn-save-role">
                    <i class="bi bi-check2"></i>
                  </button>
                </form>
                <!-- Delete -->
                <form method="post" action="${pageContext.request.contextPath}/admin/users"
                      onsubmit="return confirm('Delete <%= u.getName() %>? This cannot be undone.')">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="userId" value="<%= u.getId() %>">
                  <button type="submit" class="btn btn-sm btn-outline-danger btn-delete">
                    <i class="bi bi-trash"></i>
                  </button>
                </form>
              </div>
            </td>
          </tr>
          <% } } %>
        </tbody>
      </table>
      <div id="noResults" style="display:none;padding:30px;text-align:center;color:#686b78;font-size:0.88rem;">
        <i class="bi bi-search me-2"></i>No users found
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function filterUsers() {
  const q = document.getElementById('searchInput').value.toLowerCase();
  const rows = document.querySelectorAll('#usersTable tbody tr');
  let visible = 0;
  rows.forEach(row => {
    const text = row.textContent.toLowerCase();
    const show = text.includes(q);
    row.style.display = show ? '' : 'none';
    if (show) visible++;
  });
  document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
}

// Auto-hide toasts
document.querySelectorAll('.toast').forEach(t => {
  setTimeout(() => t.classList.remove('show'), 3000);
});
</script>
</body></html>
