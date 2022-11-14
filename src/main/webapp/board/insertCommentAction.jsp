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
	
	Board board = new Board();
	board.boardNo = Integer.parseInt(request.getParameter("board_no"));
	
	// 안전장치 boardOneForm.jsp로부터 null 또는 공백 값이 넘어왔을 경우 강제로 boardOneForm.jsp 이동
	if(request.getParameter("comment_content") == null || request.getParameter("comment_pw") == null || 
		request.getParameter("comment_content") == "" || request.getParameter("comment_pw") == "") {
		
		String msg = URLEncoder.encode("댓글에 작성에 필요한 정보를 모두 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg="+msg+"&board_no="+board.boardNo);
		return;
	}
	
	// boardOne으로부터 받아온 값 변수에 저장
	Comment comment = new Comment();
	comment.commentContent = request.getParameter("comment_content");
	comment.commentPw = request.getParameter("comment_pw");
	
	
	// 2. 요청 처리
	// 연결
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("부서 추가 드라이브 로딩 성공");
		
	// 접속	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)
	
	// Insert
	String sqlInsert = "INSERT INTO comment (board_no, comment_pw, comment_content, createdate) Values(?, ?, ?, curdate())";
	PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
	stmtInsert = conn.prepareStatement(sqlInsert);
	
	// sql에 들어갈 값 세팅
	stmtInsert.setInt(1, board.boardNo);
	stmtInsert.setString(2, comment.commentPw);
	stmtInsert.setString(3, comment.commentContent);
		
	// 실행 및 디버깅 변수 선언
	int row = stmtInsert.executeUpdate();
	
	// 디버깅
	if (row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	
	// 3. 결과 출력
	// 결과를 보여주는 boardOne.jsp로
	System.out.println("=======삽입=======");
	System.out.println("댓글 비밀번호 : " + comment.commentPw);
	System.out.println("내용 : " + comment.commentContent);
	System.out.println("==================");
	
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?board_no="+board.boardNo);
%>