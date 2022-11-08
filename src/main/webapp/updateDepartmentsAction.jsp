<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
	// 한글 처리
	request.setCharacterEncoding("utf-8");

	// 안전장치 insertPirateAction.jsp가 실행되었을 경우 강제로 updatePirateForm으로 이동
	if(request.getParameter("dept_no") == null ||
		request.getParameter("dept_name") == null) {
		
		response.sendRedirect(request.getContextPath()+"/updateDepartmentsForm.jsp");
		return;
	}
	
	
	// 1. 요청 분석
	String deptNo = request.getParameter("dept_no");
	String deptName = request.getParameter("dept_name");
	
	// 요청 분석 디버깅	
	System.out.println("수정한 데이터 : " + deptNo + " " + deptName);
	
	
	// 2. 요청 처리
	// 연결
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("드라이브 로딩 성공");
		
	// 접속
		
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	String sql = "update departments set dept_name = ?  Where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);	// 쿼리문 작성
	
	// sql update문에 들어갈 값 세팅
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);

	// 실행 및 디버깅 변수 선언
	int row = stmt.executeUpdate();
	
	// 디버깅
	if (row == 1) {
		System.out.println("수정 성공");
	} else {
		System.out.println("수정 실패");
	}
	
	
	// 3. 결과 출력
	// 결과를 보여주는 departments.jsp로
	response.sendRedirect(request.getContextPath()+"/departmentsList.jsp");
%>