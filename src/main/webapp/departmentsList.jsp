<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>

<%
	//(1) 연결

	// mariadb 드라이버 로딩(mairadb와 관련된 API를 사용할 수 있도록)
	// 단, 기본라이브러리가 아님 => 별도의 외부 라이브러리 다운로드가 필요함
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("수배명단 수정 드라이브 로딩 성공");
	
	// (2) 접속
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	// 주소 => jdbc:mariadb://localhost:3306 => jdbc:mariadb:// : (localhost | 127.0.0.1) : TCP_PORT
	// 접속이 안될 시, 오류메세지를 잘 확인해야함
	
	// 접속한 DB에 쿼리를 만들 때 사용하는 메서드
	PreparedStatement stmt = conn.prepareStatement("SELECT dept_no, dept_name from departments");
	
	// 쿼리를 실행하는 메서드
	ResultSet rs = stmt.executeQuery(); // ResultSet : 배열같은 형태
	
	
	
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
	.sub {
		font-size : 30pt;
		color : white;
	}
</Style>
<title>Departments</title>
</head>
<body>

	<br>

	<div class = "container">		
		<table class = "table table-striped table-hover">	
			<thead>	
				<tr>
					<th colspan = "4" class = "center "><span class="title">&nbsp;Employees&nbsp;</span></th>
				</tr>
				
				<tr class="table-dark">
					<th colspan = "4" class = "center"><span class="sub">&nbsp;Departments Table&nbsp;</span></th>
				</tr>
										
				<tr class="table-dark">
					<th class = "center">부서 번호</th>
					<th class = "center">부서 이름</th>
					<th class = "center">수정</th>
					<th class = "center">삭제</th>
				</tr>
			</thead>
			
			<tbody>
			<%
				while(rs.next()) {	
			%>
					<tr>
						<td class = "center"><%=rs.getString("dept_no")%></td>
						<td class = "center"><%=rs.getString("dept_name")%></td>
						<td class = "center"><a type="button" class="btn btn-warning" href = "<%=request.getContextPath()%>/updateDepartmentsForm.jsp?dept_no=<%=rs.getString("dept_no")%>">수정</a></td>
						<td class = "center"><a type="button" class="btn btn-danger" href = "<%=request.getContextPath()%>/deleteDepartments.jsp?dept_no=<%=rs.getString("dept_no")%>">삭제</a></td>
					</tr>
			<%
				}
			%>
				<tr>
						<td colspan = "4" class = "center"><a type="button" class="btn btn-dark" href = "<%=request.getContextPath()%>/insertDepartmentsForm.jsp">부서 추가</a></td>
				</tr>
				
			</tbody>
					
		</table>
	</div>
</body>
</html>