package com.imooc.reader.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.imooc.reader.entity.Book;
import com.imooc.reader.service.BookService;
import com.imooc.reader.utils.ResponseUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/api/management/book")
public class ManagementController {

    @Resource
    private BookService bookService;

    @GetMapping("/list")
    public ResponseUtils bookList(Integer page){
        ResponseUtils resp = null;

        try {
            Page p = new Page<>(page, 10);
            IPage page1 = bookService.bookPage(p);
            resp = new ResponseUtils().put("list", page1.getRecords()).put("count", page1.getTotal());
        } catch (Exception e) {
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @PostMapping("/update")
    public ResponseUtils bookUpdate(Book book){
        ResponseUtils resp = null;
        try {
            Book b = bookService.bookUpdate(book);
            resp = new ResponseUtils();
        } catch (Exception e) {
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @PostMapping("/delete")
    public ResponseUtils bookDelete(Long bookId){
        ResponseUtils resp = null;
        try {
            bookService.bookDelete(bookId);
            resp = new ResponseUtils();
        } catch (Exception e) {
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @PostMapping("/create")
    public ResponseUtils bookCreate(Book book){
        ResponseUtils resp = null;
        try {
            bookService.bookCreate(book);
            resp = new ResponseUtils();
        } catch (Exception e) {
            resp = new ResponseUtils(e.getClass().getSimpleName(), e.getMessage());
        }
        return resp;
    }

    @PostMapping("/upload")
    public String bookUploadImage() {

        return "";
    }
}
