<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LoginForm</title>
    <style>
        label {
            display: inline-block;
            width: 120px;
        }
        input {
            margin-bottom: 10px; 
        }
    </style>
</head>

<c:if test="${not empty param.err}">
	<script>
		alert("아이디 또는 비밀번호가 잘못되었습니다");
	</script>
</c:if>

<body>
    <h1>
        로그인 화면
    </h1>
    
    <sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal" var="principal"/>
	</sec:authorize>
	
	<c:choose>
		<c:when test="${empty principal}">
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link" href="/member/loginForm">로그인</a></li>
				<li class="nav-item"><a class="nav-link" href="/member/joinForm">회원가입</a></li>
			</ul>
		</c:when>
		<c:otherwise>
			이름 : ${principal.member_name}
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link" href="/member/updateForm">회원정보</a></li>
				<li class="nav-item"><a class="nav-link" href="/member/logout">로그아웃</a></li>
			</ul>
		</c:otherwise>
	</c:choose>
	
    <form id="rForm" action="/login" method="post">
    	<label>아이디 : </label><input type="text" id="mid" name="mid" required="required" placeholder="아이디를 입력해주세요."/><br/>
        <label>비밀번호 : </label><input type="password" id="mpassword" name="mpassword" required="required" placeholder="비밀번호를 입력해주세요."><br/>
    	<label for="autologin">자동로그인</label><input type="checkbox" id="autologin" name="autologin" value="Y">
	    <div>
	        <input type="submit" value="로그인">
	        <a href="loginForm">취소</a>
	    </div>
    </form>
    
    <script type="text/javascript">
	msg = "${error ? exception : ''}";
	if (msg !== "")  {
		alert(msg);
	}
    
    const rForm = document.getElementById("rForm");
    //아이디 사용 여부 확인 
    let validUserId = "";
    
    rForm.addEventListener("submit", e => {
    	//서버에 form data를 전송하지 않는다 
    	e.preventDefault();
    	
		myFetch("login", "rForm", json => {
			if(json.status == 0) {
				//성공
				alert("로그인에 성공 하였습니다");
				location = "../board/list";
			} else {
				alert(json.statusMessage);
			}
		});
    });
    </script>
    
    <sec:authorize access="isAuthenticated()">
	   로그아웃
	   회원정보보기
	</sec:authorize>
	
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	  관리자 페이지
	</sec:authorize>
	
</body>
</html>