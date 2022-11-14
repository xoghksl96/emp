<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// Map 타입의 이해
	// Class 사용하면
	
	Student stu = new Student();
	stu.name = "김태환";
	stu.age = 27;
	
	System.out.println(stu.name +" "+ stu.age);

	// Student Class가 없다면
	HashMap<String, Object> m = new HashMap<String, Object>();
	m.put("name","김태환");
	m.put("age","27");
	
	System.out.println(m.get("name") +" "+ m.get("age"));
	
	// 배열 집합이면
	// 1) Student 클래스 사용
	Student s1 = new Student();
	s1.name="김민송";
	s1.age = 26;
	
	Student s2 = new Student();
	s2.name="김설";
	s2.age = 29;
	
	ArrayList<Student> studentList = new ArrayList<Student>();
	studentList.add(s1);
	studentList.add(s2);
	
	System.out.println("ArrayList<Student>");
	for(Student st : studentList) {
		System.out.println(st.name+" "+st.age);
	}
	// 2) Map 사용
	HashMap<String, Object> m1= new HashMap<String, Object>();
	m1.put("name","김민송");
	m1.put("age","29");
	HashMap<String, Object> m2 = new HashMap<String, Object>();
	m2.put("name","김설");
	m2.put("age","27");
	
	ArrayList<HashMap<String, Object>> studentMap = new ArrayList<HashMap<String, Object>>();
	studentMap.add(m1);
	studentMap.add(m2);
	
	System.out.println("ArrayList<HashMap<String, Object>>");
	for(HashMap<String, Object> stMap : studentMap) {
		System.out.println(stMap.get("name")+" "+stMap.get("age"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>