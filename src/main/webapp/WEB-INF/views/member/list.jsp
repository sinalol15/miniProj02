<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>List</title>
    <%@ include file="/WEB-INF/views/include/meta.jsp" %>	
	<%@ include file="/WEB-INF/views/include/css.jsp" %>
    <%@ include file="/WEB-INF/views/include/js.jsp" %>
</head>
<body>
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
	<h1>회원목록</h1>
	  
    <form id="searchForm" action="list" method="post">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
    	<input type="hidden" id="action" name="action" value="">
    	<select id="size" name="size" >
        	<c:forEach var="size" items="${sizes}">
        		<option value="${size.codeid}" ${pageRequestVO.size == size.codeid ? 'selected' : ''} >${size.name}</option>
        	</c:forEach>
        </select>
    	<label>이름</label>
    	<input type="text" id="searchKey" name="searchKey" value="${param.searchKey}">
    	<input type="submit" value="검색">
    </form>
    
    <form id="listForm" action="view" method="post">
    	<input type="hidden" id="mid" name="mid" value="">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
    </form>
    
    <form id="changeForm" method="post" action="">
	    <table>
	        <tr>
	        	<th></th>
	            <th>ID</th>
	            <th>이름</th>
	            <th>나이</th>
	            <th>이메일</th>
	            <th>권한</th>
	            <th>잠금 여부</th>
	        </tr>
	        
	        <c:forEach var="member" items="${pageResponseVO.list}">
	        <tr>
	            <td><input type="checkbox" name="mid_checked" value="${member.mid}"></td>
	            <td onclick="jsView('${member.mid}')"  style="cursor:pointer;">${member.mid}</td>
	            <td>${member.mname}</td>
	            <td>${member.mage}</td>
	            <td>${member.memail}</td>
	            <td>${member.member_roles}</td>
	            <td>${member.member_account_locked}</td>
	        </tr>
	        </c:forEach>
	    </table>
   	
		<input type="button" value="잠금 해제" onclick="jsUnlocked()">
		<input type="button" value="탈퇴" onclick="jsDelete()">
		<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
	</form>
	
    <!--  페이지 네비게이션 바 출력  -->
    <div class="float-end">
        <ul class="pagination flex-wrap">
            <c:if test="${pageResponseVO.prev}">
                <li class="page-item">
                    <a class="page-link" data-num="${pageResponseVO.start -1}">이전</a>
                </li>
            </c:if>

            <c:forEach begin="${pageResponseVO.start}" end="${pageResponseVO.end}" var="num">
                <li class="page-item ${pageResponseVO.pageNo == num ? 'active':''} ">
                    <a class="page-link"  data-num="${num}">${num}</a></li>
            </c:forEach>

            <c:if test="${pageResponseVO.next}">
                <li class="page-item">
                    <a class="page-link"  data-num="${pageResponseVO.end + 1}">다음</a>
                </li>
            </c:if>
        </ul>

    </div>
    
	<script>
	menuActive("member_link");

	document.querySelector(".pagination").addEventListener("click", function (e) {
	    e.preventDefault()

	    const target = e.target

	    if(target.tagName !== 'A') {
	        return
	    }
	    //dataset 프로퍼티로 접근 또는 속성 접근 메서드 getAttribute() 사용 하여 접근 가능 
	    //const num = target.getAttribute("data-num")
	    const num = target.dataset["num"];
	    
	    //페이지번호 설정 
	    searchForm.innerHTML += `<input type='hidden' name='pageNo' value='\${num}'>`;
	    searchForm.submit();
	});
	
	document.querySelector("#size").addEventListener("change", e => {
	    searchForm.submit();
	});
	
	function jsView(memberid) {
		//인자의 값을 설정한다 
		mid.value = memberid;
		//양식을 통해서 서버의 URL로 값을 전달한다
		listForm.submit();
		
	}
	
	function jsUnlocked() {
		myFetch("unlocked", "changeForm", json => {
			if(json.status == 0) {
				alert("활성화 되었습니다");
				location = "list";
			} else {
				alert(json.statusMessage);
			}
		});
	}
	
	function jsDelete() {
		changeForm.action = "deleteUsers";
		changeForm.submit();
	}
	</script>

	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
	
</body>
</html>