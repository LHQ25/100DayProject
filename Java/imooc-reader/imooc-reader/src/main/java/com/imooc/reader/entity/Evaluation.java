package com.imooc.reader.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

@TableName("evaluation")
public class Evaluation {

    @TableId(type = IdType.AUTO)
    private Long evaluationId;
    private String content;
    private Integer score;
    private Date createTime;
    private Long memberId;
    private Long bookId;
    private Integer enjoy;
    private String state;
    private String disableReason;
    private Date disableTime;

    public Evaluation() {
    }

    public Evaluation(Long evaluationId, String content, Integer score, Date createTime, Long memberId, Long bookId, Integer enjoy, String state, String disableReason, Date disableTime) {
        this.evaluationId = evaluationId;
        this.content = content;
        this.score = score;
        this.createTime = createTime;
        this.memberId = memberId;
        this.bookId = bookId;
        this.enjoy = enjoy;
        this.state = state;
        this.disableReason = disableReason;
        this.disableTime = disableTime;
    }

    @Override
    public String toString() {
        return "Evaluation{" +
                "evaluationId=" + evaluationId +
                ", content='" + content + '\'' +
                ", score=" + score +
                ", createTime=" + createTime +
                ", memberId=" + memberId +
                ", bookId=" + bookId +
                ", enjoy=" + enjoy +
                ", state='" + state + '\'' +
                ", disableReason='" + disableReason + '\'' +
                ", disableTime=" + disableTime +
                '}';
    }

    public Long getEvaluationId() {
        return evaluationId;
    }

    public void setEvaluationId(Long evaluationId) {
        this.evaluationId = evaluationId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Integer getEnjoy() {
        return enjoy;
    }

    public void setEnjoy(Integer enjoy) {
        this.enjoy = enjoy;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getDisableReason() {
        return disableReason;
    }

    public void setDisableReason(String disableReason) {
        this.disableReason = disableReason;
    }

    public Date getDisableTime() {
        return disableTime;
    }

    public void setDisableTime(Date disableTime) {
        this.disableTime = disableTime;
    }
}
