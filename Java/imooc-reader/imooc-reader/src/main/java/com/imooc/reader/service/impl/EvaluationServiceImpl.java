package com.imooc.reader.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.imooc.reader.entity.Evaluation;
import com.imooc.reader.mapper.EvaluationMapper;
import com.imooc.reader.service.EvaluationService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
public class EvaluationServiceImpl implements EvaluationService {

    @Resource
    private EvaluationMapper evaluationMapper;

    @Override
    public List<Map> selectEvaluateList(Long bookId) {

        return evaluationMapper.selectEvaluationsByBookId(bookId);
    }

    @Override
    public int updateEnjoy(Long evaluationId) {

        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("evaluation_id", evaluationId);

        Evaluation evaluation = evaluationMapper.selectOne(queryWrapper);
        evaluation.setEnjoy(evaluation.getEnjoy() + 1);

        evaluationMapper.update(evaluation, queryWrapper);
        return evaluation.getEnjoy();
    }
}
