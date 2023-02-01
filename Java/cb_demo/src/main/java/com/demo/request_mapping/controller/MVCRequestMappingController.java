package com.demo.request_mapping.controller;

import com.demo.request_mapping.entity.LoginInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
//@RequestMapping标识一个类：设置映射请求的请求路径的初始信息
@RequestMapping("/mvc")
public class MVCRequestMappingController {

    /*
    @RequestMapping注解
        功能：将请求和处理请求的控制器方法关联起来，建立映射关系
        位置：作用在类上（请求路径的初始信息）；作用在方法上（请求路径的具体信息）
        value属性：可以匹配多个请求路径，匹配失败报404
        method属性：支持GET、POST、PUT、DELETE，默认不限制，匹配失败报405
        params属性：四种方式，param、!param、param==value、param!=value，匹配失败报400
        headers属性：四种方式，header、!header、header==value、header!=value，匹配失败报400
        支持 Ant 风格路径：?（单个字符）、*（0 或多个字符）和**（0 或多层路径）
        支持路径中的占位符：{xxx}占位符、@PathVariable赋值形参
     */

    // @RequestMapping标识一个方法：设置映射请求的请求路径的具体信息
    @RequestMapping("/rm")
    @ResponseBody
    public String test1() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/rm";
    }

    // --------------  value  --------------
    // @RequestMapping注解的value属性必须设置：至少通过一个请求地址匹配请求映射
    // @RequestMapping注解的value属性: 通过请求的请求地址匹配请求映射
    @RequestMapping(value = "/value1")
    @ResponseBody
    public String test2() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/value2";
    }

    // @RequestMapping注解的value属性: 是一个字符串类型的数组，表示该请求映射能够匹配多个请求地址所对应的
    @RequestMapping(value = {"/value2", "/v2", "/v22"})
    @ResponseBody
    public String test3() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/value3";
    }

    // --------------  method  --------------
    // @RequestMapping注解的method属性: 请求方式（GET或POST）匹配请求映射{GET、POST、PUT、DELETE}
    @RequestMapping("/method")
    @ResponseBody
    public String test4() {
        // 控制器方法不添加method属性时，可以接收GET和POST的请求
        // 默认也支持PUT和DELETE请求
        // 不过，PUT和DELETE请求比较特殊，需要使用到隐藏域，且method固定为POST
        // 在web.xml中需要添加隐藏域请求方式的过滤器配置
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/method";
    }

    // @RequestMapping注解的method属性: 不满足 method
    @RequestMapping(value = "/method2", method = {RequestMethod.POST})
    @ResponseBody
    public String test5() {
        // 浏览器报错 -> HTTP Status 405 - Request method 'POST' not supported
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/method2";
    }

    // @RequestMapping注解的method属性: 处理指定请求方式的控制器方法，SpringMVC 中提供了@RequestMapping的派生注解
    // @PostMapping("/method3") //  === @RequestMapping(value = "/method3", method = {RequestMethod.POST})
    @GetMapping("/method3") //  === @RequestMapping(value = "/method3", method = {RequestMethod.GET})
    @ResponseBody
    public String test6() {
        // 处理PUT请求的映射->@PutMapping
        // 处理DELETE请求的映射->@DeleteMapping
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/method3";
    }

    // --------------  params  --------------
    // @RequestMapping注解的params属性: 通过请求的请求参数匹配请求映射
    @GetMapping(value = "/params1", params = {"v"})
    @ResponseBody
    public String test7() {
        // 配置了params属性并指定相应的请求参数时，请求中必须要携带相应的请求参数信息，
        // 否则前台就会报抛出400的错误信息 HTTP Status 400：Parameter conditions "username" not met for actual request parameters
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/params1";
    }

    // @RequestMapping注解的params属性:  = 要求请求中不仅要携带 v 的请求参数，且值为 1
    @GetMapping(value = "/params2", params = {"v=1"})
    @ResponseBody
    public String test8() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/params2";
    }

    // @RequestMapping注解的params属性:  ! 标识取反，不能携带该参数进行请求
    @GetMapping(value = "/params3", params = {"s", "!a"})
    @ResponseBody
    public String test9() {
        // 要求请求中的请求参数中不能携带username请求参数
        // 否则 HTTP Status 400：Parameter conditions "!username" not met for actual request parameters: username={admin}, password={123456}
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/params3";
    }

    // @RequestMapping注解的params属性:  != ，要求请求中不仅要携带 a 的请求参数，且值不能为 2
    @GetMapping(value = "/params4", params = {"s", "a!=2"})
    @ResponseBody
    public String test10() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/params4";
    }

    // --------------  headers 属性  --------------
    // @RequestMapping注解的headers属性通过请求的请求头信息匹配请求映射
    // 它是一个字符串类型的数组，可以通过四种表达式设置请求头信息和请求映射的匹配关系

    // 和 params 类似，不过针对的是请求头中的内容

    // header：要求请求映射所匹配的请求必须携带header请求头信息
    // !header：要求请求映射所匹配的请求必须不能携带header请求头信息
    // header=value：要求请求映射所匹配的请求必须携带header请求头信息且header=value
    // header!=value：要求请求映射所匹配的请求必须携带header请求头信息且header!=value

    // --------------  Ant 风格路径  --------------
    // ?：表示任意的单个字符
    @GetMapping(value = "/a?a/any")
    @ResponseBody
    public String test11() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/a?a/any";
    }

    // *：表示任意的0个或多个字符
    @GetMapping(value = "/b*b/any")
    @ResponseBody
    public String test12() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/b*b/any";
    }

    // **：表示任意的一层或多层目录。注意：在使用**时，只能使用/**/xxx的方式, 0 层目录也可以，这里严谨来说，应该是“表示任意层目录
    @GetMapping(value = "/c**c/any")
    @ResponseBody
    public String test13() {
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/c**c/any";
    }


    // --------------  路径中的占位符  --------------
    // 原始方式：/deleteUser?id=1
    // rest 方式：/deleteuser/11

    // SpringMVC 路径中的占位符常用于 restful 风格中，当请求路径中将某些数据通过路径的方式传输到服务器中，
    // 就可以在相应的@RequestMapping注解的value属性中通过占位符{xxx}表示传输的数据，再通过@PathVariable注解，将占位符所表示的数据赋值给控制器方法的形参

    // 路径中的占位符：无注解形参
    @RequestMapping(value = "/test/{id}/{name}")
    @ResponseBody
    public String test14(String id, String name) {
        // 请求能够匹配成功，但是同名形参无法接收到占位符的值
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/test/{id}/{name} " + " params：" + id + " - " + name;
    }

    // 路径中的占位符：带注解形参
    @RequestMapping(value = "/test2/{id}/{name}")
    @ResponseBody
    public String test15(@PathVariable("id") String id, @PathVariable("name") String name) {
        // 请求能够匹配成功，形参通过@PathVariable注解接收到了占位符的值
        return "访问完整接口：http://localhost:8080/cb_demo_war_exploded/mvc/test/{id}/{name} " + " params：" + id + " - " + name;
    }

    // 路径中的占位符：不设置占位符
    // 有占位符时，直接显示了404错误，即表示路径中存在占位符的控制器方法不能匹配未设置占位符的请求
    // 也就是说，路径中存在占位符的控制器方法，只能接收带了对应占位符的请求

    // 路径中的占位符：占位符为空值或空格
    // 空值匹配失败，报了404错误
    // 空格匹配成功，路劲中对其解析成了对应的URL编码，即%20
}
