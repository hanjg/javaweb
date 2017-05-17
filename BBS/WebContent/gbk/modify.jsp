<%@page import="com.bbs.Article"%>
<%@page import="java.sql.*"%>
<%@page import="com.bbs.DB"%>
<%@page pageEncoding="GB18030"%>
<%@include file="_SessionCheck.jsp" %>


<%
	request.setCharacterEncoding("GBK");
	String action = request.getParameter("action");
	
	int id = Integer.parseInt(request.getParameter("id"));
	if (action != null && action.trim().equals("post")) {
		String title = request.getParameter("title");
		String content = request.getParameter("content");

		Connection connection = DB.getConnection();
		Statement statement = DB.createStatement(connection);
		String sql = "update article set title = ?, content = ? where id = ?";
		PreparedStatement pstm = DB.createPreparedStatement(connection, sql);
		pstm.setString(1, title);
		pstm.setString(2, content);
		pstm.setInt(3, id);
		pstm.executeUpdate();
		
		DB.close(pstm);
		DB.close(connection);
		//重定向
		response.sendRedirect("article.jsp");
		return;
	}
%>

<%
Connection connection = DB.getConnection();
Statement statement = DB.createStatement(connection);
String sql = "select * from article where id = " + id;
ResultSet resultSet = DB.executeQuery(statement, sql);

Article article = new Article();
if (resultSet.next()) {
	article.initFromResultSet(resultSet, -1);
}
DB.close(resultSet);
DB.close(statement);
DB.close(connection);
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>修改</title>
<meta http-equiv="content-type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" href="images/style.css"
	title="Integrated Styles">
<script language="JavaScript" type="text/javascript"
	src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS"
	href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?threadID=744236">
</head>
<body>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tbody>
			<tr>
				
				<td><img src="images/header-stretch.gif" alt="" border="0"
					height="57" width="100%"></td>
				<td width="1%"><img src="images/header-right.gif" alt=""
					border="0"></td>
			</tr>
		</tbody>
	</table>
	<br>
	<div id="jive-flatpage">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr valign="top">
					<td width="99%">
						<p class="jive-page-title">修改</p></td>
					<td width="1%"><div class="jive-accountbox"></div></td>
				</tr>
			</tbody>
		</table>



		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr valign="top">
					<td width="99%"><div id="jive-message-holder">
							<div class="jive-message-list">
								<div class="jive-table">
									<div class="jive-messagebox">
										<%--控制是article链接还是modify.jsp提交--%>
										<form action="modify.jsp" method="post">
											<input type="hidden" name="id" value=<%=article.getId() %>>
											<input type="hidden" name="action" value="post"> 标题：
											<input type="text" name="title" value=<%=article.getTitle() %>> <br> 内容：
											<textarea name="content" rows="15" cols="80"><%=article.getContent() %></textarea>
											<br> <input type="submit" value="提交">
										</form>

									</div>
								</div>
							</div>
							<div class="jive-message-list-footer">
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tbody>
										<tr>

											<td align="center" width="98%"><table border="0"
													cellpadding="0" cellspacing="0">
													<tbody>
														<tr>
															<td><a href="article.jsp"><img
																	src="images/arrow-left-16x16.gif" alt="返回到主题列表"
																	border="0" height="16" hspace="6" width="16"></a></td>
															<td><a href="article.jsp">返回到主题列表</a></td>
														</tr>
													</tbody>
												</table></td>

										</tr>
									</tbody>
								</table>
							</div>
						</div></td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>
