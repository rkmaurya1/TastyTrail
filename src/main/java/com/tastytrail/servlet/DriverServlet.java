package com.tastytrail.servlet;

import com.tastytrail.dao.OrderDAO;
import com.tastytrail.model.Order;
import com.tastytrail.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class DriverServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isDriver(req, resp)) return;

        User driver = (User) req.getSession().getAttribute("user");
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        List<Order> orders = orderDAO.getOrdersByDriver(driver.getId());
        req.setAttribute("orders", orders);
        req.setAttribute("driver", driver);

        long pending = orders.stream().filter(o -> "CONFIRMED".equals(o.getStatus()) || "PREPARING".equals(o.getStatus())).count();
        long inDelivery = orders.stream().filter(o -> "OUT_FOR_DELIVERY".equals(o.getStatus())).count();
        long delivered = orders.stream().filter(o -> "DELIVERED".equals(o.getStatus())).count();
        req.setAttribute("pendingCount", pending);
        req.setAttribute("inDeliveryCount", inDelivery);
        req.setAttribute("deliveredCount", delivered);

        req.getRequestDispatcher("/WEB-INF/driver/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isDriver(req, resp)) return;

        User driver = (User) req.getSession().getAttribute("user");
        String action = req.getParameter("action");
        int orderId = Integer.parseInt(req.getParameter("orderId"));

        if ("accept".equals(action)) {
            orderDAO.updateOrderStatus(orderId, "OUT_FOR_DELIVERY", driver.getId());
        } else if ("deliver".equals(action)) {
            orderDAO.updateOrderStatus(orderId, "DELIVERED", driver.getId());
        }

        resp.sendRedirect(req.getContextPath() + "/driver/dashboard");
    }

    private boolean isDriver(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isDriver()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return false;
        }
        return true;
    }
}
