package com.imooc.reader.utils;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;

public class ResponseUtils {

    private String code;
    private String message;
    private Map data = new LinkedHashMap<>();

    public ResponseUtils(){
        this.code = "200";
        this.message = "success";
    }

    public ResponseUtils(String code, String message){
        this.code = code;
        this.message = message;
    }

    public ResponseUtils put(String key, Object value){
        this.data.put(key, value);
        return this;
    }

    @Override
    public String toString() {
        return "ResponseUtils{" +
                "code='" + code + '\'' +
                ", message='" + message + '\'' +
                ", data=" + data +
                '}';
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map getData() {
        return data;
    }

    public void setData(Map data) {
        this.data = data;
    }
}
