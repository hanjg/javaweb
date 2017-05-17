<%@page import="com.bbs.Article"%>
<%@page import="java.sql.*"%>
<%@page import="com.bbs.DB"%>
<%@page pageEncoding="GB18030"%>

<%
	request.setCharacterEncoding("GBK");
	String action = request.getParameter("action");
	//判断是否通过在post.jsp提交表单链接到post.jsp。
	//是则插入数据库,之后重定向；否则填写表单，提交。
	if (action != null && action.trim().equals("post")) {
		String title = request.getParameter("title");
		String cont = request.getParameter("cont");

		Connection connection = DB.getConnection();

		//确保插入和更新的原子性
		boolean autoCommit = connection.getAutoCommit();
		connection.setAutoCommit(false);
		
		int rootId = -1;
		
		String sql = "insert into article values (null, ?, ?, ?, ?, now(), ?)";
		PreparedStatement preparedStatement = DB.createPreparedStatement(connection, sql, Statement.RETURN_GENERATED_KEYS);
		preparedStatement.setInt(1, 0);
		preparedStatement.setInt(2, rootId);
		preparedStatement.setString(3, title);
		preparedStatement.setString(4, cont);
		preparedStatement.setBoolean(5, true);
		preparedStatement.executeUpdate();
		
		//取出自动生成的key，并且更新rootId
		ResultSet resultSet = preparedStatement.getGeneratedKeys();
		resultSet.next();
		rootId = resultSet.getInt(1);
		Statement statement = connection.createStatement();
		statement.executeUpdate("update article set rootId = " + rootId + " where id = " + rootId);

		connection.commit();
		connection.setAutoCommit(autoCommit);
		DB.close(statement);
		DB.close(preparedStatement);
		DB.close(connection);
		
		//重定向
		response.sendRedirect("article.jsp");
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Java|Java世界_中文论坛|ChinaJavaWorld技术论坛 :
	初学java遇一难题！！望大家能帮忙一下 ...</title>
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
				<td width="140"><a
					href="http://bbs.chinajavaworld.com/index.jspa"><img
						src="images/header-left.gif"
						alt="Java|Java世界_中文论坛|ChinaJavaWorld技术论坛" border="0"></a></td>
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
						<p class="jive-page-title">主题: 发布新主题</p></td>
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
										<%--控制是article链接还是post.jsp提交--%>
										<form action="post.jsp" method="post">
											<input type="hidden" name="action" value="post"> 标题：
											<input type="text" name="title"> <br> 内容：
											<textarea name="cont" rows="15" cols="80"></textarea>
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
