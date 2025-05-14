package informationSystem.listener;

import informationSystem.pojo.User;
import informationSystem.service.UserService;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener {
    @Override
    public void sessionCreated(HttpSessionEvent httpSessionEvent) {

    }

    @Override
    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
        User user = (User) session.getAttribute("user");
        if(user != null) {
            UserService.removeOnlineUser(user.getId());
            System.out.println("用户User " + user.getId() + " 已下线！");
        }
    }
}
