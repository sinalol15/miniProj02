<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>List</title>
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
	<h1>게시물목록</h1>
	
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
	
    <form id="searchForm" action="list" method="post">
    	<input type="hidden" id="action" name="action" value="">
    	<select id="size" name="size" >
        	<c:forEach var="size" items="${sizes}">
        		<option value="${size.codeid}" ${pageRequestVO.size == size.codeid ? 'selected' : ''} >${size.name}</option>
        	</c:forEach>
        </select>
    	<label>제목</label>
    	<input type="text" id="searchKey" name="searchKey" value="${param.searchKey}">
    	<input type="submit" value="검색">
    </form>
    
   	<form id="listForm" action="view" method="post">
    	<input type="hidden" id="tbno" name="tbno">
    	<input type="hidden" id="tmid" name="tmid">
    </form>
    
    <table>
        <tr>
            <th>게시물번호</th>
            <th>제목</th>
            <th>작성일</th>
            <th>작성자</th>
            <th>조회수</th>
        </tr>
        <c:forEach var="board" items="${pageResponseVO.list}">
        <tr>
            <td onclick="jsView('${board.tbno}', '${loginVO.mid}')"  style="cursor:pointer;">${board.tbno}</td>
            <td>${board.tbtitle}</td>
            <td>${board.tbdate}</td>
            <td>${board.tmid}</td>
            <td>${board.viewcount}</td>
        </tr>
        </c:forEach>
    </table>
    
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
    
    <form id="insertForm" method="post" action="insertForm">
		<input type="button" value="등록" onclick="jsInsertForm('${loginVO.mid}')">
	</form>
		
	<script>	
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
	
	function jsView(bn, id1) {
		//인자의 값을 설정한다 
		tbno.value = bn;
		tmid.value = id1;
		
		//양식을 통해서 서버의 URL로 값을 전달한다
		listForm.submit();
		
	}
	
	function jsInsertForm(a) {
		//서버의 URL로 전송한다 
		insertForm.submit();
	}
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