//
//  main.cpp
//  C++_30_4_(IO_二进制)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <fstream>
using namespace std;

int main(int argc, const char * argv[]) {
    
    
    //二进制写
    ofstream ofs("last.txt");
    char wbuf[] = "C++终于结束了!";
    ofs.write(wbuf,sizeof(wbuf));
    ofs.close();

    //二进制读
    ifstream ifs("last.txt");
    char rbuf[100] = {0};
    ifs.read(rbuf,sizeof(rbuf));
    cout << "从文件中读到数据:" << rbuf << endl;
    ifs.close();
    return 0;
}

//二进制I/O
////类似fread
//istream& istream::read(char* buffer,streamsize num);
////类似fwrite
//ostream& ostaream::write(const char* buffer,size_t num);
