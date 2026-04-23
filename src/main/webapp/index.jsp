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
        /* THEMES */
        :root {
            --bg-color: #0b0c10; --surface-color: #1f2833; --accent-primary: #66fcf1; --accent-secondary: #45a29e;
            --text-main: #c5c6c7; --text-light: #ffffff; --success: #4caf50; --danger: #ff5252;
            --bg-gradient: radial-gradient(circle at top right, #1f2833 0%, transparent 40%);
        }
        body.theme-light {
            --bg-color: #f4f4f9; --surface-color: #ffffff; --accent-primary: #5c67f2; --accent-secondary: #747df5;
            --text-main: #333333; --text-light: #111111; --bg-gradient: none;
        }
        body.theme-blue {
            --bg-color: #0a192f; --surface-color: #112240; --accent-primary: #64ffda; --accent-secondary: #8892b0;
            --text-main: #ccd6f6; --text-light: #e6f1ff; --bg-gradient: radial-gradient(circle at top right, #112240 0%, transparent 40%);
        }
        body.theme-green {
            --bg-color: #0d1a15; --surface-color: #162c23; --accent-primary: #00ff88; --accent-secondary: #00b35f;
            --text-main: #c4ebd6; --text-light: #ffffff; --bg-gradient: radial-gradient(circle at top right, #162c23 0%, transparent 40%);
        }

        /* CORE */
        body { background-color: var(--bg-color); color: var(--text-main); font-family: 'Outfit', sans-serif; margin: 0; padding: 40px 20px; background-image: var(--bg-gradient); transition: all 0.4s ease; }
        .container { max-width: 1100px; margin: auto; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--surface-color); padding-bottom: 15px; margin-bottom: 30px; }
        h1 { color: var(--accent-primary); margin: 0; font-weight: 800; text-transform: uppercase; letter-spacing: 2px; }
        .controls-wrapper { display: flex; align-items: center; gap: 15px; }

        /* BUTTONS & INPUTS */
        .theme-select { background: var(--surface-color); color: var(--text-light); border: 1px solid var(--accent-secondary); padding: 8px 12px; border-radius: 6px; cursor: pointer; }
        .icon-btn { background: var(--surface-color); color: var(--accent-secondary); border: 1px solid var(--accent-secondary); padding: 8px 12px; border-radius: 6px; cursor: pointer; font-weight: bold; transition: 0.3s; }
        .icon-btn.active, .icon-btn:hover { background: var(--accent-primary); color: var(--bg-color); border-color: var(--accent-primary); }
        .logout-btn { background: rgba(255,82,82,0.1); color: var(--danger); text-decoration: none; padding: 8px 16px; border-radius: 6px; font-weight: 600; border: 1px solid var(--danger); transition: 0.3s; }
        .logout-btn:hover { background: var(--danger); color: #fff; }

        .form-box { background: var(--surface-color); padding: 25px; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .form-box form { display: flex; width: 100%; gap: 15px; align-items: center; }
        input, select { background: var(--bg-color); color: var(--text-light); width: 100%; padding: 12px 15px; border-radius: 6px; border: 1px solid var(--surface-color); }
        input:focus, select:focus { border-color: var(--accent-primary); outline: none; }
        .add-btn { background: var(--accent-primary); color: var(--bg-color); font-weight: 800; cursor: pointer; padding: 12px 25px; border-radius: 6px; border: none; text-transform: uppercase; white-space: nowrap; transition: 0.3s; }
        .add-btn:hover { filter: brightness(1.2); transform: translateY(-2px); }

        /* VIEW LAYOUTS (The Magic Happens Here) */
        #vaultContainer { margin-top: 20px; transition: all 0.3s ease; }

        .movie-card { background: var(--surface-color); border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); overflow: hidden; transition: transform 0.2s ease; position: relative; }
        .movie-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.4); }
        .poster-img { object-fit: cover; width: 100%; display: block; }
        .movie-info { padding: 15px; }
        .movie-title { color: var(--text-light); font-size: 1.1rem; font-weight: 800; margin: 0 0 5px 0; }
        .movie-meta { font-size: 0.85rem; color: var(--accent-secondary); margin-bottom: 10px; }
        
        .status-badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; margin-bottom: 10px; }
        .status-badge.watched { background: rgba(76, 175, 80, 0.2); color: var(--success); border: 1px solid var(--success); }
        .status-badge.unwatched { background: rgba(255, 82, 82, 0.1); color: var(--danger); border: 1px solid var(--danger); }

        .card-actions { display: flex; gap: 5px; }
        .action-btn, .delete-btn { flex: 1; padding: 8px; font-size: 0.85rem; cursor: pointer; border-radius: 4px; font-weight: 600; text-align: center; border: none; transition: 0.3s; }
        .action-btn { background: rgba(102, 252, 241, 0.1); color: var(--accent-primary); border: 1px solid var(--accent-primary); }
        .action-btn:hover { background: var(--accent-primary); color: var(--bg-color); }
        .delete-btn { background: rgba(255, 82, 82, 0.1); color: var(--danger); border: 1px solid var(--danger); }
        .delete-btn:hover { background: var(--danger); color: #fff; }

        /* GRID VIEW STYLES */
        .view-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
        .view-grid .poster-img { height: 300px; }
        .view-grid .movie-info { display: flex; flex-direction: column; height: 100%; }

        /* LIST VIEW STYLES */
        .view-list { display: flex; flex-direction: column; gap: 15px; }
        .view-list .movie-card { display: flex; align-items: center; }
        .view-list .poster-img { width: 80px; height: 120px; }
        .view-list .movie-info { display: flex; align-items: center; justify-content: space-between; width: 100%; padding: 0 20px; }
        .view-list .movie-details { flex: 2; }
        .view-list .status-badge { margin: 0; }
        .view-list .card-actions { flex: 1; justify-content: flex-end; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>The Cinematic Vault</h1>
            
            <div class="controls-wrapper">
                <button id="btnGrid" class="icon-btn" onclick="changeView('grid')">GRID</button>
                <button id="btnList" class="icon-btn" onclick="changeView('list')">LIST</button>

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
                <button type="submit" class="add-btn">Add to Vault</button>
            </form>
        </div>

        <div id="vaultContainer" class="view-grid">
            <% 
                List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                if (movies != null && !movies.isEmpty()) {
                    for (Movie m : movies) { 
            %>
            <div class="movie-card">
                <img src="<%= m.getPosterUrl() != null ? m.getPosterUrl() : "https://via.placeholder.com/300x450?text=No+Poster" %>" class="poster-img" alt="Poster">
                
                <div class="movie-info">
                    <div class="movie-details">
                        <h3 class="movie-title"><%= m.getTitle() %></h3>
                        <div class="movie-meta"><%= m.getGenre() %> • <%= m.getReleaseYear() %></div>
                        <div class="status-badge <%= m.isWatched() ? "watched" : "unwatched" %>">
                            <%= m.isWatched() ? "WATCHED" : "UN-WATCHED" %>
                        </div>
                    </div>
                    
                    <div class="card-actions">
                        <form action="movies" method="post" style="flex:1; margin:0;">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button type="submit" class="action-btn" title="Toggle Status">Toggle</button>
                        </form>
                        <form action="movies" method="post" style="flex:1; margin:0;" onsubmit="return confirm('Delete this movie?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button type="submit" class="delete-btn" title="Remove">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
            <% 
                    } 
                } else { 
            %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                Your vault is empty. Add a movie to see the magic.
            </div>
            <% } %>
        </div>
    </div>

    <script>
        function changeTheme() {
            const selectedTheme = document.getElementById('themeSelector').value;
            document.body.className = selectedTheme;
            localStorage.setItem('userVaultTheme', selectedTheme);
        }

        function changeView(viewType) {
            const container = document.getElementById('vaultContainer');
            const btnGrid = document.getElementById('btnGrid');
            const btnList = document.getElementById('btnList');

            if (viewType === 'list') {
                container.className = 'view-list';
                btnList.classList.add('active');
                btnGrid.classList.remove('active');
            } else {
                container.className = 'view-grid';
                btnGrid.classList.add('active');
                btnList.classList.remove('active');
            }
            localStorage.setItem('userVaultLayout', viewType);
        }

        // Initialize saved settings on page load
        window.onload = function() {
            // Load Theme
            const savedTheme = localStorage.getItem('userVaultTheme') || 'theme-dark';
            document.body.className = savedTheme;
            document.getElementById('themeSelector').value = savedTheme;

            // Load View (Grid/List)
            const savedLayout = localStorage.getItem('userVaultLayout') || 'grid';
            changeView(savedLayout);
        }
    </script>
</body>
</html>