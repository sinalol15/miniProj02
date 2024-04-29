package org.kosa.hello;

import java.util.List;

import org.kosa.hello.entity.CodeVO1;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class CodeService1 {
	private final CodeMapper1 codeMapper1;
	
	public List<CodeVO1> getList1() {
		return codeMapper1.getList1();
	}
}