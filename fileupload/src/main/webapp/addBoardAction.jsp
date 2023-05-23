<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "com.oreilly.servlet.*" %>
<%@ page import= "com.oreilly.servlet.multipart.*" %>
<%@ page import= "vo.*" %>
<%@ page import= "java.io.*" %><!-- delete 메소드를 호출하고 싶어서 -->
<%
	String dir = request.getServletContext().getRealPath("/upload");//파일 full 경로 찾은것 path.
	System.out.println(dir);
	
	int max = 10 * 1024 * 1024;
	// request객체가 MultipartRequest의 API를 사용할 수 있도록 랩핑
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy()); //동일한 이름이 있으면 뒤에 (1) (2) 붙여줌
	//매번 파일 업로드 할 때마다 그 폴더 들어가서 동일한 이름 있는지 찾아야되니까.
	//MultiparRequest API를 사용하여 스트림 내에서 문자값을 반환받을 수 있다.
	
	//업로드 파일의 컨텐츠 파일이 PDF 파일이 아니라면
	if(mRequest.getContentType("boardFile").equals("application/pdf")==false){
		//이미 저장된 파일을 찾아서 삭제한다(DB에는 아직 안올라가있음)
		System.out.println("PDF파일이 아닙니다");
		String saveFilename = mRequest.getFilesystemName("boardFile");
		File f = new  File(dir+"/"+saveFilename); //new File("sign.gif") 이렇게 하면 못찾음. full 경로를 다 적어줘야함. \\ 역슬러시는 역슬러시 두개가 하나.
		if(f.exists()){
			f.delete();
			System.out.println(saveFilename+"파일삭제");
		}
		response.sendRedirect(request.getContextPath()+"/addBoard.jsp");
		return;
	}
	
	// 1) input type="text" 값반환 API --> board 테이블에 저장
	String boardTitle = mRequest.getParameter("boardTitle");
	String memberId = mRequest.getParameter("memberId");
	System.out.println(boardTitle+" <--boardTitle");
	System.out.println(memberId+" <--memberId");
	
	//먼저 저장
	Board board = new Board();
	board.setBoardTitle(boardTitle);
	board.setMemberId(memberId);
	
	// 2) input type="file" 값(파일 메타 정보) 반환 API (원본파일이름, 저장된파일이름, 컨텐츠타입)
	// --> board_file 테이블에 저장
	String type = mRequest.getContentType("boardFile");
	String originFilename = mRequest.getOriginalFileName("boardFile");
	String saveFilename = mRequest.getFilesystemName("boardFile");
	
	System.out.println(type+" <--type");
	System.out.println(originFilename+" <--originFilename");
	System.out.println(saveFilename+" <--saveFilename");
	
	BoardFile boardFile = new BoardFile();
	//boardFile.setBoardNo(boardNo); //방금 insert된 primary key를 반환하는 메소드를 배워야함.
	//둘째로 저장
	boardFile.setType(type);
	boardFile.setOriginFilename(originFilename);
	boardFile.setSaveFilename(saveFilename);
	
	/*
		INSERT쿼리 실행 후 기본키값 받아오기 JDBC API
		String sql = "INSERT 쿼리문";
		pstmt = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
		int row = pstmt.executeUpdate();//insert 쿼리 실행
		ResultSet keyRs = pstmt.getGeneratedKeys(); //insert 후 입력된 행의 키값을 받아오는
		int keyValue = 0;
		if(keyRs.next()){
			keyValue = rs.getInt(1);
		}
		
		INSERT INTO board(board_title, member_id, createdate, updatedate)
		VALUES(?, ?, NOW(), NOW());
	
		INSERT INTO board_file(board_no, origin_filename, save_filename, path, type, createdate)
		VALUES(?, ?, ?, ?, ?, NOW());
	*/
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload","root","java1234");
	//첫번째 쿼리. boardTitle과 memberId 입력
	String boardSql = "INSERT INTO board(board_title, member_id, createdate, updatedate) VALUES(?, ?, NOW(), NOW())";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql, PreparedStatement.RETURN_GENERATED_KEYS); //insert하면서 들어간 key값을 다시 받을 수 있음
	boardStmt.setString(1, boardTitle);
	boardStmt.setString(2, memberId);
	boardStmt.executeUpdate(); //board 입력 후 키값 저장
	
	ResultSet keyRs = boardStmt.getGeneratedKeys(); //return 방금 입력된 키값 반환해주세요
	int boardNo = 0;
	if(keyRs.next()){
		boardNo = keyRs.getInt(1);//이름을 모르니까 무조건 인덱스로 1,2,3,4... 사용할 수밖에 없음
	}
	//두번째 쿼리.
	String fileSql = "INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate) VALUES(?, ?, ?, ?, 'upload', NOW())";
	PreparedStatement fileStmt = conn.prepareStatement(fileSql);
	fileStmt.setInt(1, boardNo);//첫번째 쿼리 if문에서 구한 boardNo.
	fileStmt.setString(2, originFilename);
	fileStmt.setString(3, saveFilename);
	fileStmt.setString(4, type); //path 오류.
	fileStmt.executeUpdate(); 
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
	
%>