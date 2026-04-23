<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.watchlist.model.Movie" %>
<%
    // Security check on the view itself
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<!-- <head>
    <meta charset="UTF-8">
    <title>The Cinematic Vault</title>
    <style>
    .delete-btn { background: transparent; border: 1px solid #ff5252; color: #ff5252; padding: 5px 10px; margin-left: 5px; cursor: pointer; border-radius: 4px; }
        .delete-btn:hover { background: #ff5252; color: #121212; }
        body { background-color: #121212; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; margin: 40px; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #333; padding-bottom: 10px; margin-bottom: 20px;}
        h1 { color: #bb86fc; margin: 0; }
        .logout-btn { background: #ff5252; color: white; text-decoration: none; padding: 8px 15px; border-radius: 4px; font-weight: bold; }
        .logout-btn:hover { background: #d32f2f; }
        .container { max-width: 1000px; margin: auto; }
        .form-box { background: #1e1e1e; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        input, select, button { padding: 10px; margin: 5px; border-radius: 4px; border: none; }
        input, select { background: #333; color: white; width: calc(33% - 20px); }
        button { background: #bb86fc; color: #121212; font-weight: bold; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #1e1e1e; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #333; vertical-align: middle; }
        th a { color: #bb86fc; text-decoration: none; }
        .poster-img { width: 70px; border-radius: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.5); }
        .watched { color: #4caf50; }
        .unwatched { color: #ff5252; }
        .action-btn { background: transparent; border: 1px solid #bb86fc; color: #bb86fc; padding: 5px 10px; }
        .action-btn:hover { background: #bb86fc; color: #121212; }
    </style>
</head> -->

<head>
    <meta charset="UTF-8">
    <title>The Cinematic Vault</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        /* CSS Variables for easy theme switching */
        :root {
            --bg-color: #0b0c10;
            --surface-color: #1f2833;
            --accent-primary: #66fcf1;
            --accent-secondary: #45a29e;
            --text-main: #c5c6c7;
            --text-light: #ffffff;
            --success: #4caf50;
            --danger: #ff5252;
        }

        body { 
            background-color: var(--bg-color); 
            color: var(--text-main); 
            font-family: 'Outfit', sans-serif; 
            margin: 0;
            padding: 40px 20px;
            background-image: radial-gradient(circle at top right, #1f2833 0%, transparent 40%);
        }

        .container { 
            max-width: 1100px; 
            margin: auto; 
        }

        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border-bottom: 2px solid var(--surface-color); 
            padding-bottom: 15px; 
            margin-bottom: 30px;
        }

        h1 { 
            color: var(--accent-primary); 
            margin: 0; 
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            text-shadow: 0 0 10px rgba(102, 252, 241, 0.3);
        }

        .logout-btn { 
            background: rgba(255, 82, 82, 0.1); 
            color: var(--danger); 
            text-decoration: none; 
            padding: 8px 16px; 
            border-radius: 6px; 
            font-weight: 600; 
            border: 1px solid var(--danger);
            transition: all 0.3s ease;
        }

        .logout-btn:hover { 
            background: var(--danger);
            color: #fff;
            box-shadow: 0 0 15px rgba(255, 82, 82, 0.4);
        }

        .form-box { 
            background: rgba(31, 40, 51, 0.6); 
            backdrop-filter: blur(10px);
            padding: 25px; 
            border-radius: 12px; 
            margin-bottom: 30px; 
            border: 1px solid rgba(197, 198, 199, 0.1);
            display: flex;
            gap: 15px;
        }

        .form-box form {
            display: flex;
            width: 100%;
            gap: 15px;
            align-items: center;
        }

        input, select { 
            background: rgba(11, 12, 16, 0.8); 
            color: var(--text-light); 
            width: 100%;
            padding: 12px 15px; 
            border-radius: 6px; 
            border: 1px solid var(--surface-color); 
            font-family: inherit;
            transition: border 0.3s ease;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--accent-primary);
        }

        button[type="submit"] { 
            background: var(--accent-primary); 
            color: var(--bg-color); 
            font-weight: 800; 
            cursor: pointer; 
            padding: 12px 25px;
            border-radius: 6px;
            border: none;
            white-space: nowrap;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        button[type="submit"]:hover { 
            background: var(--text-light); 
            box-shadow: 0 0 15px rgba(102, 252, 241, 0.5);
            transform: translateY(-2px);
        }

        table { 
            width: 100%; 
            border-collapse: separate; 
            border-spacing: 0 10px;
            margin-top: 10px; 
        }

        th {
            padding: 0 20px 10px 20px;
            text-align: left;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
            color: var(--accent-secondary);
        }

        th a { 
            color: var(--accent-secondary); 
            text-decoration: none; 
            transition: color 0.3s ease;
        }

        th a:hover { color: var(--accent-primary); }

        tbody tr {
            background: var(--surface-color);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        tbody tr:hover {
            transform: scale(1.01);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        td { 
            padding: 15px 20px; 
            vertical-align: middle; 
        }

        td:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        td:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

        .poster-img { 
            width: 60px; 
            height: 90px;
            object-fit: cover;
            border-radius: 6px; 
            box-shadow: 0 4px 8px rgba(0,0,0,0.6); 
            transition: transform 0.3s ease;
        }

        tbody tr:hover .poster-img {
            transform: scale(1.1) rotate(2deg);
        }

        strong { color: var(--text-light); font-size: 1.1rem; letter-spacing: 0.5px; }

        .watched { color: var(--success); font-weight: 600; }
        .unwatched { color: var(--accent-secondary); font-weight: 600; }

        .action-btn, .delete-btn { 
            background: transparent; 
            padding: 6px 12px; 
            font-size: 0.85rem;
            cursor: pointer; 
            border-radius: 4px; 
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .action-btn {
            border: 1px solid var(--accent-primary); 
            color: var(--accent-primary); 
        }
        .action-btn:hover { 
            background: var(--accent-primary); 
            color: var(--bg-color); 
        }

        .delete-btn { 
            border: 1px solid var(--danger); 
            color: var(--danger); 
            margin-left: 8px; 
        }
        .delete-btn:hover { 
            background: var(--danger); 
            color: #fff; 
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>The Cinematic Vault</h1>
            <div>
                Welcome, <strong><%= session.getAttribute("username") %></strong>! 
                <a href="auth?action=logout" class="logout-btn">Logout</a>
            </div>
        </div>

        <div class="form-box">
            <form action="movies" method="post">
                <input type="hidden" name="action" value="add">
                <input type="text" name="title" placeholder="Movie Title (e.g., Inception)" required>
                <select name="genre" required>
                    <option value="" disabled selected>Select Genre...</option>
                    <option value="Dark Thriller">Dark Thriller</option>
                    <option value="Mind-Bending Sci-Fi">Mind-Bending Sci-Fi</option>
                    <option value="Gritty Drama">Gritty Drama</option>
                    <option value="Action">Action</option>
                </select>
                <input type="number" name="releaseYear" placeholder="Year" required min="1900" max="2100">
                <button type="submit">Add to Vault</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Poster</th>
                    <th><a href="movies?sort=title">Title</a></th>
                    <th><a href="movies?sort=genre">Genre</a></th>
                    <th>Year</th>
                    <th><a href="movies?sort=status">Status</a></th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                    if (movies != null && !movies.isEmpty()) {
                        for (Movie m : movies) { 
                %>
                <tr>
                    <td><img src="<%= m.getPosterUrl() != null ? m.getPosterUrl() : "https://via.placeholder.com/70x100?text=N/A" %>" class="poster-img" alt="Poster"></td>
                    <td><strong><%= m.getTitle() %></strong></td>
                    <td><%= m.getGenre() %></td>
                    <td><%= m.getReleaseYear() %></td>
                    <td class="<%= m.isWatched() ? "watched" : "unwatched" %>">
                        <%= m.isWatched() ? "Watched" : "Un-watched" %>
                    </td>
                    <td style="white-space: nowrap;">
                        <form action="movies" method="post" style="display:inline-block; margin:0;">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button type="submit" class="action-btn">Toggle</button>
                        </form>
                        
                        <form action="movies" method="post" style="display:inline-block; margin:0;" onsubmit="return confirm('Are you sure you want to delete this movie from the vault?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button type="submit" class="delete-btn">Delete</button>
                        </form>
                    </td>
                </tr>
                <% 
                        } 
                    } else { 
                %>
                <tr><td colspan="6" style="text-align:center;">Your vault is empty. Add a movie to see the magic.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html> --%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.watchlist.model.Movie" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>The Cinematic Vault</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        /* 1. DEFAULT THEME (Cinematic Dark) */
        :root {
            --bg-color: #0b0c10;
            --surface-color: #1f2833;
            --accent-primary: #66fcf1;
            --accent-secondary: #45a29e;
            --text-main: #c5c6c7;
            --text-light: #ffffff;
            --success: #4caf50;
            --danger: #ff5252;
            --bg-gradient: radial-gradient(circle at top right, #1f2833 0%, transparent 40%);
        }

        /* 2. LIGHT THEME */
        body.theme-light {
            --bg-color: #f4f4f9;
            --surface-color: #ffffff;
            --accent-primary: #5c67f2;
            --accent-secondary: #747df5;
            --text-main: #333333;
            --text-light: #111111;
            --bg-gradient: none;
        }

        /* 3. DEEP BLUE THEME */
        body.theme-blue {
            --bg-color: #0a192f;
            --surface-color: #112240;
            --accent-primary: #64ffda;
            --accent-secondary: #8892b0;
            --text-main: #ccd6f6;
            --text-light: #e6f1ff;
            --bg-gradient: radial-gradient(circle at top right, #112240 0%, transparent 40%);
        }

        /* 4. MATRIX GREEN THEME */
        body.theme-green {
            --bg-color: #0d1a15;
            --surface-color: #162c23;
            --accent-primary: #00ff88;
            --accent-secondary: #00b35f;
            --text-main: #c4ebd6;
            --text-light: #ffffff;
            --bg-gradient: radial-gradient(circle at top right, #162c23 0%, transparent 40%);
        }

        /* --- CORE STYLES --- */
        body { 
            background-color: var(--bg-color); 
            color: var(--text-main); 
            font-family: 'Outfit', sans-serif; 
            margin: 0;
            padding: 40px 20px;
            background-image: var(--bg-gradient);
            transition: background-color 0.4s ease, color 0.4s ease; /* Smooth fade when switching */
        }

        .container { max-width: 1100px; margin: auto; }

        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border-bottom: 2px solid var(--surface-color); 
            padding-bottom: 15px; 
            margin-bottom: 30px;
        }

        h1 { 
            color: var(--accent-primary); 
            margin: 0; 
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .controls-wrapper {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        /* Theme Dropdown Styles */
        .theme-select {
            background: var(--surface-color);
            color: var(--text-light);
            border: 1px solid var(--accent-secondary);
            padding: 8px 12px;
            border-radius: 6px;
            font-family: inherit;
            cursor: pointer;
            outline: none;
        }

        .logout-btn { 
            background: rgba(255, 82, 82, 0.1); 
            color: var(--danger); 
            text-decoration: none; 
            padding: 8px 16px; 
            border-radius: 6px; 
            font-weight: 600; 
            border: 1px solid var(--danger);
            transition: all 0.3s ease;
        }

        .logout-btn:hover { background: var(--danger); color: #fff; }

        .form-box { 
            background: rgba(31, 40, 51, 0.05); 
            background-color: var(--surface-color);
            padding: 25px; 
            border-radius: 12px; 
            margin-bottom: 30px; 
            display: flex;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .form-box form { display: flex; width: 100%; gap: 15px; align-items: center; }

        input, select { 
            background: var(--bg-color); 
            color: var(--text-light); 
            width: 100%;
            padding: 12px 15px; 
            border-radius: 6px; 
            border: 1px solid var(--surface-color); 
            font-family: inherit;
        }

        input:focus, select:focus { border-color: var(--accent-primary); outline: none; }

        button[type="submit"] { 
            background: var(--accent-primary); 
            color: var(--bg-color); 
            font-weight: 800; 
            cursor: pointer; 
            padding: 12px 25px;
            border-radius: 6px;
            border: none;
            white-space: nowrap;
            text-transform: uppercase;
        }

        button[type="submit"]:hover { filter: brightness(1.2); transform: translateY(-2px); }

        table { width: 100%; border-collapse: separate; border-spacing: 0 10px; margin-top: 10px; }
        th { padding: 0 20px 10px 20px; text-align: left; text-transform: uppercase; font-size: 0.85rem; color: var(--accent-secondary); }
        th a { color: var(--accent-secondary); text-decoration: none; }
        th a:hover { color: var(--accent-primary); }

        tbody tr { background: var(--surface-color); box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        td { padding: 15px 20px; vertical-align: middle; }
        td:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        td:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

        .poster-img { width: 60px; height: 90px; object-fit: cover; border-radius: 6px; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
        strong { color: var(--text-light); font-size: 1.1rem; }
        .watched { color: var(--success); font-weight: 600; }
        .unwatched { color: var(--accent-secondary); font-weight: 600; }

        .action-btn, .delete-btn { background: transparent; padding: 6px 12px; font-size: 0.85rem; cursor: pointer; border-radius: 4px; font-weight: 600; }
        .action-btn { border: 1px solid var(--accent-primary); color: var(--accent-primary); }
        .action-btn:hover { background: var(--accent-primary); color: var(--bg-color); }
        .delete-btn { border: 1px solid var(--danger); color: var(--danger); margin-left: 5px; }
        .delete-btn:hover { background: var(--danger); color: #fff; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>The Cinematic Vault</h1>
            
            <div class="controls-wrapper">
                <select id="themeSelector" class="theme-select" onchange="changeTheme()">
                    <option value="theme-dark">Cinematic Dark</option>
                    <option value="theme-light">Studio Light</option>
                    <option value="theme-blue">Deep Ocean</option>
                    <option value="theme-green">Matrix Green</option>
                </select>

                <span>User: <strong><%= session.getAttribute("username") %></strong></span> 
                <a href="auth?action=logout" class="logout-btn">Logout</a>
            </div>
        </div>

        <div class="form-box">
            <form action="movies" method="post">
                <input type="hidden" name="action" value="add">
                <input type="text" name="title" placeholder="Movie Title (e.g., Inception)" required>
                <select name="genre" required>
                    <option value="" disabled selected>Select Genre...</option>
                    <option value="Dark Thriller">Dark Thriller</option>
                    <option value="Mind-Bending Sci-Fi">Mind-Bending Sci-Fi</option>
                    <option value="Gritty Drama">Gritty Drama</option>
                    <option value="Action">Action</option>
                </select>
                <input type="number" name="releaseYear" placeholder="Year" required min="1900" max="2100">
                <button type="submit">Add to Vault</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Poster</th>
                    <th><a href="movies?sort=title">Title</a></th>
                    <th><a href="movies?sort=genre">Genre</a></th>
                    <th>Year</th>
                    <th><a href="movies?sort=status">Status</a></th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                    if (movies != null && !movies.isEmpty()) {
                        for (Movie m : movies) { 
                %>
                <tr>
                    <td><img src="<%= m.getPosterUrl() != null ? m.getPosterUrl() : "https://via.placeholder.com/70x100?text=N/A" %>" class="poster-img" alt="Poster"></td>
                    <td><strong><%= m.getTitle() %></strong></td>
                    <td><%= m.getGenre() %></td>
                    <td><%= m.getReleaseYear() %></td>
                    <td class="<%= m.isWatched() ? "watched" : "unwatched" %>">
                        <%= m.isWatched() ? "Watched" : "Un-watched" %>
                    </td>
                    <td style="white-space: nowrap;">
                        <form action="movies" method="post" style="display:inline-block; margin:0;">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button type="submit" class="action-btn">Toggle</button>
                        </form>
                        
                        <form action="movies" method="post" style="display:inline-block; margin:0;" onsubmit="return confirm('Are you sure you want to delete this movie from the vault?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button type="submit" class="delete-btn">Delete</button>
                        </form>
                    </td>
                </tr>
                <% 
                        } 
                    } else { 
                %>
                <tr><td colspan="6" style="text-align:center;">Your vault is empty. Add a movie to see the magic.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script>
        // Function to change the theme and save it to LocalStorage
        function changeTheme() {
            const selectedTheme = document.getElementById('themeSelector').value;
            document.body.className = selectedTheme; // Applies the class to the body
            localStorage.setItem('userVaultTheme', selectedTheme); // Saves choice to browser memory
        }

        // When the page loads, check if the user previously saved a theme
        window.onload = function() {
            const savedTheme = localStorage.getItem('userVaultTheme') || 'theme-dark';
            document.body.className = savedTheme;
            document.getElementById('themeSelector').value = savedTheme;
        }
    </script>
</body>
</html>