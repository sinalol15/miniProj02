<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>UpdateForm</title>
	<%@ include file="/WEB-INF/views/include/css.jsp" %>
    <%@ include file="/WEB-INF/views/include/js.jsp" %>
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
<body>
	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<h1>
    	게시물 수정 수정양식 
    </h1>
    <form id="rForm" action="update" method="post">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
        <label>게시물 번호: </label> <input type="text" id="tbno" name="tbno" value="${board.tbno}" readonly="readonly"> <br/>
        <label>제목 : </label><input type="text" id="tbtitle" name="tbtitle" value="${board.tbtitle}"><br/>
        <label>내용: </label> <input type="text" id="tbcontent" name="tbcontent" value="${board.tbcontent}"><br/>
	    <div>
	        <input type="submit" value="수정">
	        <a href="view?tbno=${board.tbno}">취소</a>
	    </div>
    </form>
        
	<script type="text/javascript" src="<c:url value='/resources/js/common.js'/>"></script>
    
    <script>
    menuActive("board_link");
    
    const rForm = document.getElementById("rForm");
     
    rForm.addEventListener("submit", e => {
    	//서버에 form data를 전송하지 않는다 
    	e.preventDefault();
    	
    	myFetch("update", "rForm", json => {
    		if(json.status == 0) {
    			//성공
    			alert("게시물 수정을 성공 하였습니다");
    			location = "view?tbno=" + tbno.value;
    		} else {
    			alert(json.statusMessage);
    		}
    	});
    });
    </script>
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>

</body>
</html>