<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tastytrail.model.CartItem, com.tastytrail.model.User,
                 com.tastytrail.dao.RestaurantDAO, com.tastytrail.model.Restaurant, java.util.List" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    Integer cartRestaurantId = (Integer) session.getAttribute("cartRestaurantId");
    User cartUser = (User) session.getAttribute("user");

    double subtotal = 0;
    int deliveryFee = 0;
    Restaurant cartRestaurant = null;

    if (cart != null && !cart.isEmpty()) {
        for (CartItem ci : cart) subtotal += ci.getSubtotal();
        if (cartRestaurantId != null) {
            RestaurantDAO rdao = new RestaurantDAO();
            cartRestaurant = rdao.getRestaurantById(cartRestaurantId);
            if (cartRestaurant != null) deliveryFee = cartRestaurant.getDeliveryFee();
        }
    }

    double taxes = Math.round(subtotal * 0.05);
    double total = subtotal + deliveryFee + taxes;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your Cart — TastyTrail</title>
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

<div class="container my-4">
  <h2 style="font-weight:700;color:#1C1C1C;margin-bottom:24px;">
    <i class="bi bi-bag me-2" style="color:#CB202D;"></i>Your Cart
  </h2>

  <!-- Error message -->
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
  <% } %>

  <!-- Empty cart -->
  <div id="empty-cart-section" style="<%= (cart == null || cart.isEmpty()) ? "" : "display:none;" %>">
    <div class="empty-cart">
      <div class="icon">🛒</div>
      <h4>Your cart is empty</h4>
      <p>Add items from a restaurant to get started!</p>
      <a href="${pageContext.request.contextPath}/restaurants"
         class="btn-primary-custom" style="display:inline-block;padding:12px 32px;
         border-radius:8px;margin-top:16px;text-decoration:none;color:white;background:#CB202D;">
        Browse Restaurants
      </a>
    </div>
  </div>

  <!-- Cart content -->
  <div id="cart-items-section" style="<%= (cart == null || cart.isEmpty()) ? "display:none;" : "" %>">
    <div class="row g-4">
      <!-- Cart Items -->
      <div class="col-lg-8">

        <!-- Restaurant info -->
        <% if (cartRestaurant != null) { %>
        <div style="background:white;border-radius:12px;padding:14px 16px;margin-bottom:16px;
                    box-shadow:0 1px 8px rgba(0,0,0,0.06);display:flex;align-items:center;gap:12px;">
          <div style="font-size:1.5rem;">🏪</div>
          <div>
            <div style="font-weight:700;color:#1C1C1C;font-size:0.95rem;"><%= cartRestaurant.getName() %></div>
            <div style="font-size:0.8rem;color:#686b78;"><%= cartRestaurant.getCuisine() %></div>
          </div>
          <a href="${pageContext.request.contextPath}/menu?id=<%= cartRestaurant.getId() %>"
             class="ms-auto" style="color:#CB202D;font-size:0.85rem;font-weight:600;text-decoration:none;">
            + Add more items
          </a>
        </div>
        <% } %>

        <!-- Cart items list -->
        <% if (cart != null) { for (CartItem item : cart) { %>
        <div class="cart-item-row" data-item-id="<%= item.getMenuItemId() %>"
             data-unit-price="<%= item.getPrice() %>">
          <div style="font-size:1.8rem;flex-shrink:0;">
            <%= item.isVeg() ? "🥗" : "🍗" %>
          </div>
          <div class="cart-item-details">
            <div class="cart-item-name">
              <span class="veg-dot <%= item.isVeg() ? "veg" : "non-veg" %>"
                    style="width:12px;height:12px;display:inline-flex;margin-right:6px;vertical-align:middle;"></span>
              <%= item.getName() %>
            </div>
            <div class="cart-item-price"><%= item.getPriceFormatted() %> per item</div>
          </div>

          <!-- Qty control -->
          <div class="qty-control" style="border-color:#CB202D;">
            <button class="qty-btn cart-qty-minus" style="width:32px;height:36px;">−</button>
            <span class="cart-qty-num" style="min-width:24px;text-align:center;font-weight:700;color:#CB202D;">
              <%= item.getQuantity() %>
            </span>
            <button class="qty-btn cart-qty-plus" style="width:32px;height:36px;">+</button>
          </div>

          <div class="cart-item-subtotal"><%= item.getSubtotalFormatted() %></div>

          <button class="btn-cart-remove" title="Remove"
                  style="background:none;border:none;color:#aaa;cursor:pointer;padding:4px;font-size:1rem;">
            <i class="bi bi-x-circle"></i>
          </button>
        </div>
        <% } } %>

        <!-- Delivery note -->
        <div style="background:#fff8e1;border-radius:10px;padding:12px 16px;margin-top:8px;
                    font-size:0.85rem;color:#856404;display:flex;align-items:center;gap:8px;">
          <i class="bi bi-info-circle-fill"></i>
          Free cancellation within 2 minutes of ordering. After that, standard cancellation policy applies.
        </div>
      </div>

      <!-- Cart Summary + Checkout -->
      <div class="col-lg-4">
        <div class="cart-summary">
          <h5>Order Summary</h5>

          <div class="summary-row">
            <span>Item Total</span>
            <span id="subtotal-val">₹<%= Math.round(subtotal) %></span>
          </div>
          <div class="summary-row">
            <span>Delivery Fee</span>
            <span id="delivery-fee-val" style="<%= deliveryFee==0 ? "color:#3d9970;" : "" %>">
              <%= deliveryFee==0 ? "FREE" : "₹"+deliveryFee %>
            </span>
          </div>
          <div class="summary-row">
            <span>Taxes (5%)</span>
            <span id="taxes-val">₹<%= Math.round(taxes) %></span>
          </div>
          <div class="summary-row total">
            <span>Total</span>
            <span id="total-val">₹<%= Math.round(total) %></span>
          </div>

          <!-- Savings note -->
          <% if (deliveryFee == 0) { %>
          <div style="background:#d4edda;border-radius:8px;padding:8px 12px;
                      font-size:0.8rem;color:#155724;text-align:center;margin-top:8px;">
            🎉 You're saving on delivery!
          </div>
          <% } %>

          <!-- Checkout -->
          <% if (cartUser != null) { %>
          <button type="button" class="btn-place-order" data-bs-toggle="modal" data-bs-target="#checkoutModal">
            <i class="bi bi-bag-check me-2"></i>Proceed to Checkout
          </button>
          <% } else { %>
          <a href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}/cart"
             class="btn-place-order" style="display:block;text-align:center;text-decoration:none;
             background:#CB202D;color:white;padding:14px;border-radius:12px;font-weight:700;margin-top:16px;">
            Login to Checkout
          </a>
          <% } %>
        </div>

        <!-- Promo code box -->
        <div style="background:white;border-radius:12px;padding:16px;box-shadow:0 1px 8px rgba(0,0,0,0.06);margin-top:12px;">
          <h6 style="font-weight:700;font-size:0.9rem;margin-bottom:10px;">
            <i class="bi bi-tag me-2" style="color:#CB202D;"></i>Apply Promo Code
          </h6>
          <div style="display:flex;gap:8px;">
            <input type="text" class="form-control" placeholder="Enter code" style="font-size:0.85rem;">
            <button class="btn-outline-primary-custom" style="font-size:0.85rem;white-space:nowrap;">Apply</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Checkout Modal -->
