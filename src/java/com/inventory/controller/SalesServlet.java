package com.inventory.controller;

import com.inventory.config.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SalesServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("product_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        Connection conn = null;
        PreparedStatement pstProduct = null;
        PreparedStatement pstSale = null;
        PreparedStatement pstItem = null;
        PreparedStatement pstUpdateStock = null;
        ResultSet rsProd = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Transactions ආරක්ෂිතව සිදු කිරීමට
            
            // 1. භාණ්ඩයේ මිල සහ දැනට ඇති Stock ප්‍රමාණය ලබා ගැනීම
            String prodSql = "SELECT price, stock_quantity FROM products WHERE product_id = ?";
            pstProduct = conn.prepareStatement(prodSql);
            pstProduct.setInt(1, productId);
            rsProd = pstProduct.executeQuery();
            
            if (rsProd.next()) {
                double price = rsProd.getDouble("price");
                int currentStock = rsProd.getInt("stock_quantity");
                
                // ඉල්ලන ප්‍රමාණයට වඩා Stock තියෙනවාදැයි බැලීම
                if (currentStock >= quantity) {
                    double subtotal = price * quantity;
                    
                    // 2. Sales වගුවට අලුත් බිලක් එකතු කිරීම
                    String saleSql = "INSERT INTO sales (sale_date, total_amount) VALUES (?, ?)";
                    pstSale = conn.prepareStatement(saleSql, Statement.RETURN_GENERATED_KEYS);
                    pstSale.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                    pstSale.setDouble(2, subtotal);
                    pstSale.executeUpdate();
                    
                    // අලුතින් හැදුනු Sale ID එක ලබා ගැනීම
                    ResultSet generatedKeys = pstSale.getGeneratedKeys();
                    int saleId = 0;
                    if (generatedKeys.next()) {
                        saleId = generatedKeys.getInt(1);
                    }
                    
                    // 3. Sales_Items වගුවට විස්තර එකතු කිරීම
                    String itemSql = "INSERT INTO sales_items (sale_id, product_id, quantity, subtotal) VALUES (?, ?, ?, ?)";
                    pstItem = conn.prepareStatement(itemSql);
                    pstItem.setInt(1, saleId);
                    pstItem.setInt(2, productId);
                    pstItem.setInt(3, quantity);
                    pstItem.setDouble(4, subtotal);
                    pstItem.executeUpdate();
                    
                    // 4. Products වගුවේ ඇති Stock ප්‍රමාණය අඩු කිරීම (Inventory Update)
                    String updateStockSql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
                    pstUpdateStock = conn.prepareStatement(updateStockSql);
                    pstUpdateStock.setInt(1, quantity);
                    pstUpdateStock.setInt(2, productId);
                    pstUpdateStock.executeUpdate();
                    
                    conn.commit(); // හැමදේම සාර්ථක නම් Database එකට Save කිරීම
                }
            }
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try { 
                if(rsProd != null) rsProd.close(); 
                if(pstProduct != null) pstProduct.close(); 
                if(pstSale != null) pstSale.close(); 
                if(pstItem != null) pstItem.close(); 
                if(pstUpdateStock != null) pstUpdateStock.close(); 
                if(conn != null) conn.close(); 
            } catch(Exception e){}
        }
        
        response.sendRedirect("sales.jsp");
    }
}