//
//  T9Prompter.h
//  ZYPhoneCall
//
//  Created by t on 15-3-21.
//  Copyright (c) 2015年 RZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prompter.h"
@interface T9Prompter : NSObject

+(NSMutableArray *)pinyinMutableArrayWithPinYinresultArray:(NSArray *)pinyinResultArray WithPhoneArray:(NSMutableArray *)phonemutablearray;
       
//数字查找
+(NSMutableArray *)numberSearchResultWithPhoneArray:(NSMutableArray *)phonemutablearray WithpinYinResultArray:(NSMutableArray *)pinyinResultArray  WithSearchText:(NSString *)text;

+(NSMutableArray *)getPinYinWithStr:(NSString *)pstr;

+(NSMutableArray * )pinYinZhuanHuaWithNameArray:(NSMutableArray *)_nameMutablearray;
  
//数字的查找
+(NSMutableArray * )numberSearchResultWithNmaeMutableArray:(NSMutableArray *)_nameMutablearray WithSearchText:(NSString *)searchText;

//模糊查找
+(NSMutableArray *)selectResultwithPinYinResult:(NSMutableArray *)pingyinArray WithSearchText:(NSString *)searchText WithNameArray:(NSMutableArray *)nameMutablearray;

//将联系人拼音化
+(NSMutableDictionary *)pinYinZhuanHuaWithDataArray:(NSMutableArray *)dataArray WithNameArray:(NSMutableArray *)_nameMutablearray;

@end 
