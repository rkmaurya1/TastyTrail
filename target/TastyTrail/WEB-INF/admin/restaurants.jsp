<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.Restaurant, java.util.List" %>
<% List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants"); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Restaurants — Admin</title>
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
  </style>
</head>
<body>
<div class="sidebar">
  <div class="sidebar-brand">Tasty<span>Trail</span><br><small style="background:#CB202D;color:white;font-size:0.65rem;padding:2px 8px;border-radius:10px;">ADMIN</small></div>
  <nav class="mt-3">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link"><i class="bi bi-bag-check"></i> Orders</a>
    <a href="${pageContext.request.contextPath}/admin/restaurants" class="nav-link active"><i class="bi bi-shop"></i> Restaurants</a>
    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><i class="bi bi-people"></i> Users</a>
    <hr style="border-color:#333;margin:12px 0;">
    <a href="${pageContext.request.contextPath}/" class="nav-link"><i class="bi bi-house"></i> View Site</a>
    <a href="${pageContext.request.contextPath}/logout" class="nav-link"><i class="bi bi-box-arrow-right"></i> Logout</a>
  </nav>
</div>

<div class="main-content">
  <div style="background:white;border-radius:12px;padding:16px 20px;margin-bottom:24px;box-shadow:0 1px 10px rgba(0,0,0,0.06);display:flex;justify-content:space-between;align-items:center;">
    <h5 class="mb-0 fw-bold"><i class="bi bi-shop me-2" style="color:#CB202D;"></i>Manage Restaurants</h5>
    <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#addModal" style="border-radius:8px;font-weight:600;">
      <i class="bi bi-plus-lg me-1"></i>Add Restaurant
    </button>
  </div>

  <% if (request.getParameter("added") != null) { %><div class="alert alert-success">Restaurant added!</div><% } %>
  <% if (request.getParameter("updated") != null) { %><div class="alert alert-success">Restaurant updated!</div><% } %>
  <% if (request.getParameter("deleted") != null) { %><div class="alert alert-warning">Restaurant deleted!</div><% } %>

  <div class="card">
    <div class="card-body p-0">
      <table class="table table-hover mb-0">
        <thead>
          <tr>
            <th class="ps-4">#</th><th>Name</th><th>Cuisine</th><th>City</th>
            <th>Rating</th><th>Delivery</th><th>Status</th><th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (restaurants != null) { for (Restaurant r : restaurants) { %>
          <tr>
            <td class="ps-4 text-muted"><%= r.getId() %></td>
            <td class="fw-semibold"><%= r.getName() %></td>
            <td style="color:#686b78;font-size:0.82rem;"><%= r.getCuisine() %></td>
            <td style="font-size:0.82rem;"><%= r.getCity() %></td>
            <td><span style="background:#d4edda;color:#155724;padding:2px 8px;border-radius:10px;font-size:0.78rem;font-weight:700;"><%= r.getRating() %>★</span></td>
            <td style="font-size:0.82rem;"><%= r.getDeliveryTime() %> min · <%= r.getDeliveryFeeDisplay() %></td>
            <td><span style="background:<%= r.isOpen() ? "#d4edda" : "#f8d7da" %>;color:<%= r.isOpen() ? "#155724" : "#721c24" %>;padding:2px 8px;border-radius:10px;font-size:0.75rem;font-weight:600;"><%= r.isOpen() ? "Open" : "Closed" %></span></td>
            <td>
              <button class="btn btn-sm btn-outline-primary me-1" style="font-size:0.75rem;border-radius:6px;"
                      data-bs-toggle="modal" data-bs-target="#editModal"
                      data-id="<%= r.getId() %>" data-name="<%= r.getName() %>"
                      data-cuisine="<%= r.getCuisine() %>" data-city="<%= r.getCity() %>"
                      data-address="<%= r.getAddress() %>" data-phone="<%= r.getPhone() %>"
                      data-dt="<%= r.getDeliveryTime() %>" data-mo="<%= r.getMinOrder() %>"
                      data-df="<%= r.getDeliveryFee() %>" data-open="<%= r.isOpen() %>"
                      data-desc="<%= r.getDescription() %>">
                Edit
              </button>
              <form action="${pageContext.request.contextPath}/admin/restaurants" method="post" style="display:inline;"
                    onsubmit="return confirm('Delete this restaurant?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= r.getId() %>">
                <button type="submit" class="btn btn-sm btn-outline-danger" style="font-size:0.75rem;border-radius:6px;">Delete</button>
              </form>
            </td>
          </tr>
          <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content" style="border-radius:12px;border:none;">
      <div class="modal-header"><h5 class="modal-title fw-bold">Add Restaurant</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form action="${pageContext.request.contextPath}/admin/restaurants" method="post">
        <input type="hidden" name="action" value="add">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label fw-semibold">Name*</label><input type="text" name="name" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label fw-semibold">Cuisine*</label><input type="text" name="cuisine" class="form-control" placeholder="e.g. Indian, Pizza" required></div>
            <div class="col-12"><label class="form-label fw-semibold">Description</label><textarea name="description" class="form-control" rows="2"></textarea></div>
            <div class="col-md-8"><label class="form-label fw-semibold">Address*</label><input type="text" name="address" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label fw-semibold">City*</label><input type="text" name="city" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label fw-semibold">Phone</label><input type="text" name="phone" class="form-control"></div>
            <div class="col-md-2"><label class="form-label fw-semibold">Delivery (min)</label><input type="number" name="deliveryTime" class="form-control" value="30"></div>
            <div class="col-md-3"><label class="form-label fw-semibold">Min Order (₹)</label><input type="number" name="minOrder" class="form-control" value="0"></div>
            <div class="col-md-3"><label class="form-label fw-semibold">Delivery Fee (₹)</label><input type="number" name="deliveryFee" class="form-control" value="0"></div>
            <div class="col-12"><div class="form-check"><input class="form-check-input" type="checkbox" name="isVeg" id="addVeg"><label class="form-check-label" for="addVeg">Pure Veg Restaurant</label></div></div>
          </div>
        </div>
        <div class="modal-footer"><button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-danger">Add Restaurant</button></div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content" style="border-radius:12px;border:none;">
      <div class="modal-header"><h5 class="modal-title fw-bold">Edit Restaurant</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <form action="${pageContext.request.contextPath}/admin/restaurants" method="post">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="id" id="editId">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label fw-semibold">Name*</label><input type="text" name="name" id="editName" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label fw-semibold">Cuisine*</label><input type="text" name="cuisine" id="editCuisine" class="form-control" required></div>
            <div class="col-12"><label class="form-label fw-semibold">Description</label><textarea name="description" id="editDesc" class="form-control" rows="2"></textarea></div>
            <div class="col-md-8"><label class="form-label fw-semibold">Address</label><input type="text" name="address" id="editAddress" class="form-control"></div>
            <div class="col-md-4"><label class="form-label fw-semibold">City</label><input type="text" name="city" id="editCity" class="form-control"></div>
            <div class="col-md-4"><label class="form-label fw-semibold">Phone</label><input type="text" name="phone" id="editPhone" class="form-control"></div>
            <div class="col-md-2"><label class="form-label fw-semibold">Delivery (min)</label><input type="number" name="deliveryTime" id="editDt" class="form-control"></div>
            <div class="col-md-3"><label class="form-label fw-semibold">Min Order</label><input type="number" name="minOrder" id="editMo" class="form-control"></div>
            <div class="col-md-3"><label class="form-label fw-semibold">Delivery Fee</label><input type="number" name="deliveryFee" id="editDf" class="form-control"></div>
            <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="isVeg" id="editVeg"><label class="form-check-label" for="editVeg">Pure Veg</label></div></div>
            <div class="col-6"><div class="form-check"><input class="form-check-input" type="checkbox" name="isClosed" id="editClosed"><label class="form-check-label" for="editClosed">Mark as Closed</label></div></div>
          </div>
        </div>
        <div class="modal-footer"><button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-primary">Save Changes</button></div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('editModal').addEventListener('show.bs.modal', function(e) {
  var b = e.relatedTarget;
  document.getElementById('editId').value = b.dataset.id;
  document.getElementById('editName').value = b.dataset.name;
  document.getElementById('editCuisine').value = b.dataset.cuisine;
  document.getElementById('editDesc').value = b.dataset.desc;
  document.getElementById('editAddress').value = b.dataset.address;
  document.getElementById('editCity').value = b.dataset.city;
  document.getElementById('editPhone').value = b.dataset.phone;
  document.getElementById('editDt').value = b.dataset.dt;
  document.getElementById('editMo').value = b.dataset.mo;
  document.getElementById('editDf').value = b.dataset.df;
  document.getElementById('editClosed').checked = b.dataset.open === 'false';
});
</script>
</body></html>
