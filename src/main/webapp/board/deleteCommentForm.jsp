<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	//한글 처리
	request.setCharacterEncoding("utf-8");
	
	// boardOne.jsp 로 부터 이동하면서 받아온 값 저장.
	Comment comment = new Comment();
	comment.boardNo = Integer.parseInt(request.getParameter("board_no"));
	comment.commentNo = Integer.parseInt(request.getParameter("comment_no"));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<script type="text/javascript">
<%
	if(request.getParameter("msg") != null)
	{			
%>	
		alert("<%=request.getParameter("msg")%>");
<%	
	}
%>
</script>

<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<style>
	input {
		width : 740px;
		height : 50px;
	}
	textarea {
		font-size : 20pt;
		font-weight : bold;
	}
	.right {
		text-align : right;
		font-size : 20pt;
		font-weight : bold;
	}
	.center {
		text-align : center;
		font-size : 20pt;
		font-weight : bold;
	}
	.sub {
		font-size : 40pt;
		color : white;
	}
	.buttonSize {
		width:350px; height:auto;
	}
	.buttonFont {
		font-size : 20pt;
		font-weight : bolder;
	}
	.subButtonSize {
		width:75px; height:auto;
	}
	.subButtonFont {
		font-size : 15pt;
		font-weight : bolder;
	}
	.menuButtonSize {
		width:150px; height:auto;
	}
	.wrapper {
	  display : flex;
	  justify-content: center;
	  align-items: center;
	  min-height: 100vh;
	}
</style>

<title>댓글 삭제</title>
</head>
<body style="background-color : rgb(95,95,95)">

	<!-- 메뉴 파티션 jsp 구성-->
	<br>
	<div class="center">
		<!-- jsp:inclue에서는 절대주소를 requst.getContextPath()로 쓰지 않음 -->
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<br>
	
	<div class = "container">
		<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post">
		
			<!-- 유저에게 보여주지 않아도 된다. -->
			<input hidden = "hidden" type ="number" name = "board_no" value = "<%=comment.boardNo%>">
			
			<table class = "table table-hover" style = "background-color : rgb(255,255,255)">
				<tr>
					<th colspan="2" class = "center table-dark">댓글 삭제</th>
				</tr>
				
				<tr>
					<th class = "center table-dark">댓글 번호</th>
					<td class = "center"><input class = "center" type ="number" style ="background-color : pink" name = "comment_no" value = "<%=comment.commentNo%>" readonly="readonly"></td>
				</tr>
				
				<tr>
					<th class = "center table-dark">비밀 번호</th>
					<td class = "center"><input class = "center" type ="password" name = "comment_pw" value = ""></td>
				</tr>	
				
				<tr>
					<td colspan="2" class = "center table-dark"><button type="submit" class="btn btn-warning subButtonSize"><span class="subButtonFont">삭제</span></button></td>
				<tr>	
			</table>
		</form>
	</div>
</body>
</html>