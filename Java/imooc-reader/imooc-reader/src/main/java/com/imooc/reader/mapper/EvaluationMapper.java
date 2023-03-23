package com.imooc.reader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.imooc.reader.entity.Evaluation;
import com.imooc.reader.pojo.EvaluateRequest;

import java.util.List;
import java.util.Map;

public interface EvaluationMapper extends BaseMapper<Evaluation> {

    public List<Map> selectEvaluationsByBookId(Long bookId);

    public int createEvaluate(EvaluateRequest evaluate);
}
