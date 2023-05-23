<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename FROM board b INNER JOIN board_file f ON b.board_no = f.board_no WHERE b.board_no=? and f.board_file_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, boardFileNo);
	ResultSet rs = stmt.executeQuery();
	
	HashMap<String, Object> map = null;
	if(rs.next()){
		map = new HashMap<>();
		map.put("boardNo", rs.getInt("boardNo"));
		map.put("boardTitle", rs.getString("boardTitle"));
		map.put("boardFileNo", rs.getInt("boardFileNo")); //hidden으로 넘기기
		map.put("originFilename", rs.getString("originFilename"));
		//map.put("saveFilename", rs.getString("saveFilename")); 보여주지 않을 건 지우기
		//map.put("path", rs.getString("path"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 따로 비밀번호 묻지 않겠음 -->
<title>modifyBoard.jsp</title>
</head>
<body>
	<h1>board & boardFile 수정</h1>
	<form action="<%=request.getContextPath()%>/modifyBoardAction.jsp" method="post" enctype="multipart/form-data">
	<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
	<input type="hidden" name="boardFileNo" value="<%=map.get("boardFileNo")%>">
		<table>
			<tr><!-- 무조건 둘 다 수정하도록 -->
				<td>boardTitle</td>
				<td><textarea rows="3" cols="50" name="boardTitle" required="required"><%=map.get("boardTitle")%></textarea></td>
			</tr>
			<tr>
				<td>boardFile(수정전 파일 : <%=map.get("originFilename")%>)</td>
				<td><input type="file" name="boardFile"></td>
			</tr>
		</table>
		<button type="submit">수정</button>
	</form>
	
</body>
</html>