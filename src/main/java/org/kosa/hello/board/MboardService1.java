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
		//view Count의 값을 증가한다. 
		//만약 값을 증가 하지 못하면 게시물이 존재하지 않는 경우임  
		if (0 == boardMapper.incViewCount(board)) {
			return null; 
		}
		//view Count의 값이 증가된 객체를 얻는다
		MboardVO1 resultVO = boardMapper.read(board);
		log.info(resultVO.getTbviewcount());
		log.info(resultVO.toString());
		return resultVO;
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

	public int incViewCount(MboardVO1 board) throws ServletException, IOException {
		return boardMapper.incViewCount(board);
	}

}
