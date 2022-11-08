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
		width : 700px; 
		height : 70px;
		text-align : center;
		font-size : 40pt;
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
	.wrapper {
	  display: grid;
	  place-items: center;
	  min-height: 100vh;
	}
	.container {
		background-color : rgb(255,255,255);
		text-align : center;
	}
</Style>
<title>부서 추가</title>
</head>
<body style="background-color : rgb(95,95,95)">

	<div class = "container border">		
		<form action="<%=request.getContextPath()%>/department/insertDepartmentsAction.jsp" method="post">
			<table class = "wrapper table">
			
				<tr class="table-dark">
					<td colspan="2"><div class="title">부서 추가</div></td>
				</tr>
				
				<tr>
					<th class="align-middle">부서 번호</th>
					<td><input type="text" name="dept_no" value=""></td>
				</tr>
				
				<tr>
					<th class="align-middle">부서 이름</th>
					<td><input type="text" name="dept_name" value=""></td>
				</tr>
				
				<tr class="table-dark">
					<th colspan="2"><button type = "submit" class="btn btn-dark buttonSize"><span class="buttonFont">추가 완료</span></button></th>
				</tr>
				
			</table>
		</form> 
	</div>
</body>
</html>