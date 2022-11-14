<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<Style>
	.title {
		text-align : center;
		font-size : 80pt;
		color : rgb(255,255,255);
	}
	.button {
		text-align : center;
		width : 500px ;
		height : 150px;
	}
	.buttonFont {
		text-align : center;
		font-size : 50pt;
		line-height : 125px;
	}
	.wrapper {
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  min-height: 80vh;
	}	
</Style>

<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<title>인덱스</title>
</head>
<body style="background-color : rgb(95,95,95)">

	<table class="wrapper">
	
		<tr>
			<td>
				<div><h1 class="title">INDEX</h1></div>
			</td>
		</tr>
		
		<tr>
			<td>
				<div>
					<div>
						<a class="btn btn-dark button" href="<%=request.getContextPath()%>/department/departmentsList.jsp"><span class="buttonFont">부서 관리</span></a>
						&nbsp;
						<a class="btn btn-dark button" href="<%=request.getContextPath()%>/emp/empList.jsp"><span class="buttonFont">사원 관리</span></a>
						&nbsp;
						<a class="btn btn-dark button" href="<%=request.getContextPath()%>/board/boardList.jsp"><span class="buttonFont">게시판 관리</span></a>
					</div>
				</div>
			</td>
		</tr>
		
	</table>
	
</body>
</html>