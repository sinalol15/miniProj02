package org.kosa.hello.board;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.security.Principal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.kosa.hello.CodeService1;
import org.kosa.hello.entity.MboardFileVO;
import org.kosa.hello.entity.MboardImageFileVO;
import org.kosa.hello.entity.MboardVO1;
import org.kosa.hello.entity.MmemberVO1;
import org.kosa.hello.entity.PageRequestVO;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class MboardController1{       
	private final MboardService1 boardService;
	private final CodeService1 codeService;
	private final ServletContext application;
	
	@RequestMapping("/list")
    public String list(@Valid PageRequestVO pageRequestVO, BindingResult bindingResult, Model model) throws Exception {
		log.info("게시물 목록");
		
		log.info(pageRequestVO.toString());
		
		if(bindingResult.hasErrors()) {
			pageRequestVO = PageRequestVO.builder().build();
		}
		
		model.addAttribute("pageResponseVO", boardService.list(pageRequestVO));
		model.addAttribute("sizes", codeService.getList1());
		return "board/list";
	}
	
    @RequestMapping("/view")
	public String view(MboardVO1 board, Model model, Authentication authentication) throws ServletException, IOException, SQLException {
		log.info("목록");
		model.addAttribute("board", boardService.view(board, authentication));
		
		return "board/view";
	}
    
	@RequestMapping("/jsonBoardInfo")
	@ResponseBody
	public Map<String, Object> jsonBoardInfo(@RequestBody MboardVO1 board, Authentication authentication) throws ServletException, IOException, SQLException {
		log.info("json 상세보기 -> {}", board);
		//1. 처리
		MboardVO1 resultVO = boardService.view(board, authentication);
		System.out.println(resultVO);
		Map<String, Object> map = new HashMap<>();
		if (resultVO != null) { //성공
			map.put("status", 0);
			map.put("jsonBoard", resultVO);
		} else {
			map.put("status", -99);
			map.put("statusMessage", "게시물 정보 존재하지 않습니다");
		}

		return map;
	}
    
    @RequestMapping("/delete")
    @ResponseBody
	public Map<String, Object> delete(@RequestBody MboardVO1 board) throws ServletException, IOException {
		log.info("삭제");
		int updated = boardService.delete(board);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (updated == 1) {
			map.put("status", 0);
		} else {
			map.put("status", -99);
			map.put("statusMessage", "게시물 삭제에 실패했습니다.");
		}
		return map;
	}
	
    @RequestMapping("/updateForm")
	public String updateForm(MboardVO1 board, Model model) throws ServletException, IOException, SQLException {
		log.info("수정 양식");
		model.addAttribute("board", boardService.updateForm(board));
		
		return "board/updateForm";
	}
	
    @RequestMapping("/update")
    @ResponseBody
	public Map<String, Object> update(MboardVO1 board) throws ServletException, IOException {
		log.info("수정");
		log.info("board=> {}", board);
		int updated = boardService.update(board);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (updated == 1) {
			map.put("status", 0);
		} else {
			map.put("status", -99);
			map.put("statusMessage", "게시물 수정에 실패했습니다.");
		}
		return map;
	}
	
    @RequestMapping("/insertForm")    
	public Object insertForm(Model model) throws ServletException, IOException {
		log.info("입력 양식");
		
		model.addAttribute("board_token", boardService.getBoardToken());
		return "board/insertForm";
	}
	
    @RequestMapping("/insert")
    @ResponseBody
	public Map<String, Object> insert(MboardVO1 board, Authentication authentication) throws ServletException, IOException {
		log.info("입력");
		log.info("board => {}", board);
		Map<String, Object> map = new HashMap<String, Object>();
		MmemberVO1 memberVO = (MmemberVO1) authentication.getPrincipal();
		
		if (memberVO!= null) {
			board.setTmid(memberVO.getMid());
			
			int updated = boardService.insert(board);
			
			if (updated == 1) {
				map.put("status", 0);
			}
		} else {
			map.put("status", -99);
			map.put("statusMessage", "게시물 등록에 실패했습니다.");
		}
		
		return map;
	}
    
	@PostMapping("boardImageUpload")
	@ResponseBody
	public Object boardImageUpload(MboardImageFileVO boardImageFileVO) throws ServletException, IOException {

		// ckeditor는 이미지 업로드 후 이미지 표시하기 위해 uploaded 와 url을 json 형식으로 받아야 함
		// ckeditor 에서 파일을 보낼 때 upload : [파일] 형식으로 해서 넘어옴, upload라는 키 이용하여 파일을 저장 한다
		MultipartFile file = boardImageFileVO.getUpload();
		String board_token = boardImageFileVO.getBoard_token();

		System.out.println("board_token = " + board_token);

		//이미지 첨부 파일을 저장한다 
		String board_image_file_id = boardService.boardImageFileUpload(board_token, file);


		// 이미지를 현재 경로와 연관된 파일에 저장하기 위해 현재 경로를 알아냄
		String uploadPath = application.getContextPath() + "/board/image/" + board_image_file_id;

		Map<String, Object> result = new HashMap<>();
		result.put("uploaded", true); // 업로드 완료
		result.put("url", uploadPath); // 업로드 파일의 경로

		return result;
	}

	//게시물 첨부 파일 다운로드
    @GetMapping("fileDownload/{board_file_no}")
	public void downloadFile(@PathVariable("board_file_no") int board_file_no, HttpServletResponse response) throws Exception{
		OutputStream out = response.getOutputStream();

		MboardFileVO boardFileVO = boardService.getBoardFile(board_file_no);

		if (boardFileVO == null) {
			response.setStatus(404);
		} else {

			String originName = boardFileVO.getOriginal_filename();
			originName = URLEncoder.encode(originName, "UTF-8");
			//다운로드 할 때 헤더 설정
			response.setHeader("Cache-Control", "no-cache");
			response.addHeader("Content-disposition", "attachment; fileName="+originName);
			response.setContentLength((int)boardFileVO.getSize());
			response.setContentType(boardFileVO.getContent_type());

			//파일을 바이너리로 바꿔서 담아 놓고 responseOutputStream에 담아서 보낸다.
			FileInputStream input = new FileInputStream(new File(boardFileVO.getReal_filename()));

			//outputStream에 8k씩 전달
	        byte[] buffer = new byte[1024*8];

	        while(true) {
	        	int count = input.read(buffer);
	        	if(count<0)break;
	        	out.write(buffer,0,count);
	        }
	        input.close();
	        out.close();
		}
	}

	//게시물 내용에 추가된 이미지 파일 다운로드 
	@GetMapping("image/{board_image_file_id}")
	public void image(@PathVariable("board_image_file_id") String board_image_file_id, HttpServletResponse response) throws Exception{
		OutputStream out = response.getOutputStream();

		MboardImageFileVO boardImageFileVO = boardService.getBoardImageFile(board_image_file_id);

		if (boardImageFileVO == null) {
			response.setStatus(404);
		} else {

			String originName = boardImageFileVO.getOriginal_filename();
			originName = URLEncoder.encode(originName, "UTF-8");
			//다운로드 할 때 헤더 설정
			response.setHeader("Cache-Control", "no-cache");
			response.addHeader("Content-disposition", "attachment; fileName="+originName);
			response.setContentLength((int)boardImageFileVO.getSize());
			response.setContentType(boardImageFileVO.getContent_type());

			//파일을 바이너리로 바꿔서 담아 놓고 responseOutputStream에 담아서 보낸다.
			FileInputStream input = new FileInputStream(new File(boardImageFileVO.getReal_filename()));

			//outputStream에 8k씩 전달
	        byte[] buffer = new byte[1024*8];

	        while(true) {
	        	int count = input.read(buffer);
	        	if(count<0)break;
	        	out.write(buffer,0,count);
	        }
	        input.close();
	        out.close();
		}
	}

}
