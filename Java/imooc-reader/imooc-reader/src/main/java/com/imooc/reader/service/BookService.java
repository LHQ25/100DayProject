package com.imooc.reader.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.imooc.reader.entity.Book;
import com.imooc.reader.pojo.Books;

import java.util.List;

public interface BookService {

    public IPage<Book> selectPage(Integer page, Long categoryId, String order, Integer count);

    public Book bookDetail(Long bookId);

    public IPage<Books> bookPage(IPage page);

    public Book bookUpdate(Book book);

    public void bookDelete(Long bookId);

    public void bookCreate(Book book);
}
