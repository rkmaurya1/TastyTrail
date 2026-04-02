<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign Up — TastyTrail</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="container py-3">
  <div class="row justify-content-center">
    <div class="col-md-6 col-sm-10">
      <div class="auth-card">

        <div class="text-center mb-4">
          <a href="${pageContext.request.contextPath}/" class="auth-logo d-block">
            Tasty<span>Trail</span>
          </a>
          <h2>Create account</h2>
          <p class="subtitle">Join thousands of food lovers today</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
          <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post" novalidate>

          <div class="row g-3 mb-3">
            <div class="col-12">
              <label class="form-label">Full Name <span style="color:#CB202D;">*</span></label>
              <input type="text" name="name" class="form-control" placeholder="Ravi Sharma"
                     value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>"
                     required>
            </div>

            <div class="col-12">
              <label class="form-label">Email Address <span style="color:#CB202D;">*</span></label>
              <input type="email" name="email" class="form-control" placeholder="ravi@example.com"
                     value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                     required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Phone Number</label>
              <input type="tel" name="phone" class="form-control" placeholder="9876543210"
                     value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
            </div>

            <div class="col-md-6">
              <label class="form-label">City</label>
              <select name="city" class="form-control">
                <option value="">Select city</option>
                <option value="Delhi">Delhi</option>
                <option value="Mumbai">Mumbai</option>
                <option value="Bangalore">Bangalore</option>
                <option value="Chennai">Chennai</option>
                <option value="Hyderabad">Hyderabad</option>
                <option value="Kolkata">Kolkata</option>
                <option value="Pune">Pune</option>
                <option value="Ahmedabad">Ahmedabad</option>
                <option value="Other">Other</option>
              </select>
            </div>

            <div class="col-md-6">
              <label class="form-label">Password <span style="color:#CB202D;">*</span></label>
              <div class="input-group">
                <input type="password" name="password" id="passInput" class="form-control border-end-0"
                       placeholder="Min. 6 characters" required>
                <span class="input-group-text bg-white" style="cursor:pointer;" onclick="togglePass('passInput','eyePass')">
                  <i class="bi bi-eye" id="eyePass" style="color:#aaa;"></i>
                </span>
              </div>
            </div>

            <div class="col-md-6">
              <label class="form-label">Confirm Password <span style="color:#CB202D;">*</span></label>
              <div class="input-group">
                <input type="password" name="confirmPassword" id="confirmInput"
                       class="form-control border-end-0" placeholder="Repeat password" required>
                <span class="input-group-text bg-white" style="cursor:pointer;" onclick="togglePass('confirmInput','eyeConfirm')">
                  <i class="bi bi-eye" id="eyeConfirm" style="color:#aaa;"></i>
                </span>
              </div>
            </div>
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="termsCheck" required>
            <label class="form-check-label" for="termsCheck" style="font-size:0.85rem;color:#686b78;">
              I agree to the <a href="#" style="color:#CB202D;">Terms of Service</a> and
              <a href="#" style="color:#CB202D;">Privacy Policy</a>
            </label>
          </div>

          <button type="submit" class="btn-primary-custom">
            Create Account <i class="bi bi-arrow-right ms-2"></i>
          </button>
        </form>

        <div class="auth-divider my-4"><span>OR</span></div>

        <p class="text-center" style="font-size:0.9rem;color:#686b78;">
          Already have an account?
          <a href="${pageContext.request.contextPath}/login"
             style="color:#CB202D;font-weight:600;">Login here</a>
        </p>

      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function togglePass(inputId, iconId) {
  var input = document.getElementById(inputId);
  var icon = document.getElementById(iconId);
  input.type = input.type === 'password' ? 'text' : 'password';
  icon.className = input.type === 'text' ? 'bi bi-eye-slash' : 'bi bi-eye';
}
</script>
</body>
</html>
