<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
	<title>Home</title>
	<%@ include file="/WEB-INF/views/include/css.jsp" %>
    <%@ include file="/WEB-INF/views/include/js.jsp" %>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/header.jsp" %>

	<a href = "<c:url value='/board/list'/>"> 게시물 목록</a>
	<a href = "<c:url value='/member/loginForm'/>"> 로그인</a>
	<a href = "<c:url value='/member/list'/>"> 회원 목록</a>

	<script>
		menuActive("home_link");
	</script>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>