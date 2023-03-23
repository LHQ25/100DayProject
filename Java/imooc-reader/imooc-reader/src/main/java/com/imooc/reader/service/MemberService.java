package com.imooc.reader.service;

import com.imooc.reader.entity.Evaluation;
import com.imooc.reader.entity.Member;
import com.imooc.reader.entity.ReaderState;
import com.imooc.reader.pojo.EvaluateRequest;

import java.util.List;
import java.util.Map;

public interface MemberService {

    public Member createMember(String username, String password, String nickname);

    public Member checkMember(String username, String pwd, String code);

    public Member selectById(String memberId);

    public ReaderState selectReadState(Long memberId, Long bookId);

    public ReaderState updateReadState(Long memberId, Long bookId, Integer readState);

    public Evaluation createEvaluate(EvaluateRequest evaluate);
}
