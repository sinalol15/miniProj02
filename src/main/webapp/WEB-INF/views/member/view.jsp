<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>View</title>
	<%@ include file="/WEB-INF/views/include/css.jsp" %>
    <%@ include file="/WEB-INF/views/include/js.jsp" %>
    <style>
		th, td {
		  border: 1px solid;
		}
		th {
			border-color : #96D4D4;
		}
		td {
			border-color : #D6EEEE;
		}
		tr:nth-child(even) {
		  background-color: #D6EEEE;
		  color:#96D4D4;
		}
		tr:nth-child(odd) {
		  background-color: #96D4D4;
		  color:white;
		}
	</style>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/header.jsp" %>

    <h1>
        사용자 정보 상세보기
    </h1>
   
    <table>
        <tr>
            <th>ID</th>
            <th>이름</th>
            <th>나이</th>
            <th>이메일</th>
        </tr>
        <tr>
            <td>${principal.mid}</td>
            <td>${principal.mname}</td>
            <td>${principal.mage}</td>
            <td>${principal.memail}</td>
        </tr>
    </table>
	
	<script type="text/javascript" src="<c:url value='/resources/js/common.js'/>"></script>
	<script>
	menuActive("member_link");

	function jsList() {
		action.value = "list";
		
		viewForm.submit();
	}
	
	function jsDelete() {
		if (confirm("정말로 삭제하시겠습니까?")) {
			myFetch("delete", "viewForm", json => {
				if(json.status == 0) {
					//성공
					alert("탈퇴 되었습니다");
					location = "list";
				} else {
					alert(json.statusMessage);
				}
			});
		}
	}
	
	function jsUpdateForm() {
		action.value = "updateForm";
	
		//서버의 URL로 전송한다 
		update.submit();
	}
	</script>
	
	<!-- 두개의 폼을 하나로 합치는 방법 , js를 사용하여 처리  -->
	<form id="viewForm" method="post" action="list">
		<input type="hidden" id="action" name="action" value="">
		<input type="hidden" name="mid" value="${principal.mid}">
		<input type="button" value="목록" onclick="jsList()">
		<input type="button" value="삭제" onclick="jsDelete()">
		<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
	</form>
	<form id="update" method="post" action="updateForm">
		<input type="hidden" id="action" name="action" value="">
		<input type="hidden" name="mid" value="${principal.mid}">
		<input type="button" value="수정" onclick="jsUpdateForm()">
		<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
	</form>
	
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
	
</body>
</html>