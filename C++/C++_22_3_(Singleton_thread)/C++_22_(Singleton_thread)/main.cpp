//
//  main.cpp
//  C++_22_(Singleton_thread)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Singleton{//单例模式--懒汉式
public:
    //3)通过静态成员函数获取单例对象
    static Singleton& getInstance(void){
        pthread_mutex_lock(&mutex);
        if(s_instance == NULL){
            s_instance = new Singleton(123);
        }
        ++s_count;
        pthread_mutex_unlock(&mutex);
        return *s_instance;
    }
    //单例对象不用即销毁,销毁时机?
    //最后一个使用者不在使用才能真的销毁!
    void release(void){
        pthread_mutex_lock(&mutex);
        if(--s_count == 0){
            delete s_instance;
            s_instance = NULL;
        }
        pthread_mutex_unlock(&mutex);
    }
    void print(void){
        cout << m_data << endl;
    }
private:
    //1)私有化构造函数(包括拷贝构造)
    Singleton(int data=0):m_data(data){
        cout << "单例对象被创建了" << endl;
    }
    Singleton(const Singleton&);
    ~Singleton(void){
        cout << "单例对象被销毁了" << endl;
    }
    //2)使用静态成员变量维护唯一的对象
    static Singleton* s_instance;
    //计数:记录单例对象使用者个数
    static int s_count;
    //互斥所
    static pthread_mutex_t mutex;
private:
    int m_data;
};
Singleton* Singleton::s_instance=NULL;
int Singleton::s_count = 0;
pthread_mutex_t Singleton::mutex = PTHREAD_MUTEX_INITIALIZER;

int main(int argc, const char * argv[]) {
    
    cout << "main函数开始执行" << endl;
    //Singleton s(100);//error
    //Singleton* ps=new Singleton(100);//error
    
    Singleton& s1=Singleton::getInstance();
    Singleton& s2=Singleton::getInstance();
    Singleton& s3=Singleton::getInstance();
    
    s1.print();//123
    s1.release();//--s_count:2

    s2.print();//123
    s3.print();//123

    cout << "&s1:" << &s1 << endl;
    cout << "&s2:" << &s2 << endl;
    cout << "&s3:" << &s3 << endl;

    s2.release();//--s_count:1
    s3.release();//--s_count:0,delete
    return 0;
}
