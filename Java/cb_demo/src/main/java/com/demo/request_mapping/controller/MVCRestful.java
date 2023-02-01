package com.demo.request_mapping.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/restful")
public class MVCRestful {
    /*
    总结：
    明确REST和RESTful的关系，明确表现层、资源、状态、转移这几个概念的含义
        REST，表现层资源状态转移
        RESTful，基于REST构建的 API 就是RESTful风格
    明确RESTful的实现，是通过不同的请求方式来对应资源的不同操作，通过路径中的占位符传递请求参数
    熟练掌握如何通过RESTful进行资源的增删改查操作，以及如何处理PUT和DELETE这两种特殊的请求方式
    明确CharacterEncodingFilter和HiddenHttpMethodFilter的配置顺序，明白两个过滤器的源码处理逻辑
     */


    @RequestMapping("/rest/{name}")
    @ResponseBody
    public String test(@PathVariable String name) {

        return "参数： " + name;
    }

}
