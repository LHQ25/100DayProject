//
//  main.cpp
//  C++_6_(String)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

int main(int argc, const char * argv[]) {
    
    string str;
    
    int count = 0;
    cout << "Please input a string:" << endl;
    cin >> str;
    
    for (int i = 0; i < str.length(); i++) {
        if (str[i] == 'y' || str[i] == 'Y') {
            ++count;
        }
    }
    cout << "Y/y count:"  << count << endl;
    
    string str2 = str;
    cout << "复制第一个字符串 = :"  << str2 << endl;
    
    string str3 = str + " - "+ str2;
    cout << "字符串连接 + :"  << str3 << endl;
    
    string str4 = "str4__";
    str4 += str2;
    cout << "字符串连接 + :"  << str4 << endl;
    
    string str5 = "dagrger";
    bool res = str4 == str5;
    cout << "字符串比较 == :"  << res << endl;
    
    string str6 = "zcajwhqwlekjqwlkfe";
    str6[0] = 'A';
    str6[2] = 'D';
    cout << "字符串通过下标访问字符 == :"  << str6 << endl;
    
    
    return 0;
}

//MARK: - C++的字符串
//MARK: - 1 回顾C语言中的字符串
//1）字面值常量字符串: "..."
//2）字符指针：char*
//3）字符数组：char[]

//MARK: - 2 C++兼容C风格的字符串，同时增加了string类型，专门字符串：
/**
1）定义
    string s1;//定义空字符串
    string s2 = "xx";//定义同时初始化
2）字符串拷贝：=
    string s1 = "youcw";
    string s2 = "mindasheng";
    s1 = s2;//将s2拷贝给s1
    cout << s1 << endl;//"mindasheng"
3）字符串连接：+ +=
    string s1 = "hello";
    string s2 = " world";
    string s3 = s1 + s2;
    cout << s3 << endl;//"hello world"
4）字符串比较：== != > >= < <=
    if(s1 == s2){...}
5）随机访问: []
    string s = "minwei";
    s[0] = 'M';
    s[3] = 'W';
    cout << s << endl;//MinWei
6）暂时可以string理解为是"结构体"类型，里面包含了很多成员函数，常用的：
    size()/length();//获取字符串长度
    c_str();//返回字符串的起始地址(const char*)
eg:
    string str = "youcw";
    str.size();//5
    str.length();//5和size()等价
    ------------------
    string s1 = "hello";//C++风格
    const char* s2 = "world";//C风格
    
    s1 = s2;//ok
    s2 = s1;//error
    s2 = s1.c_str();
*/
