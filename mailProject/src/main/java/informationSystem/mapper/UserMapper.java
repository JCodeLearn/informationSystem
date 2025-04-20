package informationSystem.mapper;

import informationSystem.pojo_.User;

import java.util.Map;

public interface UserMapper {
    User findByUsername(String username);
    int insertUser(User user);
    void updateAvatar(Map map);
}
