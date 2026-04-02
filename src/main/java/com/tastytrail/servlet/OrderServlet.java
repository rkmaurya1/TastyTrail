package com.tastytrail.servlet;

import com.tastytrail.dao.OrderDAO;
import com.tastytrail.model.CartItem;
import com.tastytrail.model.Order;
import com.tastytrail.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/orders");
            return;
        }

        User user = (User) session.getAttribute("user");
        String orderIdParam = req.getParameter("id");

        if (orderIdParam != null) {
            // Single order detail
            try {
                int orderId = Integer.parseInt(orderIdParam);
                Order order = orderDAO.getOrderById(orderId);
                if (order != null && order.getUserId() == user.getId()) {
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/order-detail.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/orders");
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/orders");
            }
        } else {
            // All orders
            List<Order> orders = orderDAO.getOrdersByUser(user.getId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/orders.jsp").forward(req, resp);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        Integer restaurantId = (Integer) session.getAttribute("cartRestaurantId");

        if (cart == null || cart.isEmpty() || restaurantId == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String deliveryAddress = req.getParameter("deliveryAddress");
        String paymentMethod = req.getParameter("paymentMethod");

        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            deliveryAddress = user.getAddress() != null ? user.getAddress() : "Address not provided";
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }

        int orderId = orderDAO.placeOrder(user.getId(), restaurantId, cart,
                deliveryAddress.trim(), paymentMethod);

        if (orderId > 0) {
            // Clear cart
            session.removeAttribute("cart");
            session.removeAttribute("cartRestaurantId");
            resp.sendRedirect(req.getContextPath() + "/orders?id=" + orderId + "&success=true");
        } else {
            req.setAttribute("error", "Order placement failed. Please try again.");
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        }
    }
}
