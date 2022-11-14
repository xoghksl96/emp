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
	
	// deleteCommentForm.jsp로부터 받아온 값 변수에 저장
	Comment comment = new Comment();
	comment.boardNo = Integer.parseInt(request.getParameter("board_no"));
	comment.commentNo = Integer.parseInt(request.getParameter("comment_no"));
	
	// 안전장치 deleteCommentForm.jsp로부터 받아온  comment_pw null 또는 공백 값이 넘어왔을 경우 강제로 deleteCommentForm.jsp 이동
	if(request.getParameter("comment_pw") == null || request.getParameter("comment_pw").equals("")) {			
		String msg = URLEncoder.encode("댓글 작성 시, 입력했던 비밀번호를 입력해주세요.","utf-8");
			
		// 디버깅
		System.out.println(msg);
		
		// 강제로 updateBoardForm 으로 이동 (msg, board_no, comment_no 값을 가지고)
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg="+msg+"&board_no="+comment.boardNo+"&comment_no="+comment.commentNo);
		return;
	}
	
	comment.commentPw = request.getParameter("comment_pw");
	
	// 2. 요청 처리
	
	// 연결
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("댓글 삭제 드라이브 로딩 성공");
		
	// 접속		
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)	
	
	// DB안에 board_no의 board_pw가 입력한 비밀번호와 일치하는 항목이 있는 지 확인	
	String sqlDelete = "delete from comment where board_no = ? and comment_no = ? and comment_pw = ?";	// 삭제
	PreparedStatement stmtDelete = conn.prepareStatement(sqlDelete);
	
	// delete sql문에 들어갈 값 세팅
	stmtDelete.setInt(1,comment.boardNo);
	stmtDelete.setInt(2,comment.commentNo);
	stmtDelete.setString(3,comment.commentPw);
	
	// 실행 및 디버깅 변수 선언
	int row = stmtDelete.executeUpdate();
	
	if (row == 1) {	// DB안의 게시글 번호에 맞는 댓글번호가 존재하고, 해당 댓글의 비밀번호와 입력한 비밀번호가 일치하는 항목이 있다 -> 삭제 성공
		System.out.println("삭제 성공");
	} else { // DB안의 게시글 번호에 맞는 댓글번호가 존재하고, 해당 댓글의 비밀번호와 입력한 비밀번호가 일치하는 항목이 없다 -> 삭제 실패
		System.out.println("삭제 실패");
	
		String msg = URLEncoder.encode("잘못된 비밀번호를 입력하셨습니다.","utf-8");
		
		// 디버깅
		System.out.println(msg);
		 
		// msg,board_no,comment_no를 가지고 deleteCommentForm.jsp로 이동
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg="+msg+"&board_no="+comment.boardNo+"&comment_no="+comment.commentNo);
		return;
	}
	
	
	// 3. 결과 출력
	
	// 결과를 보여주는 boardOne.jsp로
	System.out.println("=======삭제=========");
	System.out.println("댓글 번호 : " + comment.commentNo);
	System.out.println("==================");
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?board_no="+comment.boardNo);
%>