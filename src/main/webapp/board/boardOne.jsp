<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>

<%
	// 한글 처리
	request.setCharacterEncoding("utf-8");		

	// boardList.jsp로 부터 받아온 board_no 저장.
	Board board = new Board();
	board.boardNo = Integer.parseInt(request.getParameter("board_no"));

	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");

	// 2-1 board 정보 불러오기
	
	// board_no에 맞는 글 정보 가져오기
	String sqlSelectBoard = "SELECT board_no, board_title, board_writer, board_content, createdate FROM board where board_no = ?";
	PreparedStatement stmtSelectBoard = conn.prepareStatement(sqlSelectBoard);
	
	// select문에 들어갈 값 세팅
	stmtSelectBoard.setInt(1, board.boardNo);
	
	ResultSet rsSelectBoard = stmtSelectBoard.executeQuery();

	if (rsSelectBoard.next())
	{
		board.boardTitle = rsSelectBoard.getString("board_title");
		board.boardWriter = rsSelectBoard.getString("board_writer");
		board.boardContent = rsSelectBoard.getString("board_content");
		board.createdate = rsSelectBoard.getString("createdate");
	}
	
	
	
	// 2-3 댓글 페이징
	final int ROW_PER_PAGE = 2; 	// 페이지당 노출시킬 행의 수를 상수로 설정
	int count = 0;					// board 테이블의 행의 수를 담을 변수
	int lastPage = 0;				// 마지막 페이지를 담을 변수
	
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
		
	// board 테이블의 행 개수 구하기
	String sqlCount = "SELECT COUNT(*) FROM comment where board_no = ?";
	PreparedStatement stmtCount = conn.prepareStatement(sqlCount);
	
	stmtCount.setInt(1, board.boardNo);
	
	ResultSet rsCount = stmtCount.executeQuery();
	
	if(rsCount.next()) {
		count = rsCount.getInt("COUNT(*)");
	}
	
	System.out.println("게시글 댓글의 수 : " + count);
	
	// 올림
	lastPage = (int)(Math.ceil((double)count / (double)ROW_PER_PAGE));
	
	// 2-2 comment 정보 불러오기
	// board_no의 댓글 가져오기
	String sqlSelectComment = "SELECT comment_no, comment_content, createdate FROM comment where board_no = ? order by comment_no asc limit ?,?";
	PreparedStatement stmtSelectComment = conn.prepareStatement(sqlSelectComment);
	
	// select문에 들어갈 값 세팅
	stmtSelectComment.setInt(1, board.boardNo);
	stmtSelectComment.setInt(2, (ROW_PER_PAGE) * (currentPage-1));
	stmtSelectComment.setInt(3, (ROW_PER_PAGE) );
	
	ResultSet rsSelectComment = stmtSelectComment.executeQuery();
	
	ArrayList<Comment> list = new ArrayList<Comment>();
	
	while(rsSelectComment.next()) { // ResultSet의 API를 모른다면 사용할 수 없는 반복문
		Comment comment = new Comment();
	
		comment.commentNo = rsSelectComment.getInt("comment_no");
		comment.commentContent = rsSelectComment.getString("comment_content");
		comment.createdate = rsSelectComment.getString("createdate");
		list.add(comment);
	}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>

<script type="text/javascript">
<%
	if(request.getParameter("msg") != null)
	{			
%>	
		alert("<%=request.getParameter("msg")%>");
<%	
	}
%>
</script>

<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

<style>
	.right {
		text-align : right;
		font-size : 20pt;
		font-weight : bold;
	}
	.commentLeft {
		text-align : left;
		font-size : 15pt;
		font-weight : bold;
	}
	.center {
		text-align : center;
		font-size : 20pt;
		font-weight : bold;
	}
	.commentCenter {
		text-align : center;
		font-size : 20pt;
		font-weight : bold;
		width : 100px;
	}
	.leftsize {
		width : 200px;
	}
	.comment {
		height : 100px;
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
	  min-height: 80vh;
	}
	.commentInput {
		text-align : center;
		width : 150px;
		height : 50px;
	}
	.commentDiv {
		font-size : 20pt;
		text-align : center;
		width : 150px;
		height : 100px;
		line-height : 100px;
	}
	.commentContent {
		height : 100px;
	}
	.commentContentInput {
	}
