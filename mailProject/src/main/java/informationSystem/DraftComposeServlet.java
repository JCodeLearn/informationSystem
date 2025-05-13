package informationSystem;

import informationSystem.pojo.Email;
import informationSystem.pojo.User;
import informationSystem.service.EmailService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;

@WebServlet("/draft")
public class DraftComposeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer draftId = Integer.parseInt(req.getParameter("id"));
        EmailService emailService = new EmailService();
        Email draft = emailService.getEmailById(draftId);
        System.out.println("hello, this is a draft: " + draft);
        req.setAttribute("draft", draft);
        req.getRequestDispatcher("/compose.jsp").forward(req, resp);
    }
}
