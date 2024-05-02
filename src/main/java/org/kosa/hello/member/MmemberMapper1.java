package org.kosa.hello.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.kosa.hello.entity.MhobbyVO1;
import org.kosa.hello.entity.MmemberVO1;
import org.kosa.hello.entity.PageRequestVO;

@Mapper
public interface MmemberMapper1 {
	
	List<MmemberVO1> getList(PageRequestVO pageRequestVO);
	int getTotalCount(PageRequestVO pageRequestVO);
	MmemberVO1 read(MmemberVO1 memberVO);
	int delete(MmemberVO1 memberVO);
	int update(MmemberVO1 memberVO);
	int insert(MmemberVO1 memberVO);
	void updateUUID(MmemberVO1 memberVO);
	List<MhobbyVO1> hobbies();
	List<MhobbyVO1> hobbyFoundCheck(MmemberVO1 memberVO);
	int hobbyFoundInsert(Map<String, String> map);
	List<MhobbyVO1> hobbiesName(MmemberVO1 memberVO);
	
	MmemberVO1 login(MmemberVO1 memberVO);
	int updateMemberLastLogin(String email);
	
	void loginCountInc(MmemberVO1 member);
	
	void loginCountClear(String email);
	public List<MmemberVO1> lockedMembers();
	public int unlocked(Map<String, Object> map);
	public int deleteUsers(Map<String, Object> map);
	
	int deleteHobby(MmemberVO1 memberVO);
	int updateHobby(MmemberVO1 memberVO);
}