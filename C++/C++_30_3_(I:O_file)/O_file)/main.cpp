//
//  main.cpp
//  O_file)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <fstream>
using namespace std;


int main(int argc, const char * argv[]) {
    
    
    //输出(写)
    /* FILE* fp = fopen("file.txt","w");
     * fprintf(fp,"123 4.56");
     * fclose(fp); */
    ofstream ofs("file.txt");
    ofs << 123 << ' ' << 4.56 << endl;
    ofs.close();
    
    //输入(读)
    int i=0;
    double d=0.0;
    /* FILE* fp = fopen("file.txt","r");
     * fscanf(fp,"%d %lf",&i,&d);
     * fclose(fp); */
    ifstream ifs("file.txt");
    ifs >> i >> d;
    ifs.close();
    cout << "从文件中读到:" << i << "," << d << endl;
    
    return 0;
}
//文件流
//#include <fstream>
//ifstream //类似fscanf
//ofstream //类似fprintf
