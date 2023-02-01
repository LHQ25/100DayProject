package com.demo.request_mapping.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/convert")
public class DataConverter {

    // --------------  @RequestBody  --------------
    @RequestMapping("/c1")
    @ResponseBody
    public String test1(@RequestBody String body) {
        // @RequestBody可以获取请求体，需要在控制器方法设置一个形参，使用@RequestBody进行标识，当前请求的请求体就会为当前注解所标识的形参赋值
        return "参数：" + body;
    }
}
