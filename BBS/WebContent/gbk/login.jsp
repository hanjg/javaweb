<%@page import="com.bbs.*"%>
<%@page import="java.sql.*"%>
<%@page pageEncoding="GB18030"%>

<%
	request.setCharacterEncoding("GB18030");
	String action = request.getParameter("action");
	String username = "";
	String password = "";
	if (action != null && action.trim().equals("login")) {
		username = request.getParameter("username");
		password = request.getParameter("password");
		if (username == null || !username.trim().equals("admin")) {
			out.println("用户名错误");
		} else if (password == null || !password.trim().equals("admin")) {
			out.println("密码错误");
		} else {
			session.setAttribute("adminLogin", "true");
// 			out.println("adminLogin:" + session.getAttribute("adminLogin"));
			response.sendRedirect("article.jsp");
		}
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>管理员登录</title>
<meta http-equiv="content-type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" href="images/style.css"
	title="Integrated Styles">
<script language="JavaScript" type="text/javascript"
	src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS"
	href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?threadID=744236">
</head>
<body>
	
	
	<div id="jive-flatpage">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr valign="top">
					<td width="99%">
						<p class="jive-page-title">管理员登录</p></td>
					
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
										<%--控制是由post链接还是由url链接到本网页--%>
										<form action="login.jsp" method="post">
											<input type="hidden" name="action" value="login"> 
											用户名：
											<input type="text" name="username" value=<%=username %>> <br>
											密码：
											<input type="text" name="password" value=<%=password %>> <br>
											<br> <input type="submit" value="登录">
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
