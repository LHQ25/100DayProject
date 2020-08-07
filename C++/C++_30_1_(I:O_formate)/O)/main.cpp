//
//  main.cpp
//  O)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <iomanip>
using namespace std;
int main(int argc, const char * argv[]) {
    
    
    cout << 100/3.0 << endl;
        //cout.precision(10);//格式化函数
        //cout << 100/3.0 << endl;
        
        //流控制符
        //cout << setprecision(10) << 100/3.0 << endl;

    /*
        cout << "[";//格式化函数
        cout.width(10);//域宽
        cout.fill('$');//空白位置使用$填充
        cout.setf(ios::internal);//数据靠右侧,符号为靠左侧
        cout.setf(ios::showpos);//显示正号("+")
        cout << 100 << "]" << endl;
    */
        //全局函数形式
        cout << "[" << setw(10) << setfill('$') << internal << showpos << 100 << "]" << endl;
    
    return 0;
}
//MARK: - I/O流 //了解
//MARK: - 1 主要的I/O流类
//                            ios
//                    /                \
//                istream                ostream
//        /         |        \        /        |        \
//istrstream    ifstream     iostream    ofstream    ostrstream
//
//详细参考官方手册：http://www.cplusplus.com/reference/iolibrary/
//
//MARK: - 2 格式化I/O
//1）格式化函数(本质是成员函数)
//    cout << 100/3.0 << endl;//33.3333
//    -----------------
//    cout.precision(10);//格式化函数
//    cout << 100/3.0 << endl;//33.33333333
//
//2）流控制符(本质是全局函数)
//    cout << 100/3.0 << endl;//33.3333
//    ------------------
//    #include <iomanip>
//    //流控制符
//    cout << setprecision(10) << 100/3.0 << endl;//33.33333333
//
//MARK: - 3 字符串流
//#include <strstream> //过时，不推荐使用
//istrstream、ostrstream
//
//#include <sstream> //推荐
//istringstream //类似sscanf()
//ostringstream //类似sprintf()
//
//MARK: - 4 文件流
//#include <fstream>
//ifstream //类似fscanf
//ofstream //类似fprintf
//
//MARK: - 5 二进制I/O
////类似fread
//istream& istream::read(char* buffer,streamsize num);
////类似fwrite
//ostream& ostaream::write(const char* buffer,size_t num);
