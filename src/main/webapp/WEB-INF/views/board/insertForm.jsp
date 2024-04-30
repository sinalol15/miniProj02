<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<title>InsertForm</title>
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
        게시물 등록양식 
    </h1>
    <h3>로그인 : ${principal.mname} </h3>
    <form id="rForm" action="insert" method="post">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
        <label>제목 : </label><input type="text" id="tbtitle" name="tbtitle" ><br/>
        <label>내용 : </label><input type="text" id="tbcontent" name="tbcontent" ><br/>
	    <div>
	        <input type="submit" value="등록">
	        <a href="list">취소</a>
	    </div>
    </form>
        
    <script type="text/javascript">
    
    menuActive("board_link");
    
    const rForm = document.getElementById("rForm");
    
    rForm.addEventListener("submit", e => {
    	//서버에 form data를 전송하지 않는다 
    	e.preventDefault();
    	
		myFetch("insert", "rForm", json => {
			if(json.status == 0) {
				//성공
				alert("게시물 작성에 성공 하였습니다");
				location = "list";
			} else {
				alert(json.statusMessage);
			}
		});
    });
    </script>
    
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
