package com.imooc.reader.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.imooc.reader.entity.Book;
import com.imooc.reader.service.BookService;
import com.imooc.reader.utils.ResponseUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/api/book")
public class BookController {

    @Resource
    private BookService bookService;

    @GetMapping("list")
    public ResponseUtils list(Integer page, Long categoryId, String order){
        ResponseUtils resp = null;

        try {
            IPage page1 = bookService.selectPage(page, categoryId, order, 10);
            resp = new ResponseUtils().put("page", page1);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }

        return resp;
    }

    @GetMapping("/id/{bookId}")
    public ResponseUtils bookDetail(@PathVariable(value = "bookId") Long bookId){
        ResponseUtils resp = null;
        try {
            Book book = bookService.bookDetail(bookId);
            resp = new ResponseUtils().put("book", book);
        } catch (Exception e) {
            e.printStackTrace();
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }

        return resp;
    }

}
