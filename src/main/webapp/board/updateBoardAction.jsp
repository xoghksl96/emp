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
	
	// updateBoardForm.jsp로부터 받아온 값 변수에 저장
	Board board = new Board();
	board.boardNo = Integer.parseInt(request.getParameter("board_no"));
	board.boardTitle = request.getParameter("board_title");
	board.boardContent = request.getParameter("board_content");
	board.boardWriter = request.getParameter("board_writer");
	
	// 안전장치 updateBoardForm.jsp로부터 받아온  board_pw가 null 또는 공백 값이 넘어왔을 경우 강제로 updateBoardForm.jsp 이동
	if(request.getParameter("board_pw") == null ||	request.getParameter("board_pw").equals("")) {			
		String msg = URLEncoder.encode("글 작성 시, 입력했던 비밀번호를 입력해주세요.","utf-8");
		
		// 전달할 값을 깨지지않게 utf-8로 인코딩
		board.boardTitle = URLEncoder.encode(board.boardTitle,"utf-8");
		board.boardContent = URLEncoder.encode(board.boardContent,"utf-8");
		board.boardWriter = URLEncoder.encode(board.boardWriter,"utf-8");
		
		// 디버깅
		System.out.println(msg);
		
		// 강제로 updateBoardForm 으로 이동 (msg, board_no, board_title, board_content, board_writer 값을 가지고)
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&board_no="+board.boardNo+"&board_title="+board.boardTitle+"&board_content="+board.boardContent+"&board_writer="+board.boardWriter);
		return;
	}
	
	board.boardPw = request.getParameter("board_pw");
	
	// 2. 요청 처리
	
	// 연결
	Class.forName("org.mariadb.jdbc.Driver"); // 매개변수 값으로(문자열) Maria DB 사용에 필요한 Class의 풀네임이 들어가야함
	System.out.println("부서 수정 드라이브 로딩 성공");
		
	// 접속		
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");	// 접속에 필요한 (주소, 계정, 비밀번호)	
	
	// 수정
	String sqlUpdate = "UPDATE board SET board_title = ?, board_content = ?, board_writer = ? WHERE board_no = ? and board_pw = ?;";
	PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate);
	
	// update문에 들어갈 값 세팅
	stmtUpdate.setString(1, board.boardTitle);
	stmtUpdate.setString(2, board.boardContent);
	stmtUpdate.setString(3, board.boardWriter);
	stmtUpdate.setInt(4, board.boardNo);
	stmtUpdate.setString(5, board.boardPw);

	// 실행 및 디버깅 변수 선언
	int row = stmtUpdate.executeUpdate();
	
	// 디버깅
	if (row == 1) {	// // DB에 존재하는 게시글의 board_no의 board_pw가 입력한 비밀번호와 일치하는 항목이 존재한다. -> 수정성공
		System.out.println("수정 성공");
	} else {	// DB에 존재하는 게시글의 board_no의 board_pw가 입력한 비밀번호와 일치하지 않는다. -> 수정실패
		System.out.println("수정 실패");
	
		String msg = URLEncoder.encode("잘못된 비밀번호를 입력하셨습니다.","utf-8");
		
		// 전달할 값을 깨지지않게 utf-8로 인코딩
		board.boardTitle = URLEncoder.encode(board.boardTitle,"utf-8");
		board.boardContent = URLEncoder.encode(board.boardContent,"utf-8");
		board.boardWriter = URLEncoder.encode(board.boardWriter,"utf-8");
		
		// 디버깅
		System.out.println(msg);
		
		// 강제로 updateBoardForm 으로 이동 (msg, board_no, board_title, board_content, board_writer 값을 가지고)
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&board_no="+board.boardNo+"&board_title="+board.boardTitle+"&board_content="+board.boardContent+"&board_writer="+board.boardWriter);
		return;
	}
	
	
	// 3. 결과 출력
	// 결과를 보여주는 boardList.jsp로
	System.out.println("=======수정=========");
	System.out.println("작성자 : " + board.boardWriter);
	System.out.println("제목 : " + board.boardTitle);
	System.out.println("내용 : " + board.boardContent);
	System.out.println("==================");
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>