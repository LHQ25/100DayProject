package com.imooc.reader.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.imooc.reader.entity.Book;
import com.imooc.reader.mapper.BookMapper;
import com.imooc.reader.pojo.Books;
import com.imooc.reader.service.BookService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

@Service
@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
public class BookServiceImpl implements BookService {

    @Resource
    private BookMapper bookMapper;
    @Override
    public IPage<Book> selectPage(Integer page, Long categoryId, String order, Integer rows) {

        Page<Book> p = new Page<>();
        p.setCurrent(page);
        p.setSize(rows);

        QueryWrapper<Book> queryWrapper = new QueryWrapper<>();
        if (categoryId != -1) {
            queryWrapper.eq("category_id", categoryId);
        }
        if (order.equals("quantity")) {
            queryWrapper.orderByAsc("evaluation_quantity");
        } else {
            queryWrapper.orderByAsc("evaluation_score");
        }

        return bookMapper.selectPage(p, queryWrapper);
    }

    @Override
    public Book bookDetail(Long bookId) {

        QueryWrapper<Book> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("book_id", bookId);
        return bookMapper.selectOne(queryWrapper);
    }

    @Override
    public IPage<Books> bookPage(IPage page) {
        IPage page1 = bookMapper.bookPage(page);
        return page1;
    }

    @Override
    public Book bookUpdate(Book book) {

        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("book_id", book.getBookId());
        Book oldBook = bookMapper.selectOne(queryWrapper);
        oldBook.setBookName(book.getBookName());
        oldBook.setSubTitle(book.getSubTitle());
        oldBook.setDescription(book.getDescription());
        oldBook.setAuthor(book.getAuthor());
        bookMapper.updateById(oldBook);
        return oldBook;
    }

    @Override
    public void bookDelete(Long bookId) {

        QueryWrapper queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("book_id", bookId);
        bookMapper.delete(queryWrapper);
    }

    @Override
    public void bookCreate(Book book) {

        book.setBookId(null);
        book.setCover("qwer");
        book.setEvaluationScore(0F);
        bookMapper.insert(book);
    }
}
