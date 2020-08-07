//
//  main.cpp
//  C++_26_3_(虚函数)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Shape{//图形基类,抽象类,纯抽象类
public:
    Shape(int x = 0,int y = 0):m_x(x),m_y(y){}
    virtual void draw(void) = 0;//纯虚函数
protected:
    int m_x;//x坐标
    int m_y;//y坐标
};


class Rect:public Shape{//矩形子类
public:
    Rect(int x,int y,int w,int h):Shape(x,y),m_w(w),m_h(h){}
    void draw(void){//自动变成虚函数
        cout << "绘制矩形:" << m_x << "," << m_y << "," << m_w
            << "," << m_h << endl;
    }
private:
    int m_w;//宽度
    int m_h;//高度
};
class Circle:public Shape{//圆形子类
public:
    Circle(int x,int y,int r):Shape(x,y),m_r(r){}
    void draw(void){//自动变成虚函数
        cout << "绘制圆形:" << m_x << "," << m_y << "," << m_r
            << endl;
    }
private:
    int m_r;
};
void render(Shape* buf[]){
    //正常通过指针调用成员函数根据指针的类型去调用;但是如果调用的是
    //虚函数,不再根据指针本身类型而是根据实际指向的目标对象类型调用
    for(int i=0;buf[i]!=NULL;i++)
        buf[i]->draw();
}
int main(int argc, const char * argv[]) {
    
    Shape* buf[1024] = {NULL};
    buf[0] = new Rect(1,2,3,4);
    buf[1] = new Circle(5,6,7);
    buf[2] = new Rect(11,22,13,14);
    buf[3] = new Circle(15,16,71);
    buf[4] = new Rect(8,12,33,41);
    buf[5] = new Circle(18,66,9);
    render(buf);
    return 0;
}
