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
	
	// 안전장치 insertBoardForm으로부터 null 또는 공백 값이 넘어왔을 경우 강제로 insertBoardForm.jsp 이동
	if(request.getParameter("board_writer") == null || request.getParameter("board_pw") == null || request.getParameter("board_title") ==null || request.getParameter("board_content") == null ||
		request.getParameter("board_writer") == "" || request.getParameter("board_pw") == "" || request.getParameter("board_title") == "" || request.getParameter("board_content") == "") {
		
		String msg = URLEncoder.encode("모두 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	// Form으로 부터 받아온 값 변수에 저장
	Board board = new Board();
	board.boardWriter = request.getParameter("board_writer");
	board.boardPw = request.getParameter("board_pw");
	board.boardTitle = request.getParameter("board_title");
	board.boardContent = request.getParameter("board_content");
	
	// 2. 요청 처리
	// 연결
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("부서 추가 드라이브 로딩 성공");
		
	// 접속	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	
	// Insert
	String sqlInsert = "INSERT INTO board (board_writer, board_pw, board_title, board_content, createdate) Values(?, ?, ?, ?, curdate())";
	PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
	stmtInsert = conn.prepareStatement(sqlInsert);
	
	// sql에 들어갈 값 세팅
	stmtInsert.setString(1, board.boardWriter);
	stmtInsert.setString(2, board.boardPw);
	stmtInsert.setString(3, board.boardTitle);
	stmtInsert.setString(4, board.boardContent);
		
	// 실행 및 디버깅 변수 선언
	int row = stmtInsert.executeUpdate();
	
	// 디버깅
	if (row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	
	// 3. 결과 출력
	// 결과를 보여주는 boardList.jsp로
	System.out.println("=======삽입=======");
	System.out.println("작성자 : " + board.boardWriter + " 글 비밀번호 : " + board.boardPw);
	System.out.println("제목 : " + board.boardTitle);
	System.out.println("내용 : " + board.boardContent);
	System.out.println("==================");
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>