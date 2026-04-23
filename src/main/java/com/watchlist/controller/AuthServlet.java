package com.watchlist.controller;

import com.watchlist.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT id, username FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, user);
                    pstmt.setString(2, pass); // In a real app, hash this!
                    
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        // Success! Create the session
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("username", rs.getString("username"));
                        response.sendRedirect("movies");
                    } else {
                        response.sendRedirect("login.jsp?error=1");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("login.jsp?error=1");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle Logout
        if ("logout".equals(request.getParameter("action"))) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate(); // Destroy the session
            }
            response.sendRedirect("login.jsp");
        }
    }
}