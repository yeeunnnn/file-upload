<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*"%>
<%@ page import= "vo.*"%>
<%
	if(session.getAttribute("loginMemberId")!=null){
		response.sendRedirect(request.getContextPath()+"login.jsp");
		return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(memberId+" <--memberId");
	System.out.println(memberPw+" <--memberPw");
	
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
%>