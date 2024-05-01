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
public class MboardImageFileVO {

	private String board_image_file_id;
	private String board_token;
	private String bno;
	private String original_filename;
	private String real_filename;
	private String content_type;
	private long size;
	private String make_date;

	//업로드 파일 
	private MultipartFile upload;

}