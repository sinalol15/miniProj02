package org.kosa.hello.member;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;

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
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MmemberService1 implements UserDetailsService{
	
	@Autowired
	private MmemberMapper1 memberMapper;

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
		return memberMapper.update(member);
	}
	
	public int insert(MmemberVO1 member) {
		return memberMapper.insert(member);
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
	
	public int hobbyFoundInsert(MmemberVO1 member) {
		int i=0;
		for(String mhabbit: member.getMhabbit()) {
			i = memberMapper.hobbyFoundInsert(member, mhabbit);
		}
		return i;
	}
	
	public MhobbyVO1 hobbiesName(MmemberVO1 member) {
		return memberMapper.hobbiesName(member);
	}

}
