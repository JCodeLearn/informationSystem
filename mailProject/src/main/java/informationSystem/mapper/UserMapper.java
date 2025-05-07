package informationSystem.mapper;


import java.util.Map;
import informationSystem.pojo.User;

public interface UserMapper {
    User findByUsername(String username);
    int insertUser(User user);
    void updateAvatar(Map map);
}
