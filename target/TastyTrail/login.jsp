<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login — TastyTrail</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="container">
  <div class="row justify-content-center">
    <div class="col-md-5 col-sm-10">
      <div class="auth-card">

        <!-- Logo -->
        <div class="text-center mb-4">
          <a href="${pageContext.request.contextPath}/" class="auth-logo d-block">
            Tasty<span>Trail</span>
          </a>
          <h2>Welcome back!</h2>
          <p class="subtitle">Login to order your favourite food</p>
        </div>

        <!-- Alerts -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
          <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
        </div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
          <i class="bi bi-check-circle me-2"></i><%= request.getAttribute("success") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
          <input type="hidden" name="redirect" value="${param.redirect}">

          <div class="mb-3">
            <label class="form-label">Email Address</label>
            <div class="input-group">
              <span class="input-group-text border-end-0 bg-white"
                    style="border-color:#e8e8e8;">
                <i class="bi bi-envelope" style="color:#aaa;"></i>
              </span>
              <input type="email" name="email" class="form-control border-start-0 ps-0"
                     placeholder="you@example.com"
                     value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                     required style="border-color:#e8e8e8;">
            </div>
          </div>

          <div class="mb-4">
            <label class="form-label">Password</label>
            <div class="input-group">
              <span class="input-group-text border-end-0 bg-white"
                    style="border-color:#e8e8e8;">
                <i class="bi bi-lock" style="color:#aaa;"></i>
              </span>
              <input type="password" name="password" id="passwordInput"
                     class="form-control border-start-0 border-end-0 ps-0"
                     placeholder="Your password" required style="border-color:#e8e8e8;">
              <span class="input-group-text bg-white" style="border-color:#e8e8e8;cursor:pointer;"
                    onclick="togglePassword()">
                <i class="bi bi-eye" id="eyeIcon" style="color:#aaa;"></i>
              </span>
            </div>
          </div>

          <button type="submit" class="btn-primary-custom">
            Login <i class="bi bi-arrow-right ms-2"></i>
          </button>
        </form>

        <div class="auth-divider my-4">
          <span>OR</span>
        </div>

        <p class="text-center" style="font-size:0.9rem;color:#686b78;">
          Don't have an account?
          <a href="${pageContext.request.contextPath}/register"
             style="color:#CB202D;font-weight:600;">Sign up for free</a>
        </p>

        <p class="text-center mt-3">
          <a href="${pageContext.request.contextPath}/"
             style="color:#aaa;font-size:0.85rem;">
            <i class="bi bi-arrow-left me-1"></i>Back to Home
          </a>
        </p>

      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function togglePassword() {
  var input = document.getElementById('passwordInput');
  var icon = document.getElementById('eyeIcon');
  if (input.type === 'password') {
    input.type = 'text';
    icon.className = 'bi bi-eye-slash';
  } else {
    input.type = 'password';
    icon.className = 'bi bi-eye';
  }
}
</script>
</body>
</html>