</style>
</head>
<body style="background-color : rgb(95,95,95)">

	<!-- 메뉴 파티션 jsp 구성-->
	<br>
	<div class="center">
		<!-- jsp:inclue에서는 절대주소를 requst.getContextPath()로 쓰지 않음 -->
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<br>
		
	<div class = "container">
		<table class = "table table-hover" style = "background-color : rgb(255,255,255)">
			<tr>
				<th class = "center table-dark leftsize">번호</th>
				<td class = "center"><%=board.boardNo%></td>
			</tr>
			
			<tr>
				<th class = "center table-dark">제목</th>
				<td class = "center"><%=board.boardTitle%></td>
			</tr>
			
			<tr>
				<th class = "center table-dark" style="line-height : 400px">내용</th>
				<td class = "center"><textarea rows ="10" cols ="50" readonly = "readonly"><%=board.boardContent%></textarea></td>
			</tr>
			
			<tr>
				<th class = "center table-dark">작성자</th>
				<td class = "center"><%=board.boardWriter%></td>
			</tr>
			
			<tr>
				<th class = "center table-dark">생성날짜</th>
				<td class = "center"><%=board.createdate%></td>
			</tr>	
			
			<tr>
				<th colspan = "2" class = "right table-dark">
					<div class="btn-group">
						<a type="button" class="btn btn-warning subButtonSize" href = "<%=request.getContextPath()%>/board/updateBoardForm.jsp?
							board_no=<%=board.boardNo%>
							&board_title=<%=board.boardTitle%>
							&board_content=<%=board.boardContent%>
							&board_writer=<%=board.boardWriter%>"><span class="subButtonFont">수정</span></a>
					
						<a type="button" class="btn btn-warning subButtonSize" href = "<%=request.getContextPath()%>/board/deleteBoardForm.jsp?
							board_no=<%=board.boardNo%>&"><span class="subButtonFont">삭제</span></a>
							
						&nbsp;
						&nbsp;
					</div>
				</th>
			<tr>	
		</table>
		
		<!-- 댓글 입력 폼 -->
		<div>			
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
				<input type = "hidden" name = "board_no" value = "<%=board.boardNo%>">
				
				<table class = "table table-hover" style = "background-color : rgb(255,255,255)">
				
					<tr>
						<th colspan="4" class = "center table-dark"><div class="center">댓글 작성</div></th>
					</tr>
					
					<tr>
						<th class = "center leftsize"><div class="commentContent" style="line-height : 200px">내용</div></th>
						<td colspan="3" class=""><div class="commentContentInput"><textarea rows="8" cols="140" name = "comment_content"></textarea></div>
					</tr>
					
					<tr>
						<th class = "center"><div class="">비밀번호</div></th>
						<td colspan="2"><div class=""><input type="password" name = "comment_pw"></div>
						<!-- submit 버튼 -->
						<td><button type="submit">댓글 입력</button></td>
					</tr>
					
					<tr>
						<th colspan="4" class = "center table-dark"><div class="center">댓글 목록</div></th>
					</tr>
					
					<!-- 댓글 출력 -->
					<%
					for(Comment comment : list) {
					%>
						<tr>
							<td class = "comment commentCenter"><div class="commentDiv"><%=comment.commentNo%></div></td>
							<td class = "comment commentLeft"><div class="commentContent"><%=comment.commentContent%></div></td>
							<td class = "comment commentCenter"><div class="commentDiv"><%=comment.createdate%></div></td>
							<td class = "comment commentCenter"><div class="commentDiv"><a type="button" class="btn btn-primary" href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?board_no=<%=board.boardNo%>&comment_no=<%=comment.commentNo%>">삭제</a></div></td>
						</tr>
					<%
					}
					%>
					
						<tr>
					<% 
						if(currentPage == 1) {
					%>		
							<td></td>
							
							<td>
								<div class="center">
									<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage+1%>&board_no=<%=board.boardNo%>"><span>다음</span></a></span>	
								</div>
							</td>
								
							<td></td>	
								
							<td>
								<div>
									<span class="right"><a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=lastPage%>&board_no=<%=board.boardNo%>"><span>마지막으로</span></a></span>
								</div>
							</td>
					<%
						}
						
						if(currentPage > 1 && currentPage < lastPage) {
					%>												
							<td>
								<div class="left">
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=1&board_no=<%=board.boardNo%>"><span  class="center">처음으로</span></a>
								</div>
							</td>
							
							<td colspan="2">
								<div class="center btn-group">
									<span>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage-1%>&board_no=<%=board.boardNo%>"><span class="center">이전</span></a>
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage+1%>&board_no=<%=board.boardNo%>"><span class="center">다음</span></a>
									</span>
								</div>
							</td>
							
							
							<td>
								<div class="right createdate">
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=lastPage%>&board_no=<%=board.boardNo%>"><span class="center">마지막으로</span></a>
								</div>
							</td>
					<%
						}
						
						if(currentPage == lastPage) {
					%>						
							<td>
								<div class="left no">
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=1&board_no=<%=board.boardNo%>"><span class="center">처음으로</span></a>
								</div>
							</td>
							
							<td>
								<div class="center">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage-1%>&board_no=<%=board.boardNo%>"><span class="center">이전</span></a>
								</div>
							</td>
							
							<td></td>
							<td></td>
					<%
						}
					%>
					<tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>