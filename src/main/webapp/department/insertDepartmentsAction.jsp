<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.net.URLEncoder" %>

<%
	// 1. 요청 분석
	// 한글 처리
	request.setCharacterEncoding("utf-8");
	
	// Form으로 부터 받아온 값 변수에 저장
	Department dept = new Department();
	dept.deptNo = request.getParameter("dept_no");
	dept.deptName = request.getParameter("dept_name");
	
	// 안전장치 insertDepartmentsForm으로부터 null 또는 공백 값이 넘어왔을 경우 강제로 insertDepartmentsForm.jsp 이동
	if(dept.deptNo == null || dept.deptName == null ||
		dept.deptNo.equals("") || dept.deptName.equals("")) {
		
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/department/updateDepartmentsForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청 처리
	// 연결
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("부서 추가 드라이브 로딩 성공");
		
	// 접속	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	

	// 2-1 이미 존재하는 key(dept_no)값이 입력되었을 경우 에러메세지 띄움.
	String sqlSelect = "select dept_no,dept_name from departments where dept_no = ? or dept_name = ?"; // 동일한 key(dept_no)가 있는지 확인
	PreparedStatement stmtSelect = conn.prepareStatement(sqlSelect);
	
	stmtSelect.setString(1,dept.deptNo);
	stmtSelect.setString(2,dept.deptName);
	
	ResultSet rs = stmtSelect.executeQuery(); 
	

	if(rs.next()) { // 결과물이 있다 -> 중복되는 dept_no가 이미 존재한다.
		String msg = URLEncoder.encode("부서번호 또는 부서이름이 중복되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/department/insertDepartmentsForm.jsp?msg="+msg);
		return;
	}
	
	// 2-2 중복되지 않은 dept_no, dept_name 경우 Insert
	String sqlInsert = "INSERT INTO departments (dept_no, dept_name) Values(?, ?)";
	PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
	stmtInsert = conn.prepareStatement(sqlInsert);
	
	// sql에 들어갈 값 세팅
	stmtInsert.setString(1, dept.deptNo);
	stmtInsert.setString(2, dept.deptName);
	
	// 실행 및 디버깅 변수 선언
	int row = stmtInsert.executeUpdate();
	
	// 디버깅
	if (row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	
	// 3. 결과 출력
	// 결과를 보여주는 departmentsList.jsp로
	System.out.println("추가된 부서 정보 : " + dept.deptNo + " " + dept.deptName);
	response.sendRedirect(request.getContextPath()+"/department/departmentsList.jsp");
%>