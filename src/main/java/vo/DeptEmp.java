package vo;

public class DeptEmp {
	// 테이블 컬럼과 일치하는 도메인 타입
	// 단점 JOIN 결과를 처리할 수 없다.
	//public int empNo;
	//public int deptNo;
	
	// 장점 : dept_emp 테이블의 한행 + JOIN 결과의 행도 처리 가능
	// 단점 : 복잡함
	public Employees emp;
	public Department dept;
	public String fromDate;
	public String toDate;
}
