<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%
    String currentUser = (String) session.getAttribute("email");
    String selectedUser = request.getParameter("to");

    List<Document> users = (List<Document>) request.getAttribute("users");
    List<Document> messages = (List<Document>) request.getAttribute("messages");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat - ChatApp</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #121212; /* Dark background */
            color: #fff;
            display: flex;
            height: 100vh;
        }

        .sidebar {
            width: 25%;
            background-color: #1f1f1f; /* Dark sidebar */
            padding: 20px;
            overflow-y: auto;
            border-right: 1px solid #303030; /* Darker border */
        }

        .sidebar h3 {
            color: #4CAF50; /* Green accent */
            margin-top: 0;
            margin-bottom: 20px;
            text-align: center;
        }

        .sidebar h4 {
            color: #eee;
            margin-bottom: 10px;
        }

        .user-link {
            display: block;
            padding: 10px 15px;
            margin: 8px 0;
            text-decoration: none;
            color: #ddd;
            border-radius: 6px;
            transition: background-color 0.3s ease;
        }

        .user-link:hover {
            background-color: #2a2a2a; /* Darker hover */
        }

        .sidebar a {
            display: block;
            margin-top: 20px;
            color: #4CAF50; /* Green link */
            text-decoration: none;
            transition: color 0.3s ease;
            text-align: center;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #303030;
        }

        .sidebar a:hover {
            color: #388E3C; /* Darker green hover */
            background-color: #2a2a2a;
        }

        .chat-box {
            width: 75%;
            display: flex;
            flex-direction: column;
            padding: 20px;
        }

        .message-list {
            flex-grow: 1;
            overflow-y: auto;
            border-bottom: 1px solid #303030; /* Darker border */
            margin-bottom: 15px;
            padding-bottom: 15px;
        }

        .message {
            padding: 10px 15px;
            margin: 8px 0;
            border-radius: 8px;
            word-break: break-word;
        }

        .sent {
            background-color: #4CAF50; /* Green sent message */
            color: #fff;
            align-self: flex-end;
        }

        .received {
            background-color: #2a2a2a; /* Dark received message */
            color: #ddd;
            align-self: flex-start;
        }

        .chat-box form {
            display: flex;
        }

        .chat-box input[type="text"] {
            flex-grow: 1;
            padding: 12px 15px;
            font-size: 16px;
            border: 1px solid #404040; /* Darker input border */
            border-radius: 6px;
            background-color: #2a2a2a; /* Darker input background */
            color: #fff;
            margin-right: 10px;
        }

        .chat-box input[type="text"]:focus {
            border-color: #4CAF50; /* Green focus */
            outline: none;
        }

        .chat-box input[type="submit"] {
            padding: 12px 20px;
            background-color: #4CAF50; /* Green submit button */
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .chat-box input[type="submit"]:hover {
            background-color: #45a049; /* Darker green hover */
        }

        .chat-box p {
            color: #ddd;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h3>Welcome, <%= currentUser %></h3>
        <h4>Chat with:</h4>

        <% if (users != null) {
            for (Document user : users) {
                String email = user.getString("email");
                String username = user.getString("username");
                if (!email.equals(currentUser)) {
        %>
            <a class="user-link" href="chat?to=<%= email %>"><%= username %></a>
        <%      }
            }
        } else { %>
            <p style="color: #FF5252; text-align: center;">No users found.</p>
        <% } %>

        <br><a href="login.jsp">Logout</a>
    </div>

    <div class="chat-box">
        <div class="message-list">
            <% if (messages != null) {
                for (Document msg : messages) {
                    boolean isSent = currentUser.equals(msg.getString("from"));
                    String cssClass = isSent ? "sent" : "received";
            %>
                <div class="message <%= cssClass %>">
                    <%= msg.getString("message") %>
                </div>
            <% }} else { %>
                <p style="color: #ddd; text-align: center;">No messages yet.</p>
            <% } %>
        </div>

        <% if (selectedUser != null) { %>
            <form action="sendMessage" method="post">
                <input type="hidden" name="to" value="<%= selectedUser %>">
                <input type="text" name="message" placeholder="Type a message..." required>
                <input type="submit" value="Send">
            </form>
        <% } else { %>
            <p style="color: #ddd;">Select a user to start chatting</p>
        <% } %>
    </div>
</body>
</html>