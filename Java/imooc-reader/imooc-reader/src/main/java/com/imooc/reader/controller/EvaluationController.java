package com.imooc.reader.controller;

import com.imooc.reader.service.EvaluationService;
import com.imooc.reader.utils.ResponseUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/evaluation")
public class EvaluationController {

    @Resource
    private EvaluationService evaluationService;

    @GetMapping("/list")
    public ResponseUtils list(Long bookId){

        ResponseUtils resp = null;

        try {
            List list = evaluationService.selectEvaluateList(bookId);
            resp = new ResponseUtils().put("list", list);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }

        return resp;
    }

}
