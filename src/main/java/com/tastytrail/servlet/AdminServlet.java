package com.tastytrail.servlet;

import com.tastytrail.dao.OrderDAO;
import com.tastytrail.dao.RestaurantDAO;
import com.tastytrail.dao.UserDAO;
import com.tastytrail.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final RestaurantDAO restaurantDAO = new RestaurantDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String path = req.getPathInfo(); // /dashboard, /orders, /restaurants, /users
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/dashboard":
                loadDashboard(req, resp);
                break;
            case "/orders":
                req.setAttribute("orders", orderDAO.getAllOrders());
                req.setAttribute("drivers", userDAO.getAllDrivers());
                req.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(req, resp);
                break;
            case "/restaurants":
                req.setAttribute("restaurants", restaurantDAO.getAllRestaurants());
                req.getRequestDispatcher("/WEB-INF/admin/restaurants.jsp").forward(req, resp);
                break;
            case "/users":
                req.setAttribute("users", userDAO.getAllUsers());
                req.getRequestDispatcher("/WEB-INF/admin/users.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");
        String path = req.getPathInfo();

        if ("/orders".equals(path)) {
            // Update order status
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String status = req.getParameter("status");
            String driverIdStr = req.getParameter("driverId");
            Integer driverId = (driverIdStr != null && !driverIdStr.isEmpty()) ? Integer.parseInt(driverIdStr) : null;
            orderDAO.updateOrderStatus(orderId, status, driverId);
            resp.sendRedirect(req.getContextPath() + "/admin/orders?updated=true");

        } else if ("/users".equals(path)) {
            if ("changeRole".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                String role = req.getParameter("role");
                userDAO.updateRole(userId, role);
                resp.sendRedirect(req.getContextPath() + "/admin/users?roleUpdated=true");
            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                userDAO.deleteUser(userId);
                resp.sendRedirect(req.getContextPath() + "/admin/users?deleted=true");
            }

        } else if ("/restaurants".equals(path)) {
            if ("add".equals(action)) {
                Restaurant r = buildRestaurantFromRequest(req);
                restaurantDAO.addRestaurant(r);
                resp.sendRedirect(req.getContextPath() + "/admin/restaurants?added=true");
            } else if ("edit".equals(action)) {
                Restaurant r = buildRestaurantFromRequest(req);
                r.setId(Integer.parseInt(req.getParameter("id")));
                restaurantDAO.updateRestaurant(r);
                resp.sendRedirect(req.getContextPath() + "/admin/restaurants?updated=true");
            } else if ("delete".equals(action)) {
                restaurantDAO.deleteRestaurant(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/restaurants?deleted=true");
            }
        }
    }

    private void loadDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("totalOrders", orderDAO.getTotalOrdersCount());
        req.setAttribute("totalRevenue", orderDAO.getTotalRevenue());
        req.setAttribute("totalRestaurants", restaurantDAO.getTotalCount());
        req.setAttribute("totalUsers", userDAO.getAllUsers().size());
        req.setAttribute("recentOrders", orderDAO.getAllOrders().stream().limit(5).collect(java.util.stream.Collectors.toList()));
        req.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(req, resp);
    }

    private Restaurant buildRestaurantFromRequest(HttpServletRequest req) {
        Restaurant r = new Restaurant();
        r.setName(req.getParameter("name"));
        r.setDescription(req.getParameter("description"));
        r.setCuisine(req.getParameter("cuisine"));
        r.setAddress(req.getParameter("address"));
        r.setCity(req.getParameter("city"));
        r.setPhone(req.getParameter("phone"));
        r.setDeliveryTime(parseInt(req.getParameter("deliveryTime"), 30));
        r.setMinOrder(parseInt(req.getParameter("minOrder"), 0));
        r.setDeliveryFee(parseInt(req.getParameter("deliveryFee"), 0));
        r.setVeg("on".equals(req.getParameter("isVeg")));
        r.setOpen(!"on".equals(req.getParameter("isClosed")));
        r.setRating(4.0);
        return r;
    }

    private int parseInt(String val, int def) {
        try { return Integer.parseInt(val); } catch (Exception e) { return def; }
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return false;
        }
        return true;
    }
}
