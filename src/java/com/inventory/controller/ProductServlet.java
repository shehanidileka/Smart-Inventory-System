package com.inventory.controller;

import com.inventory.config.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stock_quantity"));
            String expiryDate = request.getParameter("expiry_date");
            
            conn = DBConnection.getConnection();
            
            if ("add".equals(action)) {
                String sql = "INSERT INTO products (name, category, price, stock_quantity, expiry_date) VALUES (?, ?, ?, ?, ?)";
                pst = conn.prepareStatement(sql);
                pst.setString(1, name);
                pst.setString(2, category);
                pst.setDouble(3, price);
                pst.setInt(4, stockQuantity);
                
                if(expiryDate == null || expiryDate.trim().isEmpty()) {
                    pst.setNull(5, java.sql.Types.DATE);
                } else {
                    pst.setString(5, expiryDate);
                }
                pst.executeUpdate();
                
            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if(idStr != null && !idStr.trim().isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    String sql = "UPDATE products SET name=?, category=?, price=?, stock_quantity=?, expiry_date=? WHERE product_id=?";
                    pst = conn.prepareStatement(sql);
                    pst.setString(1, name);
                    pst.setString(2, category);
                    pst.setDouble(3, price);
                    pst.setInt(4, stockQuantity);
                    
                    if(expiryDate == null || expiryDate.trim().isEmpty() || "null".equals(expiryDate)) {
                        pst.setNull(5, java.sql.Types.DATE);
                    } else {
                        pst.setString(5, expiryDate);
                    }
                    pst.setInt(6, id);
                    pst.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // NetBeans Output window එකේ error එක බලාගන්න
        } finally {
            try { if(pst != null) pst.close(); if(conn != null) conn.close(); } catch(Exception e){}
        }
        response.sendRedirect("products.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            if ("delete".equals(action) && idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);
                conn = DBConnection.getConnection();
                
                // Foreign key error එකක් එන එක වලක්වන්න (sales_items වගුවේ මේ product_id එක තිබුනොත් delete කරන්න දෙන්නේ නෑ)
                // ඒ නිසා ආරක්ෂිතව delete කරන්න:
                String sql = "DELETE FROM products WHERE product_id=?";
                pst = conn.prepareStatement(sql);
                pst.setInt(1, id);
                pst.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(pst != null) pst.close(); if(conn != null) conn.close(); } catch(Exception e){}
        }
        response.sendRedirect("products.jsp");
    }
}