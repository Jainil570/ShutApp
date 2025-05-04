package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

import org.bson.Document;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

@WebServlet("/sendMessage")
public class SendMessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SendMessageServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String from = (String) request.getSession().getAttribute("email");
        if (from == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String to = request.getParameter("to");
        String message = request.getParameter("message");

        if (to == null || message == null || message.trim().isEmpty()) {
            response.sendRedirect("chat?to=" + to);
            return;
        }

        MongoDatabase db = MongoConnection.getDatabase();
        MongoCollection<Document> msgCol = db.getCollection("messages");

        Document msg = new Document("from", from)
                            .append("to", to)
                            .append("message", message)
                            .append("timestamp", new Date());

        msgCol.insertOne(msg);

        response.sendRedirect("chat?to=" + to);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Use POST to send messages.");
    }
}
