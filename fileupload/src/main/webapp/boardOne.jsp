<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%
	// 1. 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 2. 마리아 DB 접속 정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	// select 쿼리(join문 활용)
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, b.createdate createdate, b.updatedate updatedate, f.board_file_no boardFileNo, f.origin_filename originFilename, f.save_filename saveFilename, path FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	// 쿼리 결과를 HashMap을 이용하여 처리 (첫 번째 레코드만 가져오기)
	HashMap<String, Object> boardfile = new HashMap<>();
	if (rs.next()) {
		boardfile.put("boardNo", rs.getInt("boardNo"));
		boardfile.put("boardTitle", rs.getString("boardTitle"));
		boardfile.put("boardFileNo", rs.getInt("boardFileNo"));
		boardfile.put("originFilename", rs.getString("originFilename"));
		boardfile.put("saveFilename", rs.getString("saveFilename"));
		boardfile.put("path", rs.getString("path"));
		boardfile.put("createdate", rs.getString("createdate"));
		boardfile.put("updatedate", rs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardOne</title>
</head>
<body>
	<h1>boardOne</h1><a href="<%=request.getContextPath()%>/boardList.jsp">이전</a>
	<table border="1">
		<tr>
			<th>boardTitle</th>
			<td><%=(String)boardfile.get("boardTitle")%></td>
		</tr>
		<tr>
			<th>file</th>
			<td>
				<a href="<%=request.getContextPath()%>/<%=(String)boardfile.get("path")%>/<%=(String)boardfile.get("saveFilename")%>" download="<%=(String)boardfile.get("saveFilename")%>">
					<%=(String)boardfile.get("originFilename")%>
				</a>
			</td>
		</tr>
		<tr>
			<th>createdate</th>
			<td><%=boardfile.get("createdate")%></td>
		</tr>
		<tr>
			<th>updatedate</th>
			<td><%=boardfile.get("updatedate")%></td>
		</tr>
	</table>
</body>
</html>