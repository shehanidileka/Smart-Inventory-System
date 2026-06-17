<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.inventory.config.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartInventory AI - Product Management</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #11111d; color: #fff; display: flex; }
        .sidebar { width: 260px; height: 100vh; background-color: #1b1b28; position: fixed; top: 0; left: 0; border-right: 1px solid #2c2c3e; padding-top: 20px; }
        .sidebar h2 { text-align: center; color: #6c5ce7; font-size: 22px; margin-bottom: 30px; }
        .sidebar a { display: block; padding: 15px 25px; color: #a2a2d0; text-decoration: none; font-size: 15px; border-left: 4px solid transparent; }
        .sidebar a:hover, .sidebar a.active { background-color: #2c2c3e; color: #fff; border-left-color: #6c5ce7; }
        
        .main-content { margin-left: 260px; padding: 40px; width: calc(100% - 260px); }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #2c2c3e; padding-bottom: 20px; margin-bottom: 30px; }
        
        /* Form & Table Style */
        .container { display: flex; gap: 30px; }
        .form-container { background: #1b1b28; padding: 25px; border-radius: 10px; width: 30%; border: 1px solid #2c2c3e; height: fit-content; }
        .table-container { background: #1b1b28; padding: 25px; border-radius: 10px; width: 70%; border: 1px solid #2c2c3e; }
        
        .input-group { margin-bottom: 15px; }
        .input-group label { display: block; font-size: 13px; color: #a2a2d0; margin-bottom: 5px; }
        .input-group input, .input-group select { width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #2c2c3e; background: #11111d; color: #fff; box-sizing: border-box; }
        
        .btn { padding: 10px 15px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; width: 100%; }
        .btn-submit { background: #6c5ce7; color: white; }
        .btn-search { background: #00b894; color: white; width: auto; padding: 10px 20px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #2c2c3e; }
        th { background-color: #11111d; color: #a2a2d0; }
        .action-links a { text-decoration: none; font-size: 13px; margin-right: 10px; font-weight: bold; }
        .edit-link { color: #f1c40f; }
        .delete-link { color: #e74c3c; }
    </style>
    <script>
        // Table එකේ පේළියක් ක්ලික් කරපු ගමන් Form එකට Data ටික පිරෙන්න හදන JavaScript එක (Update කරන්න ලේසි වෙන්න)
        function editProduct(id, name, cat, price, qty, expiry) {
            document.getElementById('prod_id').value = id;
            document.getElementById('prod_name').value = name;
            document.getElementById('prod_cat').value = cat;
            document.getElementById('prod_price').value = price;
            document.getElementById('prod_qty').value = qty;
            document.getElementById('prod_expiry').value = expiry;
            document.getElementById('form_action').value = "update";
            document.getElementById('submit_btn').innerText = "Update Product";
        }
    </script>
</head>
<body>

    <div class="sidebar">
        <h2>SmartInventory AI</h2>
        <a href="dashboard.jsp">🏠 Dashboard</a>
        <a href="products.jsp" class="active">📦 Product Management</a>
        <a href="inventory.jsp">📊 Inventory Management</a>
        <a href="sales.jsp">💼 Sales Management</a>
        <a href="reports.jsp">📋 Reports</a>
        <a href="ai_insights.jsp">🤖 AI Insights Dashboard</a>
        <a href="login.jsp" style="margin-top: 50px; color: #ff7675;">🚪 Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Product Management</h1>
            <form action="products.jsp" method="GET">
                <input type="text" name="search" placeholder="Search product name..." style="padding: 10px; border-radius: 6px; border: 1px solid #2c2c3e; background: #1b1b28; color:#fff;">
                <button type="submit" class="btn btn-search">Search</button>
            </form>
        </div>

        <div class="container">
            <div class="form-container">
                <h3 style="margin-top:0;">Manage Product</h3>
                <form action="ProductServlet" method="POST">
                    <input type="hidden" id="prod_id" name="id">
                    <input type="hidden" id="form_action" name="action" value="add">
                    
                    <div class="input-group">
                        <label>Product Name</label>
                        <input type="text" id="prod_name" name="name" required>
                    </div>
                    <div class="input-group">
                        <label>Category</label>
                        <select id="prod_cat" name="category">
                            <option value="Rice & Grains">Rice & Grains</option>
                            <option value="Dairy Products">Dairy Products</option>
                            <option value="Beverages">Beverages</option>
                            <option value="Bakery & Biscuits">Bakery & Biscuits</option>
                            <option value="Personal Care">Personal Care</option>
                            <option value="Household Items">Household Items</option>
                            <option value="Snacks & Spices">Snacks & Spices</option>
                        </select>
                    </div>
                    <div class="input-group">
                        <label>Price (LKR)</label>
                        <input type="number" step="0.01" id="prod_price" name="price" required>
                    </div>
                    <div class="input-group">
                        <label>Initial Stock Qty</label>
                        <input type="number" id="prod_qty" name="stock_quantity" required>
                    </div>
                    <div class="input-group">
                        <label>Expiry Date</label>
                        <input type="date" id="prod_expiry" name="expiry_date">
                    </div>
                    <button type="submit" id="submit_btn" class="btn btn-submit">Add Product</button>
                </form>
            </div>

            <div class="table-container">
                <h3 style="margin-top:0;">Product List</h3>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Expiry</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conn = DBConnection.getConnection();
                            String searchQuery = request.getParameter("search");
                            String sql = "SELECT * FROM products ORDER BY product_id DESC";
                            PreparedStatement pst;
                            
                            if(searchQuery != null && !searchQuery.trim().isEmpty()) {
                                sql = "SELECT * FROM products WHERE name LIKE ? ORDER BY product_id DESC";
                                pst = conn.prepareStatement(sql);
                                pst.setString(1, "%" + searchQuery + "%");
                            } else {
                                pst = conn.prepareStatement(sql);
                            }
                            
                            ResultSet rs = pst.executeQuery();
                            while(rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("product_id") %></td>
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getString("category") %></td>
                            <td><%= rs.getDouble("price") %></td>
                            <td><%= rs.getInt("stock_quantity") %></td>
                            <td><%= rs.getDate("expiry_date") %></td>
                            <td class="action-links">
                                <a href="#" class="edit-link" onclick="editProduct('<%= rs.getInt("product_id") %>', '<%= rs.getString("name") %>', '<%= rs.getString("category") %>', '<%= rs.getDouble("price") %>', '<%= rs.getInt("stock_quantity") %>', '<%= rs.getDate("expiry_date") %>')">Edit</a>
                                <a href="ProductServlet?action=delete&id=<%= rs.getInt("product_id") %>" class="delete-link" onclick="return confirm('මෙම භාණ්ඩය ඉවත් කිරීමට අවශ්‍යද?')">Delete</a>
                            </td>
                        </tr>
                        <% 
                            }
                            rs.close(); pst.close(); conn.close();
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>