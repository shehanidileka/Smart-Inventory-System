<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartInventory AI - Login</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e1e2f 0%, #11111d 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #fff;
            background-image: linear-gradient(rgba(17, 17, 29, 0.85), rgba(17, 17, 29, 0.85)), url('https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=1920');
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        }
        .login-container {
            background: #1b1b28;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.3);
            width: 350px;
            text-align: center;
            border: 1px solid #2c2c3e;
        }
        .login-container h2 {
            margin-bottom: 8px;
            font-size: 24px;
            color: #fff;
        }
        .login-container p {
            font-size: 14px;
            color: #7c7cb0;
            margin-bottom: 24px;
        }
        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .input-group label {
            display: block;
            font-size: 12px;
            color: #a2a2d0;
            margin-bottom: 6px;
            text-transform: uppercase;
        }
        .input-group input {
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid #2c2c3e;
            background: #11111d;
            color: #fff;
            font-size: 14px;
            box-sizing: border-box;
        }
        .input-group input:focus {
            border-color: #6c5ce7;
            outline: none;
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background: #6c5ce7;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-login:hover {
            background: #5b4cc4;
        }
        .error-msg {
            color: #ff7675;
            font-size: 14px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>SmartInventory AI</h2>
    <p>Sign In to Portal</p>
    
    <%-- ඩේටාබේස් එකෙන් Login වැරදුනොත් පෙන්වන්න --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-msg"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="LoginServlet" method="POST">
        <div class="input-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Enter username" required>
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter password" required>
        </div>
        <button type="submit" class="btn-login">Sign In</button>
    </form>
</div>

</body>
</html>