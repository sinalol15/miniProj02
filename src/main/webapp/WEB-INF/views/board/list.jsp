<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>List</title>
	<%@ include file="/WEB-INF/views/include/css.jsp" %>
    <%@ include file="/WEB-INF/views/include/js.jsp" %>
    <%@ include file="/WEB-INF/views/include/meta.jsp" %>
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
    
	<form id="viewForm" action="view" method="post">
    	<input type="hidden" id="tbno" name="tbno">
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
            <%-- <td onclick="jsView('${board.tbno}', '${principal.mid}')"  style="cursor:pointer;">${board.tbno}</td> --%>
            <td style="cursor:pointer;"><a data-bs-toggle="modal" data-bs-target="#boardViewModel" data-bs-tbno="${board.tbno}">${board.tbno}</a></td>
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
    
    
	<!-- 상세보기 Modal -->
	<div class="modal fade" id="boardViewModel" role="dialog">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="staticBackdropLabel">게시물 상세보기</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
		      <label>게시물 번호:</label><span id="tbno"></span><br/>
		      <label>제목 : </label><span id="tbtitle"></span><br/>
		      <label>내용 : </label><span id="tbcontent"></span><br/>
		      <label>조회수 :</label><span id="tbviewcount"></span><br/>
		      <label>작성자 : </label><span id="tmid"></span><br/>
		      <label>작성일 : </label><span id="tbdate"></span><br/>
		      <label>첨부파일 : </label><span id="boardFile" data-board-file-no="" onclick="onBoardFileDownload(this)"></span><br/>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-secondary" id="btnDelete" >삭제</button>
	        <button type="button" class="btn btn-secondary" id="btnUpdate">수정</button>
	      </div>
	    </div>
	  </div>
	</div>
    
    <form id="insertForm" method="post" action="insertForm">
    	<%-- csrf 토큰 설정 --%>
		<sec:csrfInput/>
		<input type="button" value="등록" onclick="jsInsertForm('${principal.mid}')">
	</form>
		
	<script>
	menuActive("board_link");

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
	    searchForm.innerHTML += `<sec:csrfInput/><input type='hidden' name='pageNo' value='\${num}'>`;
	    searchForm.submit();
	});
	
	document.querySelector("#size").addEventListener("change", e => {
	    searchForm.submit();
	});
	
	const boardViewModel = document.querySelector("#boardViewModel");
	const span_tbno = document.querySelector(".modal-body #tbno");
	const span_tbtitle = document.querySelector(".modal-body #tbtitle");
	const span_tbcontent = document.querySelector(".modal-body #tbcontent");
	const span_tbviewcount = document.querySelector(".modal-body #tbviewcount");
	const span_tmid = document.querySelector(".modal-body #tmid");
	const span_tbdate = document.querySelector(".modal-body #tbdate");
	boardViewModel.addEventListener('shown.bs.modal', function (event) {
		const a = event.relatedTarget;
		const tbno = a.getAttribute('data-bs-tbno'); //a.dataset["bs-bno"] //, a.dataset.bs-bno 사용안됨
		console.log("모달 대화 상자 출력... tbno ", tbno);
		
		span_tbno.innerText = "";
		span_tbtitle.innerText = "";
		span_tbcontent.innerText = "";
		span_tbviewcount.innerText = "";
		span_tmid.innerText = "";
		span_tbdate.innerText = "";
		boardFile.innerText = "";
		const viewForm = document.querySelector("#viewForm");
		console.log("viewForm", viewForm);
		console.log("tbno", viewForm.querySelector("#tbno"));
		viewForm.querySelector("#tbno").value = tbno;
		myFetch("jsonBoardInfo", "viewForm", json => {
			if(json.status == 0) {
				//성공
				const jsonBoard = json.jsonBoard; 
				span_tbno.innerText = jsonBoard.tbno;
				span_tbtitle.innerText = jsonBoard.tbtitle;
				span_tbcontent.innerHTML = jsonBoard.tbcontent;
				span_tbviewcount.innerText = jsonBoard.tbviewcount;
				span_tmid.innerText = jsonBoard.tmid;
				span_tbdate.innerText = jsonBoard.tbdate;
				//첨부파일명을 출력한다
				boardFile.innerText = jsonBoard.boardFileVO.original_filename;
				//첨부파일의 번호를 설정한다 
				boardFile.setAttribute("data-board-file-no", jsonBoard.boardFileVO.board_file_id);
			} else {
				alert(json.statusMessage);
			}
		});
	})
	
	  // 모달 종료(hide) 버튼
	  document.querySelector("#btnDelete").addEventListener("click", e => {
		  if (confirm("정말로 삭제하시겠습니까?")) {
				myFetch("delete", "viewForm", json => {
					if(json.status == 0) {
						//성공
						alert("삭제 되었습니다");
						location = "list";
					} else {
						alert(json.statusMessage);
					}
				});
			} 
	  })
	  
	  document.querySelector("#btnUpdate").addEventListener("click", e => {
	    const a = e.relatedTarget;
	    const tbno = a.getAttribute('data-bs-tbno');
	    console.log("모달 대화 상자 출력... tbno ", tbno);
	
	    // Accessing the span elements
	    const span_tbtitle = document.querySelector("#span_tbtitle");
	    const span_tbcontent = document.querySelector("#span_tbcontent");
	
	    // Creating input elements for editable fields
	    const input_tbtitle = document.createElement('input');
	    input_tbtitle.type = 'text';
	    input_tbtitle.value = span_tbtitle.innerText;
	
	    const input_tbcontent = document.createElement('textarea');
	    input_tbcontent.value = span_tbcontent.innerText;
	
	    // Replace spans with input elements
	    span_tbtitle.replaceWith(input_tbtitle);
	    span_tbcontent.replaceWith(input_tbcontent);
	
	    const viewForm = document.querySelector("#viewForm");
	    console.log("viewForm", viewForm);
	    console.log("tbno", viewForm.querySelector("#span_tbno"));
	    viewForm.querySelector("#span_tbno").value = tbno;
	
	    myFetch("jsonBoardInfo", "viewForm", json => {
	        if (json.status == 0) {
	            // 성공
	            const jsonBoard = json.jsonBoard;
	            // Set input values from JSON data
	            input_tbtitle.value = jsonBoard.tbtitle;
	            input_tbcontent.value = jsonBoard.tbcontent;
	        } else {
	            alert(json.statusMessage);
	        }
	    });
	});
	
	const onBoardFileDownload = boardFile => {
		const board_file_no = boardFile.getAttribute("data-board-file-no");
		alert("첨부파일 번호 = " + board_file_no);
		location.href = "<c:url value='/board/fileDownload/'/>" + board_file_no;
	}
	
/* 	function jsView(bn, id1) {
		//인자의 값을 설정한다 
		tbno.value = bn;
		tmid.value = id1;
		
		//양식을 통해서 서버의 URL로 값을 전달한다
		listForm.submit();
		
	} */
	
	function jsInsertForm(a) {
		//서버의 URL로 전송한다 
		insertForm.submit();
	}
	
/* 	function jsDelete() {
		if (confirm("정말로 삭제하시겠습니까?")) {
			myFetch("delete", "viewForm", json => {
				if(json.status == 0) {
					//성공
					alert("삭제 되었습니다");
					location = "list";
				} else {
					alert(json.statusMessage);
				}
			});
		}
	} */
	
	function jsUpdateForm() {
		viewForm.action = "updateForm";
	
		//서버의 URL로 전송한다 
		viewForm.submit();
	}
	</script>
	
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>

</body>
</html>