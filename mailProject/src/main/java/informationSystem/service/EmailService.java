package informationSystem.service;

import informationSystem.mapper.AttachmentMapper;
import informationSystem.mapper.EmailMapper;
import informationSystem.pojo.Attachment;
import informationSystem.pojo.Contact;
import informationSystem.pojo.Email;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class EmailService {
    // 日志记录器
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    // MyBatis会话工厂
    private static SqlSessionFactory sqlSessionFactory;

    private static UserService userService = new UserService();

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

    public boolean sendEmail(Email email, List<Attachment> attachments) {
        SqlSession session = sqlSessionFactory.openSession(false);
        EmailMapper emailMapper = session.getMapper(EmailMapper.class);
        AttachmentMapper attachmentMapper = session.getMapper(AttachmentMapper.class);

        //插入邮件记录
        email.setStatus("sent");
        emailMapper.insertEmail(email);

        //处理附件
        for(Attachment attachment : attachments) {
            attachment.setEmailId(email.getId());
            attachmentMapper.insertAttachment(attachment);
        }

        session.commit();
        session.close();
        return true;
    }

    public boolean saveDraft(Email email) {
        SqlSession session = sqlSessionFactory.openSession(true);
        EmailMapper emailMapper = session.getMapper(EmailMapper.class);
        email.setStatus("draft");
        boolean result = emailMapper.insertEmail(email) > 0;
        session.close();
        return result;

    }

    public Email getEmailWithAttachments(int emailId) {
        SqlSession session = sqlSessionFactory.openSession(true);
        EmailMapper emailMapper = session.getMapper(EmailMapper.class);
        AttachmentMapper attachmentMapper = session.getMapper(AttachmentMapper.class);
        Email email = emailMapper.getEmailById(emailId);
        if(email != null) {
            email.setAttachments(attachmentMapper.findByEmailId(emailId));
            System.out.println(email.getAttachments().toString());
        }
        session.close();
        return email;
    }


