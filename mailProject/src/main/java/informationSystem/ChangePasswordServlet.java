package informationSystem;

import informationSystem.pojo.User;
import informationSystem.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String oldPassword = (String)req.getParameter("oldPassword");
        String confirmPassword = (String)req.getParameter("confirmPassword");

        UserService userService = new UserService();
        if(!userService.validatePassword(user.getId(), oldPassword)) {
            req.setAttribute("error", "原密码输入错误");
            req.getRequestDispatcher("/changePassword.jsp").forward(req, resp);
            return;
        }

        //更新密码
        userService.updatePassword(user.getId(), confirmPassword);
        resp.sendRedirect("welcome.jsp");
    }
}
