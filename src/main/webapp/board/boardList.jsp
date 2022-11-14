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
	final int ROW_PER_PAGE = 10; 	// 페이지당 노출시킬 행의 수를 상수로 설정
	int count = 0;					// board 테이블의 행의 수를 담을 변수
	int lastPage = 0;				// 마지막 페이지를 담을 변수
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// board 테이블의 행 개수 구하기
	String sqlCount = "SELECT COUNT(*) FROM board";
	PreparedStatement stmtCount = conn.prepareStatement(sqlCount);
	ResultSet rsCount = stmtCount.executeQuery();
	
	if(rsCount.next()) {
		count = rsCount.getInt("COUNT(*)");
	}
	
	System.out.println("board 행의 수 : " + count);
	
	// 올림
	lastPage = (int)(Math.ceil((double)count / (double)ROW_PER_PAGE));
	
	// 2-2 한 페이지 당 출력할 board 목록
	String sqlSelect = "SELECT board_no, board_title, board_writer, createdate FROM board ORDER BY board_no ASC LIMIT ?,?";
	PreparedStatement stmtSelect = conn.prepareStatement(sqlSelect);
	
	stmtSelect.setInt(1, ROW_PER_PAGE*(currentPage-1));
	stmtSelect.setInt(2, ROW_PER_PAGE);
	
	ResultSet rsSelect = stmtSelect.executeQuery();
	
	ArrayList<Board> list = new ArrayList<Board>();
	while(rsSelect.next()) { // ResultSet의 API를 모른다면 사용할 수 없는 반복문
		Board board = new Board();
		board.boardNo = rsSelect.getInt("board_no");
		board.boardTitle = rsSelect.getString("board_title");
		board.boardWriter = rsSelect.getString("board_writer");
		board.createdate = rsSelect.getString("createdate");
		list.add(board);
	}
%>
<!DOCTYPE html>
<html>
<head>

<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<Style>
	.title {
		width : 400px;
	}
	.content {
		width : 400px;
	}	
	.no {
		width : 150px;
	}
	.createdate {
		width : 150px;
	}
	.center {
		text-align : center;
		font-size : 18pt;
		font-weight : bold;
	}
	.left {
		text-align : left;
		font-size : 18pt;
		font-weight : bold;
	}
	.right {
		text-align : right;
		font-size : 18pt;
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
<title>게시판 관리</title>
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
					<th colspan = "4" class = "center"><span class="sub">&nbsp;자유 게시판&nbsp;</span></th>
				</tr>
										
				<tr class="table-dark">
					<th class = "center no"></th>
					<th class = "center"><div class="title">제목</div></th>
					<th class = "center"><div class="title">작성자</div></th>
					<th class = "center createdate"><div class="createdate">작성일</div></th>
				</tr>
			</thead>
			
			<tbody>
			
			<%
			for(Board board : list) {
			%>
				<tr>
					<td class = "center table-dark"><div class="no"><%=board.boardNo%></div></td>
					<td class = "center"><div class="title"><a href="<%=request.getContextPath()%>/board/boardOne.jsp?board_no=<%=board.boardNo%>"><%=board.boardTitle%></a></div></td>
					<td class = "center"><div class="content"><%=board.boardWriter%></div></td>
					<td class = "center"><div class="createdate"><%=board.createdate%></div></td>
				</tr>
			<%
			}
			%>
			
				<tr>
					<td colspan = "4" class = "center"><a type="button" class="btn btn-dark buttonSize" href = "<%=request.getContextPath()%>/board/insertBoardForm.jsp"><span class="buttonFont">글 쓰기</span></a></td>
				</tr>
				
				<tr>
				<% 
					if(currentPage == 1) {
				%>
						
						<td></td>
						<td></td>
						
						<td>
							<div class="left">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>"><span class="center">다음</span></a>
							</div>
						</td>
						
						<td>
							<div class="right createdate">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>"><span class="center">마지막으로</span></a>
							</div>
						</td>
				<%
					}
					
					if(currentPage > 1 && currentPage < lastPage) {
				%>												
						<td>
							<div class="left no">
								<a class="left" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1"><span class="center">처음으로</span></a>
							</div>
						</td>
						
						<td colspan="2">
							<div class="center">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>"><span class="center">이전</span></a>
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>"><span class="center">다음</span></a>
							</div>
						</td>
						
						
						<td>
							<div class="right createdate">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>"><span class="center">마지막으로</span></a>
							</div>
						</td>						
				<%
					}
					
					if(currentPage == lastPage) {
				%>						
						<td>
							<div class="left no">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1"><span class="center">처음으로</span></a>
							</div>
						</td>
						
						<td>
							<div class="right">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>"><span class="center">이전</span></a>
							</div>
						</td>
						
						<td></td>
						<td></td>
				<%
					}
				%>
				<tr>				
			</tbody>					
		</table>
	</div>
</body>
</html>