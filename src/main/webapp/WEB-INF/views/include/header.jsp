<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<ul class="nav nav-pills nav-justified">
  <li class="nav-item">
    <a class="nav-link"  href="<c:url value='/q'/>" id="home_link">회사소개</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="<c:url value='/board/list'/>" id="board_link">게시물</a>
  </li>

  
  	<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal" var="principal"/>
	</sec:authorize>
	
  	<c:choose>
  		<c:when test="${empty principal}">
  		    <li class="nav-item">
		      <a class="nav-link" href="<c:url value='/member/insertForm'/>" id="member_new_link">회원가입</a>
		    </li>
			<li class="nav-item">
		    	<a class="nav-link" href="<c:url value='/login/loginForm'/>" id="login_link">로그인</a>
			</li>
  		</c:when>
  		<c:otherwise>
  			<c:if test="${!empty principal && principal.mid ne 'park'}">
				<li class="nav-item">
				    <a class="nav-link" href="<c:url value='/member/mypage'/>" id="mypage_link">나의정보</a>
				</li>
				<li class="nav-item">
				    <a class="nav-link" href="<c:url value='/login/logout'/>" id="logout_link">${principal.mname}</a>
				</li>
			</c:if>
			<c:if test="${!empty principal && principal.mid eq 'park'}">
				<li class="nav-item">
				    <a class="nav-link" href="<c:url value='/member/list'/>" id="member_link">회원관리</a>
				</li>
				<li class="nav-item">
				    <a class="nav-link" href="<c:url value='/login/logout'/>" id="logout_link">${principal.mname}</a>
				</li>
			</c:if>
  		</c:otherwise>
  	</c:choose>
</ul>