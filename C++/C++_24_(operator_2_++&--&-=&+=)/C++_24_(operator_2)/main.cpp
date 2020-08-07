//
//  main.cpp
//  C++_24_(operator_2)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
class Integer{
public:
    Integer(int i = 0): m_i(i){}
    
    void print(void) const {
        cout << m_i << endl;
    }
    
    //-(负):成员函数
    const Integer operator-(void) const{
        Integer res(-m_i);
        return res;
    }
    //~:全局函数(自定义表示平方)
    friend const Integer operator~(const Integer& i){
        Integer res(i.m_i * i.m_i);
        return res;
    }
    
    //前++:成员函数形式
    Integer& operator++(void){
        ++m_i;
        return *this;
    }
    //前--:全局函数形式
    friend Integer& operator--(Integer& i){
        --i.m_i;
        return i;
    }
    //后++:成员函数形式
    const Integer operator++(int/*哑元参数*/){
        Integer old = *this;
        ++m_i;
        return old;
    }
    //后--:全局函数形式
    friend const Integer operator--(Integer& i,int/*哑元*/){
        Integer old = i;
        --i.m_i;
        return old;
    }
    //重载输出:<<
    //cout << c1 ==> operator<<(cout,c1)
    friend ostream& operator<<(ostream& os, const Integer& i){
        os << "值是：" << i.m_i;
        return os;
    }
    
    friend istream& operator>>(istream& is, Integer &i){
        cout << "输入值:";
        is >> i.m_i;
        return is;
    }
    
private:
    int m_i;
};


int main(int argc, const char * argv[]) {
    Integer i1(100);
    Integer j1 = -i1;//i.operator-()
    j1.print();//-100

    j1 = ~i1;//operator~(i)
    j1.print();//10000
    
    
    
    Integer i(100);
    Integer j = ++i;//i.operator++()
    i.print();//101
    j.print();//101
    j = --i;//operator--(i)
    i.print();//100
    j.print();//100

    j = i++;//i.operator++(0/*哑元*/)
    i.print();//101
    j.print();//100
    j = i--;//operator--(i,0/*哑元*/)
    i.print();//100
    j.print();//101

    j = ++++++i;
    i.print();//103
    j = ------i;
    i.print();//100

    //j = i++++;//应该error
    //j = i----;//应该error
    
    
    cout << i << endl;
    cin >> j;
    cout << j << endl;
    return 0;
}
