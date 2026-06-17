package com.inventory.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/smart_inventory";
    private static final String USERNAME = "root"; // ඔයාගේ MySQL Username එක (සාමාන්‍යයෙන් root)
    private static final String PASSWORD = "";     // ඔයාගේ MySQL Password එක (නැත්නම් හිස්ව තබන්න)

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}