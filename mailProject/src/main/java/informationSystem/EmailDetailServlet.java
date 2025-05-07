package informationSystem;

import informationSystem.pojo.Email;
import informationSystem.service.EmailService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/emailDetail")
public class EmailDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int emailId = Integer.parseInt(req.getParameter("id"));
        EmailService emailService = new EmailService();
        req.getSession().removeAttribute("specialAction");
        Email email = emailService.getEmailWithAttachments(emailId);
        req.getSession().setAttribute("email", email);
        System.out.println(email);
        req.getRequestDispatcher("/emailDetail.jsp").forward(req, resp);
    }

}

