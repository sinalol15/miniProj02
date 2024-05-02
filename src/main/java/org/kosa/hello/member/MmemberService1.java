package org.kosa.hello.member;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;

import org.kosa.hello.board.MboardFileMapper;
import org.kosa.hello.board.MboardImageFileMapper;
import org.kosa.hello.board.MboardMapper1;
import org.kosa.hello.board.MboardTokenMapper;
import org.kosa.hello.entity.MboardVO1;
import org.kosa.hello.entity.MhobbyVO1;
import org.kosa.hello.entity.MmemberVO1;
import org.kosa.hello.entity.PageRequestVO;
import org.kosa.hello.entity.PageResponseVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class MmemberService1 implements UserDetailsService{
	
	private final MmemberMapper1 memberMapper;
	
	private final PasswordEncoder encryptPassword;

	public PageResponseVO<MmemberVO1> list(PageRequestVO pageRequestVO) throws Exception {
		List<MmemberVO1> list = null;
		PageResponseVO<MmemberVO1> pageResponseVO = null;
		int total = 0;
		try {
			list = memberMapper.getList(pageRequestVO);
			total = memberMapper.getTotalCount(pageRequestVO);

			log.info("list {}", list);
			log.info("total {}", total);
			pageResponseVO = new PageResponseVO<MmemberVO1>(list, total, pageRequestVO.getPageNo(), pageRequestVO.getSize());
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception();
		}
		return pageResponseVO;
	}
	
	public MmemberVO1 login(MmemberVO1 memberVO)  {
		MmemberVO1 resultVO = memberMapper.login(memberVO);
		if (resultVO != null && memberVO.isEqualsPwd(resultVO.getMpassword())) {
			return resultVO;
		}
		return null;
	}
	
	@Autowired
	public static void main(String [] args) {
		BCryptPasswordEncoder bcryptPasswordEncoder = new BCryptPasswordEncoder();
		System.out.println(bcryptPasswordEncoder.encode("1004"));
		System.out.println(bcryptPasswordEncoder.encode("0123456789010234567890123456789"));
	}

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.info("username = {}", username);
		MmemberVO1 resultVO = memberMapper.login(MmemberVO1.builder().mid(username).build());
		if (resultVO == null) {
			log.info(username + " 사용자가 존재하지 않습니다");
			throw new UsernameNotFoundException(username + " 사용자가 존재하지 않습니다");
		}

		//로그인 횟수를 카운트 한다
		memberMapper.loginCountInc(resultVO);

		return resultVO;
	}
	
	public MmemberVO1 view(MmemberVO1 member) throws ServletException, IOException, SQLException {
		return memberMapper.read(member);
	}
	
	public int delete(MmemberVO1 member) {
		return memberMapper.delete(member);
	}
	
	public MmemberVO1 updateForm(MmemberVO1 member) throws ServletException, IOException, SQLException {
		return memberMapper.read(member);
	}
	
	public int update(MmemberVO1 member) throws ServletException, IOException {
		member.setPassword(encryptPassword);
		int n = memberMapper.update(member);
		memberMapper.deleteHobby(member);
		Map<String, String> map = new HashMap<>();
		map.put("mid", member.getMid());
		for (String mhabbit : member.getMhabbit()) {
			map.put("mhabbit", mhabbit);
			log.info("map = {}", map);
			memberMapper.hobbyFoundInsert(map);
		}
		
		return n;
	}
	
	public int insert(MmemberVO1 member) {
		member.setPassword(encryptPassword);
		int n = memberMapper.insert(member);
		Map<String, String> map = new HashMap<>();
		map.put("mid", member.getMid());
		for (String mhabbit : member.getMhabbit()) {
			map.put("mhabbit", mhabbit);
			log.info("map = {}", map);
			memberMapper.hobbyFoundInsert(map);
		}
		
		return n;
	}
	
	public void updateUUID(MmemberVO1 member) {
		memberMapper.updateUUID(member);
	}
	
	public List<MhobbyVO1> hobbies() {
		return memberMapper.hobbies();
	}
	
	public List<MhobbyVO1> hobbyFoundCheck(MmemberVO1 member) {
		return memberMapper.hobbyFoundCheck(member);
	}

	public int unlocked(MmemberVO1 member) {
		int n=0;
		List<String> mid_checked = member.getMid_checked();
		if (mid_checked.size() != 0) {
			List<MmemberVO1> memberList = new ArrayList<>();
			for (String mid : mid_checked) {
				memberList.add(MmemberVO1.builder().mid(mid).build());
			}
			
			log.info("memberCheckedList : " + memberList);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", memberList);
			log.info("map : " + map);
			n = memberMapper.unlocked(map);
		}
		return n;
	}
	
	public int deleteUsers(MmemberVO1 member) {
		int n=0;
		List<String> mid_checked = member.getMid_checked();
		if (mid_checked.size() != 0) {
			List<MmemberVO1> memberList = new ArrayList<>();
			for (String mid : mid_checked) {
				memberList.add(MmemberVO1.builder().mid(mid).build());
			}
			
			log.info("memberCheckedList : " + memberList);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", memberList);
			log.info("map : " + map);
			n = memberMapper.deleteUsers(map);
		}
		return n;
	}
	
//	public int hobbyFoundInsert(MmemberVO1 member) {
//		int i=0;
//		for(String mhabbit: member.getMhabbit()) {
//			i = memberMapper.hobbyFoundInsert(member);
//		}
//		return i;
//	}
	
//	public String hobbiesName(MmemberVO1 member) {
//		StringBuilder sb = new StringBuilder();
//		List<MhobbyVO1> list =  memberMapper.hobbiesName(member);
//		for(MhobbyVO1 item : list) {
//		
//			sb.append(item.getHname()).append(" ");
//		}
//		System.out.println(sb);
//		
//		return sb.toString();
//	}

}
