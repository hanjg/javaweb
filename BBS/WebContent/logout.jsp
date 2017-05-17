<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	String fromUrl = request.getParameter("fromUrl");
	String logined = (String)session.getAttribute("adminLogin");
	if (logined.trim().equals("true")) {
		session.setAttribute("adminLogin", "false");
	} 
	
	response.sendRedirect(fromUrl);
	
%>

