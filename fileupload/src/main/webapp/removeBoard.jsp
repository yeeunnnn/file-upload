<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	/* controller */
	if(request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	
	/* model */
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, b.updatedate, f.origin_filename originFileName, f.save_filename saveFileName, f.path path FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	HashMap<String, Object> map = null;
	if(rs.next()){
		map = new HashMap<>();
		map.put("boardNo", rs.getInt("boardNo"));
		map.put("boardTitle", rs.getString("boardTitle"));
		map.put("originFilename", rs.getString("originFilename"));
		map.put("saveFilename", rs.getString("saveFilename"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>removeBoard.jsp</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/removeBoardAction.jsp" method="post" enctype="multipart/form-data">
		<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
		<input type="hidden" name="saveFilename" value="<%=map.get("saveFilename")%>">
		<table>
			<tr>
				<td colspan="2"><h2>삭제하시겠습니까?</h2></td>
			</tr>
			<tr>
				<td>boardTitle</td>
				<td><%=map.get("boardTitle")%></td>
			</tr>
			<tr>
				<td>boardFile</td>
				<td><%=map.get("originFilename")%></td>
			</tr>
		</table>
		<button type="submit">삭제</button>
	</form>
</body>
</html>