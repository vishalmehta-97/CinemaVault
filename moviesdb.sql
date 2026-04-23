CREATE DATABASE watchlist_db;
USE watchlist_db;

CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    release_year INT NOT NULL,
    is_watched BOOLEAN DEFAULT FALSE
);

-- Inserting some default cinematic data
INSERT INTO movies (title, genre, release_year, is_watched) VALUES 
('Inception', 'Mind-Bending Sci-Fi', 2010, TRUE),
('Se7en', 'Dark Thriller', 1995, TRUE),
('The Batman', 'Gritty Drama', 2022, FALSE),
('Interstellar', 'Mind-Bending Sci-Fi', 2014, FALSE);


SELECT * FROM watchlist_db.movies;


truncate watchlist_db.movies;

SELECT user();

USE watchlist_db;

-- 1. Create the Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

Select * from users;

-- 2. Insert a default user so you can log in immediately
INSERT INTO users (username, password) VALUES ('karan', 'admin123');
INSERT INTO users (username, password) VALUES ('vishal', 'admin123');
INSERT INTO users (username, password) VALUES ('the_boys_admin', 'project123');

-- 3. Update the movies table
ALTER TABLE movies ADD COLUMN user_id INT;
ALTER TABLE movies ADD COLUMN poster_url VARCHAR(500);

-- 4. Link existing movies to the default user and enforce the foreign key
UPDATE movies SET user_id = 1; 
ALTER TABLE movies ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);


SELECT title, poster_url FROM movies;
