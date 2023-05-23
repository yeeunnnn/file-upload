<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>add board + file</title>
	<style type="text/css">
		table, th, td {
			border: 1px solid #FF0000;
		}
	</style>
</head>
<body>
	<h1>자료 업로드</h1>
	<form action="<%=request.getContextPath()%>/addBoardAction.jsp" method="post" enctype="multipart/form-data"><!-- multipart form-data로 파일을 넘길 땐 post -->
		<table>
			<!-- 자료 업로드 제목글 -->
			<tr>
				<th>boardTitle</th>
				<td>
					<textarea rows="3" cols="50" name="boardTitle"
						required="required"></textarea> <!-- required : 폼 입력 안하고 빈 값을 보낼 때 경고창 뜸 -->
				</td>
			</tr>
			<!-- 로그인 사용자 아이디 -->
			<%
				//String memberId = session.getAttribute("loginMemberId"); //null나옴
				String memberId = "test";
			%>
			<tr>
				<th>memberId</th>
				<td>
					<input type="text" name="memberId" readonly="readonly" value="<%=memberId%>">
				</td>
			</tr>
			<!-- file 받기 -->
			<tr>
				<th>boardFile</th><!-- 입력폼이 하나니까 boardfile의 vo를 또 만들어야 함. -->
				<td><!-- multipartformdata로 받아야돼서 분해 못함. 분해하는 메소드가 있다. -->
					<input type="file" name="boardFile" required="required">
					<!--  자바스크립트를 이용하면 '하나 입력할 시 하나의 폼이 더 생기도록' 할 수 있음. 하나의 폼에서 여러개 고르도록 하면 가독성이 안좋음 -->
				</td>
			</tr>
		</table>
		<button type="submit">자료업로드</button> <!-- 대표 자료 하나만 업로드 -->
	</form>
</body>
</html>