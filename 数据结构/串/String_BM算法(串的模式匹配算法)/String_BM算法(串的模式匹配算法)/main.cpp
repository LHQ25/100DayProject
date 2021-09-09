//
//  main.cpp
//  String_BM算法(串的模式匹配算法)
//
//  Created by cbkj on 2021/8/3.
//

#include <iostream>
#include <map>

struct GoodSuffix {
public:
    int suffix_index;
    bool ispre;
    char *suffix;
    
};

// 存储每个字符的最右下标
void badChar(const char *str, int len, std::map<char, int> &map)
{
 
//    std::map<char, int> tempMap;
    
    int index = 0;
    while (index < len) {
        
        char p = str[index];
        map[p] = index;
        index++;
    }
}

//模式串的好后缀 缓存
void goodSuffix(const char *str, int len, GoodSuffix *suffix)
{
    for (int i = 0; i < len - 1; ++i) {
        int j = i;
        int k = 0;
        while (j >= 0 && str[j] == str[len-1-k]) {
            --j;
            ++k;
            suffix[k].suffix_index = j + 1;
        }
        if (j == -1){
            suffix[k].ispre = true;
        }
    }
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
    
    const char a[10] = "asdfghjkl";
    const char b[4] = "fgh";
    
    int c = BM_stringContainOther(a, b);
    std::cout << "index: " << c << std::endl;
    
    std::map<char, int> map;
    badChar(b, 3, map);
    
    return 0;
}



