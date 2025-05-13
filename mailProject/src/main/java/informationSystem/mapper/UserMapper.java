package informationSystem.mapper;


import java.util.Map;
import informationSystem.pojo.User;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    User findByUsername(String username);
    int insertUser(User user);
    void updateAvatar(Map map);
    String getPasswordById(Integer userId);
    void updatePassword(@Param("userId")Integer userId, @Param("passWord") String passWord);
}
