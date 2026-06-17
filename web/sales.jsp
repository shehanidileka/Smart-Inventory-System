<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.inventory.config.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartInventory AI - Sales Management</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #11111d; color: #fff; display: flex; }
        .sidebar { width: 260px; height: 100vh; background-color: #1b1b28; position: fixed; top: 0; left: 0; border-right: 1px solid #2c2c3e; padding-top: 20px; }
        .sidebar h2 { text-align: center; color: #6c5ce7; font-size: 22px; margin-bottom: 30px; }
        .sidebar a { display: block; padding: 15px 25px; color: #a2a2d0; text-decoration: none; font-size: 15px; border-left: 4px solid transparent; }
        .sidebar a:hover, .sidebar a.active { background-color: #2c2c3e; color: #fff; border-left-color: #6c5ce7; }
        
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .header { border-bottom: 1px solid #2c2c3e; padding-bottom: 20px; margin-bottom: 30px; }
        
        .container { display: flex; gap: 30px; }
        .form-container { background: #1b1b28; padding: 25px; border-radius: 10px; width: 35%; border: 1px solid #2c2c3e; height: fit-content; }
        .table-container { background: #1b1b28; padding: 25px; border-radius: 10px; width: 65%; border: 1px solid #2c2c3e; }
        
        .input-group { margin-bottom: 15px; }
        .input-group label { display: block; font-size: 13px; color: #a2a2d0; margin-bottom: 5px; }
        .input-group input, .input-group select { width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #2c2c3e; background: #11111d; color: #fff; box-sizing: border-box; }
        
        .btn { padding: 10px 15px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; width: 100%; background: #6c5ce7; color: white; }
        .btn:hover { background: #5b4cc4; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #2c2c3e; }
        th { background-color: #11111d; color: #a2a2d0; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>SmartInventory AI</h2>
        <a href="dashboard.jsp">🏠 Dashboard</a>
        <a href="products.jsp">📦 Product Management</a>
        <a href="inventory.jsp">📊 Inventory Management</a>
        <a href="sales.jsp" class="active">💼 Sales Management</a>
        <a href="reports.jsp">📋 Reports</a>
        <a href="ai_insights.jsp">🤖 AI Insights Dashboard</a>
        <a href="login.jsp" style="margin-top: 50px; color: #ff7675;">🚪 Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Sales Management</h1>
        </div>

        <div class="container">
            <div class="form-container">
                <h3 style="margin-top:0; color: #00b894;">➕ Record New Sale</h3>
                <form action="SalesServlet" method="POST">
                    <div class="input-group">
                        <label>Select Product</label>
                        <select name="product_id" required>
                            <%
                                Connection conn = DBConnection.getConnection();
                                String prodSql = "SELECT product_id, name, price, stock_quantity FROM products WHERE stock_quantity > 0 ORDER BY name ASC";
                                PreparedStatement pstProd = conn.prepareStatement(prodSql);
                                ResultSet rsProd = pstProd.executeQuery();
                                while(rsProd.next()) {
                            %>
                            <option value="<%= rsProd.getInt("product_id") %>">
                                <%= rsProd.getString("name") %> - LKR <%= rsProd.getDouble("price") %> (Available: <%= rsProd.getInt("stock_quantity") %>)
                            </option>
                            <% } rsProd.close(); pstProd.close(); %>
                        </select>
                    </div>
                    <div class="input-group">
                        <label>Quantity</label>
                        <input type="number" name="quantity" min="1" value="1" required>
                    </div>
                    <button type="submit" class="btn">Complete Sale</button>
                </form>
            </div>

            <div class="table-container">
                <h3 style="margin-top:0;">Recent Sales Log (Last 10 Transactions)</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Sale ID</th>
                            <th>Date & Time</th>
                            <th>Total Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String salesSql = "SELECT * FROM sales ORDER BY sale_id DESC LIMIT 10";
                            PreparedStatement pstSales = conn.prepareStatement(salesSql);
                            ResultSet rsSales = pstSales.executeQuery();
                            while(rsSales.next()) {
                        %>
                        <tr>
                            <td>#<%= rsSales.getInt("sale_id") %></td>
                            <td><%= rsSales.getTimestamp("sale_date") %></td>
                            <td style="font-weight: bold; color: #2ed573;">LKR <%= rsSales.getDouble("total_amount") %></td>
                        </tr>
                        <% } rsSales.close(); pstSales.close(); conn.close(); %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>