package org.kosa.hello;

import java.io.IOException;
import java.security.Principal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.kosa.hello.board.MboardService1;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class MboardController1{       
	private final MboardService1 boardService;
	private final CodeService1 codeService;
	
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
	public String view(MboardVO1 board, Model model) throws ServletException, IOException, SQLException {
		log.info("목록");
		model.addAttribute("board", boardService.view(board));
		
		return "board/view";
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
	public Map<String, Object> update(@RequestBody MboardVO1 board) throws ServletException, IOException {
		log.info("수정");
		
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
	public String insertForm(Model model) throws ServletException, IOException {
		log.info("입력 양식");
		
		return "board/insertForm";
	}
	
    @RequestMapping("/insert")
    @ResponseBody
	public Map<String, Object> insert(@RequestBody MboardVO1 board, Model model, HttpSession session) throws ServletException, IOException {
		log.info("입력");
		Map<String, Object> map = new HashMap<String, Object>();
		
		log.info("입력 sessionId = " + session.getId());
		MmemberVO1 loginVO = (MmemberVO1)session.getAttribute("loginVO");
		if (loginVO != null) {
			board.setTmid(loginVO.getMid());
			
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

}
