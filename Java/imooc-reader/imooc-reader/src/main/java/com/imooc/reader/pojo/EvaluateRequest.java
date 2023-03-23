package com.imooc.reader.pojo;

public class EvaluateRequest {

    private Long memberId;
    private Long bookId;
    private int score;
    private String content;

    public EvaluateRequest() {
    }

    public EvaluateRequest(Long memberId, Long bookId, int score, String content) {
        this.memberId = memberId;
        this.bookId = bookId;
        this.score = score;
        this.content = content;
    }

    @Override
    public String toString() {
        return "EvaluateRequest{" +
                "memberId=" + memberId +
                ", bookId=" + bookId +
                ", score=" + score +
                ", content='" + content + '\'' +
                '}';
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

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
