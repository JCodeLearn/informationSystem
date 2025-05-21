package informationSystem;

import informationSystem.pojo.Attachment;
import informationSystem.pojo.Email;
import informationSystem.pojo.User;
import informationSystem.service.EmailService;
import informationSystem.service.UserService;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/compose")
public class ComposeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String action = null;
        String receiver = null;
        String subject = null;
        String content = null;
        Integer draftId = null;

        User sender = (User) req.getSession().getAttribute("user");

        List< Attachment> attachments = new ArrayList<>();
        if(ServletFileUpload.isMultipartContent(req)) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            try {
                for(FileItem item : upload.parseRequest(req)) {
                    if(!item.isFormField()) {
                        Attachment attachment = new Attachment();
                        attachment.setFileName(item.getName());
                        attachment.setFileType(item.getContentType());
                        attachment.setFileData(item.get());
                        attachments.add(attachment);
                    } else {
                        switch (item.getFieldName()) {
                            case "action":
                                action = item.getString("UTF-8");
                                break;
                            case "receiver":
                                receiver = item.getString("UTF-8");
                                break;
                            case "subject":
                                subject = item.getString("UTF-8");
                                break;
                            case "content":
                                content = item.getString("UTF-8");
                                break;
                            //新增加内容
                            case "draftId":
                                draftId = Integer.parseInt(item.getString("UTF-8"));
                                break;
                        }
                    }
                }
            } catch (FileUploadException e) {
                e.printStackTrace();
            }
        }

        //移除域元素中的草稿标记
        req.removeAttribute("draft");

        Email email = new Email();
        email.setSenderId(sender.getId());
        UserService userService = new UserService();
        User receiverUser = userService.findByUsername(receiver);
        if(receiverUser == null) {
            if(!("draft".equals(action))) {
                req.setAttribute("error", "发送失败，不存在该用户！");
                req.getRequestDispatcher("/compose.jsp").forward(req, resp);
                return;
            }
            email.setReceiverId(null);
        } else {
            email.setReceiverId(receiverUser.getId());
        }
        email.setSubject(subject);
        email.setContent(content);
        EmailService emailService = new EmailService();

        String redirectUrl;
        if("draft".equals(action)) {
            if(draftId != null) {
                email.setId(draftId);
                email.setStatus("draft");
                emailService.updateDraft(email);
            } else {
                emailService.saveDraft(email);
            }
            //重定向到草稿箱
            redirectUrl = "/welcome.jsp?action=draft";
        } else {
            if(draftId != null) {
                email.setId(draftId);
                email.setStatus("sent");
                email.setSendTime(new Date());
                emailService.makeDraftSent(email, attachments);
            } else {
                emailService.sendEmail(email, attachments);
            }
            if(receiverUser != null && UserService.isUserOnline(receiverUser.getId())) {
                HttpSession receiverSession = UserService.getUserSession(receiverUser.getId());
                if(receiverSession != null) {
                    receiverSession.setAttribute("newMailCome", true);
                }
            }
            //重定向到发送箱
            redirectUrl = "/welcome.jsp?action=sent";
        }

        resp.sendRedirect(req.getContextPath() + redirectUrl);

    }
}


