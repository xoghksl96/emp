<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>

<%

	// 1. 요청 분석 (Controller)
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");

	
	// 2. 업무 처리 (Model)

	// mariadb 드라이버 로딩(mairadb와 관련된 API를 사용할 수 있도록)
	// 단, 기본라이브러리가 아님 => 별도의 외부 라이브러리 다운로드가 필요함
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("departments 드라이브 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	PreparedStatement stmt = null;
	
	// 2-1 word == null
	if(word == null) {
		String sql = "select dept_no, dept_name from departments order by dept_no desc";
		stmt = conn.prepareStatement(sql);	 // 접속한 DB에 쿼리를 만들 때 사용하는 메서드
		
	}
	// 2-2 word == ''
	else {
		String sql = "select dept_no, dept_name from departments where dept_name like ? order by dept_no desc";
		stmt = conn.prepareStatement(sql);	 // 접속한 DB에 쿼리를 만들 때 사용하는 메서드
		stmt.setString(1,"%"+word+"%");
	}
	
	// 쿼리를 실행하는 메서드
	// 모델데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아님.
	// ResultSet rs라는 모델자료구조를 좀 더 일반적이고 독립적인 자료구조 변경이 필요.
	ResultSet rs = stmt.executeQuery(); 
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()) { // ResultSet의 API를 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("dept_no");
		d.deptName = rs.getString("dept_name");
		list.add(d);
	}
	
	// 3. 출력 (View)
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
</Style>
<title>Departments</title>
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
					<th colspan = "4" class = "center">
						<span class="sub">&nbsp;Departments Table&nbsp;</span>
						<span class=""></span>
						
					</th>
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
				// 자바문법에서 제공하는 foreach문을 사용하여 출력
				for(Department d : list) {	
			%>
					<tr>
						<td class = "center"><%=d.deptNo%></td>
						<td class = "center"><%=d.deptName%></td>
						<td class = "center"><a type="button" class="btn btn-warning subButtonSize" href = "<%=request.getContextPath()%>/department/updateDepartmentsForm.jsp?dept_no=<%=d.deptNo%>"><span class="subButtonFont">수정</span></a></td>
						<td class = "center"><a type="button" class="btn btn-danger subButtonSize" href = "<%=request.getContextPath()%>/department/deleteDepartments.jsp?dept_no=<%=d.deptNo%>"><span class="subButtonFont">삭제</span></a></td>
					</tr>
			<%
				}
			%>
				<tr>
					<td colspan = "4" class = "center"><a type="button" class="btn btn-dark buttonSize" href = "<%=request.getContextPath()%>/department/insertDepartmentsForm.jsp"><span class="buttonFont">부서 추가</span></a></td>
				</tr>			
			</tbody>					
		</table>
		
		<form action="<%=request.getContextPath()%>/department/departmentsList.jsp" method="post">
			<label for="word">부서이름 검색</label>
			<input type="text" name="word">
			<button type="submit">검색</button>
		</form>			
	</div>
</body>
</html>