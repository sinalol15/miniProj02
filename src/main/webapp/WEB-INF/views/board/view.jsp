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
        게시물 상세보기
    </h1>
   
	<label>게시물 번호: ${board.tbno}</label> <br/>
	<label>제목 : ${board.tbtitle}</label><br/>
	<label>내용 : ${board.tbcontent}</label><br/>
	<label>조회수 : ${board.tbviewcount}</label><br/>
	<label>작성일 : ${board.tbdate}</label><br/>
	<label>작성자 : ${board.tmid}</label><br/>
	
	<script>	
	function jsList() {
		viewForm.action = "list";
		
		viewForm.submit();
	}
	//tmid
	function jsDelete() {
		if (confirm("정말로 삭제하시겠습니까?")) {
			myFetch("delete", "viewForm", json => {
				if(json.status == 0) {
					//성공
					alert("게시물을 삭제 하였습니다");
					location = "list";
				} else {
					alert(json.statusMessage);
				}
			});
		}
	}
	
	function jsUpdateForm() {
		//서버의 URL을 설정한다 
		viewForm.action = "updateForm";
	
		//서버의 URL로 전송한다 
		viewForm.submit();
	}
	</script>
	<!-- 두개의 폼을 하나로 합치는 방법 , js를 사용하여 처리  -->
	<form id="viewForm" method="post" action="view">
		<input type="hidden" name="tbno" value="${board.tbno}">
		<input type="button" value="목록" onclick="jsList()">
		<c:if test="${!empty principal && ((principal.mid eq board.tmid) || (principal.mid eq 'park'))}">
			<input type="button" value="삭제" onclick="jsDelete()">
			<input type="button" value="수정" onclick="jsUpdateForm()">
		</c:if>
		<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
	</form>
	
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
	
</body>
</html>