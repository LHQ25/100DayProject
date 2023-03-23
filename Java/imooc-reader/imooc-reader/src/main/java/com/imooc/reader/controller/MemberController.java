package com.imooc.reader.controller;

import com.imooc.reader.entity.Evaluation;
import com.imooc.reader.entity.Member;
import com.imooc.reader.entity.ReaderState;
import com.imooc.reader.pojo.EvaluateRequest;
import com.imooc.reader.service.EvaluationService;
import com.imooc.reader.service.MemberService;
import com.imooc.reader.utils.ResponseUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/member")
public class MemberController {

    @Resource
    private MemberService memberService;
    @Resource
    private EvaluationService evaluationService;

    @PostMapping("/check_login")
    public ResponseUtils checkMember(String username, String password, @RequestParam("vc") String code, HttpServletRequest request) {

        ResponseUtils resp = null;

        String vc = (String) request.getSession().getAttribute("kaptchaVerifyCode");
        if (vc == null || vc.isEmpty() || !vc.equalsIgnoreCase(code)) {
            return new ResponseUtils("300", "验证码不正确");
        }

        try {
            Member member = memberService.checkMember(username, password, code);
            if (member != null) {
                resp = new ResponseUtils().put("member", member);
            } else {
                resp = new ResponseUtils("202", "会员不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }

        return resp;
    }

    @PostMapping("/register")
    public ResponseUtils register(String username, String password, String nickname, @RequestParam("vc") String code, HttpServletRequest request) {

        String vc = (String) request.getSession().getAttribute("kaptchaVerifyCode");
        if (vc == null || vc.isEmpty() || !vc.equalsIgnoreCase(code)) {
            return new ResponseUtils("300", "验证码不正确");
        }

        ResponseUtils resp = null;

        try {
            Member member = memberService.createMember(username, password, nickname);
            resp = new ResponseUtils().put("data", member);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }

        return resp;
    }

    @GetMapping("/select_by_id")
    public ResponseUtils memberStatus(String memberId){
        ResponseUtils resp = null;
        try {
            Member member = memberService.selectById(memberId);
            resp = new ResponseUtils().put("member", member);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @GetMapping("/select_read_state")
    public ResponseUtils readerStatus(Long memberId, Long bookId){
        ResponseUtils resp = null;
        try {
            ReaderState member = memberService.selectReadState(memberId, bookId);
            resp = new ResponseUtils().put("readState", member);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @PostMapping("/update_read_state")
    public ResponseUtils updateReadState(Long memberId, Long bookId, Integer readState){
        ResponseUtils resp = null;
        try {
            ReaderState member = memberService.updateReadState(memberId, bookId, readState);
            resp = new ResponseUtils().put("readState", member);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @PostMapping("/enjoy")
    public ResponseUtils enjoy(Long evaluationId){
        ResponseUtils resp = null;
        try {
            int enjoy = evaluationService.updateEnjoy(evaluationId);
            Map m = new HashMap<>();
            m.put("enjoy", enjoy);
            resp = new ResponseUtils().put("evaluation", m);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @PostMapping("/evaluate")
    public ResponseUtils evaluate(EvaluateRequest evaluate){
        ResponseUtils resp = null;
        try {
            Evaluation evaluation = memberService.createEvaluate(evaluate);
            resp = new ResponseUtils().put("evaluation", evaluation);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }
}
