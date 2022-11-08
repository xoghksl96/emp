<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%
	//한글 처리
	request.setCharacterEncoding("utf-8");

	//1. 요청 분석
	Department dept = new Department();
	dept.deptNo = request.getParameter("dept_no");
	dept.deptName = null;
	
	// 연결
	// mariadb 드라이버 로딩(mairadb와 관련된 API를 사용할 수 있도록)
	// 단, 기본라이브러리가 아님 => 별도의 외부 라이브러리 다운로드가 필요함
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	
	// 접속	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	
	// 접속한 DB에 쿼리를 만들 때 사용하는 메서드
	String sql = "SELECT dept_name FROM departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// sql문에 들어갈 값 세팅
	stmt.setString(1,dept.deptNo);
	
	// 쿼리를 실행하는 메서드
	ResultSet rs = stmt.executeQuery(); // 결과물은 0행 또는 1행
	
	if(rs.next()) {
		dept.deptName = rs.getString("dept_name");
	}
	
	System.out.println("수정할 데이터 : " + dept.deptNo + " " + dept.deptName);
%>
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
<title>부서 수정</title>
</head>
<body style="background-color : rgb(95,95,95)">
	<div class = "container">
		
		<form action="<%=request.getContextPath()%>/department/updateDepartmentsAction.jsp" method="post">
			<table class = "wrapper table">
			
				<tr class="table-dark">
					<td colspan="2"><div class="title">부서 수정</div></td>
				</tr>
				
				<tr>
					<th class="align-middle">부서 번호</th>
					<td><input type="text" style = "background-color : pink" name="dept_no" value="<%=dept.deptNo%>" readonly = "readonly"></td>
				</tr>
				
				<tr>
					<th class="align-middle">부서 이름</th>
					<td><input type="text" name="dept_name" value="<%=dept.deptName%>"></td>
				</tr>
							
				<tr class="table-dark">
					<th colspan="2"><button type = "submit" class="btn btn-warning buttonSize"><span class="buttonFont">수정 완료</span></button></th>
				</tr>
				
			</table>
			
			
		</form> 
	</div>
</body>
</html>