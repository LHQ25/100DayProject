//
//  main.cpp
//  C++_24_(operater_3_array)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;


//简单容器类:里面可以保存若干个int数据
class Array{
public:
    Array(size_t size){
        m_arr = new int[size];
    }
    ~Array(void){
        delete[] m_arr;
    }
    //arr[i] ==> arr.operator[i]
    int& operator[](size_t i){//适用非常对象,返回左值
        return m_arr[i];
    }
    const int& operator[](size_t i)const{//适用常对象,返回右值
        return m_arr[i];
    }
private:
    int* m_arr;
};


int main(int argc, const char * argv[]) {
    
    Array arr(5);
    arr[0] = 123; //arr.operator[](0) = 123
    cout << arr[0] << endl;//123
    
    const Array& arr2 = arr;
    cout << arr2[0] << endl;//ok
    //arr2[0] = 321;//error: Cannot assign to return value because function 'operator[]' returns a const value
    return 0;
}
//MARK: - 下标操作符重载 []
/**
功能：实现自定义类型对象能够像数组一样去使用
注：非常对象返回左值，常对象返回右值
    string s = "minwei";
    s[0] = 'M';//s.operator[](0) = 'M'
    s[3] = 'W';//s.operator[](3) = 'W'
    cout << s << endl;//"MinWei"
    ---------------------------------
    const string s2 = "youchengwei";
    cout << s2[0] << endl;//y
    s2[0] = 'Y';//error
*/
