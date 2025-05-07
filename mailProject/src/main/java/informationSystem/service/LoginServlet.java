package informationSystem;

import informationSystem.pojo.User;
import informationSystem.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService = new UserService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            // 业务处理
            User existingUser = userService.login(username, password);
            if (existingUser != null) {
                // 登录逻辑
                if (password.equals(existingUser.getPassword())) {
                    request.getSession().setAttribute("user", existingUser);
                    response.sendRedirect("welcome.jsp");
                } else {
                    request.setAttribute("error", "密码错误");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                // 注册逻辑
                User newUser = new User();
                newUser.setUsername(username);
                newUser.setPassword(password);
                if (userService.register(newUser)) {
                    request.getSession().setAttribute("user", newUser);
                    response.sendRedirect("welcome.jsp");
                } else {
                    request.setAttribute("error", "注册失败，已存在该用户！");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "系统繁忙，请稍后再试");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}