package org.kosa.hello.entity;

import java.util.List;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

import org.kosa.hello.board.MboardFileMapper;
import org.kosa.hello.board.MboardImageFileMapper;
import org.kosa.hello.board.MboardMapper1;
import org.kosa.hello.board.MboardTokenMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MmemberVO1 implements UserDetails{
	private String mid;
	private String mhid;
	private String mpassword;
	private String mname;
	private List<String> mhabbit;
	private int    mage;
	private String memail;
	private String mgender;
	private String mpassword2;
	private String err;
	private String action;
	private String member_roles;
	private String member_account_expired;
	private String member_account_locked;
	private int member_login_count;
	private LocalDateTime member_last_login_time;
	private String hname;
	
	//uuid
	private String muuid;
	
	private String autologin;
	
	private List<String> mid_checked;

    public void setPassword(PasswordEncoder encryptPassword) {
        this.mpassword = encryptPassword.encode(mpassword);
    }
	
	public MmemberVO1(String mid, String mpassword, String mname, int mage, String memail) {
		super();
		this.mid = mid;
		this.mpassword = mpassword;
		this.mname = mname;
		this.mage = mage;
		this.memail = memail;
	}
	
	public boolean isEqualPassword(MmemberVO1 memberVO) {
		return memberVO != null && mpassword2.equals(memberVO.getMpassword()); 
	}
	
	public boolean isEqualsPwd(String pwd) {
		return this.mpassword.equals(pwd);		
	}
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		Collection<GrantedAuthority> collections = new ArrayList<GrantedAuthority>();
		Arrays.stream(member_roles.split(",")).forEach(role -> collections.add(new SimpleGrantedAuthority("ROLE_" + role.trim())));
		return collections;
	}
	
	@Override
	public boolean isAccountNonExpired() {
		return "N".equalsIgnoreCase(member_account_expired);
	}
	
	@Override
	public boolean isAccountNonLocked() {
		return "N".equalsIgnoreCase(member_account_locked);
	}
	
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}

	@Override
	public String getPassword() {
		return mpassword;
	}

	@Override
	public String getUsername() {
		return mid;
	}
}
