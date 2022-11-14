<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<Style>
	table {
		width : 600px;
		height : 300px;
	}
	tr {
		background-color : rgb(222,222,222)
	}
	th,td {
		text-align : center;
		font-size : 25pt;
	}
	input {
		width : 690px; 
		height : 70px;
		text-align : center;
		font-size : 40pt;
	}
	.center {
		text-align : center;
		font-size : 20pt;
		font-weight : bold;
	}
	.title {
		font-weight : bolder;
		font-size : 60pt;
	}
	.buttonSize {
		width:350px; height:auto;
	}
	.buttonFont {
		font-size : 40pt;
		font-weight : bolder;
	}
	.subButtonFont {
		font-size : 15pt;
		font-weight : bolder;
	}
	.menuButtonSize {
		width:150px; height:auto;
	}
	.wrapper {
	  display: grid;
	  place-items: center;
	  min-height: 80vh;
	}
	.container {
		background-color : rgb(255,255,255);
		text-align : center;
	}
</Style>
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
<title>부서 추가</title>
</head>
<body style="background-color : rgb(95,95,95)">
	<div class = "container-sm">
	
		<!-- 메뉴 파티션 jsp 구성-->
		<!-- jsp:inclue에서는 절대주소를 requst.getContextPath()로 쓰지 않음 -->
		<br>
		<div class="center"><jsp:include page="/inc/menu.jsp"></jsp:include></div>
		<br>
		
		<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
			<table class = "wrapper table">
				
				<tr class="table-dark">
					<td colspan="2"><div class="title">글 쓰기</div></td>
				</tr>
				
				<tr>
					<th class="align-middle">작성자</th>
					<td><input type="text" name="board_writer" value=""></td>
				</tr>
				
				<tr>
					<th class="align-middle">비밀번호</th>
					<td><input type="password" name="board_pw" value=""></td>
				</tr>
				
				<tr>
					<th class="align-middle">제목</th>
					<td><input type="text" name="board_title" value=""></td>
				</tr>
				
				<tr>
					<th class="align-middle">내용</th>
					<td><textarea name = "board_content" rows="5" cols="43"></textarea></td>
				</tr>
				
				<tr class="table-dark">
					<th colspan="2"><button type = "submit" class="btn btn-dark buttonSize"><span class="buttonFont">작성완료</span></button></th>
				</tr>
				
			</table>
		</form> 
	</div>
</body>
</html>