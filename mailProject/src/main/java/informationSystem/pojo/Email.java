package informationSystem.pojo;

import java.util.Date;
import java.util.List;

public class Email {
    private Integer id;
    private Integer senderId;
    private Integer receiverId;
    private String subject;
    private String content;
    private Date sendTime;
    private Integer isRead;
    private String status;
    private List<Attachment> attachments;
    private String receiverUsername = null;
    private String senderUsername = null;

    public String getSenderUsername() {
        return senderUsername;
    }

    public void setSenderUsername(String senderUsername) {
        this.senderUsername = senderUsername;
    }

    public String getReceiverUsername() {
        return receiverUsername;
    }

    public void setReceiverUsername(String receiverUsername) {
        this.receiverUsername = receiverUsername;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getSenderId() {
        return senderId;
    }

    public void setSenderId(Integer senderId) {
        this.senderId = senderId;
    }

    public Integer getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(Integer receiverId) {
        this.receiverId = receiverId;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getSendTime() {
        return sendTime;
    }

    public void setSendTime(Date sendTime) {
        this.sendTime = sendTime;
    }

    public Integer getIsRead() {
        return isRead;
    }

    public void setIsRead(Integer read) {
        isRead = read;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Attachment> getAttachments() {
        return attachments;
    }

    public void setAttachments(List<Attachment> attachments) {
        this.attachments = attachments;
    }

    @Override
    public String toString() {
        return "Email{" +
                "id=" + id +
                ", senderId=" + senderId +
                ", receiverId=" + receiverId +
                ", subject='" + subject + '\'' +
                ", content='" + content + '\'' +
                ", sendTime=" + sendTime +
                ", isRead=" + isRead +
                ", status='" + status + '\'' +
                ", receiverUsername='" + receiverUsername + '\'' +
                ", senderUsername='" + senderUsername + '\'' +
                '}';
    }
}
