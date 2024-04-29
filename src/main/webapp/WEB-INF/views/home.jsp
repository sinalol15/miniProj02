<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
</head>
<body>
    <sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal" var="principal"/>
	</sec:authorize>
	
	<c:choose>
		<c:when test="${empty principal}">
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link" href="/login/loginForm">로그인</a></li>
				<li class="nav-item"><a class="nav-link" href="/login/joinForm">회원가입</a></li>
			</ul>
		</c:when>
		<c:otherwise>
			이름 : ${principal.member_name}
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link" href="/member/updateForm">회원정보</a></li>
				<li class="nav-item"><a class="nav-link" href="/login/logout">로그아웃</a></li>
				<li class="nav-item"><a class="nav-link" href="/board/list">게시물 목록</a></li>
			</ul>
		</c:otherwise>
	</c:choose>
</body>
</html>