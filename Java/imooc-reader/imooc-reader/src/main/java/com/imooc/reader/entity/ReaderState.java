package com.imooc.reader.entity;

import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

@TableName("member_read_state")
public class ReaderState {
    private Long rsId;
    private Long bookId;
    private Long memberId;
    private Integer readState;
    private Date createTime;

    public ReaderState() {
    }

    public ReaderState(Long rsId, Long bookId, Long memberId, Integer readState, Date createTime) {
        this.rsId = rsId;
        this.bookId = bookId;
        this.memberId = memberId;
        this.readState = readState;
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "ReaderState{" +
                "rsId=" + rsId +
                ", bookId=" + bookId +
                ", memberId=" + memberId +
                ", readState=" + readState +
                ", createTime=" + createTime +
                '}';
    }

    public Long getRsId() {
        return rsId;
    }

    public void setRsId(Long rsId) {
        this.rsId = rsId;
    }

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Integer getReadState() {
        return readState;
    }

    public void setReadState(Integer readState) {
        this.readState = readState;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
