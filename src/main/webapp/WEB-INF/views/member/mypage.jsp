<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Mypage</title>
    <%@ include file="/WEB-INF/views/include/meta.jsp" %>	
	<%@ include file="/WEB-INF/views/include/css.jsp" %>
    <%@ include file="/WEB-INF/views/include/js.jsp" %>
	<style>
	    label {
	        display: inline-block;
	        width: 200px;
	    }
	    input {
	        margin-bottom: 10px; 
	    }
	</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/header.jsp" %>

	<h1>
       나의 페이지
    </h1>
   
	<label>아이디 : ${principal.mid}</label> <br/>
	<label>이름 : ${principal.mname}</label><br/>
	<label>나이: ${principal.mage}</label><br/>
	<label>이메일: ${principal.memail}</label><br/>
	<label>취미: ${hobbies.hname}</label>
	
	
	<script>
	menuActive("member_link");

	function jsDelete() {
		if (confirm("정말로 탈퇴하시겠습니까?")) {
			myFetch("delete", "viewForm", json => {
				if(json.status == 0) {
					//성공
					alert("회원정보를 삭제 하였습니다");
					location = "list";
				} else {
					alert(json.statusMessage);
				}
			});
		}
	}
	
	function jsUpdateForm() {
		if (confirm("정말로 수정하시겠습니까?")) {
			//서버의 URL을 설정한다 
			action.value = "updateForm";
		
			//서버의 URL로 전송한다 
			update.submit();
		}	
	}
	
	</script>
	<!-- 두개의 폼을 하나로 합치는 방법 , js를 사용하여 처리  -->
	<form id="viewForm" method="post" action="members1">
		<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
		<input type="hidden" id="action" name="action" value="">
		<input type="hidden" id="mid" name="mid" value="${member.mid}">
		<input type="button" value="삭제" onclick="jsDelete()">
	</form>
	<form id="update" method="post" action="updateForm">
		<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
		<input type="hidden" id="action" name="action" value="">
		<input type="hidden" name="mid" value="${member.mid}">
		<input type="button" value="수정" onclick="jsUpdateForm()">
	</form>
	
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
	
</body>
</html>