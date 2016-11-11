//
//  ZYSavemanger.h
//  WeChatphone
//
//  Created by BBC on 16/4/26.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYSavemanger : NSObject

/**
 *  保存电话本数据
 */ 
+(void)saveLocationDataSaveWithDict:(NSDictionary *)dict;

/**
 *  获取电话本数据 
 */ 
+(NSDictionary *)getLocationData;

 
/**
 *  //获取通讯录
 */
+(NSArray *)getTongXunLuWithargs:(NSDictionary *)argDic;

@end
