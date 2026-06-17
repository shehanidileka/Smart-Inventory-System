<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.inventory.config.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartInventory AI - Inventory Status</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #11111d; color: #fff; display: flex; }
        .sidebar { width: 260px; height: 100vh; background-color: #1b1b28; position: fixed; top: 0; left: 0; border-right: 1px solid #2c2c3e; padding-top: 20px; }
        .sidebar h2 { text-align: center; color: #6c5ce7; font-size: 22px; margin-bottom: 30px; }
        .sidebar a { display: block; padding: 15px 25px; color: #a2a2d0; text-decoration: none; font-size: 15px; border-left: 4px solid transparent; }
        .sidebar a:hover, .sidebar a.active { background-color: #2c2c3e; color: #fff; border-left-color: #6c5ce7; }
        
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .header { border-bottom: 1px solid #2c2c3e; padding-bottom: 20px; margin-bottom: 30px; }
        
        .grid { display: flex; gap: 20px; margin-bottom: 30px; }
        .stat-card { background: #1b1b28; padding: 20px; border-radius: 8px; border: 1px solid #2c2c3e; width: 50%; }
        .stat-card h3 { margin: 0 0 10px 0; font-size: 14px; color: #7c7cb0; }
        .stat-card p { margin: 0; font-size: 24px; font-weight: bold; }
        
        .table-container { background: #1b1b28; padding: 25px; border-radius: 10px; border: 1px solid #2c2c3e; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #2c2c3e; }
        th { background-color: #11111d; color: #a2a2d0; }
        
        /* Alerts සකසන කොටස */
        .status-badge { padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .status-normal { background-color: #2ed573; color: #fff; }
        .status-low { background-color: #ff7675; color: #fff; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>SmartInventory AI</h2>
        <a href="dashboard.jsp">🏠 Dashboard</a>
        <a href="products.jsp">📦 Product Management</a>
        <a href="inventory.jsp" class="active">📊 Inventory Management</a>
        <a href="sales.jsp">💼 Sales Management</a>
        <a href="reports.jsp">📋 Reports</a>
        <a href="ai_insights.jsp">🤖 AI Insights Dashboard</a>
        <a href="login.jsp" style="margin-top: 50px; color: #ff7675;">🚪 Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Inventory & Stock Status</h1>
        </div>

        <%
            Connection conn = DBConnection.getConnection();
            
            // 1. මුළු Stock එකේ තියෙන බඩු ප්‍රමාණය ගණන් කිරීම
            String countSql = "SELECT COUNT(*) AS total FROM products";
            PreparedStatement pstCount = conn.prepareStatement(countSql);
            ResultSet rsCount = pstCount.executeQuery();
            int totalProducts = 0;
            if(rsCount.next()) totalProducts = rsCount.getInt("total");
            
            // 2. Stock එක 15ට වඩා අඩු බඩු (Low Stock Items) ගණන් කිරීම
            String lowCountSql = "SELECT COUNT(*) AS low_total FROM products WHERE stock_quantity <= 15";
            PreparedStatement pstLowCount = conn.prepareStatement(lowCountSql);
            ResultSet rsLowCount = pstLowCount.executeQuery();
            int lowStockProducts = 0;
            if(rsLowCount.next()) lowStockProducts = rsLowCount.getInt("low_total");
        %>

        <div class="grid">
            <div class="stat-card">
                <h3>Total Monitored Products</h3>
                <p><%= totalProducts %> Items</p>
            </div>
            <div class="stat-card" style="border-color: <%= lowStockProducts > 0 ? "#ff7675" : "#2c2c3e" %>;">
                <h3>Low Stock Alerts</h3>
                <p style="color: <%= lowStockProducts > 0 ? "#ff7675" : "#2ed573" %>;"><%= lowStockProducts %> Items Need Restocking</p>
            </div>
        </div>

        <div class="table-container">
            <h3 style="margin-top:0;">Current Stock Levels</h3>
            <table>
                <thead>
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Category</th>
                        <th>Available Stock</th>
                        <th>Status Alert</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "SELECT * FROM products ORDER BY stock_quantity ASC";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        ResultSet rs = pst.executeQuery();
                        while(rs.next()) {
                            int stock = rs.getInt("stock_quantity");
                            boolean isLow = (stock <= 15); // Stock එක 15 හෝ ඊට අඩු නම් Alert එකක් දෙනවා
                    %>
                    <tr>
                        <td><%= rs.getInt("product_id") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("category") %></td>
                        <td style="font-weight: bold; color: <%= isLow ? "#ff7675" : "#fff" %>;"><%= stock %></td>
                        <td>
                            <% if(isLow) { %>
                                <span class="status-badge status-low">⚠️ LOW STOCK</span>
                            <% } else { %>
                                <span class="status-badge status-normal">✔ GOOD</span>
                            <% } %>
                        </td>
                    </tr>
                    <% 
                        }
                        rs.close(); pst.close(); rsCount.close(); pstCount.close(); rsLowCount.close(); pstLowCount.close(); conn.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>