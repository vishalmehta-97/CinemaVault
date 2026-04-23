package com.watchlist.controller;

import com.watchlist.model.Movie;
import com.watchlist.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

@WebServlet("/movies")
public class MovieServlet extends HttpServlet {
    
    // GET YOUR FREE KEY AT: http://www.omdbapi.com/apikey.aspx
//    private static final String OMDB_API_KEY = "http://www.omdbapi.com/?i=tt3896198&apikey=40214fb6"; 

    private static final String OMDB_API_KEY = "40214fb6"; 
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. SECURITY CHECK: Is the user logged in?
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        String sort = request.getParameter("sort");
        String orderBy = "title ASC"; 
        
        if ("genre".equals(sort)) orderBy = "genre ASC";
        else if ("status".equals(sort)) orderBy = "is_watched ASC";

        List<Movie> movieList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Only fetch movies belonging to the logged-in user
            String sql = "SELECT * FROM movies WHERE user_id = ? ORDER BY " + orderBy;
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, userId);
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    movieList.add(new Movie(
                        rs.getInt("id"), rs.getString("title"),
                        rs.getString("genre"), rs.getInt("release_year"),
                        rs.getBoolean("is_watched"), rs.getString("poster_url") // Added poster
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("movies", movieList);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("add".equals(action)) {
                String title = request.getParameter("title");
                String posterUrl = fetchPosterFromAPI(title); // Call the API
                
                String sql = "INSERT INTO movies (title, genre, release_year, user_id, poster_url) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, title);
                    pstmt.setString(2, request.getParameter("genre"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("releaseYear")));
                    pstmt.setInt(4, userId);
                    pstmt.setString(5, posterUrl);
                    pstmt.executeUpdate();
                }
            } else if ("toggle".equals(action)) {
                // Ensure users can only toggle THEIR OWN movies
                String sql = "UPDATE movies SET is_watched = NOT is_watched WHERE id = ? AND user_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    pstmt.setInt(2, userId);
                    pstmt.executeUpdate();
                }
            
        } else if ("toggle".equals(action)) {
            // Ensure users can only toggle THEIR OWN movies
            String sql = "UPDATE movies SET is_watched = NOT is_watched WHERE id = ? AND user_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                pstmt.setInt(2, userId);
                pstmt.executeUpdate();
            }
            
        // --- NEW DELETE LOGIC STARTS HERE ---
        } else if ("delete".equals(action)) {
            String sql = "DELETE FROM movies WHERE id = ? AND user_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                pstmt.setInt(2, userId); // Security check!
                pstmt.executeUpdate();
            }
        }
        
        // --- NEW DELETE LOGIC ENDS HERE ---
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("movies");
    }

    // --- HELPER METHOD: Fetch Image from API ---
    private String fetchPosterFromAPI(String movieTitle) {
        try {
            // Encode the title so spaces become %20
            String encodedTitle = URLEncoder.encode(movieTitle, "UTF-8");
            URL url = new URL("http://www.omdbapi.com/?t=" + encodedTitle + "&apikey=" + OMDB_API_KEY);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.connect();

            if (conn.getResponseCode() == 200) {
                Scanner scanner = new Scanner(url.openStream());
                String response = scanner.useDelimiter("\\Z").next();
                scanner.close();
                
                // Quick extraction of the Poster URL without needing external JSON libraries
                if (response.contains("\"Poster\":\"")) {
                    String[] parts = response.split("\"Poster\":\"");
                    String urlPart = parts[1].split("\"")[0];
                    if (!urlPart.equals("N/A")) return urlPart;
                }
            }
        } catch (Exception e) {
            System.out.println("Could not fetch poster: " + e.getMessage());
        }
        return "https://via.placeholder.com/100x150?text=No+Poster"; // Fallback image
    }
}