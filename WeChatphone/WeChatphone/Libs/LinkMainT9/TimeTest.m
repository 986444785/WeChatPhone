//
//  TimeTest.m
//  YouKeApp
//
//  Created by t on 15-3-27.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "TimeTest.h"

@implementation TimeTest
 

+(void)timeTrangFormWithTime:(NSString *)beforeTime Complate:(void(^)(NSString *time,NSString *day))complate
{
    NSRange range1=NSMakeRange(0, 10);

    NSString * dayStr = [beforeTime substringWithRange:range1];

    NSString * lastDay = [dayStr substringFromIndex:5];

    NSString * times = [beforeTime substringFromIndex:10];

    NSString * timeStr = [times substringToIndex:6];

    complate(timeStr ,lastDay );
}


+(NSString *)timeWithBeforeTime:(NSString *)beforeTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm dateFromString:beforeTime];


    NSRange range1=NSMakeRange(0, 10);
    NSString *   dayStr = [beforeTime substringWithRange:range1];

//    NSRange range2=NSMakeRange(0, 15);
    NSString *   times = [beforeTime substringFromIndex:10];

    NSLog(@"时间  %@",beforeTime);
    NSLog(@"时间1   %@",dayStr);
    NSLog(@"dayStr-------   %@",times);
    NSString * timeStr = [times substringToIndex:6];
    NSLog(@"timeLast ==== %@",timeStr);
    
    float dd = (float)[datenow timeIntervalSince1970] - [newdate timeIntervalSince1970];
    NSString *timeString=@"";
    
    float t2=fabsf(dd);
    float t=t2/60;

    if (t<60) {
//
//        timeString =@"今天";
//    }
//    else if (t<60)
//    {
//        timeString =[NSString stringWithFormat:@"%.0f分钟前",t];
                timeString =@"今天";
    }else
    {
        t=  t2/3600;
        if (t<24)
        {
//            timeString =[NSString stringWithFormat:@"%.0f小时前",t];

            timeString = @"今天";
        }
        else
        {
            t=t2/(3600*24);
            if (t<1) {
                timeString =[NSString stringWithFormat:@"%.0f昨天",t];
            }else
            {
                //字符串截取
                NSRange range=NSMakeRange(0, 9);
                timeString = [beforeTime substringWithRange:range];
            }
        }
    }
    
    
    return timeString ;
    
}

+(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}





@end
