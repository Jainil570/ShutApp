package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import servlets.MongoConnection;

import java.io.IOException;

import org.bson.Document;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        MongoDatabase database = MongoConnection.getDatabase();
        MongoCollection<Document> users = database.getCollection("users");

        // Check if user already exists
        Document existingUser = users.find(new Document("email", email)).first();
        if (existingUser != null) {
            response.sendRedirect("register.jsp?error=exists");
            return;
        }

        // Insert new user
        Document user = new Document("username", username)
                            .append("email", email)
                            .append("password", password);

        users.insertOne(user);
        response.sendRedirect("login.jsp?success=1");
		doGet(request, response);
	}

}
