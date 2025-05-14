<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="informationSystem.pojo.Email" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=请先登录系统");
        return;
    }

    List<Email> emails = (List<Email>) request.getSession().getAttribute("emails");
    String specialAction = (String) session.getAttribute("specialAction");
    System.out.println("specialAction is " + specialAction);
    System.out.println(emails);

%>

<div class="email-list">
    <%-- 根据specialAction类型来选择不同的 --%>
    <c:choose>
        <%-- 收件箱 --%>
         <c:when test="${specialAction eq 'inbox'}">
            <c:forEach items="${emails}" var="email">
        <a href="emailDetail?id=${email.id}&takeAction=readAction" class="email-item">
            <div class="email-header">
                <%-- 显示未读标识 --%>
                <c:if test="${email.isRead == 0}">
                    <span class="unread-dot" style="
                        display: inline-block;
                        width: 8px;
                        height: 8px;
                        background: #e74c3c;
                        border-radius: 50%;
                        margin-right: 8px;
                    "></span>
                </c:if>
                <span class="subject">${email.subject}</span>
                <span class="time">${email.sendTime}</span>
<%--                    <span class="time">    --%>
<%--                      <fmt:formatDate value="${email.sendTime}" pattern="yyyy-MM-dd HH:mm"/>    --%>
<%--                       </span>                                                                        --%>
            </div>
            <div class="receiver">
                发件人：${email.senderUsername}
             </div>
         </a>
      </c:forEach>
   </c:when>

        <%-- 草稿箱 --%>
        <c:when test="${specialAction eq 'draft'}">
               <c:forEach items="${emails}" var="email">
                       <a href="draft?id=${email.id}" class="email-item">
                        <div class="email-header">
                         <span class="subject">${email.subject}</span>
                          <span class="time">${email.sendTime}</span>
        <%--               <span class="time"><fmt:formatDate value="${email.sendTime}" pattern="yyyy-MM-dd HH:mm"/></span>   --%>
                        </div>
                     <div class="receiver">草稿（未发送）</div>
                  </a>
              </c:forEach>
          </c:when>
        <%-- 已发送 --%>
        <c:when test="${specialAction eq 'sent'}">
            <c:forEach items="${emails}" var="email">
                <a href="emailDetail?id=${email.id}" class="email-item">
                    <div class="email-header">
                        <span class="subject">${email.subject}</span>
                        <span class="time">${email.sendTime}</span>
                    </div>
                    <div class="receiver">收件人：${email.receiverUsername}</div>
                </a>
            </c:forEach>
            <c:if test="${empty emails}">
               <div class="no-emails">暂无邮件</div>
            </c:if>
        </c:when>
        <%-- 通讯录 --%>
    </c:choose>

</div>


