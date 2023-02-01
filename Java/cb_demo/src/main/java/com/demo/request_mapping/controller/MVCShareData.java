package com.demo.request_mapping.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

import java.util.Map;

@Controller
@RequestMapping("/share")
public class MVCShareData {

    /*
    域对象有三种：request（请求域）、session（会话域）和application（上下文）
        向request域对象共享数据方式：本质都是ModelAndView

        Servlet API（不推荐）：HttpServletRequest
        ModelAndView：需要返回自身
        Model、Map、ModelMap：本质都是BindingAwareModelMap

        向session域共享数据：HttpSession
        向application域共享数据：ServletContext
     */

    // --------------  向 request 域对象共享数据  --------------
    // 通过 Servlet API
    @RequestMapping("servletApiData")
    public String test1(HttpServletRequest request) {
        request.setAttribute("toRequestScope", "Servlet Api");
        return "index";
    }

    // 通过 ModelAndView
    @RequestMapping("mvData")
    public ModelAndView test2() {
        // 在 SpringMVC 中，不管用的何种方式，本质上最后都会封装到ModelAndView。同时要注意使用ModelAndView向 request 域对象共享数据时，需要返回ModelAndView自身
        /*
          ModelAndView有Model和View两个功能
          Model用于向请求域共享数据
          View用于设置视图，实现页面跳转
         */
        ModelAndView mv = new ModelAndView();
        //向请求域共享数据
        mv.addObject("testRequestScope", "hello, ModelAndView!");
        //设置视图，实现页面跳转
        mv.setViewName("index");
        return mv;
    }

    // 通过 Model
    @RequestMapping("modelData")
    public String test3(Model model) {
        //向请求域共享数据
        model.addAttribute("toRequestScope", "Servlet Api");
        return "index";
    }

    // 通过 ModelMap
    @RequestMapping("modelMapData")
    public String test4(ModelMap modelMap) {
        //向请求域共享数据
        modelMap.addAttribute("toRequestScope", "Servlet Api");
        return "index";
    }

    // 通过 Map -> 形式与Model方式类似
    @RequestMapping("mapData")
    public String test5(Map<String, Object> map) {
        //向请求域共享数据
        map.put("toRequestScope", "Servlet Api");
        return "index";
    }

    // 结论： Model、Map、ModelMap类型的形参本质上都是BindingAwareModelMap


    // --------------  向 session 域共享数据  --------------
    @RequestMapping("sessionData")
    public String test6(HttpSession session) {
        // 形式与HttpServletRequest方式类似，形参为HttpSession。
        // 需要注意的是 SpringMVC 虽然提供了一个@SessionAttribute注解，但并不好用，因此反而建议直接使用原生 Servlet 中的HttpSession对象
        session.setAttribute("toRequestScope", "Servlet Api");
        return "index";
    }

    // --------------  向 application 域共享数据  --------------
    @RequestMapping("applicationData")
    public String test7(HttpSession session) {
        // 形式与HttpSession方式类似，只不过需要先从session对象中获取ServletContext上下文对象，即application域对象，再做操作
        ServletContext application = session.getServletContext();
        application.setAttribute("toRequestScope", "applicationData");
        return "index";
    }
}
