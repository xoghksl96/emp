<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
	// 1 요청 분석

	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
		
	// 2 요청 처리
	
	// 2-1 페이징
	final int ROW_PER_PAGE = 10; 	// 페이지당 노출시킬 행의 수를 상수로 설정
	int count = 0;			// employees 테이블의 행의 수를 담을 변수
	int lastPage = 0;		// 마지막 페이지를 담을 변수
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sqlCount = "SELECT COUNT(*) FROM employees";
	PreparedStatement stmtCount = conn.prepareStatement(sqlCount);
	ResultSet rsCount = stmtCount.executeQuery();
	
	if(rsCount.next()) {
		count = rsCount.getInt("COUNT(*)");
	}
	System.out.println("employees 행의 수 : " + count);
	
	lastPage = count / ROW_PER_PAGE;
	if(count % ROW_PER_PAGE != 0) {	// 나누어 떨어지고 남은 값까지 출력하기 위함
		lastPage = lastPage + 1;
	}
	
	// 2-2 한 페이지 당 출력할 emp목록
	String sqlSelect = "SELECT * FROM employees ORDER BY emp_no ASC LIMIT ?,?";
	PreparedStatement stmtSelect = conn.prepareStatement(sqlSelect);
	
	stmtSelect.setInt(1, ROW_PER_PAGE*(currentPage-1));
	stmtSelect.setInt(2, ROW_PER_PAGE);
	
	ResultSet rsSelect = stmtSelect.executeQuery();
	
	ArrayList<Employees> list = new ArrayList<Employees>();
	while(rsSelect.next()) { // ResultSet의 API를 모른다면 사용할 수 없는 반복문
		Employees emp = new Employees();
		emp.empNo = rsSelect.getInt("emp_no");
		emp.birthDate = rsSelect.getString("birth_date");
		emp.firstName = rsSelect.getString("first_name");
		emp.lastName = rsSelect.getString("last_name");
		emp.gender = rsSelect.getString("gender");
		emp.hireDate = rsSelect.getString("hire_date");
		list.add(emp);
	}
%>
<!DOCTYPE html>
<html>
<head>

<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<Style>
	.center {
		text-align : center;
		font-size : 20pt;
		font-weight : bold;
	}
	.left {
		text-align : left;
		font-size : 20pt;
		font-weight : bold;
	}
	.right {
		text-align : right;
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
</Style>
<meta charset="UTF-8">
<title>사원 관리</title>
</head>
<body style="background-color : rgb(95,95,95)">


	<br>
	<!-- 메뉴 파티션 jsp 구성-->
	<div class="center">
		<!-- jsp:inclue에서는 절대주소를 requst.getContextPath()로 쓰지 않음 -->
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<br>


	<div class = "container">		
		<table class = "table table-hover" style = "background-color : rgb(255,255,255)">	
			<thead>					
				<tr class="table-dark">
					<th colspan = "8" class = "center"><span class="sub">&nbsp;Employees Table&nbsp;</span></th>
				</tr>
										
				<tr class="table-dark">
					<th class = "center">사원 번호</th>
					<th class = "center">사원 생일</th>
					<th class = "center">First_Name</th>
					<th class = "center">Last_Name</th>
					<th class = "center">성별</th>
					<th class = "center">입사일</th>
					<th class = "center">수정</th>
					<th class = "center">삭제</th>
				</tr>
			</thead>
			
			<tbody>
			
			<%
			for(Employees emp : list) {
			%>
				<tr>
					<td class = "center"><%=emp.empNo%></td>
					<td class = "center"><%=emp.birthDate%></td>
					<td class = "center"><%=emp.firstName%></td>
					<td class = "center"><%=emp.lastName%></td>
					<td class = "center"><%=emp.gender%></td>
					<td class = "center"><%=emp.hireDate%></td>
					<td class = "center"><a type="button" class="btn btn-warning subButtonSize" href = "<%=request.getContextPath()%>/emp/updateEmpForm.jsp?emp_no=<%=emp.empNo%>"><span class="subButtonFont">수정</span></a></td>
					<td class = "center"><a type="button" class="btn btn-danger subButtonSize" href = "<%=request.getContextPath()%>/emp/deleteEmp.jsp?emp_no=<%=emp.empNo%>"><span class="subButtonFont">삭제</span></a></td>
				</tr>
			<%
			}
			%>
			
				<tr>
					<td colspan = "8" class = "center"><a type="button" class="btn btn-dark buttonSize" href = "<%=request.getContextPath()%>/department/insertDepartmentsForm.jsp"><span class="buttonFont">사원 추가</span></a></td>
				</tr>
				
				<tr>
				<% 
					if(currentPage == 1) {
				%>
						<td colspan="3"></td>
						<td colspan="1" class="center"><a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>"><span class="center">다음</span></a></td>
						<td colspan="4"class="right"><a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>"><span class="center">마지막으로</span></a></td>
				<%
					}
					
					if(currentPage > 1 && currentPage < lastPage) {
				%>
						<td class="left"><a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1"><span class="center">처음으로</span></a></td>
						<td colspan = "6" class="center">
							<div class="center btn-group btn-group-lg">
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>"><span class="center">이전</span></a>
							&nbsp;
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>"><span class="center">다음</span></a>
							</div>
						</td>
							
						<td class="right"><a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>"><span class="center">마지막으로</span></a></td>
				<%
					}
					
					if(currentPage == lastPage) {
				%>
						<td colspan="1" class="left"><a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1"><span class="center">처음으로</span></a></td>
						<td colspan="5" class="center"><a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>"><span class="center">이전</span></a></td>
						<td colspan="2"></td>
				<%
					}
				%>
				<tr>				
			</tbody>
					
		</table>
	</div>
</body>
</html>