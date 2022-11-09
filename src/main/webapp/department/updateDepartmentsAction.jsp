<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "java.net.URLEncoder" %>
<%

	//1. 요청 분석
	// 한글 처리
	request.setCharacterEncoding("utf-8");
	
	// Form으로 부터 받아온 값 변수에 저장
	Department dept = new Department();
	dept.deptNo = request.getParameter("dept_no");
	dept.deptName = request.getParameter("dept_name");
	
	// 안전장치 updateDepartmentsForm으로부터 null 또는 공백 값이 넘어왔을 경우 강제로 updateDepartmentsForm.jsp 이동
	if(dept.deptNo == null || dept.deptName == null ||
		dept.deptNo.equals("") || dept.deptName.equals("")) {
			
		response.sendRedirect(request.getContextPath()+"/department/updateDepartmentsForm.jsp");
		return;
	}
	
	
	// 2. 요청 처리
	
	// 연결
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("부서 수정 드라이브 로딩 성공");
		
	// 접속		
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	
	
	// 2-1 이미 존재하는 dept_name값이 입력되없을 경우 에러메세지 띄움.
	String sqlSelect = "select dept_name from departments where dept_name = ?"; // 동일한 dept_name이 있는지 확인
	PreparedStatement stmtSelect = conn.prepareStatement(sqlSelect);
	
	stmtSelect.setString(1,dept.deptName);
	
	ResultSet rs = stmtSelect.executeQuery(); 
	

	if(rs.next()) { // 결과물이 있다 -> 중복되는 dept_no가 이미 존재한다.
		String msg = URLEncoder.encode("부서이름 " + dept.deptName + " (은)는 사용할 수 없습니다.","utf-8");
		System.out.println(msg);
		response.sendRedirect(request.getContextPath()+"/department/updateDepartmentsForm.jsp?msg="+msg+"&dept_no="+dept.deptNo+"&dept_name="+dept.deptName);
		return;
	}
	
	
	// 2-2 dept_name이 중복되지 않을 경우 입력한 값으로 수정
	String sqlUpdate = "update departments set dept_name = ?  Where dept_no = ?";
	PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate);
	
	// sql에 들어갈 값 세팅
	stmtUpdate.setString(1, dept.deptName);
	stmtUpdate.setString(2, dept.deptNo);

	// 실행 및 디버깅 변수 선언
	int row = stmtUpdate.executeUpdate();
	
	// 디버깅
	if (row == 1) {
		System.out.println("수정 성공");
	} else {
		System.out.println("수정 실패");
	}
	
	
	// 3. 결과 출력
	// 결과를 보여주는 departments.jsp로
	System.out.println("수정된 데이터 : " + dept.deptNo + " " + dept.deptName);
	response.sendRedirect(request.getContextPath()+"/department/departmentsList.jsp");
%>