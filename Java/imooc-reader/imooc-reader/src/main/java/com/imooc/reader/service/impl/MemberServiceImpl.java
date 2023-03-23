package com.imooc.reader.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.imooc.reader.entity.Book;
import com.imooc.reader.entity.Evaluation;
import com.imooc.reader.entity.Member;
import com.imooc.reader.entity.ReaderState;
import com.imooc.reader.mapper.BookMapper;
import com.imooc.reader.mapper.EvaluationMapper;
import com.imooc.reader.mapper.MemberMapper;
import com.imooc.reader.pojo.EvaluateRequest;
import com.imooc.reader.pojo.ReadStateRequest;
import com.imooc.reader.service.BookService;
import com.imooc.reader.service.MemberService;
import com.imooc.reader.service.exception.MemberException;
import com.imooc.reader.utils.MD5Utils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

@Service
@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
public class MemberServiceImpl implements MemberService {

    @Resource
    private MemberMapper memberMapper;

    @Resource
    private EvaluationMapper evaluationMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Member createMember(String username, String password, String nickname) {

        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        Long count = memberMapper.selectCount(queryWrapper);
        if (count > 0) {
            throw new MemberException("用户名重复");
        }

        Member member = new Member();
        member.setUsername(username);
        member.setNickname(nickname);
        // 设置时间
        member.setCreateTime(new Date());

        // 获取随机盐值
        int salt = new Random().nextInt(1000) + 1000;
        member.setSalt(salt);
        // 加密密码
        String pwd = MD5Utils.md5Digest(password, salt);
        member.setPassword(pwd);
        // 插入数据
        memberMapper.insert(member);
        return member;
    }

    @Override
    public Member checkMember(String username, String pwd, String code) {

        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        Member member = memberMapper.selectOne(queryWrapper);
        if (member != null) {
            int salt = member.getSalt();
            String password = MD5Utils.md5Digest(pwd, salt);
            if (password.equals(member.getPassword())) {
                return member;
            } else {
                throw new MemberException("密码错误");
            }
        } else {
            throw new MemberException("会员未注册");
        }
    }

    @Override
    public Member selectById(String memberId) {

        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("member_id", memberId);
        Member member = memberMapper.selectOne(queryWrapper);
        if (member == null) {
            throw new MemberException("用户不存在");
        }
        return member;
    }

    @Override
    public ReaderState selectReadState(Long memberId, Long bookId) {
        ReaderState readerState = memberMapper.selectReadState(new ReadStateRequest(memberId, bookId));
        if (readerState == null) {
            readerState = new ReaderState(0L,bookId, memberId, -1, new Date());
        }
        return readerState;
    }

    @Override
    public ReaderState updateReadState(Long memberId, Long bookId, Integer readState) {

        ReaderState readerState = selectReadState(memberId, bookId);
        if (Objects.equals(readerState.getReadState(), readState)) {
            throw new MemberException("重复设置");
        }
        if (readerState == null) {
            ReaderState rs = new ReaderState();
            rs.setMemberId(memberId);
            rs.setBookId(bookId);
            rs.setReadState(readState);
            rs.setCreateTime(new Date());
            Long id = memberMapper.insertReadState(rs);
            rs.setRsId(id);
            return rs;
        }

        readerState.setReadState(readState);

        ReadStateRequest request = new ReadStateRequest(memberId, bookId);
        request.setReadState(readState);
        memberMapper.updateReadState(request);
        return readerState;
    }

    @Override
    public Evaluation createEvaluate(EvaluateRequest evaluate) {

        Evaluation evaluation = new Evaluation();

        evaluation.setContent(evaluate.getContent());
        evaluation.setScore(evaluate.getScore());
        evaluation.setMemberId(evaluate.getMemberId());
        evaluation.setBookId(evaluate.getBookId());
        evaluation.setCreateTime(new Date());

        Long id = (long) evaluationMapper.insert(evaluation);
        evaluation.setEvaluationId(id);

        evaluation.setEnjoy(0);
        evaluation.setState("commit");

        return evaluation;
    }
}
