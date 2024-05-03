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
    <%-- 부트스트랩5 css --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- ckeditor 관련 자바 스크립트  --%>
	<script src="https://cdn.ckeditor.com/ckeditor5/12.4.0/classic/ckeditor.js"></script>
	<script src="https://ckeditor.com/apps/ckfinder/3.5.0/ckfinder.js"></script>
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
    	<input type="hidden" id="tmid" name="tmid">
		<sec:csrfInput/>
    </form>
    
    <table>
        <tr>
        	<th></th>
            <th>게시물번호</th>
            <th>제목</th>
            <th>작성일</th>
            <th>작성자</th>
            <th>조회수</th>
        </tr>
        <c:forEach var="board" items="${pageResponseVO.list}">
        <tr>
        	<c:if test="${board.isNew eq 1}">
        		<td><img src="/image/new.png" alt="new" width="30" height="30"></td>
       		</c:if>
       		<c:if test="${board.isNew eq 0}">
       			<td>  </td>
       		</c:if>
            <%-- <td onclick="jsView('${board.tbno}', '${principal.mid}')"  style="cursor:pointer;">${board.tbno}</td> --%>
            <td style="cursor:pointer;"><a data-bs-toggle="modal" data-bs-target="#boardViewModel" data-bs-tbno="${board.tbno}" data-bs-tmid="${board.tmid}">${board.tbno}</a></td>
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
	      <div id="view" style="display:">
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
	      </div>
	      <div id="update" style="display:none">
	      	  <div class="modal-header">
		        <h5 class="modal-title" id="staticBackdropLabel">게시물 수정 양식</h5>
		        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		      </div>
		      <div class="modal-body">
			      <label>게시물 번호:</label><span id="tbno2"></span><br/>
			      <label>제목 : </label><input type="text" id="tbtitle2" value="${board.tbtitle}"><br/>
			      <label>내용 : </label><input type="text" id="tbcontent2" ><br/>
			      <label>조회수 :</label><span id="tbviewcount2"></span><br/>
			      <label>작성자 : </label><span id="tmid2"></span><br/>
			      <label>작성일 : </label><span id="tbdate2"></span><br/>
			      <label>첨부파일 : </label><span id="boardFile2" data-board-file-no="" onclick="onBoardFileDownload(this)"></span><br/>
		      </div>
		      <div id="div_file">
				  <input  type='file' name='file' />
			  </div>
	      </div>
	      <div id="viewButton" style="display:">
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
		        <div id="updateDiv" style="display:none">
			        <button type="button" class="btn btn-secondary" id="btnDelete">삭제</button>
			        <button type="button" class="btn btn-secondary" id="btnUpdateForm">수정</button>
		        </div>
		      </div>
		  </div>
		  <div id="updateButton" style="display:none">
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" id="btnCancle">취소</button>
		        <button type="button" class="btn btn-secondary" id="btnUpdate">수정</button>
		      </div>
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
	
	const span_tbno2 = document.querySelector(".modal-body #tbno2");
	const span_tbtitle2 = document.querySelector(".modal-body #tbtitle2");
	const span_tbcontent2 = document.querySelector(".modal-body #tbcontent2");
	const span_tbviewcount2 = document.querySelector(".modal-body #tbviewcount2");
	const span_tmid2 = document.querySelector(".modal-body #tmid2");
	const span_tbdate2 = document.querySelector(".modal-body #tbdate2");
	
	const csrfParameter = document.querySelector("meta[name='_csrf_parameter']").content;
	const csrfToken = document.querySelector("meta[name='_csrf']").content;
	const board_image_url = "<c:url value='/board/boardImageUpload?board_token=${board_token}&'/>" + csrfParameter + "=" + csrfToken;
	//cfeditor관련 설정 
	let bcontent; //cfeditor의 객체를 저장하기 위한 변수 
	ClassicEditor.create(document.querySelector('#tbcontent2'),{
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
	
	boardViewModel.addEventListener('shown.bs.modal', function (event) {
		
		document.querySelector("#updateDiv").style.display = "none";
		const a = event.relatedTarget;
		const tbno = a.getAttribute('data-bs-tbno'); //a.dataset["bs-bno"] //, a.dataset.bs-bno 사용안됨
		const tmid = a.getAttribute('data-bs-tmid');
		const mid = "${principal.mid}";
		console.log("모달 대화 상자 출력... tbno ", tbno);
		
		span_tbno.innerText = "";
		span_tbtitle.innerText = "";
		span_tbcontent.innerText = "";
		span_tbviewcount.innerText = "";
		span_tmid.innerText = "";
		span_tbdate.innerText = "";
		boardFile.innerText = "";
		
		span_tbno2.innerText = "";
		span_tbtitle2.innerText = "";
		span_tbtitle2.innerText = "";
		span_tbcontent2.innerText = "";
		span_tmid2.innerText = "";
		span_tbdate2.innerText = "";
		
		const viewForm = document.querySelector("#viewForm");
		console.log("viewForm", viewForm);
		console.log("tbno", viewForm.querySelector("#tbno"));
		console.log("tmid", viewForm.querySelector("#tmid"));
		viewForm.querySelector("#tbno").value = tbno;
		viewForm.querySelector("#tmid").value = tmid;
		myFetch("jsonBoardInfo", "viewForm", json => {
			if(json.status == 0) {
				
				if (mid == tmid || mid == 'park') {
					document.querySelector("#updateDiv").style.display = "";
				}        

				//성공
				const jsonBoard = json.jsonBoard; 
				span_tbno.innerText = jsonBoard.tbno;
				span_tbtitle.innerText = jsonBoard.tbtitle;
				span_tbcontent.innerHTML = jsonBoard.tbcontent;
				span_tbviewcount.innerText = jsonBoard.tbviewcount;
				span_tmid.innerText = jsonBoard.tmid;
				span_tbdate.innerText = jsonBoard.tbdate;
				
				span_tbno2.innerText = jsonBoard.tbno;
				span_tbtitle2.innerText = jsonBoard.tbtitle;
				span_tbcontent2.innerText = jsonBoard.tbcontent;
				span_tbviewcount2.innerText = jsonBoard.tbviewcount;
				span_tmid2.innerText = jsonBoard.tmid;
				span_tbdate2.innerText = jsonBoard.tbdate;
				
				//첨부파일명을 출력한다
				boardFile.innerText = jsonBoard.boardFileVO.original_filename;
				//첨부파일의 번호를 설정한다 
				boardFile.setAttribute("data-board-file-no", jsonBoard.boardFileVO.board_file_id);
			} else {
				alert(json.statusMessage);
			}
		});
	})
	
	  // 모달 삭제(hide) 버튼
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
		  document.querySelector("#update").style.display = "";
		  document.querySelector("#updateButton").style.display = "";
		  document.querySelector("#view").style.display = "none";
		  document.querySelector("#viewButton").style.display = "none";
		  
		  if (confirm("정말로 수정하시겠습니까?")) {
			  myFetch("update", "viewForm", json => {
		    		if(json.status == 0) {
		    			//성공
		    			alert("게시물 수정을 성공 하였습니다");
		    			location = "view?tbno=" + tbno.value;
		    		} else {
		    			alert(json.statusMessage);
		    		}
		    	});
			} 

	  })
	  
	  document.querySelector("#btnUpdateForm").addEventListener("click", e => {
		  document.querySelector("#update").style.display = "";
		  document.querySelector("#updateButton").style.display = "";
		  document.querySelector("#view").style.display = "none";
		  document.querySelector("#viewButton").style.display = "none";
		  
		  

	  })
	  
	  document.querySelector("#btnCancle").addEventListener("click", e => {
		  document.querySelector("#update").style.display = "none";
		  document.querySelector("#updateButton").style.display = "none";
		  document.querySelector("#view").style.display = "";
		  document.querySelector("#viewButton").style.display = "";
	  })
	
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