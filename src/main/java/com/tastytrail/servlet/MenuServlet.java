package com.tastytrail.servlet;

import com.tastytrail.dao.MenuDAO;
import com.tastytrail.dao.RestaurantDAO;
import com.tastytrail.model.MenuItem;
import com.tastytrail.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class MenuServlet extends HttpServlet {

    private final RestaurantDAO restaurantDAO = new RestaurantDAO();
    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/restaurants");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idParam);
            Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);

            if (restaurant == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Restaurant not found");
                return;
            }

            Map<String, List<MenuItem>> menuByCategory = menuDAO.getMenuGroupedByCategory(restaurantId);

            req.setAttribute("restaurant", restaurant);
            req.setAttribute("menuByCategory", menuByCategory);
            req.getRequestDispatcher("/menu.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/restaurants");
        }
    }
}
