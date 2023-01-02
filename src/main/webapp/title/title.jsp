<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
	//1 요청 분석

	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String word = request.getParameter("word");
		
	// 2 요청 처리
	
	// 페이징에 필요한 변수 선언
	final int ROW_PER_PAGE = 10; 	// 페이지당 노출시킬 행의 수를 상수로 설정
	int count = 0;			// employees 테이블의 행의 수를 담을 변수
	int lastPage = 0;		// 마지막 페이지를 담을 변수
	
	// DB연결
	// 유지보수가 용이하도록 매개변수에 들어갈 값들을 따로 변수에 저장
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPassword = "java1234";
	
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);	//Connection conn = DriverManager.getConnection("주소:포트번호/employees", "사용자", "비밀번호");
	
	// sql문 담을 변수
	String sqlCount = null;
	String sqlSelect = null;
	
	// sql 핸들링 할 변수
	PreparedStatement stmtCount = null;
	PreparedStatement stmtSelect = null;
	
	// sql 실행 할 변수
	ResultSet rsCount = null;
	ResultSet rsSelect = null;
	
	// 2-1 word == null
	if(word == null) {
		// 2-1-1 word == null 일때 행 개수 세기 및 페이징 준비
		sqlCount = "SELECT COUNT(*) FROM title t INNER JOIN employees e ON t.emp_no = e.emp_no";
		stmtCount = conn.prepareStatement(sqlCount);
		rsCount = stmtCount.executeQuery();
		
		if(rsCount.next()) {
			count = rsCount.getInt("COUNT(*)");
		}

		lastPage = (int)(Math.ceil((double)count / (double)ROW_PER_PAGE));
		
		
		// 2-1-2 word == null 일때 출력(10개씩)
		sqlSelect = "SELECT t.emp_no, CONCAT(e.first_name, ' ', e.last_name), t.title, t.from_date, t.to_date FROM titles t INNER JOIN employees e ON t.emp_no = e.emp_no ORDER BY t.emp_no ASC LIMIT ?,?";
		stmtSelect = conn.prepareStatement(sqlSelect);
		stmtSelect.setInt(1, ROW_PER_PAGE*(currentPage-1));
		stmtSelect.setInt(2, ROW_PER_PAGE);
		
		rsSelect = stmtSelect.executeQuery();
		
		System.out.println("null 검색 JOIN(salaries,employees) 행의 수 : " + count);
	}
	
	// 2-2 word != null
	else {
		// 2-2-1 word != null 일때 행 개수 세기 및 페이징 준비
		sqlCount = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name like ? or e.last_name like ?";
		stmtCount = conn.prepareStatement(sqlCount);
		stmtCount.setString(1,"%"+word+"%");
		stmtCount.setString(2,"%"+word+"%");
		rsCount = stmtCount.executeQuery();
		
		if(rsCount.next()) {
			count = rsCount.getInt("COUNT(*)");
		}
		
		lastPage = (int)(Math.ceil((double)count / (double)ROW_PER_PAGE));
		
		
		// 2-2-2 word != null 일때 출력(10개씩)
		sqlSelect = "SELECT t.emp_no, CONCAT(e.first_name, ' ', e.last_name), t.title, t.from_date, t.to_date FROM titles t INNER JOIN employees e ON t.emp_no = e.emp_no WHERE CONCAT(e.first_name, ' ', e.last_name) like ? ORDER BY t.emp_no ASC LIMIT ?,?";
		stmtSelect = conn.prepareStatement(sqlSelect);
		stmtSelect.setString(1,"%"+word+"%");
		stmtSelect.setInt(2, ROW_PER_PAGE*(currentPage-1));
		stmtSelect.setInt(3, ROW_PER_PAGE);
		
		rsSelect = stmtSelect.executeQuery();
		
		System.out.println(word+" 검색 JOIN(salaries,employees) 행의 수 : " + count);
	}
	
	// HasMap<키,값>
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rsSelect.next()) { // ResultSet의 API를 모른다면 사용할 수 없는 반복문
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", rsSelect.getInt("s.emp_no"));
		map.put("name", rsSelect.getString("CONCAT(e.first_name, ' ', e.last_name)"));
		map.put("salary", rsSelect.getInt("s.salary"));
		map.put("fromDate", rsSelect.getString("s.from_date"));
		map.put("toDate", rsSelect.getString("s.to_date"));
			
		list.add(map);
	}
	
	
	// 서버가 점유하는 메모리를 다시 뺏어오기위함
	rsCount.close();
	rsSelect.close();
	stmtCount.close();
	stmtSelect.close();
	conn.close();
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
					<th colspan = "8" class = "center">
						<span class="sub">&nbsp;Salary Table&nbsp;</span>
						<span class="">
							<form action="<%=request.getContextPath()%>/salary/salaryList.jsp" method="post">
								<label for="word">사원 이름 검색</label>
								<%
								if (word == null) {
								%>
									<input type="text" Style = "text-align : center" name="word">
								<%
								} else {
								%>
									<input type="text" Style = "text-align : center" name="word" value="<%=word%>">
								<%
								}
								%>
								<button type="submit">검색</button>
							</form>
						</span>
					</th>
				</tr>
										
				<tr class="table-dark">
					<th class = "center">사원 번호</th>
					<th class = "center">이름</th>
					<th class = "center">연봉</th>
					<th class = "center">입사일</th>
					<th class = "center">퇴사일</th>
					<th class = "center">수정</th>
					<th class = "center">삭제</th>
				</tr>
			</thead>
			
			<tbody>
			
			<%
			for(HashMap<String, Object> map : list) {
			%>
				<tr>
					<td class = "center"><%=map.get("empNo")%></td>
					<td class = "center" style="width : 300px"><%=map.get("name")%></td>
					<td class = "center"><%=map.get("salary")%></td>
					<td class = "center"><%=map.get("fromDate")%></td>
					<td class = "center"><%=map.get("toDate")%></td>
					<td class = "center"><a type="button" class="btn btn-warning subButtonSize" href = "<%=request.getContextPath()%>/emp/updateEmpForm.jsp?emp_no=<%=map.get("empNo")%>"><span class="subButtonFont">수정</span></a></td>
					<td class = "center"><a type="button" class="btn btn-danger subButtonSize" href = "<%=request.getContextPath()%>/emp/deleteEmp.jsp?emp_no=<%=map.get("empNo")%>"><span class="subButtonFont">삭제</span></a></td>
				</tr>
			<%
			}
			%>
			
				<tr>
					<td colspan = "8" class = "center"><a type="button" class="btn btn-dark buttonSize" href = "<%=request.getContextPath()%>/department/insertDepartmentsForm.jsp"><span class="buttonFont">사원 추가</span></a></td>
				</tr>
			
				
				<tr>
				<% 
					if(currentPage != lastPage && currentPage == 1) {
						if(word == null) {
						%>
							<td colspan="3"></td>
							<td colspan="1" class="left"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>"><span class="center">다음</span></a></td>
							<td colspan="3"class="right"><a href="<%=request.getContextPath()%>//salary/salaryList.jsp?currentPage=<%=lastPage%>"><span class="center">마지막으로</span></a></td>
						<%
							
						} else {
						%>
							<td colspan="3"></td>
							<td colspan="1" class="left"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><span class="center">다음</span></a></td>
							<td colspan="3"class="right"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&word=<%=word%>"><span class="center">마지막으로</span></a></td>
						<%
						}
					}
					
					if(currentPage > 1 && currentPage < lastPage) {
						if(word == null) {
						%>
							<td class="left"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1"><span class="center">처음으로</span></a></td>
							<td colspan = "5" class="center">
								<div class="center btn-group btn-group-lg">
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>"><span class="center">이전</span></a>
								&nbsp;
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>"><span class="center">다음</span></a>
								</div>
							</td>
								
							<td class="right"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>"><span class="center">마지막으로</span></a></td>
						<%
							
						} else {
						%>
							<td class="left"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&word=<%=word%>"><span class="center">처음으로</span></a></td>
							<td colspan = "5" class="center">
								<div class="center btn-group btn-group-lg">
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><span class="center">이전</span></a>
								&nbsp;
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><span class="center">다음</span></a>
								</div>
							</td>
								
							<td class="right"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&word=<%=word%>"><span class="center">마지막으로</span></a></td>
						<%
						}
					}
					
					if(currentPage == lastPage && currentPage != 1) {
						if(word == null) {
						%>
							<td colspan="1" class="left"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1"><span class="center">처음으로</span></a></td>
							<td colspan="4" class="center"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>"><span class="center">이전</span></a></td>
							<td colspan="2"></td>
						<%
							
						} else {
						%>
							<td colspan="1" class="left"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&word=<%=word%>"><span class="center">처음으로</span></a></td>
							<td colspan="4" class="center"><a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><span class="center">이전</span></a></td>
							<td colspan="2"></td>						
						<%
						}
					}
					
					if (currentPage == lastPage && currentPage == 1) {
					%>
						<td colspan="7"></td>
					<%
					}					
					%>
				</tr>			
			</tbody>					
		</table>
	</div>
</body>
</html>