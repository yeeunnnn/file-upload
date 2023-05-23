<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import= "com.oreilly.servlet.*" %>
<%@ page import= "com.oreilly.servlet.multipart.*" %>
<%@ page import= "vo.*" %>
<%@ page import= "java.io.*" %>
<%
	//파일의 full 경로
	String dir = request.getServletContext().getRealPath("/upload");//파일 full 경로 찾은것 path.
	System.out.println(dir);
	int max = 10 * 1024 * 1024;
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy()); //동일한 이름이 있으면 뒤에 (1) (2) 붙여줌

	if(mRequest.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+ "/boardList.jsp");
		return;
	}
	
	int boardNo = Integer.parseInt(mRequest.getParameter("boardNo"));
	String saveFilename = mRequest.getParameter("saveFilename");
	
	//1. 파일 삭제
	File f = new File(dir + "/" + saveFilename);
	if(f.exists()){
		f.delete();
		System.out.println(saveFilename + "파일삭제");
	}
	
	//2. board 삭제
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String boardSql = "DELETE FROM board WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	boardStmt.executeUpdate();//변경 값 업데이트
	
	response.sendRedirect(request.getContextPath() + "/boardList.jsp");
	
%>