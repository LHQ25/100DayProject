package com.imooc.reader.controller;

import com.imooc.reader.entity.Category;
import com.imooc.reader.service.CategoryService;
import com.imooc.reader.utils.ResponseUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/category")
public class CategoryController {

    @Resource
    private CategoryService categoryService;

    @GetMapping("/list")
    public ResponseUtils list() {

        ResponseUtils response = null;
        try {
            List list = categoryService.selectAll();
            response = new ResponseUtils().put("list", list);
        } catch (Exception e) {
            e.printStackTrace();
            response = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return response;
    }

}