<div class="modal fade" id="checkoutModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fw-bold">
          <i class="bi bi-bag-check me-2" style="color:#CB202D;"></i>Checkout
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/orders" method="post" id="checkoutForm">
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label fw-semibold">Delivery Address</label>
            <textarea name="deliveryAddress" id="deliveryAddress" class="form-control" rows="3"
                      placeholder="Enter your full delivery address" required
                      style="font-size:0.9rem;"><%= cartUser != null && cartUser.getAddress() != null ? cartUser.getAddress() : "" %></textarea>
          </div>

          <div class="mb-3">
            <label class="form-label fw-semibold">Payment Method</label>
            <div class="d-flex gap-2 flex-wrap">
              <label style="flex:1;min-width:100px;border:1.5px solid #e8e8e8;border-radius:8px;
                            padding:12px;cursor:pointer;text-align:center;font-size:0.85rem;">
                <input type="radio" name="paymentMethod" value="COD" checked style="margin-right:6px;">
                💵 Cash on Delivery
              </label>
              <label style="flex:1;min-width:100px;border:1.5px solid #e8e8e8;border-radius:8px;
                            padding:12px;cursor:pointer;text-align:center;font-size:0.85rem;">
                <input type="radio" name="paymentMethod" value="UPI" style="margin-right:6px;">
                📱 UPI
              </label>
              <label style="flex:1;min-width:100px;border:1.5px solid #e8e8e8;border-radius:8px;
                            padding:12px;cursor:pointer;text-align:center;font-size:0.85rem;">
                <input type="radio" name="paymentMethod" value="CARD" style="margin-right:6px;">
                💳 Card
              </label>
            </div>
          </div>

          <div style="background:#f9f9f9;border-radius:8px;padding:12px 16px;">
            <div style="display:flex;justify-content:space-between;font-size:0.85rem;color:#686b78;margin-bottom:6px;">
              <span>Item Total</span><span>₹<%= Math.round(subtotal) %></span>
            </div>
            <div style="display:flex;justify-content:space-between;font-size:0.85rem;color:#686b78;margin-bottom:6px;">
              <span>Delivery</span><span><%= deliveryFee==0 ? "FREE" : "₹"+deliveryFee %></span>
            </div>
            <div style="display:flex;justify-content:space-between;font-size:0.85rem;color:#686b78;margin-bottom:8px;">
              <span>Taxes</span><span>₹<%= Math.round(taxes) %></span>
            </div>
            <div style="display:flex;justify-content:space-between;font-weight:700;color:#1C1C1C;">
              <span>Total</span><span>₹<%= Math.round(total) %></span>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn-place-order" style="width:auto;padding:10px 30px;margin-top:0;">
            <i class="bi bi-check-circle me-1"></i>Place Order · ₹<%= Math.round(total) %>
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
