package org.kosa.hello.board;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.kosa.hello.entity.MboardFileVO;
import org.kosa.hello.entity.MboardVO1;

@Mapper
public interface MboardFileMapper {

	List<MboardFileVO> getList(MboardVO1 boardVO);
	MboardFileVO getBoardFile(int board_file_no);
	MboardFileVO getBoardFileVO(MboardVO1 boardVO);
	int delete(MboardFileVO boardFileVO);
	int insert(MboardFileVO boardFileVO);

}