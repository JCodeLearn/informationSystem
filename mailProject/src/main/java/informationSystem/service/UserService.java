package informationSystem.service;

import informationSystem.mapper.UserMapper;
import informationSystem.pojo.*;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

public class UserService {
    // 日志记录器
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    // MyBatis会话工厂（单例模式）
    private static SqlSessionFactory sqlSessionFactory;

    // 静态初始化块加载配置
    static {
        try {
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
            logger.info("MyBatis会话工厂初始化成功");
        } catch (IOException e) {
            logger.error("MyBatis配置加载失败", e);
            throw new RuntimeException("系统初始化失败", e);
        }
    }

    /**
     * 用户登录验证
     * @param username 用户名
     * @param password 密码
     * @return 用户对象（验证成功）或null（验证失败）
     */
    public User login(String username, String password) {
//        try (SqlSession session = sqlSessionFactory.openSession()) {
//
//        }
            SqlSession session = sqlSessionFactory.openSession();
            UserMapper mapper = session.getMapper(UserMapper.class);
            User user = mapper.findByUsername(username);
            session.close();

            if (user == null) {
                logger.warn("登录失败：用户 {} 不存在", username);
                return null;
            }

            if (!password.equals(user.getPassword())) {
                logger.warn("登录失败：用户 {} 密码错误", username);
                return null;
            }

            logger.info("用户 {} 登录成功", username);
            return user;

//        } catch (Exception e) {
//            logger.error("登录操作异常", e);
//            throw new ServiceException("登录服务暂时不可用", e);
//        }
    }

    /**
     * 用户注册
     * @param user 用户对象
     * @return 注册是否成功
     */
    public boolean register(User user) {
        // 开启手动提交事务
            SqlSession session = sqlSessionFactory.openSession(false);
            UserMapper mapper = session.getMapper(UserMapper.class);

            // 检查用户名是否存在
            if (mapper.findByUsername(user.getUsername()) != null) {
                logger.warn("注册失败：用户名 {} 已存在", user.getUsername());
                session.close();
                return false;
            }

            // 执行插入操作
            int result = mapper.insertUser(user);
            if (result > 0) {
                session.commit(); // 提交事务
                logger.info("用户 {} 注册成功", user.getUsername());
                session.close();
                return true;
            }

            session.rollback(); // 回滚事务
            logger.error("注册失败：数据库插入异常");
            session.close();
            return false;

    }

//    // 获取用户
//    public User getUserById(int userId) {
//        try (SqlSession session = sqlSessionFactory.openSession()) {
//            UserMapper mapper = session.getMapper(UserMapper.class);
//            return mapper.selectUserById(userId);
//        }
//    }

    // 更新头像
    public void updateAvatar(int userId, byte[] avatar, String contentType) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("id", userId);
            params.put("avatar", avatar);
            params.put("avatarType", contentType);
            mapper.updateAvatar(params);
        }
    }

    //通过名字来查找User
    public User findByUsername(String username) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            User findUser = mapper.findByUsername(username);
            session.close();
            return findUser;
        }
    }

    // 更新头像
    public void updateAvatar(int userId, byte[] avatar, String contentType) {
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("id", userId);
            params.put("avatar", avatar);
            params.put("avatarType", contentType);
            mapper.updateAvatar(params);
        }
    }

    //识别是否非法密码
    public boolean validatePassword(Integer userId, String password) {
        SqlSession session = sqlSessionFactory.openSession(true);
        UserMapper mapper = session.getMapper(UserMapper.class);
        String oldPassword = mapper.getPasswordById(userId);
        session.close();
        if(oldPassword != null && oldPassword.equals(password)) {
            return true;
        } else {
            return false;
        }
    }

    //更新密码
    public void updatePassword(Integer userId, String password) {
        SqlSession session = sqlSessionFactory.openSession(true);
        UserMapper mapper = session.getMapper(UserMapper.class);
        mapper.updatePassword(userId, password);
        session.close();
    }

}
