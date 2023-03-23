package com.imooc.reader.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.imooc.reader.entity.Book;
import com.imooc.reader.entity.Evaluation;

import java.util.List;
import java.util.Map;

public interface EvaluationService {

    public List<Map> selectEvaluateList(Long bookId);

    public int updateEnjoy(Long evaluationId);
}
