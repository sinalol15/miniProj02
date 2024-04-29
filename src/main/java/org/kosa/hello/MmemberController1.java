package org.kosa.hello;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.kosa.hello.entity.MhobbyVO1;
import org.kosa.hello.entity.MmemberVO1;
import org.kosa.hello.entity.PageRequestVO;
import org.kosa.hello.member.MmemberService1;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Servlet implementation class MmemberController
 */
@Controller
@Slf4j
@RequestMapping("/member")
@RequiredArgsConstructor
public class MmemberController1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final MmemberService1 memberService;   
	private final CodeService1 codeService;
	
	@RequestMapping("/list")
  	public String list(@Valid PageRequestVO pageRequestVO, BindingResult bindingResult, Model model) throws Exception {
  		log.info("목록");
  		
  		log.info(pageRequestVO.toString());
  		
  		if(bindingResult.hasErrors()) {
  			pageRequestVO = PageRequestVO.builder().build();
  		}
  		model.addAttribute("pageResponseVO", memberService.list(pageRequestVO));
  		model.addAttribute("sizes", codeService.getList1());
  		
  		return "member/list";
  	}
  	
	@RequestMapping("/view")
  	public String view(MmemberVO1 member, Model model) throws ServletException, IOException, SQLException {
  		log.info("상세 정보");
  		model.addAttribute("member", memberService.view(member));
  		
  		return "member/view";
  	}
  	
	@RequestMapping("/delete")
	@ResponseBody
  	public Map<String, Object> delete(@RequestBody MmemberVO1 member) throws ServletException, IOException {
  		log.info("삭제");
  		
  		int updated = memberService.delete(member);
  		
  		Map<String, Object> map = new HashMap<String, Object>();
  		
  		if (updated == 1) {
  			map.put("status", 0);
  		} else {
  			map.put("status", -99);
  			map.put("statusMessage", "������ ���� �߽��ϴ�.");
  		}
  		return map;
  	}
  	
	@RequestMapping("/updateForm")
  	public String updateForm(MmemberVO1 member, Model model) throws ServletException, IOException, SQLException {
  		log.info("수정 양식");
  		
  		model.addAttribute("member", memberService.updateForm(member));
  		model.addAttribute("hobbies", memberService.hobbyFoundCheck(member));

  		return "member/updateForm";
  	}
  	
	@RequestMapping("/update")
	@ResponseBody
  	public Map<String, Object> update(@RequestBody MmemberVO1 member, @RequestBody MhobbyVO1 hobby) throws ServletException, IOException {
  		log.info("수정");
  		
  		int updated1 = memberService.update(member);
  		List<MhobbyVO1> updated2 = memberService.hobbyFoundCheck(member);
  		
  		Map<String, Object> map = new HashMap<String, Object>();
  		
  		if (updated1 == 1) {
  			map.put("status", 0);
  	  		if (updated2 != null) {
  	  			map.put("status", 0);
  	  		} else {
  	  			map.put("status", -99);
  	  			map.put("statusMessage", "수정할 정보를 다시 입력해주세요.");
  	  		}
  		} else {
  			map.put("status", -99);
  			map.put("statusMessage", "수정에 실패했습니다.");
  		}
  		
  		return map;
  	}
  	
	@RequestMapping("/insertForm")
  	public String insertForm(Model model) throws ServletException, IOException {
  		log.info("가입 양식");
  		
  		model.addAttribute("hobbies", memberService.hobbies());
  		
  		return "member/insertForm";
  	}
  	
	@RequestMapping("/insert")
	@ResponseBody
  	public Map<String, Object> insert(@RequestBody MmemberVO1 member, Model model, HttpSession session) throws ServletException, IOException {
  		log.info("가입");
  		Map<String, Object> map = new HashMap<String, Object>();
  		
  		log.info("가입 sessionId = " +session.getId());
  		MmemberVO1 loginVO = (MmemberVO1)session.getAttribute("loginVO");
  		if (loginVO.getMid() == null  || loginVO.getMid().length() == 0) {
  			map.put("status", -1);
  			map.put("statusMessage", "id에 null값이 들어갔습니다.");
  		} else {
  			int updated = memberService.insert(member);
  			
  			if (updated == 1) {
  				map.put("status", 0);
  			} else {
  				map.put("status", -99);
  				map.put("statusMessage", "가입에 실패했습니다.");
  			}
  		}
  		
  		return map;
  	}

	@ResponseBody
	@RequestMapping("/existUserId")
  	public Map<String, Object> existUserId(@RequestBody MmemberVO1 member, Model model) throws ServletException, IOException, SQLException {
  		log.info("existUserId userid->" + member.getMid());
  		MmemberVO1 existMember = memberService.view(member);
  		Map<String, Object> map = new HashMap<String, Object>();
  		System.out.println(existMember);
  		
  		if (existMember == null) {
  			map.put("existUser", false);
  		} else {
  			map.put("existUser", true);
  		}
  		return map;
  	}

	@RequestMapping("/loginForm")
  	public String loginForm(Model model) {
  		log.info("로그인 양식");
  		
  		return "member/loginForm";
  	}

	@RequestMapping("/login")
	@ResponseBody
	public Map<String, Object> login(@RequestBody MmemberVO1 memberVO, HttpSession session) throws ServletException, IOException {
		log.info("로그인 -> {}", memberVO);
		MmemberVO1 loginVO = memberService.login(memberVO);
		
		Map<String, Object> map = new HashMap<>();
		if (loginVO != null) {
			session.setAttribute("loginVO", loginVO);
			map.put("loginVO", loginVO);
			map.put("status", 0);
		} else {
			map.put("status", -99);
			map.put("statusMessage", "로그인에 실패하였습니다.");
		}
		
		return map;
	}
  	
	@RequestMapping("/logout")
	@ResponseBody
  	public Map<String, Object> logout(Model model) throws IOException {
  		Map<String, Object> map = new HashMap<String, Object>();

  		return map;
  	}
  	
	@RequestMapping("/mypage")
  	public String mypage(MmemberVO1 member, Model model) throws ServletException, IOException {
  		log.info("마이 페이지");

  		return "member/mypage";
  	}

}