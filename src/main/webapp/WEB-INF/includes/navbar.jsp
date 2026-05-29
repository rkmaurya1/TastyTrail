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

    <!-- Location Selector -->
    <button class="loc-btn d-none d-lg-flex" id="locationBtn" onclick="openLocationModal()">
      <i class="bi bi-geo-alt-fill" style="color:#CB202D;"></i>
      <div class="loc-btn-text">
        <span class="loc-label">Deliver to</span>
        <span class="loc-value" id="navLocationText">Select Location</span>
      </div>
      <i class="bi bi-chevron-down" style="font-size:0.75rem;color:#686b78;"></i>
    </button>
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
             href="${pageContext.request.contextPath}/menu">Our Menu</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/#categories">Foods</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/#about">About Us</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/#contact">Contact Us</a>
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
            <div style="width:34px;height:34px;border-radius:50%;
                        background:linear-gradient(135deg,#1F2330 0%,#0F1115 100%);
                        color:#fff;display:flex;align-items:center;justify-content:center;
                        font-weight:600;font-size:0.86rem;letter-spacing:-0.01em;
                        box-shadow:0 1px 2px rgba(0,0,0,0.08),0 4px 12px rgba(0,0,0,0.08);">
              <%= navUser.getName().substring(0,1).toUpperCase() %>
            </div>
            <span class="d-none d-lg-inline" style="font-size:0.9rem;font-weight:600;letter-spacing:-0.01em;">
              <%= navUser.getName().split(" ")[0] %>
            </span>
          </a>
          <ul class="dropdown-menu dropdown-menu-end"
              style="border-radius:14px;box-shadow:0 12px 40px rgba(15,17,21,0.14);
                     border:1px solid #ECEEF1;min-width:180px;padding:6px;">
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

<!-- ===== LOCATION MODAL ===== -->
<div id="locationModal" class="loc-modal-overlay" onclick="closeLocationModal(event)">
  <div class="loc-modal-box">
    <div class="loc-modal-header">
      <h5><i class="bi bi-geo-alt-fill me-2" style="color:#CB202D;"></i>Choose Delivery Location</h5>
      <button onclick="closeLocationModal()" class="loc-modal-close">&times;</button>
    </div>
    <div class="loc-modal-body">
      <button class="loc-gps-btn" onclick="detectLocation()">
        <i class="bi bi-crosshair2"></i>
        Use my current location
      </button>
      <div class="loc-divider"><span>or enter manually</span></div>
      <div class="loc-input-wrap">
        <i class="bi bi-search loc-input-icon"></i>
        <input type="text" id="locationInput" class="loc-input"
               placeholder="Search city, area or pincode..."
               oninput="filterLocations(this.value)">
      </div>
      <div id="locationSuggestions" class="loc-suggestions"></div>
      <div class="loc-popular">
        <p class="loc-popular-label">Popular Cities</p>
        <div class="loc-chips">
          <button class="loc-chip" onclick="selectLocation('New Delhi')">New Delhi</button>
          <button class="loc-chip" onclick="selectLocation('Mumbai')">Mumbai</button>
          <button class="loc-chip" onclick="selectLocation('Bengaluru')">Bengaluru</button>
          <button class="loc-chip" onclick="selectLocation('Hyderabad')">Hyderabad</button>
          <button class="loc-chip" onclick="selectLocation('Pune')">Pune</button>
          <button class="loc-chip" onclick="selectLocation('Chennai')">Chennai</button>
          <button class="loc-chip" onclick="selectLocation('Kolkata')">Kolkata</button>
          <button class="loc-chip" onclick="selectLocation('Ahmedabad')">Ahmedabad</button>
        </div>
      </div>
    </div>
    <div class="loc-modal-footer">
      <span id="locSelectedPreview" class="loc-selected-preview"></span>
      <button class="loc-confirm-btn" id="locConfirmBtn" onclick="confirmLocation()" disabled>
        Confirm Location
      </button>
    </div>
  </div>
</div>

<script>
(function() {
  var saved = localStorage.getItem('tastytrail_location');
  if (saved) document.getElementById('navLocationText').textContent = saved;
})();

var pendingLocation = null;

function openLocationModal() {
  document.getElementById('locationModal').classList.add('active');
  setTimeout(function() { document.getElementById('locationInput').focus(); }, 200);
}

function closeLocationModal(e) {
  if (!e || e.target === document.getElementById('locationModal')) {
    document.getElementById('locationModal').classList.remove('active');
    pendingLocation = null;
    document.getElementById('locSelectedPreview').textContent = '';
    document.getElementById('locConfirmBtn').disabled = true;
    document.getElementById('locationInput').value = '';
    document.getElementById('locationSuggestions').innerHTML = '';
  }
}

function selectLocation(loc) {
  pendingLocation = loc;
  document.getElementById('locSelectedPreview').textContent = '\uD83D\uDCCD ' + loc;
  document.getElementById('locConfirmBtn').disabled = false;
  document.getElementById('locationInput').value = loc;
  document.getElementById('locationSuggestions').innerHTML = '';
}

function confirmLocation() {
  if (!pendingLocation) return;
  localStorage.setItem('tastytrail_location', pendingLocation);
  document.getElementById('navLocationText').textContent = pendingLocation;
  document.getElementById('locationModal').classList.remove('active');
  // Update "Our Location" card if present on page
  var contactEl = document.getElementById('contactLocationText');
  if (contactEl) contactEl.innerHTML = pendingLocation;
  var dirLink = document.getElementById('contactDirectionsLink');
  if (dirLink) dirLink.href = 'https://www.google.com/maps/search/?api=1&query=' + encodeURIComponent(pendingLocation);
  window.dispatchEvent(new Event('locationUpdated'));
  pendingLocation = null;
}

function filterLocations(val) {
  var cities = ['New Delhi','Mumbai','Bengaluru','Hyderabad','Pune','Chennai','Kolkata','Ahmedabad',
                'Jaipur','Lucknow','Chandigarh','Noida','Gurgaon','Indore','Bhopal','Surat'];
  var box = document.getElementById('locationSuggestions');
  if (!val.trim()) { box.innerHTML = ''; return; }
  var matches = cities.filter(function(c) { return c.toLowerCase().includes(val.toLowerCase()); });
  if (!matches.length) matches = [val];
  box.innerHTML = matches.map(function(c) {
    return '<div class="loc-suggestion-item" onclick="selectLocation(\'' + c.replace(/'/g,"\\'") + '\')">'
         + '<i class="bi bi-geo-alt me-2" style="color:#CB202D;"></i>' + c + '</div>';
  }).join('');
}

function detectLocation() {
  if (!navigator.geolocation) { alert('Geolocation not supported'); return; }
  var btn = document.querySelector('.loc-gps-btn');
  btn.innerHTML = '<i class="bi bi-arrow-repeat"></i> Detecting...';
  btn.disabled = true;
  navigator.geolocation.getCurrentPosition(function(pos) {
    fetch('https://nominatim.openstreetmap.org/reverse?lat=' + pos.coords.latitude
          + '&lon=' + pos.coords.longitude + '&format=json')
      .then(function(r) { return r.json(); })
      .then(function(d) {
        var loc = d.address.city || d.address.town || d.address.village || d.address.state || 'Your Location';
        selectLocation(loc);
        btn.innerHTML = '<i class="bi bi-crosshair2"></i> Use my current location';
        btn.disabled = false;
      });
  }, function() {
    btn.innerHTML = '<i class="bi bi-crosshair2"></i> Use my current location';
    btn.disabled = false;
    alert('Could not detect location. Please enter manually.');
  });
}
</script>
