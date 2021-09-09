//
//  main.cpp
//  String_串匹配(Sunday算法)
//
//  Created by cbkj on 2021/8/4.
//

#include <iostream>

using namespace std;
//#include <string.h>
//#include <vector>
//#include <verc>
/*
 Sunday算法是Daniel M.Sunday于1990年提出的字符串模式匹配算法，它比后面要介绍的KMP算法和BM算法都要晚提出。不过其逻辑和处理方式比后二者要更简单清晰，故提前介绍。
 
 Sunday算法会提前记录 [公式] 的组成和每种字符在 [公式] 中最右出现的位置，比如 : "abcab"，每种字符在模板中的最靠右的位置为{'a':3, 'b':4, 'c':2}。
 
 在每一次的比较中，一旦出现失配，算法会去看 [公式] 中在当前匹配段后一位的字符 [公式] ，找到这个字符在 [公式] 中最右出现的位置，并与其对齐，如果在 [公式] 中没有对应的字符 [公式]，则直接右移跳过整段的匹配段。
 */

class SundayTable {
    
private:
    char ch;
    uint index;
    
public:
    
    SundayTable();
    SundayTable(char c, uint i): ch(c), index(i){}
    
    char getCh() {
        return this->ch;
    }
    
    uint getIndex() {
        return this->index;
    }
    
    void setIndex(uint index){
        this->index = index;
    }
    
    void desc(){
        std::cout << this->getCh() << ":" << this->getIndex() << std::endl;
    }
};


SundayTable * initCharTables(const char *str, int *count)
{
    
    int i = 0;
    int c = 0;
    uint len = (uint)strlen(str);
//    vector<SundayTable> vec_temp;
    std::map
    
    SundayTable *temp = {};//(SundayTable *)malloc(c * sizeof(SundayTable));
    
    while (i < len) {
        
        for (int j = 0; j < c; j++) {
            if (temp[j].getCh() == str[i]) {
                temp[j].setIndex(i);
            }else{
                SundayTable tmp_s(str[i], i);
                temp[c-1] = tmp_s;
                c++;
                break;
            }
        }
        i++;
    }
    
    return 0;
}

int BM_stringContainOther(const char *str, const char *str2)
{
    
    
    uint str_len = (uint)strlen(str);
    uint str2_len = (uint)strlen(str2);
    
    uint index = str2_len - 1;
    while (index < str_len) {
        
        if (str[index] != str2[index]) {
            // 坏字符下标
            std::cout << "坏字符下标: " << index << std::endl;
            break;
        }
        index--;
//        if (str[index] == str2[str2_len - 1])
//        {
//            int i = str2_len - 1;
//            bool isMate = false;
//            while (i > 0) {
//                if (str2[i] != str[index - i]) {
//                    isMate = false;
//                    break;
//                }
//                i--;
//            }
//            if (isMate)
//            {
//                return index - str2_len - 1;
//            }
//            else
//            {
//                index += i;
//            }
//        }
//        else
//        {
//
//        }
    }
    return 0;
}

int main(int argc, const char * argv[]) {
    
//    const char a[10] = "asdfghjkl";
     char b[4] = "fgh";
//
//    int c = BM_stringContainOther(a, b);
//    std::cout << "index: " << c << std::endl;
    
    
    int count = 0;
    SundayTable *tables = initCharTables(b, &count);
    for (int i = 0; i<count; i++) {
        tables[i].desc();
    }
    
    return 0;
}




