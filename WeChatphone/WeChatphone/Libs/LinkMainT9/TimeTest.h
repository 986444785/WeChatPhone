//
//  TimeTest.h
//  YouKeApp
//
//  Created by t on 15-3-27.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTest : NSObject


+(NSString *)timeWithBeforeTime:(NSString *)beforeTime;

+(NSString *)compareDate:(NSDate *)date;


+(void)timeTrangFormWithTime:(NSString *)beforeTime Complate:(void(^)(NSString *time,NSString *day))complate;
 

@end
