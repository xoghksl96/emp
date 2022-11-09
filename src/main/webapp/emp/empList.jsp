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
	int rowPerPage = 10; 	// 페이지당 노출시킬 행의 수
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
	
	lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {	// 나누어 떨어지고 남은 값까지 출력하기 위함
		lastPage = lastPage + 1;
	}
	
	// 2-2 한 페이지 당 출력할 emp목록
	String sqlSelect = "SELECT * FROM employees ORDER BY emp_no ASC LIMIT ?,?";
	PreparedStatement stmtSelect = conn.prepareStatement(sqlSelect);
	
	stmtSelect.setInt(1, rowPerPage*(currentPage-1));
	stmtSelect.setInt(2, rowPerPage);
	
	ResultSet rsSelect = stmtSelect.executeQuery();
	
	ArrayList<Employees> list = new ArrayList<Employees>();
	while(rsSelect.next()) { // ResultSet의 API를 모른다면 사용할 수 없는 반복문
		Employees emp = new Employees();
		emp.emp_no = rsSelect.getInt("emp_no");
		emp.birth_date = rsSelect.getString("birth_date");
		emp.first_name = rsSelect.getString("first_name");
		emp.last_name = rsSelect.getString("last_name");
		emp.gender = rsSelect.getString("gender");
		emp.hire_date = rsSelect.getString("hire_date");
		list.add(emp);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 파티션 jsp 구성 -->
	<div>
		
	</div>
	
	<h1>사원 목록</h1>
	<!-- 부서별 사원목록 출력되도록 메뉴 -->
	
	<div>현재 페이지 : <%=currentPage%></div>
	
	<!-- 페이징 코드 -->
	<div>
	<% 
		if(currentPage != 1) {
	%>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음으로</a>
	<%
		}
		
		if(currentPage > 1) {
	%>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
		
		if(currentPage < lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
	<%
		}
		
		if(currentPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막으로</a>
	<%
		}
	%>
	</div>
	
	<!-- 실제 출력문 -->
	<div>
		<table>
			<tr>
				<td class = "center">사원 번호</td>
				<td class = "center">사원 생일</td>
				<td class = "center">First_Name</td>
				<td class = "center">Last_Name</td>
				<td class = "center">성별</td>
				<td class = "center">입사일</td>
				<td class = "center">수정</td>
				<td class = "center">삭제</td>
			</tr>
		
		<%
			for(Employees emp : list) {
		%>
				<tr>
					<td class = "center"><%=emp.emp_no%></td>
					<td class = "center"><%=emp.birth_date%></td>
					<td class = "center"><%=emp.first_name%></td>
					<td class = "center"><%=emp.last_name%></td>
					<td class = "center"><%=emp.gender%></td>
					<td class = "center"><%=emp.hire_date%></td>
					<td class = "center"><a type="button" class="btn btn-warning subButtonSize" href = "<%=request.getContextPath()%>/department/updateDepartmentsForm.jsp?dept_no=<%=emp.emp_no%>"><span class="subButtonFont">수정</span></a></td>
					<td class = "center"><a type="button" class="btn btn-danger subButtonSize" href = "<%=request.getContextPath()%>/department/deleteDepartments.jsp?dept_no=<%=emp.emp_no%>"><span class="subButtonFont">삭제</span></a></td>
				</tr>
		<%
			}
		%>
		</table>
	</div>
</body>
</html>