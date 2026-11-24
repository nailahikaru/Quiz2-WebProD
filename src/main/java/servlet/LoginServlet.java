package servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import org.mindrot.jbcrypt.BCrypt;
import util.DBConnection;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement("SELECT id, name, password FROM users WHERE email=?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // hash Laravel berawalan $2y$, jBCrypt membaca $2a$
                String hash = rs.getString("password").replaceFirst("^\\$2y\\$", "\\$2a\\$");
                if (BCrypt.checkpw(pass, hash)) {
                    HttpSession s = req.getSession();
                    s.setAttribute("userId", rs.getLong("id"));
                    s.setAttribute("userName", rs.getString("name"));
                    res.sendRedirect(req.getContextPath() + "/polls");
                    return;
                }
            }
            req.setAttribute("error", "Email atau password salah.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        } catch (SQLException e) { throw new ServletException(e); }
    }
}