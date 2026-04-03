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

        // Single restaurant — redirect to menu
        resp.sendRedirect(req.getContextPath() + "/menu");
    }
}
