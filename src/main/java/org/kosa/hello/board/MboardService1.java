package org.kosa.hello.board;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;

import org.kosa.hello.entity.MboardVO1;
import org.kosa.hello.entity.PageRequestVO;
import org.kosa.hello.entity.PageResponseVO;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class MboardService1 {
	private static final long serialVersionUID = 1L;
       
	private final MboardMapper1 boardMapper;

	public PageResponseVO<MboardVO1> list(PageRequestVO pageRequestVO) throws Exception {
		List<MboardVO1> list = null;
		PageResponseVO<MboardVO1> pageResponseVO = null;
		int total = 0;
		try {
			list = boardMapper.getList(pageRequestVO);
			total = boardMapper.getTotalCount(pageRequestVO);

			log.info("list {}", list);
			log.info("total {}", total);
			pageResponseVO = new PageResponseVO<MboardVO1>(list, total, pageRequestVO.getPageNo(), pageRequestVO.getSize());
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception();
		}
		return pageResponseVO;
	}
	
	public MboardVO1 view(MboardVO1 board) throws ServletException, IOException, SQLException {
		return boardMapper.read(board);
	}
	
	public int delete(MboardVO1 board) throws ServletException, IOException {
		return boardMapper.delete(board);
	}
	
	public MboardVO1 updateForm(MboardVO1 board) throws ServletException, IOException, SQLException {
		return boardMapper.read(board);
	}
	
	public int update(MboardVO1 board) throws ServletException, IOException {
		return boardMapper.update(board);
	}
	
	public int insert(MboardVO1 board) throws ServletException, IOException {
		return boardMapper.insert(board);
	}

}
