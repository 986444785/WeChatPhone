//
//  ChineseToPinyin.h
//  DialContact
//
//  Created by lczh on 12-2-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChineseToPinyinHelper.h"

#define kTextString @"textString"
#define kTextArray @"textArray"

#define kPinyinString @"pinyinString"
//#define kPinyinArray @"pingyinArray"

#define kFullNumString @"fullString"
#define kFullNumArray @"fullArray"
#define kFullNumSearchString @"fullSearch"

typedef enum {
    UTF8TagInit = 0,
    UTF8TagAscii,
    UTF8TagOther,
    UTF8TagChinese
}UTF8Tag;

@interface ChineseToPinyin : NSObject
+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 
+ (NSString *) titleFromPinyin:(NSString *)pinyin;
+ (NSString *) numFromString:(NSString *)string isQuanPin:(bool) boolQuanPin;

+ (NSDictionary *) divideString:(NSString *)string;

+ (NSString *)translatePinyinFromOneCharacter:(NSString*)string;
+ (NSString *)translatePinyinFromString:(NSString *)string;
+ (NSString *)translateTitleFromOneCharacter:(NSString*)string;
+ (NSString *)translateTitleFromString:(NSString *)string;
+ (NSString *)translateNumberFromString:(NSString *)string;
+ (void)freePinyinMap;
@end
