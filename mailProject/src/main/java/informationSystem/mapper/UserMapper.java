package informationSystem.mapper;


import java.util.Map;
import informationSystem.pojo.*;

public interface UserMapper {
    User findByUsername(String username);
    int insertUser(User user);
    void updateAvatar(Map map);
}
