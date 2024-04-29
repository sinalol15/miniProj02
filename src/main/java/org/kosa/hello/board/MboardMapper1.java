package org.kosa.hello.board;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.kosa.hello.entity.MboardVO1;
import org.kosa.hello.entity.PageRequestVO;

@Mapper
public interface MboardMapper1 {
	
	List<MboardVO1> getList(PageRequestVO pageRequestVO);
	int  getTotalCount(PageRequestVO pageRequestVO);
	MboardVO1 read(MboardVO1 boardVO);
	int delete(MboardVO1 boardVO);
	int update(MboardVO1 boardVO);
	int insert(MboardVO1 boardVO);
}
