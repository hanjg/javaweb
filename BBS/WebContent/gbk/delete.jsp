<%@page import="com.bbs.*"%>
<%@page import="java.sql.*"%>
<%@page pageEncoding="GB18030"%>
<%@include file="_SessionCheck.jsp" %>

<%!
//删除所有子孙节点之后删除该节点
private void delete(Connection connection, int id, boolean isLeaf) {
	if (!isLeaf) {
		Statement statement = null;
		ResultSet rs = null;
		try {
			statement = connection.createStatement();
			String sql = "select * from article where parentId = " + id;
			rs= DB.executeQuery(statement, sql);
			while (rs.next()) {
				delete(connection, rs.getInt("id"), rs.getBoolean("isLeaf"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(statement);
		}
	}
	
	DB.executeUpdate(connection, "delete from article where id = " + id);
}
%>

<%
int id = Integer.parseInt(request.getParameter("id"));
boolean isLeaf = Boolean.parseBoolean(request.getParameter("isLeaf"));
int parentId = Integer.parseInt(request.getParameter("parentId"));
String fromUrl = request.getParameter("fromUrl");
Connection connection = null;
Statement stmt = null;
ResultSet rs = null;

boolean autoCommit = false;

try {
	connection = DB.getConnection();
	autoCommit = connection.getAutoCommit();
	connection.setAutoCommit(false);
	
	delete(connection, id, isLeaf);
	
	stmt = DB.createStatement(connection);
	rs = DB.executeQuery(stmt, "select count(*) from article where parentId = " + parentId);
	rs.next();
	int count = rs.getInt(1);
	if (count == 0) {
		DB.executeUpdate(connection, "update article set isLeaf = true where id = " + parentId);
	}
	
	connection.commit();
	
} finally {
	connection.setAutoCommit(autoCommit);
	DB.close(rs);
	DB.close(stmt);
	DB.close(connection);
}

response.sendRedirect(fromUrl);
%>


