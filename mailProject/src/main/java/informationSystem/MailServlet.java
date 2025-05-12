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
import java.util.Collection;
import java.util.Collections;
import java.util.List;

@WebServlet("/mail")
public class MailServlet extends HttpServlet {
    private EmailService emailService = new EmailService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        System.out.println("[DEBUG] action =" + action);
        User user = (User)req.getSession().getAttribute("user");

        if(user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<Email> emails;
        switch(action) {
            case "sent":
                emails = emailService.getSentEmails(user.getId());
                break;
            default:
                emails = Collections.emptyList();
        }

        String specialAction = new String(action);
        req.getSession().setAttribute("specialAction", specialAction);
        List<Contact> contacts = emailService.getRecentContacts(user.getId());
        req.getSession().setAttribute("contacts", contacts);
        req.getRequestDispatcher("/emailList.jsp").forward(req, resp);
    }

}

