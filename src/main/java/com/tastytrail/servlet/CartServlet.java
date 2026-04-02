package com.tastytrail.servlet;

import com.google.gson.Gson;
import com.tastytrail.dao.MenuDAO;
import com.tastytrail.model.CartItem;
import com.tastytrail.model.MenuItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CartServlet extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if ("add".equals(action)) {
            addToCart(req, resp, session);
        } else if ("remove".equals(action)) {
            removeFromCart(req, resp, session);
        } else if ("update".equals(action)) {
            updateQuantity(req, resp, session);
        } else if ("clear".equals(action)) {
            session.removeAttribute("cart");
            session.removeAttribute("cartRestaurantId");
            resp.getWriter().write("{\"success\":true,\"message\":\"Cart cleared\"}");
        }
    }

    @SuppressWarnings("unchecked")
    private void addToCart(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            int menuItemId = Integer.parseInt(req.getParameter("menuItemId"));
            int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));

            // Check if cart has items from a different restaurant
            Integer cartRestaurantId = (Integer) session.getAttribute("cartRestaurantId");
            if (cartRestaurantId != null && cartRestaurantId != restaurantId) {
                resp.getWriter().write("{\"success\":false,\"message\":\"different_restaurant\"}");
                return;
            }

            MenuItem item = menuDAO.getMenuItemById(menuItemId);
            if (item == null) {
                resp.getWriter().write("{\"success\":false,\"message\":\"Item not found\"}");
                return;
            }

            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();

            boolean found = false;
            for (CartItem ci : cart) {
                if (ci.getMenuItemId() == menuItemId) {
                    ci.setQuantity(ci.getQuantity() + 1);
                    found = true;
                    break;
                }
            }

            if (!found) {
                cart.add(new CartItem(menuItemId, item.getName(), item.getPrice(),
                        1, item.getImage(), item.isVeg(), restaurantId));
            }

            session.setAttribute("cart", cart);
            session.setAttribute("cartRestaurantId", restaurantId);

            int totalItems = cart.stream().mapToInt(CartItem::getQuantity).sum();
            resp.getWriter().write("{\"success\":true,\"cartCount\":" + totalItems + "}");

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid parameters\"}");
        }
    }

    @SuppressWarnings("unchecked")
    private void removeFromCart(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            int menuItemId = Integer.parseInt(req.getParameter("menuItemId"));
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                cart.removeIf(ci -> ci.getMenuItemId() == menuItemId);
                if (cart.isEmpty()) {
                    session.removeAttribute("cart");
                    session.removeAttribute("cartRestaurantId");
                } else {
                    session.setAttribute("cart", cart);
                }
            }

            int totalItems = cart == null ? 0 : cart.stream().mapToInt(CartItem::getQuantity).sum();
            resp.getWriter().write("{\"success\":true,\"cartCount\":" + totalItems + "}");

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid parameters\"}");
        }
    }

    @SuppressWarnings("unchecked")
    private void updateQuantity(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            int menuItemId = Integer.parseInt(req.getParameter("menuItemId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart != null) {
                if (quantity <= 0) {
                    cart.removeIf(ci -> ci.getMenuItemId() == menuItemId);
                } else {
                    for (CartItem ci : cart) {
                        if (ci.getMenuItemId() == menuItemId) {
                            ci.setQuantity(quantity);
                            break;
                        }
                    }
                }
                if (cart.isEmpty()) {
                    session.removeAttribute("cart");
                    session.removeAttribute("cartRestaurantId");
                } else {
                    session.setAttribute("cart", cart);
                }
            }

            int totalItems = cart == null ? 0 : cart.stream().mapToInt(CartItem::getQuantity).sum();
            resp.getWriter().write("{\"success\":true,\"cartCount\":" + totalItems + "}");

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid parameters\"}");
        }
    }
}
