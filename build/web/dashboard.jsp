<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartInventory AI - Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #11111d;
            color: #fff;
            display: flex;
        }
        /* Sidebar සැකසුම් */
        .sidebar {
            width: 260px;
            height: 100vh;
            background-color: #1b1b28;
            position: fixed;
            top: 0;
            left: 0;
            border-right: 1px solid #2c2c3e;
            padding-top: 20px;
        }
        .sidebar h2 {
            text-align: center;
            color: #6c5ce7;
            font-size: 22px;
            margin-bottom: 30px;
        }
        .sidebar a {
            display: block;
            padding: 15px 25px;
            color: #a2a2d0;
            text-decoration: none;
            font-size: 15px;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #2c2c3e;
            color: #fff;
            border-left-color: #6c5ce7;
        }
        /* Main Content සැකසුම් */
        .main-content {
            margin-left: 260px;
            padding: 40px;
            width: calc(100% - 260px);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #2c2c3e;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
        }
        .user-info {
            font-size: 16px;
            color: #a2a2d0;
        }
        /* Summary Cards */
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background-color: #1b1b28;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #2c2c3e;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .card h3 {
            margin: 0 0 10px 0;
            font-size: 14px;
            color: #7c7cb0;
            text-transform: uppercase;
        }
        .card p {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
            color: #6c5ce7;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>SmartInventory AI</h2>
        <a href="dashboard.jsp" class="active">🏠 Dashboard</a>
        <a href="products.jsp">📦 Product Management</a>
        <a href="inventory.jsp">📊 Inventory Management</a>
        <a href="sales.jsp">💼 Sales Management</a>
        <a href="reports.jsp">📋 Reports</a>
        <a href="ai_insights.jsp">🤖 AI Insights Dashboard</a>
        <a href="login.jsp" style="margin-top: 50px; color: #ff7675;">🚪 Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Dashboard Overview</h1>
            <div class="user-info">
                Welcome, <strong><%= session.getAttribute("user") != null ? session.getAttribute("user") : "Admin" %></strong> 
                (<%= session.getAttribute("role") != null ? session.getAttribute("role") : "Admin" %>)
            </div>
        </div>

        <div class="card-container">
            <div class="card">
                <h3>Total Products</h3>
                <p>50 Items</p> </div>
            <div class="card">
                <h3>Total Sales Recorded</h3>
                <p>1,000+ Transactions</p> </div>
            <div class="card">
                <h3>System Status</h3>
                <p style="color: #2ed573;">AI Online</p>
            </div>
        </div>

        <h2>Welcome to AI-Powered Retail Management</h2>
        <p style="color: #a2a2d0; line-height: 1.6;">
            Use the sidebar menu to navigate through product setups, inventory tracking, and cutting-edge AI forecasts[cite: 112].
        </p>
    </div>

</body>
</html>