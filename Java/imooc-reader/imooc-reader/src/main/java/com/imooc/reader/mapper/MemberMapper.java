package com.imooc.reader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.imooc.reader.entity.Member;
import com.imooc.reader.entity.ReaderState;
import com.imooc.reader.pojo.ReadStateRequest;

public interface MemberMapper extends BaseMapper<Member> {

    public ReaderState selectReadState(ReadStateRequest request);

    public int updateReadState(ReadStateRequest request);

    public Long insertReadState(ReaderState rs);

}
