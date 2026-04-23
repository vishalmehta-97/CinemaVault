<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - The Cinematic Vault</title>
    <style>
        body { background-color: #121212; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: #1e1e1e; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.5); text-align: center; }
        h2 { color: #bb86fc; margin-bottom: 20px; }
        input { display: block; width: 100%; padding: 10px; margin: 10px 0; background: #333; color: white; border: none; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; background: #bb86fc; color: #121212; padding: 10px; font-weight: bold; border: none; border-radius: 4px; cursor: pointer; margin-top: 10px; }
        button:hover { background: #9b59b6; }
        .error { color: #ff5252; margin-bottom: 15px; font-size: 14px; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Enter The Vault</h2>
        <% if (request.getParameter("error") != null) { %>
            <div class="error">Invalid username or password.</div>
        <% } %>
        <form action="auth" method="post">
            <input type="hidden" name="action" value="login">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Log In</button>
        </form>
    </div>
</body>
</html>