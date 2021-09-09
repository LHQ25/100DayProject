//
//  main.cpp
//  String_KPM(字符串匹配)
//
//  Created by cbkj on 2021/8/3.
//

#include <iostream>


int bf_stringContainOther(const char *str, const char *str2)
{
    
    size_t str_len = strlen(str);
    size_t str2_len = strlen(str2);
    
    int index = 0;
    while (index < (str_len - str2_len)) {
        
        
        bool isMate = false;
        for (int i = 0; i < str2_len; i++) {
            
            if (str[i + index] != str2[i])
            {
                isMate = false;
                index++;
                break;
            }
            else
            {
                isMate = true;
            }
        }
        
        if (isMate == true)
        {
            return index;
        }
    }
    return 0;
}

int main(int argc, const char * argv[]) {
    
    const char a[10] = "asdfghjkl";
    const char b[4] = "fgh";
    
    int c = bf_stringContainOther(a, b);
    std::cout << "index: " << c << std::endl;
    return 0;
}



