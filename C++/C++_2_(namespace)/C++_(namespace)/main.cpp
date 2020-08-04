//
//  main.cpp
//  C++_(namespace)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>



namespace ns1 {
void func(){
    std::cout << "ns1的func" << std::endl;
}
}
namespace ns2 {
void func(){
    std::cout << "ns2的func" << std::endl;
}
}

namespace ns3 {
void func(){
    std::cout << "ns3的func" << std::endl;
}
}

namespace ns4 {
void func(){
    std::cout << "ns4的func" << std::endl;
}
}

using namespace ns3;

int main(int argc, const char * argv[]) {
    
    //名字空间成员不能直接访问 可以通过作用域限定符"::"访问
    ns1::func(); //ns1的func
    ns2::func(); //ns2的func
    func();  //ns3的func
    
    
    
    //错误使用
    //using namespace ns1;
    //func(); //不知道是使用ns3的func 还是ns1的func
    
    return 0;
}

//MARK: - 1 名字空间作用
//1）避免名字冲突
//2）划分逻辑单元

//MARK: - 2 定义
/**namespace 名字空间名{
    名字空间成员1;
    名字空间成员2;
    ...
}
注：名字空间成员可以是全局函数、全局变量、类型、名字空间.
*/

//MARK: - 3 名字空间成员使用
/**
1）作用域限定操作符"::"
    名字空间名::要访问的成员;
    eg:
    std::cout //指定访问标准名字空间里面的cout
2）名字空间指令
    using namespace 名字空间名;
    注：在该条指令以后的代码中，指定名字空间的成员都可见，可以直接访问，省略"名字空间名::".
    eg:
    using namespace std;
    cout << a;//ok
3）名字空间声明
    using 名字空间名::名字空间成员;
    注：将名字空间中特定的一个成员引入到当前作用域，在该作用域访问这个成员就如同访问自己的局部成员一样，可以直接访问，省略"名字空间名::"
*/
//MARK: - 4 全局作用域和匿名名字空间//了解
/**
1）没有放在任何名字空间的成员属于全局作用域，可以直接访问，但如果和局部作用域的成员名字一样，局部优先；这时如果还希望访问全局作用域的成员可以通过“::xx”显式访问。
2）定义名字空间时可以没有名字，即为匿名名字空间，匿名空间中成员和全局作用域类似，可以直接访问，也可以通过"::xx"显式的访问，唯一的区别匿名空间的成员被局限在当前文件中使用。
*/
//MARK: - 5 名字空间的嵌套与合并//了解
/**
1）名字空间嵌套
eg:
    namespace ns1{
        int num = 100;
        namespace ns2{
            int num = 200;
            namespace ns3{
                int num = 300;
            }
        }
    }
    cout << ns1::num << endl;//100
    cout << ns1::ns2::num << endl;//200
    cout << ns1::ns2::ns3::num << endl;//300
2）名字空间合并：两个同名的空间会自动合并成一个
    namespace ns{//1.cpp
        void func1(void){...}
    }
    namespace ns{//2.cpp
        void func2(void){...}
    }
*/
