package informationSystem.mapper;

import informationSystem.pojo.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface EmailMapper {
    int insertEmail(Email email);
    Email getEmailById(int id);
    List<Email> getEmailsBySenderAndStatus(@Param("senderId") int senderId, @Param("status") String status);
    int updateEmailStatus(@Param("id") int id, @Param("status") String status);
    void updateEmail(Email email);
    List<Email> getReceivedEmails(Integer receiverId);
    void markAsRead(Integer emailId);
    List<Contact> getRecentContact(Integer userId);
}

