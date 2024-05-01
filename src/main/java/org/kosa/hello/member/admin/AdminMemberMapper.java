package org.kosa.hello.member.admin;

import org.apache.ibatis.annotations.Mapper;
import org.kosa.hello.entity.MmemberVO1;

@Mapper
public interface AdminMemberMapper {

	MmemberVO1 login(MmemberVO1 boardVO);

}