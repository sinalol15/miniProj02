<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>List</title>
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
	<h1>게시물목록</h1>
	<h4>로그인 : ${principal.mname} </h4>
    <form id="searchForm" action="list" method="post">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
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
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
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
            <td onclick="jsView('${board.tbno}', '${principal.mid}')"  style="cursor:pointer;">${board.tbno}</td>
            <td>${board.tbtitle}</td>
            <td>${board.tbdate}</td>
            <td>${board.tmid}</td>
            <td>${board.tbviewcount}</td>
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
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
		<input type="button" value="등록" onclick="jsInsertForm('${principal.mid}')">
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
	
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>

</body>
</html>