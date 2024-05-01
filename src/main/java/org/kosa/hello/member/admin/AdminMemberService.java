package org.kosa.hello.member.admin;

import org.kosa.hello.entity.MboardVO1;
import org.kosa.hello.entity.MmemberVO1;
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
@RequiredArgsConstructor
public class AdminMemberService {

	private final AdminMemberMapper  memberMapper;

	public MmemberVO1 login(MmemberVO1 memberVO)  {
		//view Count의 값이 증가된 객체를 얻는다
		MmemberVO1 resultVO = memberMapper.login(memberVO);
		if (resultVO != null && memberVO.isEqualsPwd(resultVO.getMpassword())) {
			return resultVO;
		}
		return null;
	}

}