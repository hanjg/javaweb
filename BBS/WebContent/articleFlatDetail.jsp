<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.bbs.Article"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.bbs.DB"%>
<%@page import="java.sql.Connection"%>

<%
String strId = request.getParameter("id");
if (strId == null || strId.trim().equals("")) {
	out.println("Error Id!");
	return;
}
int id = 0;
try {
	id = Integer.parseInt(strId);
} catch (NumberFormatException e) {
	out.println("Error Id!");
	return;
}

List<Article> articles = new ArrayList<>();
Connection connection = DB.getConnection();
Statement statement = DB.createStatement(connection);
String sql = "select * from article where rootId = " + id + " order by publishDate asc";
ResultSet resultSet = DB.executeQuery(statement, sql);
while (resultSet.next()) {
	Article article = new Article();
	article.initFromResultSet(resultSet, -1);
	articles.add(article);
}
DB.close(resultSet);
DB.close(statement);
DB.close(connection);

%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>详细信息</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS" href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?threadID=744236">
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tbody>
    <tr>
      
      <td><img src="images/header-stretch.gif" alt="" border="0" height="57" width="100%"></td>
      <td width="1%"><img src="images/header-right.gif" alt="" border="0"></td>
    </tr>
  </tbody>
</table>

<div id="jive-flatpage">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="99%">
          <p class="jive-page-title"> 主题 :<%=articles.get(0).getTitle() %></p></td>
        <td width="1%"><div class="jive-accountbox"></div></td>
      </tr>
    </tbody>
  </table>
  <div class="jive-buttons">
    <table summary="Buttons" border="0" cellpadding="0" cellspacing="0">
      <tbody>
        <tr>
          
          
        </tr>
      </tbody>
    </table>
  </div>
  
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="99%"><div id="jive-message-holder">
            <div class="jive-message-list">
              <div class="jive-table">
                <div class="jive-messagebox">
                
                <!-- 循环开始 -->
                 <% 
                 	for(int i = 0; i < articles.size(); i++) {
                 		Article article = articles.get(i);
                 		String floor = i == 0 ? "楼主：" : ("第" + i + "楼：");
                 %>
                  <table summary="Message" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tbody>
                      <tr id="jive-message-780144" class="jive-odd" valign="top">
                        <td class="jive-first" width="1%">
						<!-- 个人信息的table -->
						<table border="0" cellpadding="0" cellspacing="0" width="150">
                            <tbody>
                              <tr>
                                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tbody>
                                      <tr valign="top">
                                        <td style="padding: 0px;" width="1%"><nobr> <a href="http://bbs.chinajavaworld.com/profile.jspa?userID=215489" title="诺曼底客">诺曼底客</a> </nobr> </td>
                                        <td style="padding: 0px;" width="99%"><img class="jive-status-level-image" src="images/level3.gif" title="世界新手" alt="" border="0"><br>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                  <img class="jive-avatar" src="images/avatar-display.png" alt="" border="0"> <br>
                                  <br>
                                  <span class="jive-description"> 发表:
                                  34 <br>
                                  点数: 100<br>
                                  注册:
                                  07-5-10 <br>
                                  <a href="http://blog.chinajavaworld.com/u/215489" target="_blank"><font color="red">访问我的Blog</font></a> </span> </td>
                              </tr>
                            </tbody>
                          </table>
						  <!--个人信息table结束-->
						  
						  </td>
                        <td class="jive-last" width="99%"><table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tbody>
                              <tr valign="top">
                              
                                <td width="1%"></td>
                                <td width="97%"><span class="jive-subject"><%= floor + article.getTitle() %></span> </td>
                                
                                 <td class="jive-rating-buttons" nowrap="nowrap" width="1%"></td>
                                <td width="1%"><div class="jive-buttons">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                      <tbody>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td class="jive-icon"><a href="reply.jsp?id=<%=article.getId() %>&rootId=<%=article.getRootId() %>" title="回复本主题"><img src="images/reply-16x16.gif" alt="回复本主题" border="0" height="16" width="16"></a> </td>
                                          <td class="jive-icon-label"><a href="reply.jsp?id=<%=article.getId() %>&rootId=<%=article.getRootId() %>" title="回复本主题">回复</a> </td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div></td>
                                
                              </tr>
                              <tr>
                                <td colspan="4" style="border-top: 1px solid rgb(204, 204, 204);"><br>
                                 <%= article.getContent() %> <br>
                                  <br>
                                </td>
                              </tr>
                              <tr>
                                <td colspan="4" style="font-size: 9pt;"><img src="images/sigline.gif"><br>
                                  <font color="#568ac2">学程序是枯燥的事情，愿大家在一起能从中得到快乐！</font> <br>
                                </td>
                              </tr>
                              <tr>
                                
                              </tr>
                            </tbody>
                          </table></td>
                      </tr>
                    </tbody>
                  </table>
                  
                 <% 
                 	}
                 %>
                <!-- 循环结束 -->
                </div>
              </div>
            </div>
            <div class="jive-message-list-footer">
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody>
                  <tr>
                    <td nowrap="nowrap" width="1%"></td>
                    <td align="center" width="98%"><table border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                          <tr>
                            <td><a href="articleFlat.jsp"><img src="images/arrow-left-16x16.gif" alt="返回到主题列表" border="0" height="16" hspace="6" width="16"></a> </td>
                            <td><a href="articleFlat.jsp">返回到主题列表</a> </td>
                          </tr>
                        </tbody>
                      </table></td>
                    <td nowrap="nowrap" width="1%">&nbsp;</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div></td>
        <td width="1%"></td>
      </tr>
    </tbody>
  </table>
</div>
</body>
</html>
