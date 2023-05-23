<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	/*
	board_file_no
	board_no
	origin_filename
	save_filename
	path
	type
	createdate
	
		SELECT
		b.board_title boardTitle,
		f.origin_filename
		f.save_filename
		f.path
		FROM board b INNER board_file f //board하고 board_file의 특정 데이터를 연결
		ON b.board_no = f.board_no
		OREDER BY b.createdate DESC
	*/
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename, f.save_filename saveFilename, path FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<>();
		m.put("boardNo", rs.getInt("boardNo"));
		m.put("boardTitle", rs.getString("boardTitle"));
		m.put("boardFileNo", rs.getInt("boardFileNo"));
		m.put("originFilename", rs.getString("originFilename"));
		m.put("saveFilename", rs.getString("saveFilename"));
		m.put("path", rs.getString("path"));
		list.add(m);
	}
	
	%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!--상세보기, 로그인 되어있으면 다운받을 수도 있고-->
<title></title>
<style type="text/css">
	table, th, td {
		border: 1px solid #FF0000;
	}
</style>
</head>
<body>
	<h1>PDF 자료 목록</h1>
	<table>
		<tr>
			<td>boardTitle</td>
			<td>originFilename</td>
			<td>수정</td>
			<td>삭제</td>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
			<tr>
				<td><%=(String)m.get("boardTitle")%></td>
				<td>
					<a href="<%=request.getContextPath()%>/<%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>" download="<%=(String)m.get("saveFilename")%>">
						<%=(String)m.get("originFilename")%>
					</a>
				</td>
				<td><a href="<%=request.getContextPath()%>/modifyBoard.jsp?boardNo=<%=m.get("boardNo")%>&boardFileNo=<%=m.get("boardFileNo")%>">수정</a></td><!-- Board와 BoardFile 두개 각각 수정. -->
				<td><a href="<%=request.getContextPath()%>/removeBoard.jsp?boardNo=<%=m.get("boardNo")%>&boardFileNo=<%=m.get("boardFileNo")%>">삭제</a></td><!-- delete시 파일도 같이 삭제 -->
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>