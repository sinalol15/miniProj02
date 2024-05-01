package org.kosa.hello.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MboardFileVO {

	private String board_file_id;
	private int tbno;
	private String original_filename;
	private String real_filename;
	private String content_type;
	private long size;
	private String make_date;

}