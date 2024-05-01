package org.kosa.hello.entity;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MboardVO1 {
	private int tbno;
	private String tbtitle;
	private String tbcontent;
	private String tbdate;
	private String tmid;
	private String mname;
	private String tbviewcount;

	private String action;
	
	//게시물 토큰 변수 선언
	private String board_token;
	
	//업로드 파일 
	private MultipartFile file;
	
	//첨부 파일
	private MboardFileVO boardFileVO;

	public MboardVO1(int tbno, String tbtitle, String tbcontent, String tbdate, String mname) {
		super();
		this.tbno = tbno;
		this.tbtitle = tbtitle;
		this.tbcontent = tbcontent;
		this.tbdate = tbdate;
		this.mname = mname;
	}

	public MboardVO1(int tbno, String tbtitle, String tbcontent, String tbdate, String mname, String tbviewcount) {
		super();
		this.tbno = tbno;
		this.tbtitle = tbtitle;
		this.tbcontent = tbcontent;
		this.tbdate = tbdate;
		this.mname = mname;
		this.tbviewcount = tbviewcount;
	}
}
