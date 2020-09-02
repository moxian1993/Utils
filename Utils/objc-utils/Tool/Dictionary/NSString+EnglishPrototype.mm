//
//  NSString+EnglishPrototype.m
//  CommonFramework
//
//  Created by zhuwei on 15/2/7.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "NSString+EnglishPrototype.h"
#import "porterstemmer.h"

@implementation NSString (EnglishPrototype)

#define LETTER(ch) (isupper(ch) || islower(ch))
static char * s;         /* a char * (=string) pointer; passed into b above */

#define INC 50           /* size units in which s is increased */
static int i_max = INC;  /* maximum offset in s */

void increase_s()
{  i_max += INC;
    {  char * new_s = (char *) malloc(i_max+1);
        { int i; for (i = 0; i < i_max; i++) new_s[i] = s[i]; } /* copy across */
        free(s); s = new_s;
    }
}

/**
 获得字符串原型
 
 @return 返回英语字符串原型
 */
- (NSString *)englishPrototype {
    s = (char *) malloc(i_max+1);
    NSMutableString* prototype = [NSMutableString string];
    int len = 1024;
    char* buffer = (char*)malloc(len);
    memset(buffer, '\0', len);
    const char* str = [[self lowercaseString] UTF8String];
    size_t srcLen = strlen(str);
    if(srcLen < len) {
        memcpy(buffer, str, srcLen);
        
        for (int idx = 0; idx < srcLen; idx ++) {
            int ch = buffer[idx];
            
            if (LETTER(ch))
            {  int i = 0;
                while(TRUE)
                {  if (i == i_max) increase_s();
                    
                    ch = tolower(ch); /* forces lower case */
                    
                    s[i] = ch;
                    i++;
                    ch = buffer[++idx];
                    if (!LETTER(ch)) {
                        idx --;
                        break;
                    }
                }
                s[stem(s,0,i-1)+1] = 0;
                [prototype appendFormat:@"%s",s];
            }
            else {
                [prototype appendFormat:@"%c",ch];
            }
        }
        
    }
    free(buffer);
    free(s);
    return prototype;
}

@end
