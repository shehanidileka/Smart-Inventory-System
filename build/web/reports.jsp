<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.inventory.config.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartInventory AI - Business Reports</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #11111d; color: #fff; display: flex; }
        .sidebar { width: 260px; height: 100vh; background-color: #1b1b28; position: fixed; top: 0; left: 0; border-right: 1px solid #2c2c3e; padding-top: 20px; }
        .sidebar h2 { text-align: center; color: #6c5ce7; font-size: 22px; margin-bottom: 30px; }
        .sidebar a { display: block; padding: 15px 25px; color: #a2a2d0; text-decoration: none; font-size: 15px; border-left: 4px solid transparent; }
        .sidebar a:hover, .sidebar a.active { background-color: #2c2c3e; color: #fff; border-left-color: #6c5ce7; }
        
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .header { border-bottom: 1px solid #2c2c3e; padding-bottom: 20px; margin-bottom: 30px; }
        
        .grid { display: flex; gap: 20px; margin-bottom: 30px; }
        .report-card { background: #1b1b28; padding: 25px; border-radius: 10px; border: 1px solid #2c2c3e; width: 50%; }
        .report-card h3 { margin: 0 0 10px 0; font-size: 14px; color: #7c7cb0; text-transform: uppercase; }
        .report-card p { margin: 0; font-size: 28px; font-weight: bold; color: #00b894; }
        
        .table-container { background: #1b1b28; padding: 25px; border-radius: 10px; border: 1px solid #2c2c3e; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #2c2c3e; }
        th { background-color: #11111d; color: #a2a2d0; }
        
        /* මුද්‍රණය කිරීමට (Print) අවශ්‍ය පහසුකම */
        .btn-print { background-color: #6c5ce7; color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; cursor: pointer; float: right; }
        .btn-print:hover { background-color: #5b4cc4; }
        
        @media print {
            .sidebar, .btn-print { display: none; }
            .main-content { margin-left: 0; width: 100%; color: #000; background: #fff; }
            .report-card, .table-container { background: #fff; border: 1px solid #000; color: #000; }
            th { background-color: #f5f5f5; color: #000; }
            td, th { border-bottom: 1px solid #000; }
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>SmartInventory AI</h2>
        <a href="dashboard.jsp">🏠 Dashboard</a>
        <a href="products.jsp">📦 Product Management</a>
        <a href="inventory.jsp">📊 Inventory Management</a>
        <a href="sales.jsp">💼 Sales Management</a>
        <a href="reports.jsp" class="active">📋 Reports</a>
        <a href="ai_insights.jsp">🤖 AI Insights Dashboard</a>
        <a href="login.jsp" style="margin-top: 50px; color: #ff7675;">🚪 Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <button class="btn-print" onclick="window.print()">🖨 Print Report</button>
            <h1>Management Reports & Analytics</h1>
        </div>

        <%
            Connection conn = DBConnection.getConnection();
            DecimalFormat df = new DecimalFormat("#,###.00");
            
            // 1. මුළු ආදායම (Total Revenue) ගණනය කිරීම
            String revSql = "SELECT SUM(total_amount) AS total_revenue, COUNT(*) AS total_count FROM sales";
            PreparedStatement pstRev = conn.prepareStatement(revSql);
            ResultSet rsRev = pstRev.executeQuery();
            double totalRevenue = 0;
            int totalTransactions = 0;
            if(rsRev.next()) {
                totalRevenue = rsRev.getDouble("total_revenue");
                totalTransactions = rsRev.getInt("total_count");
            }
            rsRev.close(); pstRev.close();
        %>

        <div class="grid">
            <div class="report-card">
                <h3>Total Cumulative Revenue</h3>
                <p>LKR <%= df.format(totalRevenue) %></p>
            </div>
            <div class="report-card">
                <h3>Total Processed Orders</h3>
                <p style="color: #6c5ce7;"><%= totalTransactions %> Invoices</p>
            </div>
        </div>

        <div class="table-container">
            <h3 style="margin-top:0; color: #a29bfe;">📦 Revenue Breakdown by Product Category</h3>
            <table>
                <thead>
                    <tr>
                        <th>Product Category</th>
                        <th>Total Units Sold</th>
                        <th>Generated Revenue (LKR)</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // 2. Category අනුව විකුණුම් එකතුව ලබා ගැනීම
                        String catSql = "SELECT p.category, SUM(si.quantity) AS units_sold, SUM(si.subtotal) AS cat_revenue " +
                                       "FROM sales_items si JOIN products p ON si.product_id = p.product_id " +
                                       "GROUP BY p.category ORDER BY cat_revenue DESC";
                        PreparedStatement pstCat = conn.prepareStatement(catSql);
                        ResultSet rsCat = pstCat.executeQuery();
                        while(rsCat.next()) {
                    %>
                    <tr>
                        <td style="font-weight: bold;"><%= rsCat.getString("category") %></td>
                        <td><%= rsCat.getInt("units_sold") %> Units</td>
                        <td style="color: #2ed573; font-weight: bold;">LKR <%= df.format(rsCat.getDouble("cat_revenue")) %></td>
                    </tr>
                    <% 
                        }
                        rsCat.close(); pstCat.close(); conn.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>