<%@page import="com.bbs.Article"%>
<%@page import="java.sql.*"%>
<%@page import="com.bbs.DB"%>
<%@page pageEncoding="GB18030"%>

<%
	request.setCharacterEncoding("GBK");
	String action = request.getParameter("action");
	//�ж��Ƿ�ͨ����post.jsp�ύ�����ӵ�post.jsp��
	//����������ݿ�,֮���ض��򣻷�����д�����ύ��
	if (action != null && action.trim().equals("post")) {
		String title = request.getParameter("title");
		String cont = request.getParameter("cont");

		Connection connection = DB.getConnection();

		//ȷ������͸��µ�ԭ����
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
		
		//ȡ���Զ����ɵ�key�����Ҹ���rootId
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
		
		//�ض���
		response.sendRedirect("article.jsp");
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Java|Java����_������̳|ChinaJavaWorld������̳ :
	��ѧjava��һ���⣡��������ܰ�æһ�� ...</title>
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
						alt="Java|Java����_������̳|ChinaJavaWorld������̳" border="0"></a></td>
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
						<p class="jive-page-title">����: ����������</p></td>
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
										<%--������article���ӻ���post.jsp�ύ--%>
										<form action="post.jsp" method="post">
											<input type="hidden" name="action" value="post"> ���⣺
											<input type="text" name="title"> <br> ���ݣ�
											<textarea name="cont" rows="15" cols="80"></textarea>
											<br> <input type="submit" value="�ύ">
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
																	src="images/arrow-left-16x16.gif" alt="���ص������б�"
																	border="0" height="16" hspace="6" width="16"></a></td>
															<td><a href="article.jsp">���ص������б�</a></td>
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
