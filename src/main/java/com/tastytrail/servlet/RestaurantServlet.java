package com.tastytrail.servlet;

import com.tastytrail.dao.RestaurantDAO;
import com.tastytrail.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class RestaurantServlet extends HttpServlet {

    private final RestaurantDAO restaurantDAO = new RestaurantDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String query = req.getParameter("q");
        String cuisine = req.getParameter("cuisine");
        String filter = req.getParameter("filter");

        List<Restaurant> restaurants;

        if (query != null && !query.trim().isEmpty()) {
            restaurants = restaurantDAO.searchRestaurants(query.trim());
            req.setAttribute("searchQuery", query);
        } else if (cuisine != null && !cuisine.trim().isEmpty()) {
            restaurants = restaurantDAO.getRestaurantsByCuisine(cuisine.trim());
            req.setAttribute("selectedCuisine", cuisine);
        } else if ("veg".equals(filter)) {
            restaurants = restaurantDAO.getVegRestaurants();
            req.setAttribute("vegFilter", true);
        } else {
            restaurants = restaurantDAO.getAllRestaurants();
        }

        req.setAttribute("restaurants", restaurants);
        req.setAttribute("totalCount", restaurants.size());
        req.getRequestDispatcher("/restaurants.jsp").forward(req, resp);
    }
}
