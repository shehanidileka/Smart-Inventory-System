<%@page import="java.sql.Connection"%>
<%@page import="com.inventory.config.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Test Connection</title>
    </head>
    <body>
        <h1>Smart Inventory System - Connection Test</h1>
        <%
            Connection conn = DBConnection.getConnection();
            if(conn != null) {
                out.print("<h3 style='color:green;'>Database එක සාර්ථකව සම්බන්ධ වුණා!</h3>");
                conn.close();
            } else {
                out.print("<h3 style='color:red;'>Database එක සම්බන්ධ කිරීමට නොහැකි වුණා. පරීක්ෂා කර බලන්න.</h3>");
            }
        %>
    </body>
</html>