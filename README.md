
🎬 The Cinematic Vault
The Cinematic Vault is a full-stack Java EE web application designed for film enthusiasts to manage a personalized movie catalog. Moving beyond a simple library system, this project features a localized database, third-party API integration, and a dynamic, theme-able user interface.

🚀 Key Features
Secure User Authentication: Session-based login/logout system allowing individual users to manage their own private vaults.

Live Poster Integration: Automatically fetches high-quality movie posters from the OMDb API based on the title entered.

Smart CRUD Operations: Complete Create, Read, Update (Toggle Status), and Delete functionality with MySQL backend.

Dynamic UI Layouts: Toggle between a Netflix-style Grid View for posters and a Clean List View for data management.

Personalized Themes: Interactive theme switcher with four distinct palettes: Cinematic Dark, Studio Light, Deep Ocean, and Matrix Green.

Persistent Settings: Utilizes browser localStorage to remember the user's preferred layout and theme even after refreshing.

🛠️ Technical Stack
Backend: Java Servlets, JSP (JavaServer Pages), JDBC.

Architecture: Model-View-Controller (MVC).

Database: MySQL.

API: OMDb (Open Movie Database) REST API.

Frontend: HTML5, CSS3 (Flexbox/Grid), JavaScript (ES6).

Server: Apache Tomcat 10.1.

📂 Project Structure
com.watchlist.model: Contains the Movie.java POJO.

com.watchlist.controller: Handles business logic via MovieServlet and AuthServlet.

com.watchlist.util: Manages database connectivity through DBConnection.

webapp: Contains the frontend logic (index.jsp, login.jsp).

How to use this description:
Repository About Section: Use the short version:

"A full-stack Java EE Cinematic Watchlist manager featuring OMDb API integration, MySQL backend, and dynamic theme/view toggles."


⚙️ Setup & Installation
1. Database Configuration
Run the following SQL script in your MySQL environment:

SQL
CREATE DATABASE watchlist_db;
USE watchlist_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    release_year INT NOT NULL,
    is_watched BOOLEAN DEFAULT FALSE,
    poster_url VARCHAR(500),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
2. Eclipse Setup
Import the project as a Dynamic Web Project.

Add the mysql-connector-j JAR to your Build Path.

Open DBConnection.java and update your MySQL USER and PASSWORD.

Open MovieServlet.java and replace OMDB_API_KEY with your free key from omdbapi.com.

3. Run
Right-click the project -> Run on Server.

Access the app at http://localhost:8080/CinematicVault/movies.

Developed by Vishal Mehta - MCA Data Science
"""
