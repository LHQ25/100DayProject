package com.demo.request_mapping.entity;

public class LoginInfo {

    private Integer id;
    private String userName;
    private Integer gender;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public LoginInfo(Integer id, String userName, Integer gender) {
        this.id = id;
        this.userName = userName;
        this.gender = gender;
    }

    @Override
    public String toString() {
        return "LoginInfo{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", gender=" + gender +
                '}';
    }
}
