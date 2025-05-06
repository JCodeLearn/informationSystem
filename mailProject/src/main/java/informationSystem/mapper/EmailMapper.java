package informationSystem.mapper;

import informationSystem.pojo.Email;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface EmailMapper {
    int insertEmail(Email email);
    Email getEmailById(int id);
    List<Email> getEmailsBySenderAndStatus(@Param("senderId") int senderId, @Param("status") String status);
   
}

