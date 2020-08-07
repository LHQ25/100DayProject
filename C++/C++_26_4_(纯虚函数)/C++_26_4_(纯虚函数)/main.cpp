//
//  main.cpp
//  C++_26_4_(纯虚函数)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

using namespace std;
class PDFParser{
public:
    void parse(const char* pdffile){
        cout << "解析出一行文本" << endl;
        onText();
        cout << "解析出一幅图片" << endl;
        onImage();
        cout << "解析出一个矩形" << endl;
        onRect();
    }
private:
    virtual void onText(void) = 0;
    virtual void onImage(void) = 0;
    virtual void onRect(void) = 0;
};
class PDFRender:public PDFParser{
private:
    void onText(void) {
        cout << "显示一行文本" << endl;
    }
    void onImage(void) {
        cout << "绘制一幅图片" << endl;
    }
    void onRect(void) {
        cout << "绘制一个矩形" << endl;
    }
};


int main(int argc, const char * argv[]) {
    
    PDFRender render;
    render.parse("xx.pdf");
    return 0;
}
