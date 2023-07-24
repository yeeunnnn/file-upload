<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
/*
		필드:
		board_file_no
		board_no
		origin_filename
		save_filename
		path
		type
		createdate
		
		SQL문:
			SELECT
			b.board_title boardTitle,
			f.origin_filename
			f.save_filename
			f.path
			FROM board b INNER board_file f //board와 board_file의 특정 데이터를 연결
			ON b.board_no = f.board_no
			OREDER BY b.createdate DESC
*/
	
	// 1.드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 2. 마리아 DB 접속 정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	// select 쿼리(join문 활용)
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename, f.save_filename saveFilename, path FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	// 쿼리 결과를 HashMap을 이용하여 처리한 후, ArrayList에 추가
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
<title></title>
<style type="text/css">
	table, th, td {
		border: 1px solid #FF0000;
	}
</style>
</head>
<body>
	<h1>PDF 자료 목록</h1><a href="<%=request.getContextPath()%>/addBoard.jsp">파일 추가</a><a href="<%=request.getContextPath()%>/login.jsp"> 로그인</a>
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
				<td><a href="<%=request.getContextPath()%>/boardOne.jsp?boardNo=<%=m.get("boardNo")%>"><%=(String)m.get("boardTitle")%></a></td>
		<%
			if(session.getAttribute("loginMemberId")!=null){ // 로그인 아이디가 있는 경우에만 다운로드 가능
		%>
				<td>
					<a href="<%=request.getContextPath()%>/<%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>" download="<%=(String)m.get("saveFilename")%>">
						<%=(String)m.get("originFilename")%>
					</a>
				</td>
		<%
			} else {
		%>
			<td>
				<a href="<%=request.getContextPath()%>/<%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>">
					<%=(String)m.get("originFilename")%>
				</a>
			</td>
		<%		
			}
		%>		
				<td><a href="<%=request.getContextPath()%>/modifyBoard.jsp?boardNo=<%=m.get("boardNo")%>&boardFileNo=<%=m.get("boardFileNo")%>">수정</a></td><!-- Board와 BoardFile 두개 각각 수정. -->
				<td><a href="<%=request.getContextPath()%>/removeBoard.jsp?boardNo=<%=m.get("boardNo")%>&boardFileNo=<%=m.get("boardFileNo")%>">삭제</a></td><!-- delete시 파일도 같이 삭제 -->
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>