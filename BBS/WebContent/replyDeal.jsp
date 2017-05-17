<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.bbs.DB"%>
<%@page import="java.sql.Connection"%>

<%
request.setCharacterEncoding("UTF-8");
int parentId = Integer.parseInt(request.getParameter("parentId"));
int rootId = Integer.parseInt(request.getParameter("rootId"));
String title = request.getParameter("title");
String cont = request.getParameter("cont");
String fromUrl = request.getParameter("fromUrl");

System.out.println("fromUrl=" + fromUrl);

Connection connection = DB.getConnection();

//确保插入和更新的原子性
boolean autoCommit = connection.getAutoCommit();
connection.setAutoCommit(false);

String sql = "insert into article values (null, ?, ?, ?, ?, now(), ?)";
PreparedStatement preparedStatement = DB.createPreparedStatement(connection, sql);
preparedStatement.setInt(1, parentId);
preparedStatement.setInt(2, rootId);
preparedStatement.setString(3, title);
preparedStatement.setString(4, cont);
preparedStatement.setBoolean(5, true);
preparedStatement.executeUpdate();

//回复叶节点，需要将叶节点设置为非叶节点
Statement statement = connection.createStatement();
statement.executeUpdate("update article set isLeaf = false where id = " + parentId);

connection.commit();
connection.setAutoCommit(autoCommit);

DB.close(statement);
DB.close(preparedStatement);
DB.close(connection);
%>

<%
 %>
<span id="time" style="background:red">3</span>秒钟之后跳转，如不跳转点击下面链接<br>
<a href="index.jsp">首页</a>

<script type="text/javascript">
function delayUrl(url) {
	var delay = document.getElementById("time").innerHTML;
	//alert(delay);
	if (delay > 0) {
		delay--;
		document.getElementById("time").innerHTML = delay;
	} else {
		window.top.location.href = url;
	}
	setTimeout("delayUrl('" + url + "')", 1000);
}
</script>

<script type="text/javascript">
	
	delayUrl("index.jsp");
</script>
