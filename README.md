# ShutApp: An Advanced Java Chat Application

This project showcases a real-time chat application built using advanced Java technologies. It leverages the power of Java Servlets, Java Server Pages (JSP), and WebSocket (implicitly through the `jakarta.servlet.annotation.WebServlet` annotation for servlet mapping) to create a dynamic and interactive user experience. The application persists chat messages and user data using MongoDB, a NoSQL database known for its flexibility and scalability.

This README provides a comprehensive overview of the application's architecture, key components, setup instructions, and potential areas for future enhancements. By exploring this project, you can gain practical insights into building modern web applications with advanced Java concepts.
here is the video link :

## Core Advanced Java Concepts Utilized

This ChatApp effectively demonstrates several key concepts of advanced Java:

* **Servlets:** The application utilizes Java Servlets (`.java` files like `ChatServlet`, `LoginServlet`, `RegisterServlet`, and `SendMessageServlet`) to handle client requests and server-side logic. These servlets manage user authentication, message handling, and data retrieval from the database. The `@WebServlet` annotation is used for declarative mapping of servlet classes to specific URL patterns, simplifying configuration.
* **Java Server Pages (JSP):** JSPs (`.jsp` files like `chat.jsp`, `login.jsp`, and `register.jsp`) are used for the presentation layer. They allow embedding Java code within HTML to dynamically generate web pages. In this application, JSPs are responsible for rendering the user interface, displaying user lists, and presenting chat messages. JSTL (JavaServer Pages Standard Tag Library) could be incorporated for cleaner code in more complex applications, though basic scriptlets are used here for demonstration.
* **HTTP Sessions:** The `HttpSession` object is used to manage user sessions after successful login. This allows the application to maintain the logged-in state of users and access their information (like email and username) across different requests.
* **Database Connectivity (MongoDB):** The application integrates with MongoDB using the official Java driver. The `MongoConnection` class manages the connection to the MongoDB database, and the servlets interact with the database to store and retrieve user information and chat messages.
* **Request and Response Objects:** Servlets use `HttpServletRequest` to receive data from the client (e.g., form submissions, URL parameters) and `HttpServletResponse` to send data back to the client (e.g., HTML content, redirects).
* **Redirection and Forwarding:** Servlets use `response.sendRedirect()` to redirect the client's browser to a different URL (e.g., after successful login or registration) and `request.getRequestDispatcher().forward()` to pass control to another resource (e.g., from a servlet to a JSP to render a page).

## Application Architecture

The ChatApp follows a basic Model-View-Controller (MVC) pattern, although it's not strictly enforced:

* **Model:** The data is managed by the MongoDB database. Java classes (`org.bson.Document`) are used to represent the data retrieved from and stored in the database.
* **View:** JSPs (`.jsp` files) are responsible for rendering the user interface and displaying data to the user.
* **Controller:** Servlets (`.java` files) handle user requests, interact with the model (MongoDB), and determine which view to display.

## Key Components and Functionality

### 1. `servlets.ChatServlet.java`

* **`@WebServlet("/chat")`:** Maps this servlet to the `/chat` URL.
* **`doGet(HttpServletRequest request, HttpServletResponse response)`:**
    * Handles GET requests to display the chat interface.
    * Checks if the user is logged in using `HttpSession`. If not, redirects to `login.jsp`.
    * Retrieves the logged-in user's email from the session.
    * Fetches a list of all registered users (excluding the current user) from the `users` collection in MongoDB.
    * Retrieves chat messages between the current user and a selected user (if any) from the `messages` collection in MongoDB, filtering based on the `from` and `to` fields and sorting by timestamp.
    * Sets request attributes (`users`, `messages`, `toUser`) to be accessed by `chat.jsp`.
    * Forwards the request and response to `chat.jsp` for rendering.
* **`doPost(HttpServletRequest request, HttpServletResponse response)`:**
    * Simply calls the `doGet` method to handle POST requests to the `/chat` URL (though typically, POST would be used for actions like sending a message, which is handled by `SendMessageServlet`).

### 2. `servlets.LoginServlet.java`

* **`@WebServlet("/login")`:** Maps this servlet to the `/login` URL.
* **`doPost(HttpServletRequest request, HttpServletResponse response)`:**
    * Handles POST requests from the `login.jsp` form.
    * Retrieves the entered `email` and `password` from the request parameters.
    * Connects to the MongoDB database and retrieves the `users` collection.
    * Queries the `users` collection to find a user with the matching `email` and `password`.
    * If a user is found:
        * Creates a new `HttpSession` or retrieves the existing one.
        * Sets session attributes (`username`, `email`) for the logged-in user.
        * Redirects the user to the `/chat` servlet.
    * If no user is found:
        * Redirects the user back to `login.jsp` with an error parameter (`error=1`).

### 3. `servlets.MongoConnection.java`

* Manages the connection to the MongoDB database.
* **`CONNECTION_STRING`:** Defines the MongoDB connection URI (`mongodb://localhost:27017`).
* **`DATABASE_NAME`:** Specifies the name of the database to use (`chatapp`).
* **`mongoClient`:** A static `MongoClient` instance to ensure a single connection pool.
* **`getDatabase()`:** A static method that returns the `MongoDatabase` instance. It initializes the `MongoClient` if it's null, ensuring that the connection is established only once.

### 4. `servlets.RegisterServlet.java`

