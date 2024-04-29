package org.kosa.hello;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.kosa.hello.entity.CodeVO1;

@Mapper
public interface CodeMapper1 {
	List<CodeVO1> getList1();
}