<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>UpdateForm</title>
    <%@ include file="/WEB-INF/views/include/meta.jsp" %>	
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
        회원정보 수정양식 
    </h1>
    <form id="rForm" action="update" method="post">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
        <label>아이디 : </label> <input type="text" id="mid" name="mid" value="${member.mid}" readonly="readonly"> <br/>
        <label>비밀번호 : </label>   <input type="password" id="mpassword" name="mpassword" required="required"><br/>
        <label>비밀번호확인 : </label>   <input type="password" id="mpassword2" name="mpassword2" required="required"><br/>
        <label>이름 : </label>   <input type="text" id="mname" name="mname" value="${member.mname}"><br/>
        <label>나이: </label>    <input type="text" id="mage" name="mage" value="${member.mage}"><br/>
        <label>이메일: </label>  <input type="text" id="memail" name="memail" value="${member.memail}"><br/>
	    
	    <h4>취미: </h4>
        <c:forEach var="hobbies" items="${hobbies}">
		    <label>${hobbies.hname}</label>
		    <input type="checkbox" name="mhabbit" value="${hobbies.hnumber}" ${hobbies.checked}><br/>
		</c:forEach>
	    
	    <div>
	        <input type="button" value="수정" onclick="jsUpdate()">
	        <a href="mypage?mid=${member.mid}">취소</a>
	    </div>
    </form>
    
    <script type="text/javascript">
	menuActive("member_link");

    function jsUpdate() {
    	if (mpassword.value != mpassword2.value) {
    		alert("비밀번호가 잘못되었습니다.")
    		mpassword2.value = "";
    		mpassword2.focus();
    		return false;
    	}
    	
    	myFetch("update", "rForm", json => {
    		if(json.status == 0) {
    			//성공
    			alert("회원 정보 수정을 성공 하였습니다");
    			location = "mypage?mid=" + mid.value;
    		} else {
    			alert(json.statusMessage);
    		}
    	});
    }
    </script>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>

</body>
</html>