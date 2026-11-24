package servlet;

import dao.PollDAO;
import model.Poll;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/polls")
public class PollServlet extends HttpServlet {
    private final PollDAO dao = new PollDAO();

    private Long userId(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s == null ? null : (Long) s.getAttribute("userId");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (userId(req) == null) { res.sendRedirect(req.getContextPath() + "/login"); return; }
        String action = req.getParameter("action");
        if (action == null) action = "list";
        try {
            switch (action) {
                case "create":
                    req.getRequestDispatcher("/poll-form.jsp").forward(req, res);
                    break;
                case "edit":
                    req.setAttribute("poll", dao.findById(Integer.parseInt(req.getParameter("id"))));
                    req.getRequestDispatcher("/poll-form.jsp").forward(req, res);
                    break;
                case "detail":
                    int id = Integer.parseInt(req.getParameter("id"));
                    Poll p = dao.findById(id);
                    req.setAttribute("poll", p);
                    req.setAttribute("voted", dao.hasVoted(id, userId(req)));
                    req.getRequestDispatcher("/poll-detail.jsp").forward(req, res);
                    break;
                default:
                    req.setAttribute("polls", dao.findAll());
                    req.getRequestDispatcher("/polls.jsp").forward(req, res);
            }
        } catch (SQLException e) { throw new ServletException(e); }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Long uid = userId(req);
        if (uid == null) { res.sendRedirect(req.getContextPath() + "/login"); return; }
        String action = req.getParameter("action");
        String base = req.getContextPath() + "/polls";
        try {
            switch (action) {
                case "create":
                    dao.create(uid, req.getParameter("question"), req.getParameter("description"),
                        req.getParameter("deadline"), req.getParameterValues("options"));
                    res.sendRedirect(base);
                    break;
                case "update":
                    dao.update(Integer.parseInt(req.getParameter("id")), req.getParameter("question"),
                        req.getParameter("description"), req.getParameter("deadline"),
                        req.getParameter("active") != null);
                    res.sendRedirect(base);
                    break;
                case "delete":
                    dao.delete(Integer.parseInt(req.getParameter("id")));
                    res.sendRedirect(base);
                    break;
                case "vote":
                    int pollId = Integer.parseInt(req.getParameter("pollId"));
                    String opt = req.getParameter("optionId");
                    Poll p = dao.findById(pollId);
                    if (opt == null || p == null || !p.isOpen() || dao.hasVoted(pollId, uid)) {
                        res.sendRedirect(base + "?action=detail&id=" + pollId + "&error=1");
                        return;
                    }
                    dao.vote(pollId, Integer.parseInt(opt), uid);
                    res.sendRedirect(base + "?action=detail&id=" + pollId);
                    break;
                default:
                    res.sendRedirect(base);
            }
        } catch (SQLException e) { throw new ServletException(e); }
    }
}