<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "com.oreilly.servlet.*" %>
<%@ page import= "com.oreilly.servlet.multipart.*" %><!-- com.oreilly.servlet.multipart.* 패키지의 MultipartRequest 클래스 -->
<%@ page import= "java.sql.*" %>
<%@ page import= "java.io.*" %>
<%@ page import= "vo.*" %>
<%
	String dir = request.getServletContext().getRealPath("/upload");
	System.out.println("업로드할 폴더(dir) : "+dir);
	
	int max = 10 * 1024 * 1024;
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	mRequest.getOriginalFileName("boardFile");
	//System.out.println(mRequest.getOriginalFileName("boardFile") + "<-- boardFileName");
	// mRequeset.getOriginalFileName("boardFile") 값이 null이면 board테이블에 title만 수정
	int boardNo = Integer.parseInt(mRequest.getParameter("boardNo")); 
	int boardFileNo = Integer.parseInt(mRequest.getParameter("boardFileNo"));
	
	//1) board_title 수정
	String boardTitle = mRequest.getParameter("boardTitle");

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	String boardSql = "UPDATE board SET board_title = ? WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setString(1, boardTitle);
	boardStmt.setInt(2, boardNo);
	int boardRow = boardStmt.executeUpdate();
	
	//2) 이전 boardFile 삭제, 새로운 boardFile추가 테이블을 수정.
	if(mRequest.getOriginalFileName("boardFile")!= null){
		// 수정할 파일이 있으면
		// pdf파일이 아니면 새로 업로드 한 파일을 삭제 유효성 검사
		if(mRequest.getContentType("boardFile").equals("application/pdf") == false) {
			System.out.println("PDF파일이 아닙니다");
			String saveFilename = mRequest.getFilesystemName("boardFile");
			File f = new File(dir+"/"+saveFilename);
			if(f.exists()){
				f.delete(); // pdf 파일이 아니면 파일 삭제
				System.out.println(saveFilename+"파일삭제");
				}
			} else { //PDF파일이면 새로 업로드 후 이전파일 삭제 및 DB수정(update)
				String type = mRequest.getContentType("boardFile");
				String originFilename = mRequest.getOriginalFileName("boardFile");
				String saveFilename = mRequest.getFilesystemName("boardFile");
				
				// boardfile 객체에 담아 사용
				BoardFile boardFile = new BoardFile();
				boardFile.setBoardFileNo(boardFileNo);
				boardFile.setType(type);
				boardFile.setOriginFilename(originFilename);
				boardFile.setSaveFilename(saveFilename);
				
				// 1) 이전파일 삭제
				String saveFilenameSql = "SELECT save_filename FROM board_file WHERE board_file_no=?";
				PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
				saveFilenameStmt.setInt(1, boardFile.getBoardFileNo());
				ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
				
				String preSaveFilename = "";
				if(saveFilenameRs.next()){
					preSaveFilename = saveFilenameRs.getString("save_filename");
				}
			
				File f = new File(dir+"/"+preSaveFilename);
				if(f.exists()){
					f.delete();
				}
				
				// 2)수정된 파일의 정보로 DB를 수정
				String boardFileSql = "UPDATE board_file SET origin_filename=?, save_filename=? where board_file_no=?";
				PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
				boardFileStmt.setString(1, boardFile.getOriginFilename());
				boardFileStmt.setString(2, boardFile.getSaveFilename());
				boardFileStmt.setInt(3, boardFile.getBoardFileNo());
				int boardFileRow = boardFileStmt.executeUpdate();
			}
			
		}
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
	
%>