package informationSystem;

import informationSystem.pojo.Attachment;
import informationSystem.service.AttachmentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {
    private AttachmentService attachmentService = new AttachmentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int attachmentId = Integer.parseInt(req.getParameter("attachmentId"));
        Attachment attachment = attachmentService.getAttachmentById(attachmentId);
        resp.setContentType("application/octet-stream");
        String encodedFileName = URLEncoder.encode(attachment.getFileName(), "UTF-8");
        resp.setHeader("Content-Disposition",
                "attachment; filename=\"" + encodedFileName + "\"");
        resp.getOutputStream().write(attachment.getFileData());
    }
}
