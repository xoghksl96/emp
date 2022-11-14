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
	
	// boardOne.jsp로부터 값을 전달받아온다. 
	Board board = new Board();
	board.boardNo = Integer.parseInt(request.getParameter("board_no"));
	board.boardTitle = request.getParameter("board_title");
	board.boardContent = request.getParameter("board_content");
	board.boardWriter = request.getParameter("board_writer");	
	
	
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

<title>게시글 수정</title>
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
		<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">
			<table class = "table table-hover" style = "background-color : rgb(255,255,255)">
				<tr>
					<th colspan="2"  class = "center table-dark">게시글 수정</th>
				</tr>
				
				<tr>
					<th class = "center table-dark">게시글 번호</th>
					<td class = "center"><input type ="number"  class = "center" style ="background-color : pink" name = "board_no" value = "<%=board.boardNo%>" readonly="readonly"></td>
				</tr>
				
				<tr>
					<th class = "center table-dark">제목</th>
					<td class = "center"><input type ="text" class = "center" name = "board_title" value = "<%=board.boardTitle%>"></td>
				</tr>
				
				<tr>
					<th class = "center table-dark">내용</th>
					<td class = "center"><textarea name = "board_content" rows ="10" cols ="50"><%=board.boardContent%></textarea></td>
				</tr>
				
				<tr>
					<th class = "center table-dark">작성자</th>
					<td class = "center"><input type ="text" class = "center" name = "board_writer" value = "<%=board.boardWriter%>"></td>
				</tr>
				
				<tr>
					<th class = "center table-dark">비밀번호</th>
					<td class = "center"><input type ="password" class = "center" name = "board_pw" value = ""></td>
				</tr>	
				
				<tr>
					<td colspan="2"  class = "center table-dark"><button type="submit" class="btn btn-warning subButtonSize"><span class="subButtonFont">수정</span></button></td>
				<tr>	
			</table>
		</form>
	</div>
</body>
</html>