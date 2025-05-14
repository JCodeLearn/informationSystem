package informationSystem;

import informationSystem.pojo.User;
import informationSystem.service.UserService;
import org.apache.commons.io.IOUtils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/ravatar")
public class RAvatarServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        // 从参数获取 userId
        String receiverUsername = req.getParameter("receiverUsername");
        if (receiverUsername == null) {
            sendDefaultAvatar(resp);
            return;
        }
        try {
            User user = userService.findByUsername(receiverUsername);
            if (user != null && user.getAvatar() != null) {
                resp.setContentType(user.getAvatarType());
                resp.getOutputStream().write(user.getAvatar());
            } else {
                sendDefaultAvatar(resp);
            }
        } catch (Exception e) {
            sendDefaultAvatar(resp);
        }
    }

    private void sendDefaultAvatar(HttpServletResponse resp) throws IOException {
        try (InputStream defaultImg = getServletContext()
                .getResourceAsStream("/images/default-avatar.jpeg")) {
            IOUtils.copy(defaultImg, resp.getOutputStream());
        }
    }

}