* **`@WebServlet("/register")`:** Maps this servlet to the `/register` URL.
* **`doPost(HttpServletRequest request, HttpServletResponse response)`:**
    * Handles POST requests from the `register.jsp` form.
    * Retrieves the entered `username`, `email`, and `password` from the request parameters.
    * Connects to the MongoDB database and retrieves the `users` collection.
    * Checks if a user with the given `email` already exists in the `users` collection. If so, redirects back to `register.jsp` with an error (`error=exists`).
    * If the email is not already registered, creates a new `Document` with the user's information.
    * Inserts the new user `Document` into the `users` collection.
    * Redirects the user to `login.jsp` with a success message (`success=1`).

### 5. `servlets.SendMessageServlet.java`

* **`@WebServlet("/sendMessage")`:** Maps this servlet to the `/sendMessage` URL.
* **`doPost(HttpServletRequest request, HttpServletResponse response)`:**
    * Handles POST requests to send a new chat message.
    * Retrieves the sender's email (`from`) from the `HttpSession`. If not logged in, redirects to `login.jsp`.
    * Retrieves the recipient's email (`to`) and the `message` content from the request parameters.
    * Validates that `to` and `message` are not null or empty. If invalid, redirects back to the chat interface with the current recipient.
    * Connects to the MongoDB database and retrieves the `messages` collection.
    * Creates a new `Document` to represent the message, including `from`, `to`, `message`, and a `timestamp`.
    * Inserts the new message `Document` into the `messages` collection.
    * Redirects the user back to the `/chat` interface with the recipient's email as a parameter (`chat?to=...`) to refresh the chat window.

### 6. `chat.jsp`

* The main chat interface.
* Retrieves the logged-in `currentUser` email and the `selectedUser` email (if any) from the session and request attributes.
* Accesses the `users` list to display a sidebar of other users to chat with. Each username is a link that reloads `chat.jsp` with the `to` parameter set to the other user's email.
* Iterates through the `messages` list and displays each message. Messages sent by the `currentUser` are styled differently from received messages.
* Includes a form to send new messages. The `to` field is a hidden input, and the `message` field allows the user to type their message. The form submits to the `/sendMessage` servlet.
* Provides a logout link that redirects to `login.jsp`.

### 7. `login.jsp`

* The login page.
* Displays a form with fields for `email` and `password`.
* The form submits to the `/login` servlet using the POST method.
* Displays an error message if the `error` parameter is present in the URL (e.g., after failed login).
* Provides a link to the `register.jsp` page for new users.

### 8. `register.jsp`

* The user registration page.
* Displays a form with fields for `username`, `email`, and `password`.
* The form submits to the `/register` servlet using the POST method.
* Displays an error message if the `error` parameter is `exists` in the URL (indicating that the email is already registered).
* Provides a link back to the `login.jsp` page for existing users.

## Setup Instructions

To run this ChatApp, you need to have the following installed and configured:

1.  **Java Development Kit (JDK):** Ensure you have a compatible JDK installed on your system.
2.  **Apache Tomcat or another Servlet Container:** You need a servlet container to deploy and run the Java web application. Apache Tomcat is a popular open-source option.
3.  **MongoDB:** Install and run a MongoDB server. The application is configured to connect to a MongoDB instance running on `localhost:27017`.
4.  **MongoDB Java Driver:** The MongoDB Java driver needs to be included in your project's dependencies. If you are using a build tool like Maven or Gradle, add the following dependency:

    **Maven:**
    ```xml
    <dependency>
        <groupId>org.mongodb</groupId>
        <artifactId>mongodb-driver-sync</artifactId>
        <version>4.11.0</version> </dependency>
    ```

    **Gradle:**
    ```gradle
    implementation 'org.mongodb:mongodb-driver-sync:4.11.0' // Use the latest stable version
    ```

### Deployment Steps:

1.  **Package the Application:** If you are using an IDE like IntelliJ IDEA or Eclipse, build your project to create a WAR (Web Application Archive) file.
2.  **Deploy to Tomcat:** Copy the generated WAR file to the `webapps` directory of your Tomcat installation.
3.  **Start Tomcat:** Start the Apache Tomcat server.
4.  **Access the Application:** Open your web browser and navigate to `http://localhost:8080/your-war-file-name/login.jsp` (replace `your-war-file-name` with the actual name of your WAR file).

## Potential Future Enhancements

This ChatApp provides a basic foundation for real-time communication. Here are some potential areas for future enhancements:

* **Real-time Updates with WebSockets:** Implement WebSockets instead of relying solely on HTTP requests for a more seamless and real-time chat experience. This would eliminate the need for constant page reloads to see new messages.
* **User Presence:** Display the online/offline status of users.
* **Group Chat:** Allow users to create and participate in group conversations.
* **Private Messaging:** Ensure messages are strictly private between the sender and receiver.
* **Message Delivery Status:** Indicate whether a message has been sent, delivered, and read.
* **Rich Media Support:** Allow users to send images, videos, and other file types.
* **User Interface Improvements:** Enhance the user interface with more modern styling and better responsiveness. Consider using a frontend framework like React, Angular, or Vue.js for a richer client-side experience.
* **Input Validation and Error Handling:** Implement more robust input validation on the server-side and provide more informative error messages to the user.
* **Security Enhancements:** Implement proper security measures such as password hashing (e.g., using bcrypt), protection against cross-site scripting (XSS), and other common web vulnerabilities.
* **Scalability:** Consider using a more scalable architecture for handling a large number of concurrent users, such as using a message queue or a distributed caching system.
* **Testing:** Implement unit and integration tests to ensure the reliability and correctness of the application.

By exploring and extending this ChatApp, you can deepen your understanding of advanced Java web development and build more sophisticated and engaging applications.
