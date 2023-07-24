<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%
   // 원본 request를 객체를 cos(패키지의 이전 이름) api로 랩핑
   // new MultipartRequest(원본request, 업로드폴더, 최대파일사이즈byte, 인코딩, 중복이름정책)
   
   // 프로젝트 안의 upload 폴더의 실제 물리적 위치를 반환
   String dir = request.getServletContext().getRealPath("/upload");
   System.out.println(dir + " <-- dir");
   int maxFileSize = 1024 * 1024 * 100; // 최대 파일 크기를 100Mbyte로 설정 (2의 10승). 가독성을 위해 상수로 분리하여 표현.
   // ex. 하루 : 1000 * 60 * 60 * 24
   
   // 업로드 폴더 내에 동일한 이름이 있으면 뒤에 숫자를 추가하여 파일 이름을 변경 
   DefaultFileRenamePolicy fp = new DefaultFileRenamePolicy();
   
   // MultipartRequest 객체 생성: 파일 업로드를 처리하는 데 사용
   MultipartRequest mreq = new MultipartRequest(request, dir, maxFileSize, "utf-8", fp);
%>