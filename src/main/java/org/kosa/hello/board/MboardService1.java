package org.kosa.hello.board;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.ServletException;

import org.kosa.hello.entity.MboardFileVO;
import org.kosa.hello.entity.MboardImageFileVO;
import org.kosa.hello.entity.MboardVO1;
import org.kosa.hello.entity.MmemberVO1;
import org.kosa.hello.entity.PageRequestVO;
import org.kosa.hello.entity.PageResponseVO;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class MboardService1 {
	private static final long serialVersionUID = 1L;
    
	private final String CURR_IMAGE_REPO_PATH = "c:\\upload";
	
	private final MboardMapper1 boardMapper;

	private final MboardFileMapper  boardFileMapper;
	private final MboardTokenMapper  boardTokenMapper;
	private final MboardImageFileMapper  boardImageFileMapper;
	
	//날자 서식을 생성한다
	private final SimpleDateFormat date_format = new SimpleDateFormat(File.separator + "YYYY" + File.separator + "MM" + File.separator + "dd");
	
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
	
	@Transactional
	public MboardVO1 view(MboardVO1 board, Authentication authentication) throws ServletException, IOException, SQLException {
		//view Count의 값을 증가한다. 
		//만약 값을 증가 하지 못하면 게시물이 존재하지 않는 경우임 
		MmemberVO1 memberVO = (MmemberVO1) authentication.getPrincipal();
		if (!memberVO.getMid().equals(board.getTmid())) {
			boardMapper.incViewCount(board); 
		}
		//view Count의 값이 증가된 객체를 얻는다
		MboardVO1 resultVO = boardMapper.read(board);
		log.info(resultVO.getTbviewcount());
		log.info(resultVO.toString());
		
		resultVO.setBoardFileVO(boardFileMapper.getBoardFileVO(board));
		
		return resultVO;
	}
	
	@Transactional
	public int delete(MboardVO1 board) throws ServletException, IOException {
		return boardMapper.delete(board);
	}
	
	public MboardVO1 updateForm(MboardVO1 board) throws ServletException, IOException, SQLException {
		return boardMapper.read(board);
	}
	
	@Transactional
	public int update(MboardVO1 board) throws ServletException, IOException {
		return boardMapper.update(board);
	}
	
	@Transactional
	public int insert(MboardVO1 board) throws ServletException, IOException {
		//게시물 등록시 게시물의 번호를 얻는다  
		int result = boardMapper.insert(board);

		//MultipartFile 객체를 파일에 저장한다
		MboardFileVO boardFileVO = writeFile(board.getFile());
		if (boardFileVO != null) {
			//첨부파일에 게시물의 아이디를 설정한다
			boardFileVO.setTbno(board.getTbno());
			//저장에 파일 정보를 DB에 저장한다
			result = boardFileMapper.insert(boardFileVO);
		}
		
		//board_token의 상태를 임시 상태에서 완료 상태로 변경한다
		boardTokenMapper.updateStatusComplate(board.getBoard_token());

		//실제 게시물 내용에 사용된 이미지만 게시물 이미지의 board_token 값을 bno로 변경한다
		//게시물 내용 중 사용하다 삭제한 이미지는 삭제 처리해야 한다.
		//1. board_token의 값에 대한 이미지 목록을 얻는다
		//2. 게시물 내용 중 이미지가 사용중이 아니면 삭제 목록에 추가함 
		//3. 삭제 목록에 있는 이미지를 (파일 및 DB)삭제 한다
		//4. 게시물 이미지의 board_token 값을 bno로 변경한다

		String bcontent = board.getTbcontent();
		//파일 다운로드  URL을 구성한다
		final String imageURL = "/board/image/";

		//1. board_token의 값에 대한 이미지 목록을 얻는다
		List<MboardImageFileVO> boardImageFiles = boardImageFileMapper.getBoardImages(board.getBoard_token());

		//2. 게시물 내용 중 이미지가 사용중이 아니면 삭제 목록에 추가함 
		List<MboardImageFileVO> deleteImageList = boardImageFiles.stream().filter(
				//게시물 내용에 해당 이미지가 존재하지 않으면 삭제 대상임 
				fileUpload -> !bcontent.contains(imageURL + fileUpload.getBoard_image_file_id())
			).collect(Collectors.toList());

		if (deleteImageList.size() != 0) {
			//3. 삭제 목록에 있는 이미지를 (파일)삭제 한다
			deleteImageList.stream().forEach(boardImageFile -> new File(boardImageFile.getReal_filename()).delete());

			//3. 삭제 목록에 있는 이미지를 (DB)삭제 한다
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", deleteImageList);
			boardImageFileMapper.deleteBoardImageFiles(map);
		}

		//4. 게시물 이미지의 board_token 값을 bno로 변경한다
		boardImageFileMapper.updateBoardNo(board);

		return result;
	}
	
	//MultipartFile 객체를 파일에 저장한다 
	private MboardFileVO writeFile(MultipartFile file) {
		if (file == null || file.getName() == null) return null;

		Calendar now = Calendar.getInstance();
		//저장위치를 오늘의 날짜로 한다
		String realFolder = date_format.format(now.getTime());
		//실제 저장 위치를 생성한다
		File realPath = new File(CURR_IMAGE_REPO_PATH + realFolder);
		//오늘 날짜에 대한 폴더가 없으면 생성한다  
		if(!realPath.exists()) {
			realPath.mkdirs();
		}
		//실제 파일명으로 사용할 이름을 생성한다  
		String fileNameReal = UUID.randomUUID().toString();
		File realFile = new File(realPath, fileNameReal);

		//파일을 실제 위치에 저장한다 
		try {
			file.transferTo(realFile);
		} catch (Exception e) {
			e.printStackTrace();
			log.info("transferTo : ", e);
			return null;
		}

		//저장된 첨부파일 객체를 리턴한다
		return MboardFileVO.builder()
				.content_type(file.getContentType())
				.original_filename(file.getOriginalFilename())
				.real_filename(realFile.getAbsolutePath())
				.size(file.getSize())
				.build();
	}

	public int incViewCount(MboardVO1 board) throws ServletException, IOException {
		return boardMapper.incViewCount(board);
	}
	
	public MboardFileVO getBoardFile(int board_file_no) {
		return boardFileMapper.getBoardFile(board_file_no);
	}
	
	public String getBoardToken() {
		final String board_token = UUID.randomUUID().toString(); 

		boardTokenMapper.insert(board_token);

		return board_token;
	}

//	public int updateUseStatus(String board_token) {
//		MboardTokenVO boardTokenVO = MboardTokenVO.builder().board_token(board_token).status(1).build();
//
//		return boardTokenMapper.updateStatus(boardTokenVO);
//	}

	public String boardImageFileUpload(String board_token, MultipartFile file) {
		Calendar now = Calendar.getInstance();
		//저장위치를 오늘의 날짜로 한다
		String realFolder = date_format.format(now.getTime());
		//실제 저장 위치를 생성한다
		File realPath = new File(CURR_IMAGE_REPO_PATH + realFolder);
		//오늘 날짜에 대한 폴더가 없으면 생성한다  
		if(!realPath.exists()) {
			realPath.mkdirs();
		}
		//실제 파일명으로 사용할 이름을 생성한다  
		String fileNameReal = UUID.randomUUID().toString();
		File realFile = new File(realPath, fileNameReal);

		//파일을 실제 위치에 저장한다 
		try {
			file.transferTo(realFile);
		} catch (Exception e) {
			e.printStackTrace();
			log.info("transferTo : ", e);
			return null;
		}

		//게시물에 내용에 추가되는 이미지 파일 객체를 생성한다 
		MboardImageFileVO boardImageFileVO = MboardImageFileVO.builder()
				.board_token(board_token)
				.content_type(file.getContentType())
				.original_filename(file.getOriginalFilename())
				.real_filename(realFile.getAbsolutePath())
				.size(file.getSize())
				.build(); 

		//게시물에 내용에 추가되는 이미지 파일을 DB에 저장한다 
		boardImageFileMapper.insert(boardImageFileVO);

		return boardImageFileVO.getBoard_image_file_id();		
	}

	public MboardImageFileVO getBoardImageFile(String board_image_file_id) {
		return boardImageFileMapper.findById(board_image_file_id);
	}

}
