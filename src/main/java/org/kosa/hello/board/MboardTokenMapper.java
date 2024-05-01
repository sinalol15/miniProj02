package org.kosa.hello.board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.kosa.hello.entity.MboardTokenVO;

@Mapper
public interface MboardTokenMapper {

	int insert(String board_token);
	int updateStatusComplate(String board_token);
	public List<MboardTokenVO> listToken();
	public int deletes(Map<String, Object> map);
	public void deleteByToken(String token);
	
}