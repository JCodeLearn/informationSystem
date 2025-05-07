package informationSystem.service;

import informationSystem.mapper.AttachmentMapper;
import informationSystem.pojo.*;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;

public class AttachmentService {
    // 日志记录器
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    // MyBatis会话工厂
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

    public Attachment getAttachmentById(Integer id) {
        SqlSession session = sqlSessionFactory.openSession(true);
        AttachmentMapper mapper = session.getMapper(AttachmentMapper.class);
        Attachment attachment = mapper.findById(id);
        return attachment;
    }

}

