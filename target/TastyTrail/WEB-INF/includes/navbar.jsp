<%@ page import="com.tastytrail.model.CartItem, java.util.List" %>
<%
    List<CartItem> navCart = (List<CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (navCart != null) {
        for (CartItem ci : navCart) cartCount += ci.getQuantity();
    }
    com.tastytrail.model.User navUser = (com.tastytrail.model.User) session.getAttribute("user");
    String currentUri = request.getRequestURI();
%>
<nav class="navbar navbar-expand-lg">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">
      Tasty<span>Trail</span>
    </a>
    <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMenu">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link <%= currentUri.endsWith("/") || currentUri.contains("index") ? "active" : "" %>"
             href="${pageContext.request.contextPath}/">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link <%= currentUri.contains("menu") ? "active" : "" %>"
             href="${pageContext.request.contextPath}/menu">Menu</a>
        </li>
        <% if (navUser != null) { %>
        <li class="nav-item">
          <a class="nav-link <%= currentUri.contains("orders") ? "active" : "" %>"
             href="${pageContext.request.contextPath}/orders">My Orders</a>
        </li>
        <% } %>
      </ul>

      <ul class="navbar-nav align-items-center gap-2">
        <!-- Cart -->
        <li class="nav-item">
          <a class="nav-link cart-badge" href="${pageContext.request.contextPath}/cart">
            <i class="bi bi-bag" style="font-size:1.2rem;"></i>
            <span id="navCartCount" class="cart-count" <%= cartCount == 0 ? "style='display:none;'" : "" %>>
              <%= cartCount > 0 ? cartCount : "" %>
            </span>
          </a>
        </li>

        <% if (navUser != null) { %>
        <!-- User dropdown -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#"
             data-bs-toggle="dropdown">
            <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#CB202D,#FC8019);
                        color:white;display:flex;align-items:center;justify-content:center;
                        font-weight:700;font-size:0.85rem;">
              <%= navUser.getName().substring(0,1).toUpperCase() %>
            </div>
            <span class="d-none d-lg-inline" style="font-size:0.9rem;font-weight:600;">
              <%= navUser.getName().split(" ")[0] %>
            </span>
          </a>
          <ul class="dropdown-menu dropdown-menu-end" style="border-radius:12px;box-shadow:0 8px 30px rgba(0,0,0,0.12);border:none;min-width:160px;">
            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
              <i class="bi bi-person me-2"></i>Profile</a></li>
            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders">
              <i class="bi bi-bag-check me-2"></i>My Orders</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout">
              <i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
          </ul>
        </li>
        <% } else { %>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/login"
             style="font-weight:600;">Login</a>
        </li>
        <li class="nav-item">
          <a class="nav-link btn-nav-login" href="${pageContext.request.contextPath}/register">
            Sign Up
          </a>
        </li>
        <% } %>
      </ul>
    </div>
  </div>
</nav>
