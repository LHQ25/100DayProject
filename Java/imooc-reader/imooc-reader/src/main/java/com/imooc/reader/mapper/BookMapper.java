package com.imooc.reader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.imooc.reader.entity.Book;
import com.imooc.reader.pojo.Books;

import java.util.List;

public interface BookMapper extends BaseMapper<Book> {

    public IPage<Books> bookPage(IPage page);
}
