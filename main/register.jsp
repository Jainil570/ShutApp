<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - ChatApp</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #121212; /* Dark background */
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #1f1f1f; /* Dark container */
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); /* Stronger shadow */
            width: 400px;
            text-align: center;
            border: 1px solid #303030; /* Darker border */
        }

        h2 {
            margin-bottom: 30px;
            color: #4CAF50; /* Green accent color */
        }

        label {
            display: block;
            text-align: left;
            margin-bottom: 8px;
            color: #eee;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 25px;
            border: 1px solid #404040; /* Darker input border */
            border-radius: 6px;
            background-color: #2a2a2a; /* Darker input background */
            color: #fff;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: #4CAF50; /* Green focus border */
            outline: none;
        }

        input[type="submit"] {
            padding: 12px 30px;
            background-color: #4CAF50; /* Green submit button */
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 18px;
            transition: background-color 0.3s ease;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #45a049; /* Darker green hover */
        }

        p {
            margin-top: 20px;
            color: #ddd;
        }

        a {
            color: #4CAF50; /* Green link */
            text-decoration: none;
            transition: color 0.3s ease;
        }

        a:hover {
            color: #388E3C; 
        }

        .error-message {
            color: #FF5252;
            margin-top: 10px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Register</h2>
        <form action="register" method="post">
            <label for="username">Username:</label><br>
            <input type="text" name="username" required><br><br>

            <label for="email">Email:</label><br>
            <input type="email" name="email" required><br><br>

            <label for="password">Password:</label><br>
            <input type="password" name="password" required><br><br>

            <input type="submit" value="Register">
        </form>

        <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </div>
</body>
</html>