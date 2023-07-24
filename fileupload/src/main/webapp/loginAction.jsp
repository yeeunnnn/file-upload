<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*"%>
<%@ page import= "vo.*"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");
	
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId")!=null){
		response.sendRedirect(request.getContextPath()+"login.jsp");
		return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 디버깅
	System.out.println(memberId+" <--memberId");
	System.out.println(memberPw+" <--memberPw");
	
	// Member 객체에 담아 사용
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
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String sql="SELECT member_id memberId, member_pw memberPw FROM member WHERE member_id = ? AND member_pw = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	rs = stmt.executeQuery();
	
	// DB member 정보를 순회하며, 로그인 정보가 일치할 시 세션에 로그인 정보를 저장
	if(rs.next()){
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션 정보: " + session.getAttribute("loginMemberId"));
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
		return;
	} else {
		System.out.println("로그인 실패");
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
%>