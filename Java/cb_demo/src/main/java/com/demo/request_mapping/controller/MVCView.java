package com.demo.request_mapping.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("view")
public class MVCView {

    /*
    SpringMVC 中的视图是View接口，视图的作用渲染数据，将模型Model中的数据展示给用户
    SpringMVC 视图的种类很多，默认有转发视图InternalResourceView和重定向视图RedirectView

    当工程引入jstl的依赖，转发视图会自动转换为JstlView（JSP 内容了解即可）
    若使用的视图技术为Thymeleaf，在 SpringMVC 的配置文件中配置了Thymeleaf的视图解析器，由此视图解析器解析之后所得到的是ThymeleafView

    注意：只有在视图名称没有任何前缀时，视图被Thymeleaf视图解析器解析之后，创建的才是ThymeleafView。
    当视图名称包含前缀（如forward:或redirect:）时，分别对应的时InternalResourceView转发视图和RedirectView重定向视图
     */

    // --------------  ThymeleafView  --------------
    // 当控制器方法中所设置的视图名称没有任何前缀时，此时的视图名称会被 SpringMVC 配置文件中所配置的视图解析器解析，视图名称拼接视图前缀和视图后缀所得到的最终路径，会通过转发的方式实现跳转
    @RequestMapping("/v1")
    public String test() {
        return "index";
    }
}
