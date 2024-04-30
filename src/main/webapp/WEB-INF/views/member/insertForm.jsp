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
	
	<form id="insertForm" action="hobby" method="post">
		<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
    	<input type="hidden" id="action" name="action" value="hobby">
    </form>
    
	<h1>
        회원가입 정보 입력
    </h1>
    <form id="rForm" action="members1" method="post">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
       	<input type="hidden" name="action" value="insert">
        <label>아이디 : </label> <input type="text" id="mid" name="mid" required="required"><input type="button" id="duplicateId" value="중복확인"><br/>
        <label>비밀번호 : </label>   <input type="password" id="mpassword" name="mpassword" required="required"><br/>
        <label>비밀번호확인 : </label>   <input type="password" id="mpassword2" name="mpassword2" required="required"><br/>
        <label>이름 : </label>   <input type="text" id="mname" name="mname" required="required"><br/>
        <label>나이: </label>    <input type="text" id="mage" name="mage" required="required"><br/>
        <label>이메일: </label>  <input type="text" id="memail" name="memail" required="required"><br/>
        <label>성별: </label>  
		<input type="radio" id="male" name="mgender" value="male">
		<label for="male">남성</label>
		<input type="radio" id="female" name="mgender" value="female">
		<label for="female">여성</label><br/>
        
        <h4>취미: </h4>
        <c:forEach var="hobbies" items="${hobbies}">
		    <label>${hobbies.hname}</label>
		    <input type="checkbox" name="mhabbit" value="${hobbies.hnumber}"><br/>
		</c:forEach>
		
		<input type="submit" value="등록">
        <a href="list">취소</a>
    </form>
    
    <script type="text/javascript">
    
	menuActive("member_link");

    const rForm = document.getElementById("rForm");
    const mid = document.getElementById("mid");
    const mpassword = document.getElementById("mpassword");
    const mpassword2 = document.getElementById("mpassword2");
    const mname = document.getElementById("mname");
    const mage = document.getElementById("mage");
    const memail = document.getElementById("memail");
    //아이디 사용 여부 확인 
    let validUserId = "";
    
    rForm.addEventListener("submit", e => {
    	//서버에 form data를 전송하지 않는다 
    	e.preventDefault();
    	
    	if (validUserId == "" || mid.value != validUserId) {
    		alert("아이디 중복확인 해주세요");
    		return false;
    	}
    	
    	if (mpassword.value != mpassword2.value) {
        	
    		alert("비밀번호가 잘못되었습니다.")
    		mpassword2.value = "";
    		mpassword2.focus();
    		return false;
    	}
		myFetch("insert", "rForm", json => {
			if(json.status == 0) {
				//성공
				alert("회원가입을 성공 하였습니다");
				location = "loginForm";
			} else {
				alert(json.statusMessage);
			}
		});
    });
    
    //id의 객체를 얻는다
	const duplicateId = document.getElementById("duplicateId");
    //click 이벤트 핸들러 등록
	duplicateId.addEventListener("click", () => {
		const mid = document.getElementById("mid");
		if (mid.value == "") {
			alert("아이디를 입력해주세요");
			mid.focus();
			return;
		}
		const param = {
			action : "existUserId",
			mid : mid.value
		}
		fetch("members1", {
			method:"POST",
			body:JSON.stringify(param),
			headers : {"Content-type" : "application/json; charset=utf-8"}
		}).then(res => res.json()).then(json => {
			//서버로 부터 받은 결과를 사용해서 처리 루틴 구현  
			console.log("json ", json );
			if (json.existUser == true) {
				alert("해당 아이디는 사용 중 입니다.");
				validUserId = "";
			} else {
				alert("사용가능한 아이디 입니다.");
				validUserId = mid.value;
			}
		});
	});
    </script>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
    
</body>
</html>
