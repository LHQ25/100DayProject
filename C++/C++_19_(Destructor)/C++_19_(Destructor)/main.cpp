//
//  main.cpp
//  C++_19_(Destructor)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Integer{
public:
    Integer(int i=0){
        m_pi = new int(i);
    }
    void print(void)const{
        cout << *m_pi << endl;
    }
    ~Integer(void){
        cout << "析构函数" << endl;
        delete m_pi;
    }
private:
    int* m_pi;
};

class A{
public:
    A(void){
        cout << "A(void)" << endl;
    }
    ~A(void){
        cout << "~A(void)" << endl;
    }
};
class B{
public:
    B(void){
        cout << "B(void)" << endl;
    }
    ~B(void){
        cout << "~B(void)" << endl;
    }
    A m_a;//成员子对象
};

int main(int argc, const char * argv[]) {
    
    if(1){
        Integer i(100);
        i.print();//100
        cout << "test1" << endl;
        Integer* pi = new Integer(200);
        pi->print();//200
        delete pi;//->析构函数
        cout << "test3" << endl;
    }//->析构函数
    cout << "test2" << endl;
    
    //子对象的析构函数  注意看先后顺序
    B b;
    
    return 0;
}
//MARK: - 析构函数(Destructor)
//MARK: -  1 语法
/**
    class 类名{
        ~类名(void){
            //主要负责清理对象生命周期中的动态资源
        }
    };
    1）函数名必须是"~类名"
    2）没有返回类型，也没有参数
    3）不能被重载，一个类只能有一个析构函数、
 */
//MARK: -  2 当对象被销毁时，相应类的析构函数将被自动执行
 /**
1）栈对象当其离开所在作用域时，其析构函数被作用域终止“右化括号”调用
2）堆对象的析构函数被delete操作符调用
 */
//MARK: -  3 如果一个类自己没有定义析构函数，那么编译器会为该类提供一个缺省的析构函数：
 /**
1）对基本类型的成员变量，什么也不做
2）对类 类型的成员(成员子对象)，将会自动调用相应类的析构函数.
 */
//MARK: - 4 对象创建和销毁的过程
 /**
1）创建
--》分配内存
--》构造成员子对象(按声明顺序)
--》执行构造函数代码
2）销毁
--》执行析构函数代码
--》析构成员子对象(按声明逆序)
--》释放内存
 */
