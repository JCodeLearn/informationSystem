package informationSystem.mapper;

import informationSystem.pojo.Attachment;

import java.util.List;

public interface AttachmentMapper {
    int insertAttachment(Attachment attachment);
    List<Attachment> findByEmailId(Integer emailId);
    Attachment findById(Integer id);
}
