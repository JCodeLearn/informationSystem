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

        if("checkNew".equals(action)) {
            checkNewMail(req, resp);
            return;
        }

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
            case "draft":
                emails = emailService.getDraftEmails(user.getId());
                break;
            case "inbox":
                emails =emailService.getReceivedEmails(user.getId());
                break;
            default:
                emails = Collections.emptyList();
        }

        String specialAction = new String(action);
        req.getSession().setAttribute("specialAction", specialAction);
        if(!"contacts".equals(action)){
            req.getSession().setAttribute("emails", emails);
            System.out.println("hello " + emails);
        } else {
            List<Contact> contacts = emailService.getRecentContacts(user.getId());
            req.getSession().setAttribute("contacts", contacts);
        }

        req.getRequestDispatcher("/emailList.jsp").forward(req, resp);
    }

    private void checkNewMail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        //检查会话中的新邮件标记
        Boolean hasNew = (Boolean) req.getSession().getAttribute("newMailCome");
        //返回JSON响应
        resp.setContentType("application/json");
        resp.getWriter().write("{\"hasNew\":" + (hasNew != null && hasNew) + "}");
        //清除已通知的标记
        System.out.println("Hello, this is the practice of putting out a window!");
        if(hasNew != null && hasNew) {
            req.getSession().removeAttribute("newMailCome");
        }
    }

}


