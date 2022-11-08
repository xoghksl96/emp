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
	th {
		background-color : gray;
		font-size : 15pt;
	}
	td {
		text-align : center;
		font-size : 15pt;
	}
	input {
		width : 300px; height : 30px;
	}
	.title {
		border : 10px solid black;
		background-color : yellow;
		font-size : 60pt;
		color : black;
	}
	
	.center {
		text-align : center;
		font-size : 20pt;
	}
	.buttonSize {
		width:auto; height:auto;
	}
	.buttonFont {
		font-size : 50pt;
	}
	.wrapper {
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  min-height: 100vh;
}
</Style>
<title>부서 추가</title>
</head>
<body>
	<div class = "container" Style="text-align : center">
		
		<form action="<%=request.getContextPath()%>/insertDepartmentsAction.jsp" method="post">
			<table class = "table wrapper">
			
				<tr>
					<td colspan="2"><div class="title">부서 추가</div></td>
				</tr>
				
				
				<tr>
					<th class="align-middle">부서 번호</th>
					<td><input type="text" class = "center" name="dept_no" value=""></td>
				</tr>
				
				<tr>
					<th class="align-middle">부서 이름</th>
					<td><input type="text" class = "center" name="dept_name" value=""></td>
				</tr>
				
				<tr>
					<th colspan="2"><button type = "submit" class="btn btn-dark buttonSize"><span class="buttonFont">부서 입력</span></button></th>
				</tr>
			</table>
		</form> 
	</div>
</body>
</html>