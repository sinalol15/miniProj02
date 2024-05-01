package org.kosa.hello.login;

import org.apache.ibatis.annotations.Mapper;
import org.kosa.hello.entity.MmemberVO1;

@Mapper
public interface LoginMapper {
	MmemberVO1 login(String mid);
	//마지막 로그인 시간 변경
	int updateMemberLastLogin(String mid);
	
	//로그인 시 비번 틀린 횟수를 1 증가
	//틀린 횟수가 3회 이상이면 계정을 잠근다.
	int loginCountInc(String mid);
	
	//로그인 성공이 비번 틀린 횟수를 초기화
	int loginCountClear(String mid);
}