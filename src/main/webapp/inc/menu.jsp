<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 메뉴 파티션 페이지 사용할 코드 -->
<a type="button" class="btn btn-light menuButtonSize" href="<%=request.getContextPath()%>/index.jsp"><span class="subButtonFont">홈으로</span></a>
<a type="button" class="btn btn-light menuButtonSize" href="<%=request.getContextPath()%>/department/departmentsList.jsp"><span class="subButtonFont">부서관리</span></a>
<a type="button" class="btn btn-light menuButtonSize" href="<%=request.getContextPath()%>/emp/empList.jsp"><span class="subButtonFont">사원관리</span></a>
<a type="button" class="btn btn-light menuButtonSize" href="<%=request.getContextPath()%>/salary/salaryList.jsp"><span class="subButtonFont">연봉관리</span></a>
<a type="button" class="btn btn-light menuButtonSize" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp"><span class="subButtonFont">사원 소속</span></a>
<a type="button" class="btn btn-light menuButtonSize" href="<%=request.getContextPath()%>/board/boardList.jsp"><span class="subButtonFont">게시판 관리</span></a>