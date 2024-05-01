package org.kosa.hello.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MboardTokenVO {

	private String board_token;
	private int   status;
	private String make_date;

}