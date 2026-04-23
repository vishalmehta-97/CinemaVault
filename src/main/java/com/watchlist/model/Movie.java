package com.watchlist.model;

public class Movie {
    private int id;
    private String title;
    private String genre;
    private int releaseYear;
    private boolean isWatched;
    private String posterUrl; // NEW

    // Updated Constructor
    public Movie(int id, String title, String genre, int releaseYear, boolean isWatched, String posterUrl) {
        this.id = id;
        this.title = title;
        this.genre = genre;
        this.releaseYear = releaseYear;
        this.isWatched = isWatched;
        this.posterUrl = posterUrl;
    }

    // Getters
    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getGenre() { return genre; }
    public int getReleaseYear() { return releaseYear; }
    public boolean isWatched() { return isWatched; }
    public String getPosterUrl() { return posterUrl; } // NEW
}