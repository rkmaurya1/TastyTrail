<footer>
  <div class="container">
    <div class="row g-5">
      <div class="col-lg-4 col-md-6">
        <div class="footer-brand">Tasty<span>Trail</span></div>
        <p style="font-size:0.92rem;color:rgba(255,255,255,0.55);line-height:1.65;margin:10px 0 22px;max-width:320px;">
          Discover the best food & drinks near you. Order fresh, eat happy.
        </p>
        <div class="d-flex gap-2">
          <a href="#" aria-label="Facebook" class="footer-social"><i class="bi bi-facebook"></i></a>
          <a href="#" aria-label="Instagram" class="footer-social"><i class="bi bi-instagram"></i></a>
          <a href="#" aria-label="Twitter" class="footer-social"><i class="bi bi-twitter-x"></i></a>
          <a href="#" aria-label="YouTube" class="footer-social"><i class="bi bi-youtube"></i></a>
        </div>
      </div>
      <div class="col-lg-2 col-md-6">
        <h5>Company</h5>
        <a href="#">About Us</a>
        <a href="#">Careers</a>
        <a href="#">Blog</a>
        <a href="#">Press</a>
      </div>
      <div class="col-lg-2 col-md-6">
        <h5>For Foodies</h5>
        <a href="${pageContext.request.contextPath}/restaurants">Restaurants</a>
        <a href="${pageContext.request.contextPath}/orders">My Orders</a>
        <a href="#">Offers</a>
        <a href="#">Help</a>
      </div>
      <div class="col-lg-4 col-md-6">
        <h5>Get the App</h5>
        <p style="font-size:0.88rem;color:rgba(255,255,255,0.55);margin-bottom:14px;line-height:1.6;">
          Order faster with our mobile app
        </p>
        <div class="d-flex gap-2 flex-wrap">
          <a href="#" class="footer-app-btn">
            <i class="bi bi-apple" style="font-size:1.4rem;"></i>
            <div><div class="footer-app-sub">Download on the</div>App Store</div>
          </a>
          <a href="#" class="footer-app-btn">
            <i class="bi bi-google-play" style="font-size:1.3rem;"></i>
            <div><div class="footer-app-sub">Get it on</div>Google Play</div>
          </a>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <p>&copy; 2024 TastyTrail. All rights reserved.</p>
    </div>
  </div>
</footer>

<style>
  .footer-social {
    width: 36px; height: 36px;
    display: inline-flex; align-items: center; justify-content: center;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.08);
    border-radius: 10px;
    color: rgba(255,255,255,0.7) !important;
    font-size: 1rem;
    transition: background 0.15s, color 0.15s, border-color 0.15s, transform 0.15s;
    margin: 0 !important;
  }
  .footer-social:hover {
    background: rgba(255,255,255,0.1);
    border-color: rgba(255,255,255,0.2);
    color: #fff !important;
    transform: translateY(-2px);
  }
  .footer-app-btn {
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.1);
    padding: 10px 18px;
    border-radius: 12px;
    display: flex; align-items: center; gap: 10px;
    color: #fff !important;
    font-size: 0.92rem;
    font-weight: 600;
    letter-spacing: -0.01em;
    line-height: 1.15;
    margin: 0 !important;
    transition: background 0.15s, border-color 0.15s, transform 0.15s;
  }
  .footer-app-btn:hover {
    background: rgba(255,255,255,0.08);
    border-color: rgba(255,255,255,0.2);
    transform: translateY(-2px);
  }
  .footer-app-sub {
    font-size: 0.66rem;
    font-weight: 500;
    letter-spacing: 0.02em;
    color: rgba(255,255,255,0.55);
    text-transform: none;
  }
</style>
