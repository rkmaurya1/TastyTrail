<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.User" %>
<%
    User profileUser = (User) session.getAttribute("user");
    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile — TastyTrail</title>
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

<div class="container my-4" style="max-width:720px;">
  <h2 style="font-weight:700;color:#1C1C1C;margin-bottom:24px;">
    <i class="bi bi-person-circle me-2" style="color:#CB202D;"></i>My Profile
  </h2>

  <% if (request.getAttribute("success") != null) { %>
  <div class="alert alert-success"><i class="bi bi-check-circle me-2"></i><%= request.getAttribute("success") %></div>
  <% } %>
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-danger"><i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %></div>
  <% } %>

  <div class="profile-card">
    <!-- Avatar + name -->
    <div class="d-flex align-items-center gap-3 mb-4 pb-4" style="border-bottom:1px solid #e8e8e8;">
      <div class="profile-avatar">
        <%= profileUser.getName().substring(0,1).toUpperCase() %>
      </div>
      <div>
        <h4 style="font-weight:700;color:#1C1C1C;margin-bottom:2px;"><%= profileUser.getName() %></h4>
        <div style="color:#686b78;font-size:0.9rem;">
          <i class="bi bi-envelope me-1"></i><%= profileUser.getEmail() %>
        </div>
        <div style="color:#686b78;font-size:0.85rem;margin-top:2px;">
          Member since <%= new java.text.SimpleDateFormat("MMMM yyyy").format(profileUser.getCreatedAt()) %>
        </div>
      </div>
    </div>

    <!-- Edit form -->
    <form action="${pageContext.request.contextPath}/profile" method="post">
      <div class="row g-3">
        <div class="col-md-6">
          <label class="form-label">Full Name</label>
          <input type="text" name="name" class="form-control"
                 value="<%= profileUser.getName() %>" required>
        </div>
        <div class="col-md-6">
          <label class="form-label">Email Address</label>
          <input type="email" class="form-control"
                 value="<%= profileUser.getEmail() %>" disabled
                 style="background:#f9f9f9;color:#686b78;">
          <div style="font-size:0.75rem;color:#aaa;margin-top:4px;">Email cannot be changed</div>
        </div>
        <div class="col-md-6">
          <label class="form-label">Phone Number</label>
          <input type="tel" name="phone" class="form-control"
                 value="<%= profileUser.getPhone() != null ? profileUser.getPhone() : "" %>"
                 placeholder="9876543210">
        </div>
        <div class="col-md-6">
          <label class="form-label">City</label>
          <select name="city" class="form-control">
            <option value="">Select city</option>
            <%
              String[] cities = {"Delhi","Mumbai","Bangalore","Chennai","Hyderabad","Kolkata","Pune","Ahmedabad","Other"};
              for (String c : cities) {
                boolean selected = c.equals(profileUser.getCity());
            %>
            <option value="<%= c %>" <%= selected ? "selected" : "" %>><%= c %></option>
            <% } %>
          </select>
        </div>
        <div class="col-12">
          <label class="form-label">Default Delivery Address</label>
          <textarea name="address" class="form-control" rows="2"
                    placeholder="Your default delivery address"><%= profileUser.getAddress() != null ? profileUser.getAddress() : "" %></textarea>
        </div>
      </div>

      <div class="d-flex gap-2 mt-4">
        <button type="submit" class="btn-primary-custom" style="width:auto;padding:10px 28px;">
          <i class="bi bi-check2 me-1"></i>Save Changes
        </button>
        <a href="${pageContext.request.contextPath}/orders" class="btn-outline-primary-custom">
          View My Orders
        </a>
      </div>
    </form>
  </div>

  <!-- Account actions -->
  <div class="profile-card mt-3">
    <h6 style="font-weight:700;color:#1C1C1C;margin-bottom:16px;">Account</h6>
    <div class="d-flex gap-2 flex-wrap">
      <a href="${pageContext.request.contextPath}/orders" class="btn-outline-primary-custom">
        <i class="bi bi-bag me-1"></i>My Orders
      </a>
      <a href="${pageContext.request.contextPath}/logout"
         style="border:1.5px solid #e8e8e8;color:#CB202D;background:transparent;
                border-radius:8px;padding:8px 20px;font-weight:600;font-family:Poppins,sans-serif;
                cursor:pointer;transition:all 0.2s;font-size:0.9rem;text-decoration:none;">
        <i class="bi bi-box-arrow-right me-1"></i>Logout
      </a>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
