/* =============================================
   TastyTrail — Main JavaScript
   ============================================= */

$(document).ready(function () {

  // Hide page loader
  setTimeout(function () {
    $('.page-loader').fadeOut(300);
  }, 400);

  // Initialize cart count from session (via data attribute on body)
  updateNavCartCount();

  // =============================================
  // CART OPERATIONS
  // =============================================

  // Add to cart
  $(document).on('click', '.btn-add-to-cart', function () {
    var $btn = $(this);
    var menuItemId = $btn.data('item-id');
    var restaurantId = $btn.data('restaurant-id');
    var itemName = $btn.data('item-name');

    addToCart(menuItemId, restaurantId, itemName, $btn);
  });

  function addToCart(menuItemId, restaurantId, itemName, $btn) {
    $.ajax({
      url: contextPath + '/cart',
      type: 'POST',
      data: { action: 'add', menuItemId: menuItemId, restaurantId: restaurantId },
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          updateNavCartCount(res.cartCount);
          showToast('Added "' + itemName + '" to cart!', 'success');

          // Transform btn to qty-control
          var $wrap = $btn.closest('.menu-item-action');
          $wrap.html(
            '<div class="qty-control" data-item-id="' + menuItemId + '">' +
            '  <button class="qty-btn btn-qty-minus" data-item-id="' + menuItemId + '" data-restaurant-id="' + restaurantId + '">−</button>' +
            '  <span class="qty-num">1</span>' +
            '  <button class="qty-btn btn-qty-plus" data-item-id="' + menuItemId + '" data-restaurant-id="' + restaurantId + '" data-item-name="' + itemName + '">+</button>' +
            '</div>'
          );
        } else if (res.message === 'different_restaurant') {
          showDifferentRestaurantModal(menuItemId, restaurantId, itemName);
        } else {
          showToast('Could not add item. Please try again.', 'error');
        }
      },
      error: function () {
        showToast('Network error. Please try again.', 'error');
      }
    });
  }

  // Increase qty
  $(document).on('click', '.btn-qty-plus', function () {
    var menuItemId = $(this).data('item-id');
    var restaurantId = $(this).data('restaurant-id');
    var itemName = $(this).data('item-name');
    var $numSpan = $(this).closest('.qty-control').find('.qty-num');
    var current = parseInt($numSpan.text());
    var newQty = current + 1;

    $.ajax({
      url: contextPath + '/cart',
      type: 'POST',
      data: { action: 'update', menuItemId: menuItemId, quantity: newQty },
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $numSpan.text(newQty);
          updateNavCartCount(res.cartCount);
        }
      }
    });
  });

  // Decrease qty
  $(document).on('click', '.btn-qty-minus', function () {
    var menuItemId = $(this).data('item-id');
    var $control = $(this).closest('.qty-control');
    var $wrap = $control.closest('.menu-item-action');
    var restaurantId = $(this).data('restaurant-id');
    var $numSpan = $control.find('.qty-num');
    var current = parseInt($numSpan.text());
    var newQty = current - 1;

    if (newQty <= 0) {
      // Remove from cart and restore Add button
      $.ajax({
        url: contextPath + '/cart',
        type: 'POST',
        data: { action: 'remove', menuItemId: menuItemId },
        dataType: 'json',
        success: function (res) {
          updateNavCartCount(res.cartCount);
          $wrap.html(
            '<button class="btn-add btn-add-to-cart" ' +
            'data-item-id="' + menuItemId + '" ' +
            'data-restaurant-id="' + restaurantId + '">ADD</button>'
          );
        }
      });
    } else {
      $.ajax({
        url: contextPath + '/cart',
        type: 'POST',
        data: { action: 'update', menuItemId: menuItemId, quantity: newQty },
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            $numSpan.text(newQty);
            updateNavCartCount(res.cartCount);
          }
        }
      });
    }
  });

  // Cart page: quantity controls
  $(document).on('click', '.cart-qty-plus', function () {
    var $row = $(this).closest('.cart-item-row');
    var menuItemId = $row.data('item-id');
    var $numSpan = $row.find('.cart-qty-num');
    var current = parseInt($numSpan.text());
    var newQty = current + 1;

    $.ajax({
      url: contextPath + '/cart',
      type: 'POST',
      data: { action: 'update', menuItemId: menuItemId, quantity: newQty },
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $numSpan.text(newQty);
          updateNavCartCount(res.cartCount);
          updateCartSubtotal($row, newQty);
          recalcCartTotal();
        }
      }
    });
  });

  $(document).on('click', '.cart-qty-minus', function () {
    var $row = $(this).closest('.cart-item-row');
    var menuItemId = $row.data('item-id');
    var $numSpan = $row.find('.cart-qty-num');
    var current = parseInt($numSpan.text());
    var newQty = current - 1;

    if (newQty <= 0) {
      $.ajax({
        url: contextPath + '/cart',
        type: 'POST',
        data: { action: 'remove', menuItemId: menuItemId },
        dataType: 'json',
        success: function (res) {
          $row.fadeOut(200, function () { $(this).remove(); checkEmptyCart(); });
          updateNavCartCount(res.cartCount);
          recalcCartTotal();
        }
      });
    } else {
      $.ajax({
        url: contextPath + '/cart',
        type: 'POST',
        data: { action: 'update', menuItemId: menuItemId, quantity: newQty },
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            $numSpan.text(newQty);
            updateNavCartCount(res.cartCount);
            updateCartSubtotal($row, newQty);
            recalcCartTotal();
          }
        }
      });
    }
  });

  // Remove item from cart
  $(document).on('click', '.btn-cart-remove', function () {
    var $row = $(this).closest('.cart-item-row');
    var menuItemId = $row.data('item-id');

    $.ajax({
      url: contextPath + '/cart',
      type: 'POST',
      data: { action: 'remove', menuItemId: menuItemId },
      dataType: 'json',
      success: function (res) {
        $row.fadeOut(200, function () { $(this).remove(); checkEmptyCart(); });
        updateNavCartCount(res.cartCount);
        recalcCartTotal();
      }
    });
  });

  function updateCartSubtotal($row, qty) {
    var unitPrice = parseFloat($row.data('unit-price'));
    var subtotal = unitPrice * qty;
    $row.find('.cart-item-subtotal').text('₹' + Math.round(subtotal));
  }

  function recalcCartTotal() {
    var subtotal = 0;
    $('.cart-item-row').each(function () {
      var price = parseFloat($(this).data('unit-price'));
      var qty = parseInt($(this).find('.cart-qty-num').text());
      subtotal += price * qty;
    });
    var delivery = parseInt($('#delivery-fee-val').text().replace('₹', '')) || 0;
    var taxes = Math.round(subtotal * 0.05);
    var total = subtotal + delivery + taxes;
    $('#subtotal-val').text('₹' + Math.round(subtotal));
    $('#taxes-val').text('₹' + taxes);
    $('#total-val').text('₹' + total);
  }

  function checkEmptyCart() {
    if ($('.cart-item-row').length === 0) {
      $('#cart-items-section').hide();
      $('#empty-cart-section').show();
    }
  }

  // Different restaurant modal
  function showDifferentRestaurantModal(menuItemId, restaurantId, itemName) {
    $('#diffRestaurantModal').remove();
    $('body').append(
      '<div class="modal fade" id="diffRestaurantModal" tabindex="-1">' +
      '<div class="modal-dialog modal-dialog-centered">' +
      '<div class="modal-content">' +
      '<div class="modal-header">' +
      '<h5 class="modal-title fw-bold">Start a new cart?</h5>' +
      '</div>' +
      '<div class="modal-body">' +
      '<p>Your cart has items from a different restaurant. Would you like to clear it and start a new order?</p>' +
      '</div>' +
      '<div class="modal-footer">' +
      '<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>' +
      '<button type="button" class="btn btn-danger" id="btnClearAndAdd">Clear cart & add item</button>' +
      '</div>' +
      '</div></div></div>'
    );

    var modal = new bootstrap.Modal(document.getElementById('diffRestaurantModal'));
    modal.show();

    $('#btnClearAndAdd').on('click', function () {
      $.ajax({
        url: contextPath + '/cart',
        type: 'POST',
        data: { action: 'clear' },
        dataType: 'json',
        success: function () {
          modal.hide();
          addToCart(menuItemId, restaurantId, itemName, null);
        }
      });
    });
  }

  // =============================================
  // HERO SEARCH
  // =============================================
  $('#heroSearchForm').on('submit', function (e) {
    e.preventDefault();
    var query = $('#foodSearchInput').val().trim();
    if (query) {
      window.location.href = contextPath + '/restaurants?q=' + encodeURIComponent(query);
    }
  });

  // =============================================
  // MENU SIDEBAR NAVIGATION
  // =============================================
  $('.menu-sidebar .list-group-item').on('click', function () {
    $('.menu-sidebar .list-group-item').removeClass('active');
    $(this).addClass('active');
    var target = $(this).data('target');
    var $section = $('#section-' + target);
    if ($section.length) {
      $('html, body').animate({ scrollTop: $section.offset().top - 100 }, 400);
    }
  });

  // Highlight sidebar on scroll
  $(window).on('scroll', function () {
    var scrollPos = $(window).scrollTop() + 120;
    $('.menu-category-section').each(function () {
      var top = $(this).offset().top;
      var bottom = top + $(this).outerHeight();
      if (scrollPos >= top && scrollPos < bottom) {
        var id = $(this).attr('id').replace('section-', '');
        $('.menu-sidebar .list-group-item').removeClass('active');
        $('.menu-sidebar .list-group-item[data-target="' + id + '"]').addClass('active');
      }
    });
  });

  // =============================================
  // CHECKOUT FORM
  // =============================================
  $('#checkoutForm').on('submit', function (e) {
    var addr = $('#deliveryAddress').val().trim();
    if (!addr) {
      e.preventDefault();
      showToast('Please enter a delivery address.', 'error');
    }
  });

  // =============================================
  // UTILITY FUNCTIONS
  // =============================================

  function updateNavCartCount(count) {
    if (count !== undefined) {
      if (count > 0) {
        $('#navCartCount').text(count).show();
      } else {
        $('#navCartCount').hide();
      }
    }
  }

  function showToast(message, type) {
    type = type || 'info';
    var icon = type === 'success' ? '✓' : type === 'error' ? '✗' : 'ℹ';
    var $toast = $('<div class="tt-toast ' + type + '">' + icon + ' ' + message + '</div>');
    $('#toastContainer').append($toast);
    setTimeout(function () { $toast.remove(); }, 3200);
  }

  // Make showToast globally accessible
  window.showToast = showToast;

});
