<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//한글 처리
	request.setCharacterEncoding("utf-8");

	//1. 요청 분석
	String deptNo = request.getParameter("dept_no");

	//(1) 연결
	// mariadb 드라이버 로딩(mairadb와 관련된 API를 사용할 수 있도록)
	// 단, 기본라이브러리가 아님 => 별도의 외부 라이브러리 다운로드가 필요함
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("지명수배 명단 드라이브 로딩 성공");
	
	// (2) 접속
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	// 주소 => jdbc:mariadb://localhost:3306 => jdbc:mariadb:// : (localhost | 127.0.0.1) : TCP_PORT
	// 접속이 안될 시, 오류메세지를 잘 확인해야함
	
	// 접속한 DB에 쿼리를 만들 때 사용하는 메서드
	PreparedStatement stmt = conn.prepareStatement("SELECT dept_name FROM departments where dept_no = ?");
	
	stmt.setString(1,deptNo);
	// 쿼리를 실행하는 메서드
	ResultSet rs = stmt.executeQuery(); // 결과물은 0행 또는 1행
	
	String deptName = null;
	
	if(rs.next()) {
		deptName = rs.getString("dept_name");
	}
	
	System.out.println("수정할 데이터 : " + deptNo + " " + deptName);
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
	th {
		background-color : gray;
		font-size : 15pt;
	}
	td {
		text-align : center;
	}
	
	.radioButtnSize {
		width:20px; height:20px;
	}
	.radioFont {
		font-size : 20pt;
	}
	.title {
		border : 10px solid black;
		background-color : yellow;
		font-size : 60pt;
		color : black;
	}
	.center {
		text-align : center;
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
<title>부서 UPDATE</title>
</head>
<body>
	<div class = "container" Style="text-align : center">
		
		<form action="<%=request.getContextPath()%>/updateDepartmentsAction.jsp" method="post">
			<table class = "wrapper table table-striped ">
				<tr>
					<td colspan="2"><div class="title">부서 UPDATE</div></td>
				</tr>
				
				<tr>
					<th class="align-middle">부서 번호</th>
					<td><input type="text" class = "center" style = "background-color : pink" name="dept_no" value="<%=deptNo%>" readonly = "readonly"></td>
				</tr>
				
				<tr>
					<th class="align-middle">부서 이름	</th>
					<td><input type="text" class = "center" name="dept_name" value="<%=deptName%>"></td>
				</tr>
				
				
				<tr>
					<th colspan="2"><button type = "submit" class="btn btn-dark buttonSize"><span class="buttonFont">부서정보 수정</span></button></th>
				</tr>
			</table>
			
			
		</form> 
	</div>
</body>
</html>