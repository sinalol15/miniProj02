package org.kosa.hello.scheduler;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.kosa.hello.board.MboardImageFileMapper;
import org.kosa.hello.board.MboardTokenMapper;
import org.kosa.hello.entity.MboardImageFileVO;
import org.kosa.hello.entity.MboardTokenVO;
import org.kosa.hello.entity.MmemberVO1;
import org.kosa.hello.member.MmemberMapper1;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
@EnableScheduling
public class SchedulerService {
	private final MboardTokenMapper boardTokenMapper;
	private final MboardImageFileMapper boardImageFileMapper;
	private final MmemberMapper1 memberMapper;

	@Scheduled(fixedDelay = 60000) // 60초마다 실행 
	public void fileTokenAutoDelete() {
		System.out.println("첨부 파일 업로드 중 완료되지 않음 파일을 삭제한다");
		//현재 30분 전에 생성되고 임시 상태인 token 목록을 얻는다 
		List<MboardTokenVO> boardTokenList = boardTokenMapper.listToken();
		if (boardTokenList.size() != 0) {
			log.info("fileTokenList : " + boardTokenList);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", boardTokenList);
			log.info("map : " + map);

			//board_token을 기준으로 BoardImageFile 목록을 얻는다 
			List<MboardImageFileVO> boardImageFileList = boardImageFileMapper.getBoardImageFileList(map);
			for (MboardImageFileVO fileUpload : boardImageFileList) {
				log.info("삭제 파일 : " + fileUpload.getReal_filename());
				//저장소에 저장된 파일을 삭제한다 
				new File(fileUpload.getReal_filename()).delete();
			}
			if (boardImageFileList.size() != 0) {
				//게시물 내용에 추가된 이미지 정보를 삭제한다
				boardImageFileMapper.deleteBoardToken(map);
			}
			//임시로 사용된 게시물 토큰을 삭제한다
			boardTokenMapper.deletes(map);
		}
	}
	
	@Scheduled(fixedDelay = 60000)
	public void memberUnlockedAutoUpdate() {
		System.out.println("10분 전 잠긴 계정을 활성화 시킨다");
		//현재로부터 10분 전에 잠긴 계정의 mid 목록을 얻는다
		List<MmemberVO1> memberList = memberMapper.lockedMembers();
		if (memberList.size() != 0) {
			log.info("memberLockedList : " + memberList);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", memberList);
			log.info("map : " + map);
			
			memberMapper.unlocked(map);
		}
	}
}
