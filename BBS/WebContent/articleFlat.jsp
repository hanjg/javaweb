<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.bbs.*"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Connection"%>

<%
	boolean logined = false;
	String adminLogin = (String) session.getAttribute("adminLogin");
	if (adminLogin != null && adminLogin.trim().equals("true")) {
		logined = true;
	}
%>

<%
	final int PAGE_SIZE = 5;
	int pageNo = 1;
	String pageNoStr = request.getParameter("pageNo");
	if (pageNoStr != null && !pageNoStr.equals("")) {
		try {
			pageNo = Integer.parseInt(pageNoStr);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
	}
	if (pageNo < 1) {
		pageNo = 1;
	}

	Connection connection = DB.getConnection();

	Statement statement = DB.createStatement(connection);
	ResultSet resultSet = DB.executeQuery(statement, "select count(*) from article where parentId = 0");
	resultSet.next();
	int articleNum = resultSet.getInt(1);
	int totalPages = (articleNum - 1) / PAGE_SIZE + 1;

	if (pageNo > totalPages) {
		pageNo = totalPages;
	}

	List<Article> articles = new ArrayList<>();
	int startIndex = (pageNo - 1) * PAGE_SIZE;
	//从数据库中取出下标startIndex开始的page_size个楼主贴，按照发表日期的降序排列
	String sql = "select * from article where parentId = 0 order by publishDate desc limit " + startIndex + ", "
			+ PAGE_SIZE;
	resultSet = DB.executeQuery(statement, sql);
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
<title>BBS</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="images/style.css"
	title="Integrated Styles">
<script language="JavaScript" type="text/javascript"
	src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS"
	href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?forumID=20">
<script language="JavaScript" type="text/javascript"
	src="images/common.js"></script>
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


	<div id="jive-forumpage">

		<div class="jive-buttons">
			<table summary="Buttons" border="0" cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="jive-icon"><a href="post.jsp"><img
								src="images/post-16x16.gif" alt="发表新主题" border="0" height="16"
								width="16"></a></td>
						<td class="jive-icon-label"><a id="jive-post-thread"
							href="post.jsp">发表新主题</a></td>
						<td class="jive-icon-label"><a href="article.jsp">显示所有帖子</a></td>
						<%
							String url = request.getRequestURL().toString();
							String query = request.getQueryString();
							url += query == null ? "" : ("?" + request.getQueryString());
						%>
						<%
							if (logined) {
						%>
						<td class="jive-icon-label"><a href="logout.jsp?fromUrl=<%=url%>">登出</a></td>
						<%
							} else {
						%>
						<td class="jive-icon-label"><a href="login.jsp?fromUrl=<%=url%>">登录</a></td>
						<%
							}
						%>
					</tr>
				</tbody>
			</table>
		</div>

		<table border="0" cellpadding="3" cellspacing="0" width="100%">
			<tbody>
				<tr valign="top">
					<td><span class="nobreak"><span class="jive-paginator">
								第<%=pageNo%>页,共<%=totalPages%>页 [
						</span></span> <span class="nobreak"><span class="jive-paginator">
								<a href="articleFlat.jsp?pageNo=1">第一页</a>
						</span></span> <span class="nobreak"><span class="jive-paginator">|</span></span>

						<span class="nobreak"><span class="jive-paginator">
								<a href="articleFlat.jsp?pageNo=<%=pageNo - 1%>">上一页</a>
						</span></span> <span class="nobreak"><span class="jive-paginator">|
						</span></span> <span class="nobreak"><span class="jive-paginator">
								<a href="articleFlat.jsp?pageNo=<%=pageNo + 1%>">下一页</a>
						</span></span> <span class="nobreak"><span class="jive-paginator">|
						</span></span> <span class="nobreak"><span class="jive-paginator">
								<a href="articleFlat.jsp?pageNo=<%=totalPages%>">最末页</a> ]
						</span> </span></td>
				</tr>
			</tbody>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr valign="top">
					<td width="99%"><div class="jive-thread-list">
							<div class="jive-table">
								<table summary="List of threads" cellpadding="0" cellspacing="0"
									width="100%">
									<thead>
										<tr>
											<%
												int titleWidth = logined ? 4 : 2;
											%>
											<th class="jive-first" colspan="<%=titleWidth%>">主题</th>
											<th class="jive-author"><nobr> 作者 &nbsp; </nobr></th>
											<th class="jive-view-count"><nobr> 浏览 &nbsp; </nobr></th>
											<th class="jive-msg-count" nowrap="nowrap">回复</th>
											<th class="jive-last" nowrap="nowrap">最新帖子</th>
										</tr>
									</thead>
									<tbody>
										<%
											int i = 1;
											for (Article article : articles) {
												String classStr = i % 2 == 0 ? "jive-odd" : "jive-even";
										%>
										<tr class=<%=classStr%>>
											<td class="jive-first" nowrap="nowrap" width="1%"><div
													class="jive-bullet">
													<img src="images/read-16x16.gif" alt="已读" border="0"
														height="16" width="16">
													<!-- div-->
												</div></td>

											<%
												if (logined) {
											%>
											<td nowrap="nowrap" width="1%" style="width: 36px;"><a
												href="delete.jsp?id=<%=article.getId()%>&parentId=<%=article.getParentId()%>&isLeaf=<%=article.isLeaf()%>&fromUrl=<%=url%>">删除</a></td>
											<td nowrap="nowrap" width="1%" style="width: 36px;"><a
												href="modify.jsp?id=<%=article.getId()%>&fromUrl=<%=url%>">修改</a></td>

											<%
												}
											%>

											<td class="jive-thread-name" width="95%"><a
												id="jive-thread-1"
												href="articleFlatDetail.jsp?id=<%=article.getId()%>"><%=article.getTitle()%></a></td>
											<td class="jive-author" nowrap="nowrap" width="1%"><span
												class=""> <a
													href="http://bbs.chinajavaworld.com/profile.jspa?userID=226030">author1</a>
											</span></td>
											<td class="jive-view-count" width="1%">104</td>
											<td class="jive-msg-count" width="1%">5</td>
											<td class="jive-last" nowrap="nowrap" width="1%"><div
													class="jive-last-post">
													<%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(article.getPublishDate())%>
													<br> by: <a
														href="http://bbs.chinajavaworld.com/thread.jspa?messageID=780182#780182"
														title="jingjiangjun" style="">hhh &#187;</a>
												</div></td>
										</tr>

										<%
											i++;
											}
										%>
									</tbody>
								</table>
							</div>
						</div>
						<div class="jive-legend"></div></td>
				</tr>
			</tbody>
		</table>
		<br> <br>
	</div>
</body>
</html>
