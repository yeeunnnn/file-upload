<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login</title>
</head>
<body>
	<%
		if(session.getAttribute("loginMemberId")==null){
	%>
	<form action="<%=request.getContextPath()%>/loginAction.jsp">
		<table border="1">
			<tr>
				<td colspan="2"><h4>로그인</h4></td>
			</tr>
			<tr>
				<td>ID</td>
				<td><input type="text" name="memberId"></td>
			</tr>
			<tr>
				<td>PW</td>
				<td><input type="password" name="memberPw"></td>
			</tr>
		</table>
		<button type="submit">로그인</button>
	</form>
		<%
			} else {
				String logInId = (String)session.getAttribute("loginMemberId");
		%>
			<table>
				<tr>
					<td><%=logInId%>님 반값습니다.</td>
				</tr>
			</table>
		<%
			}
		%>
</body>
</html>