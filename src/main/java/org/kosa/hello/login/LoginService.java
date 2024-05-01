package org.kosa.hello.login;

import org.kosa.hello.entity.MmemberVO1;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/*
 * MVC 
 * Model : B/L 로직을 구현하는 부분(service + dao)  
 * View  : 출력(jsp) 
 * Controller : model와 view에 대한 제어를 담당 
 */
@Service
@Slf4j
public class LoginService implements UserDetailsService {

	@Autowired
	private LoginMapper loginMapper;

	@Override
	public UserDetails loadUserByUsername(String member_id) throws UsernameNotFoundException {
		log.info("member_id = {}", member_id);

		//로그인 횟수를 카운트 한다
		loginMapper.loginCountInc(member_id);

		MmemberVO1 resultVO = loginMapper.login(member_id);
		if (resultVO == null) {
			log.info(member_id + " 사용자가 존재하지 않습니다");
			throw new UsernameNotFoundException(member_id + " 사용자가 존재하지 않습니다");
		}
		log.info("resultVO = {}", resultVO);

		return resultVO;
	}
}