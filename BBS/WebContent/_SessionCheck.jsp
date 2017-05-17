<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.bbs.Article"%>
<%@page import="java.sql.*"%>
<%@page import="com.bbs.DB"%>

<%
String adminLogin = (String)session.getAttribute("adminLogin");
if (adminLogin == null || !adminLogin.trim().equals("true")) {
	response.sendRedirect("login.jsp");
	//sendRedirct之后继续执行,所以需要return
	return;
}

%>


