<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<title>InsertForm</title>
    <%@ include file="/WEB-INF/views/include/meta.jsp" %>	
	<%@ include file="/WEB-INF/views/include/css.jsp" %>
    <%@ include file="/WEB-INF/views/include/js.jsp" %>
    <%-- 부트스트랩5 css --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- ckeditor 관련 자바 스크립트  --%>
	<script src="https://cdn.ckeditor.com/ckeditor5/12.4.0/classic/ckeditor.js"></script>
	<script src="https://ckeditor.com/apps/ckfinder/3.5.0/ckfinder.js"></script>
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
	<form id="rForm" action="insert" method="post" enctype="multipart/form-data">
		<!-- 게시물 토큰을 설정한다 -->
        <input type="hidden" id="board_token" name="board_token" value="${board_token}"><br/>
        <input class="btitle" id="btitle" name="tbtitle" required="required" placeholder="게시물 제목을 입력해주세요"><br/>
        <textarea id="bcontent" name="tbcontent" required="required" placeholder="게시물 내용을 입력해주세요">
        </textarea>
        <div id="div_file">
			<input  type='file' name='file' />
		</div>
        <br/>
	    <div>
	        <input type="submit" value="등록">
	        <a href="list">취소</a>
	    </div>
    </form>
        
    <script type="text/javascript">
    
    menuActive("board_link");
    
    const csrfParameter = document.querySelector("meta[name='_csrf_parameter']").content;
	const csrfToken = document.querySelector("meta[name='_csrf']").content;
	//이미지 업로드 URL
	const board_image_url = "<c:url value='/board/boardImageUpload?board_token=${board_token}&'/>" + csrfParameter + "=" + csrfToken;
    
	//cfeditor관련 설정 
	let bcontent; //cfeditor의 객체를 저장하기 위한 변수 
	ClassicEditor.create(document.querySelector('#bcontent'),{
		//이미지 업로드 URL을 설정한다 
		ckfinder: {
			uploadUrl : board_image_url
		}
	})
	.then(editor => {
		console.log('Editor was initialized');
		//ckeditor객체를 전역변수 bcontent에 설정함 
		window.bcontent = editor;
	})
	.catch(error => {
		console.error(error);
	});
    
    const rForm = document.getElementById("rForm");
    
    rForm.addEventListener("submit", e => {
    	//서버에 form data를 전송하지 않는다 
    	e.preventDefault();
    	
    	myFileFetch("insert", "rForm", json => {
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
