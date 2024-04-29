package org.kosa.hello.entity;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Positive;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class PageRequestVO {
	
    @Builder.Default
    @Min(value = 1)
    @Positive
    private int pageNo = 1;

    @Builder.Default
    @Min(value = 10)
    @Max(value = 100)
    @Positive
    private int size = 10;

    private String link;

    private String searchKey;

    public int getSkip(){
        return (pageNo - 1) * 10;
    }

	public String getLink() {
		if(link == null){
			StringBuilder builder = new StringBuilder();
			builder.append("page=" + this.pageNo);
			builder.append("&size=" + this.size);
			
			if (this.searchKey != null && this.searchKey.length() != 0) {
				try {
					builder.append("&searchKey=" + URLEncoder.encode(this.searchKey,"UTF-8"));
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
			}
			link = builder.toString();
		}
		return link;
	}    
}
