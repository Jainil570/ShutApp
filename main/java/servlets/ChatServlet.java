package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.bson.Document;
import org.bson.conversions.Bson;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;

@WebServlet("/chat") // Correct @WebServlet annotation
public class ChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ChatServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("ChatServlet: doGet method CALLED");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            System.out.println("ChatServlet: User not logged in. Redirecting to login.");
            response.sendRedirect("login.jsp");
            return;
        }
        String currentUserEmail = (String) session.getAttribute("email");
        System.out.println("ChatServlet: Current user email: " + currentUserEmail);

        String toUserEmail = request.getParameter("to");
        System.out.println("ChatServlet: toUserEmail: " + toUserEmail);

        MongoDatabase db = MongoConnection.getDatabase();
        if (db == null) {
            System.out.println("ChatServlet: ERROR: Could not connect to database!");
            response.getWriter().println("<h1>Database Connection Error</h1>"); //basic error message
            return;
        }

        MongoCollection<Document> usersCol = db.getCollection("users");
        System.out.println("ChatServlet: Got users collection: " + usersCol.getNamespace());

        // Get all users except the current one
        List<Document> users = usersCol.find().into(new ArrayList<>());
        System.out.println("ChatServlet: Number of users fetched from DB: " + users.size());

        // Log the users before filtering
        System.out.println("ChatServlet: Users before filtering:");
        if (users.isEmpty()) {
            System.out.println("ChatServlet:  No users found in DB!");
        } else {
            for (Document user : users) {
                System.out.println("ChatServlet: User before filter: " + user.toJson());
            }
        }

        users.removeIf(user -> currentUserEmail.equals(user.getString("email")));
        System.out.println("ChatServlet: Number of users after filtering: " + users.size());

        // Log the users after filtering
        System.out.println("ChatServlet: Users after filtering:");
        if (users.isEmpty()) {
            System.out.println("ChatServlet: No users to display after filtering.");
        } else {
            for (Document user : users) {
                System.out.println("ChatServlet: User: " + user.toJson());
            }
        }

        List<Document> messages = new ArrayList<>();
        if (toUserEmail != null) {
            Bson filter = Filters.or(
                    Filters.and(Filters.eq("from", currentUserEmail), Filters.eq("to", toUserEmail)),
                    Filters.and(Filters.eq("from", toUserEmail), Filters.eq("to", currentUserEmail)));
            MongoCollection<Document> msgCol = db.getCollection("messages"); // ADD THIS LINE
            messages = msgCol.find(filter)
                    .sort(Sorts.ascending("timestamp"))
                    .into(new ArrayList<>());
        }

        request.setAttribute("users", users);
        request.setAttribute("messages", messages);
        request.setAttribute("toUser", toUserEmail);
        System.out.println("ChatServlet: Setting request attributes and forwarding to chat.jsp");
        request.getRequestDispatcher("chat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
