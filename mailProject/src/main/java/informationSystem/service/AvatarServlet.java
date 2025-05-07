package informationSystem;

import informationSystem.pojo.User;
import informationSystem.service.UserService;
import org.apache.commons.io.IOUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/avatar")
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 5,    // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class AvatarServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User)req.getSession().getAttribute("user");
        if(user.getAvatar() != null) {
            resp.setContentType(user.getAvatarType());
            resp.getOutputStream().write(user.getAvatar());
        } else {
            InputStream defaultImg = getServletContext().getResourceAsStream("/images/default-avatar.jpeg");
            IOUtils.copy(defaultImg, resp.getOutputStream());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Part filePart = req.getPart("avatar");
        int userId = ((User)req.getSession().getAttribute("user")).getId();
        String username = ((User)req.getSession().getAttribute("user")).getUsername();
        if(filePart == null || filePart.getSize() == 0) {
            System.out.println("未选择文件或文件为空");
        }
        try (InputStream fileContent = filePart.getInputStream()) {
            byte[] avatarBytes = IOUtils.toByteArray(fileContent);
            String contentType = filePart.getContentType();
            userService.updateAvatar(userId, avatarBytes, contentType);
            User updateUser = userService.findByUsername(username);
            req.getSession().setAttribute("user", updateUser);
            resp.sendRedirect("welcome.jsp");
        } catch (Exception e) {
            req.setAttribute("error", "头像更新失败");
            req.getRequestDispatcher("/avatar-upload.jsp").forward(req, resp);
        }
    }
}
