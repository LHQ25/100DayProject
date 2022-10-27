package com.example.retrofitdemo

data class TopArticle(val data: List<Article>, val errorCode: Int, val errorMsg: String)

data class Article(val author: String, val name: String, val children: List<Article>)