package org.kosa.hello.entity;

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
	private int viewcount;

	private String action;

	public MboardVO1(int tbno, String tbtitle, String tbcontent, String tbdate, String mname) {
		super();
		this.tbno = tbno;
		this.tbtitle = tbtitle;
		this.tbcontent = tbcontent;
		this.tbdate = tbdate;
		this.mname = mname;
	}

	public MboardVO1(int tbno, String tbtitle, String tbcontent, String tbdate, String mname, int viewcount) {
		super();
		this.tbno = tbno;
		this.tbtitle = tbtitle;
		this.tbcontent = tbcontent;
		this.tbdate = tbdate;
		this.mname = mname;
		this.viewcount = viewcount;
	}
}
