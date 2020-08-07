//
//  main.cpp
//  C++_29_2_(Exception)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

using namespace std;
class ErrorA{};
class ErrorB:public ErrorA{};
void func(void){
    throw ErrorA();
    //throw ErrorB();
}


int main(int argc, const char * argv[]) {
    try{
        func();
    }
    catch(ErrorB& ex){
        cout << "针对ErrorB异常处理" << endl;
    }
    catch(ErrorA& ex){
        cout << "针对ErrorA异常处理" << endl;
    }
    return 0;
}
//MARK: - 异常检测和捕获
//try{
//     可能引发异常的语句;
//}
//catch(异常类型1){
//     针对异常类型1数据的处理.
//}
//catch(异常类型2){
//     针对异常类型2数据的处理.
//}
//...
//
//注：catch子句根据异常对象的类型自上而下顺序匹配，而不是最优匹配，因此对子类异常捕获语句要写在前面，否则会被基类异常捕获语句提前截获。
