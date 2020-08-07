//
//  main.cpp
//  O_String)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <sstream>
using namespace std;
int main(int argc, const char * argv[]) {
    
    
    int i = 123;
    double d = 4.56;
    /* char buf[100] = {0}
     * sprintf(buf,"%d %lf",i,d);*/
    ostringstream oss;
    oss << i << ' ' << d ;
    cout << oss.str() << endl;

    /*  char buf[] = "321 6.54"
     *  int i2=0;
     *  double d2=0.0;
     *  sscanf(buf,"%d %lf",&i2,&d2);*/
    istringstream iss;
    iss.str("321 6.54");
    int i2=0;
    double d2=0.0;
    iss >> i2 >> d2;
    cout << i2 << "," << d2 << endl;
    
    return 0;
}
//MARK: - 流控制符(本质是全局函数)
//cout << 100/3.0 << endl;//33.3333
//------------------
//#include <iomanip>
////流控制符
//cout << setprecision(10) << 100/3.0 << endl;//33.33333333
