<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@page import="com.bbs.*"%>
<%@page import="java.util.List"%>
<%@page pageEncoding="GB18030" %>

<%!
private void tree(List<Article> articles, Connection connection, int parentId, int grade) {
	String sql = "select * from article where parentId = " + parentId;
	Statement statement = DB.createStatement(connection);
	ResultSet resultSet = DB.executeQuery(statement, sql);
	try {
		while (resultSet.next()) {
			Article article = new Article();
			article.initFromResultSet(resultSet, grade);
			articles.add(article);
			if (!article.isLeaf()) {
				tree(articles, connection, article.getId(), grade + 1);
			}
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		DB.close(resultSet);
		DB.close(statement);
	}
	
}
%>

<%
boolean logined = false;
String adminLogin = (String)session.getAttribute("adminLogin");
if (adminLogin != null && adminLogin.trim().equals("true")) {
	logined = true;
}
 %>

<%
Connection connection = DB.getConnection();
List<Article> articles = new ArrayList<>();
tree(articles, connection, 0, 0);
DB.close(connection);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>BBS</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS" href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?forumID=20">
<script language="JavaScript" type="text/javascript" src="images/common.js"></script>
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

<div id="jive-forumpage">
  
  <div class="jive-buttons">
    <table summary="Buttons" border="0" cellpadding="0" cellspacing="0">
      <tbody>
        <tr>
          <td class="jive-icon"><a href="post.jsp"><img src="images/post-16x16.gif" alt="发布新主题" border="0" height="16" width="16"></a></td>
          <td class="jive-icon-label"><a id="jive-post-thread" href="post.jsp">发布新主题</a> </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<div>
  
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="99%"><div class="jive-thread-list">
            <div class="jive-table">
              <table summary="List of threads" cellpadding="0" cellspacing="0" width="100%">
                <thead>
                  <tr>
                    <th class="jive-first" colspan="3"> 主题 </th>
                    <th class="jive-author"> <nobr> 作者
                      &nbsp; </nobr> </th>
                    <th class="jive-view-count"> <nobr> 浏览
                      &nbsp; </nobr> </th>
                    <th class="jive-msg-count" nowrap="nowrap"> 回复 </th>
                    <th class="jive-last" nowrap="nowrap">最新帖子 </th>
                  </tr>
                </thead>
                <tbody>
				<%
				for(Article article : articles) {
					String preString = "";
					for(int i = 0; i < article.getGrade(); i++) {
						preString += "----";
					}
				%>
				                  <tr class="jive-even">
                    <td class="jive-first" nowrap="nowrap" width="1%" style="width: 21px; "><div class="jive-bullet"> <img src="images/read-16x16.gif" alt="鐎规瓕灏锟�" border="0" height="16" width="16">
                        <!-- div-->
                      </div></td>
                      
                    <%if (logined) { %>
                    	<td nowrap="nowrap" width="1%" style="width: 36px; "><a href="delete.jsp?id=<%=article.getId()%>&parentId=<%=article.getParentId()%>&isLeaf=<%=article.isLeaf()%>">删除</a></td>
                       	<td nowrap="nowrap" width="1%" style="width: 36px; "><a href="modify.jsp?id=<%=article.getId()%>">修改</a></td>
                    	
                    <%} %>
                    
                    <td class="jive-thread-name" width="95%"><a id="jive-thread-1" href="articleDetail.jsp?id=<%= article.getId()%>"><%= preString + article.getTitle() %></a></td>
                    <td class="jive-author" nowrap="nowrap" width="1%"><span class=""> <a href="http://bbs.chinajavaworld.com/profile.jspa?userID=226030">author1</a> </span></td>
                    <td class="jive-view-count" width="1%"> 104</td>
                    <td class="jive-msg-count" width="1%"> 5</td>
                    <td class="jive-last" nowrap="nowrap" width="1%"><div class="jive-last-post"> <%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(article.getPublishDate()) %> <br>
                        by: <a href="http://bbs.chinajavaworld.com/thread.jspa?messageID=780182#780182" title="jingjiangjun" style="">hhh &#187;</a> </div></td>
                  </tr>
                  
                  <%-- 
                  <tr class="jive-odd">
                    <td class="jive-first" nowrap="nowrap" width="1%"><div class="jive-bullet"> <img src="images/read-16x16.gif" alt="鐎规瓕灏锟�" border="0" height="16" width="16">
                        <!-- div-->
                      </div></td>
                    <td nowrap="nowrap" width="1%">&nbsp;
                      
                      
                      
                      
                      &nbsp;</td>
                    <td class="jive-thread-name" width="95%"><a id="jive-thread-2" href="http://bbs.chinajavaworld.com/thread.jspa?threadID=744234&amp;tstart=25">閻犲浄鎷� 闁稿繐瀚槐鍨椤掍礁鐦归柣鎰帮拷娑氱憮闂侇叏缍侀崳锟� 闂佹寧鐟ㄩ銈夋晬瀹�瀣闁挎冻鎷�/a></td>
                    <td class="jive-author" nowrap="nowrap" width="1%"><span class=""> <a href="http://bbs.chinajavaworld.com/profile.jspa?userID=226028">403783154</a> </span></td>
                    <td class="jive-view-count" width="1%"> 52</td>
                    <td class="jive-msg-count" width="1%"> 2</td>
                    <td class="jive-last" nowrap="nowrap" width="1%"><div class="jive-last-post"> 2007-9-13 濞戞挸锕ゅ畷锟�40 <br>
                        by: <a href="http://bbs.chinajavaworld.com/thread.jspa?messageID=780172#780172" title="downing114" style="">downing114 &#187;</a> </div></td>
                  </tr>
                  
                 --%>
       			<%
				}
       			%>
                </tbody>
              </table>
            </div>
          </div>
          </td>
      </tr>
    </tbody>
  </table>
  
</div>
</body>
</html>
