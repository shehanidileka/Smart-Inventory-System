package com.inventory.controller;

import com.inventory.config.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            // ඩේටාබේස් එකේ පරිශීලකයා ඉන්නවාදැයි බැලීම
            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);
            
            rs = pst.executeQuery();
            
            if (rs.next()) {
                // Login සාර්ථක නම් Session එකක් සාදා Dashboard එකට යැවීම
                HttpSession session = request.getSession();
                session.setAttribute("user", rs.getString("username"));
                session.setAttribute("role", rs.getString("role")); // Admin/Staff [cite: 33]
                
                response.sendRedirect("dashboard.jsp"); // ඊළඟට හදන පිටුව
            } else {
                // Login වැරදි නම් නැවත Login පිටුවට හරවා යැවීම
                request.setAttribute("errorMessage", "Username හෝ Password වැරදියි!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); if(pst != null) pst.close(); if(conn != null) conn.close(); } catch(Exception e){}
        }
    }
}