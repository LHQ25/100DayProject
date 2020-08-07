//
//  main.cpp
//  C++_29_4_(Func_Exception)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

using namespace std;
class FileError:public exception{
public:
    //虚函数覆盖时,子类中版本不能说明比基类版本抛出更多的异常
    virtual ~FileError(void) throw() {}
    virtual const char* what(void) const throw(){
        cout << "针对文件的错误处理" << endl;
        return "FileError";
    }
};
class MemoryError:public exception{
public:
    virtual ~MemoryError(void) throw() {}
    virtual const char* what(void) const throw(){
        cout << "针对内存的错误处理" << endl;
        return "MemoryError";
    }
};

int main(int argc, const char * argv[]) {
    
    try{
        //throw FileError();
        //throw MemoryError();
        //new失败抛出异常"throw std::bad_alloc()"
        char* p = new char[0xffffffff];
    }
    catch(exception& ex){
        cout << ex.what() << endl;
    }
    
    return 0;
}
//MARK: - 标准异常类exception
//    vi /usr/include/c++/编译器版本号/exception
//    class exception{
//      public:
//        exception() throw() { }
//        virtual ~exception() throw();
//
//        /* Returns a C-style character string describing the general cause
//           of the current error.  */
//        virtual const char* what() const throw();
//      };
//    注：“_GLIBCXX_USE_NOEXCEPT”即为空异常说明“throw()”
//
//eg：
//    try{
//        func();
//        ...
//    }
//    catch(exception& ex){//可以捕获exception所有子类类型异常对象
//        ex.what();
//    }
