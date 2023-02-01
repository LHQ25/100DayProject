package com.demo.request_mapping.controller;

import com.demo.request_mapping.entity.LoginInfo;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/mvc_params")
public class MVCRequestParamsController {

    // --------------  SpringMVC 获取请求参数  --------------
    /*
    获取请求的方式有两种：
        通过 Servlet API 获取（不推荐）
        通过控制器方法获取（就是要用它，不然学 SpringMVC 干什么，不是）

    SpringMVC 获取请求参数的注解：@RequestParam、@RequestHeader、@CookieValue
        都是作用在控制器方法上的形参的（就是获取请求参数的，还能作用在别的地方？）
        都有三个属性：value/name、required、defaultValue（这不是四个吗？呸）
        主要解决形参和请求参数名不同名的问题，其次是必填问题，最后是缺省值的问题

    如果请求参数与控制器方法形参同名，就可以不用上述的@RequestParam注解
    如果请求参数有多个值，通过字符串类型或字符数组类型都可以获取
    如果请求参数与控制器方法形参对象属性同名，同理。即满足同名条件时，SpringMVC 中允许通过实体类接收请求参数
     */

    // --------------  通过 Servlet API 获取  --------------
    @RequestMapping("/params")
    @ResponseBody
    public String test1(HttpServletRequest servletRequest) {
        String name = servletRequest.getParameter("name");
        String pwd = servletRequest.getParameter("pwd");

        // SpringMVC 的 IOC 容器帮我们注入了HttpServletRequest请求对象，
        // 同时DispatherServlet为我们调用 testServletAPI() 方法时自动给request参数赋了值，
        // 因此可以在方法形参位置传入请求对象HttpServletRequest就可以直接使用其getParameter()方法获取参数
        return "请求参数：" + name + pwd;
    }

    // --------------  通过控制器方法形参获取  --------------
    // 同名形参
    @RequestMapping("/params2")
    @ResponseBody
    public String test2(String name, String pwd) {
        // 在控制器方法的形参位置，设置和请求参数同名的形参，当浏览器发送请求，匹配到请求映射时，在DispatcherServlet中就会将请求参数赋值给相应的形参

        // 在@RequestMapping注解的“路径中的占位符”一节中，我们测试过了 restful 风格在不使用@PathVariable转而通过同名形参的方式，试图获取占位符的值，
        // 不过 SpringMVC 并没有很智能地给我们为同名参数赋值。但是这里 SpringMVC 允许我们使用同名形参为请求参数赋值。这是占位符和请求参数的一个区别，需要注意区分！！！
        return "请求参数：" + name + pwd;
    }

    // 同名形参多值
    @RequestMapping("/params3")
    @ResponseBody
    public String test3(String name, String pwd, String hobby, String[] hobby2) {
        // 若请求所传输的请求参数中有多值情况，此时可以在控制器方法的形参中设置字符串数组或者字符串类型的形参接收此请求参数
        // hobby2: 若使用字符串数组类型的形参，此参数的数组中包含了每一个数据
        // hobby: 若使用字符串类型的形参，此参数的值为每个数据中间使用逗号拼接的结果
        return "请求参数：" + name + pwd + hobby + hobby2.toString();
    }

    // --------------  @RequestParam获取  --------------
    @RequestMapping("/params4")
    @ResponseBody
    public String test4(String name, @RequestParam("nick_name") String nickName, @RequestParam(required = true, defaultValue = "aaaa") String pwd) {
        // @RequestParam是将请求参数和控制器方法的形参创建映射关系
        //一共有三个属性：
        //  value：指定为形参赋值的请求参数的参数名
        //  required：设置是否必须传输此请求参数，默认值为true
        //      若设置为true，则当前请求必须传输value所指定的请求参数，若没有传输该请求参数，且没有设置defaultValue属性，则页面报错400：Required String parameter'xxx'is not present；
        //      若设置为false，则当前请求不是必须传输value所指定的请求参数，若没有传输，则注解所标识的形参的值为null
        //  defaultValue：不管required属性值为true或false，当value所指定的请求参数没有传输或传输的值为空值时，则使用默认值为形参赋值
        return "请求参数：" + name + nickName + pwd;
    }

    // --------------  @RequestHeader & @CookieValue  --------------
    // 针对的对象不同，用法同获取 params 一致

    // --------------  通过实体类获取  --------------
    @RequestMapping("/params5")
    @ResponseBody
    public String test5(LoginInfo login) {
        // 可以在控制器方法的形参位置设置一个实体类类型的形参，此时浏览器传输的请求参数的参数名和实体类中的属性名一致，那么请求参数就会为此属性赋值
        return "请求参数：" + login.toString();
    }

    // --------------  处理乱码问题  --------------
    // 注意：在 Servlet 阶段，是通过request.setCharacterEncoding("UTF-8");的方式解决乱码问题的。
    // 虽然 SpringMVC 中可以使用HttpServletRequest对象，但是没有效果。原因也很简单，是因为请求参数获取在前，设置编码格式在后
    // 要想处理乱码问题，思路有二：
    //      获取请求参数之后，手动解码编码。但是这种方式要求每次处理post请求的请求参数都要手动处理，太不人性化了吧。你嫌烦，我还嫌烦呢（❌）
    //      获取请求参数之前“做手脚”：发送请求之前，也就是在Servlet处理请求之前（👌）
    //那什么组件时在Servlet之前执行的呢？
    //众所周知 （我不知道），JavaWeb 服务器中三大组件：监听器、过滤器、Servlet。很显然，监听器和过滤器都在Servlet之前
    //      ServletContextListener监听器：只是来监听ServletContext的创建和销毁，都是只执行一次
    //      Filter过滤器：只要设置了过滤路径，只要当前所访问的请求地址满足过滤路径，那么都会被过滤器过滤
    //
    //很显然，用过滤器就可以做到在发送请求之前“做手脚”，这样所有请求都要经过过滤器的处理，再交给DispatherServlet处理
    //但是，这个过滤不需要我们写，SpringMVC 已为我们准备好了，只要再web.xml中进行配置即可
}
