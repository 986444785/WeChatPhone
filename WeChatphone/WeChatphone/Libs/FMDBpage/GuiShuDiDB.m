//
//  GuiShuDiDB.m
//  YouKeApp
//
//  Created by t on 15-3-29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "GuiShuDiDB.h"

@implementation GuiShuDiDB

+(NSString *)locationForPhoneNumber:(NSString *)phoneNumber
{
    
    NSString *dbFile = [[NSBundle mainBundle] pathForResource:@"telocation" ofType:@"db"];
    FMDatabase *db  = [FMDatabase databaseWithPath:dbFile];

    if (phoneNumber.length == 0) {
        return nil;
    } 
    
    BOOL isMobilePhone = ([phoneNumber characterAtIndex:0] == '1' && phoneNumber.length == 11);
    BOOL hasAreaCode = ([phoneNumber characterAtIndex:0] == '0');
    BOOL isForeign = (hasAreaCode && phoneNumber.length > 2 && [phoneNumber characterAtIndex:1] == '0');
    
    NSString *location = nil;
    
    @synchronized (db) {
        [db open];
        
        if (isMobilePhone) {
            // 手机号取前7位，查到固话区号，再查地址
            NSString *prefix = [phoneNumber substringToIndex:7];
            FMResultSet *s = [db executeQuery:@"SELECT areacode FROM mob_location where _id=?", prefix];
            if ([s next]) {
                NSInteger areacode = [s intForColumnIndex:0];
                [s close];
                
                s = [db executeQuery:@"SELECT location FROM tel_location where _id=?", @(areacode)];
                if ([s next]) {
                    location = [s stringForColumnIndex:0];
                    [s close];
                }
            }
        } else {
            if (isForeign) {
                location = @"国际长途";
            } else if (hasAreaCode) {
                // 国内长途，首位是1、2则区号为两位，否则区号为3位
                NSString *areacode;
                if (   phoneNumber.length > 3
                    && (   [phoneNumber characterAtIndex:1] == '1'
                        || [phoneNumber characterAtIndex:1] == '2')) {
                        areacode = [phoneNumber substringWithRange:NSMakeRange(1, 2)];
                    } else if (phoneNumber.length > 4) {
                        areacode = [phoneNumber substringWithRange:NSMakeRange(1, 3)];
                    }
                
                FMResultSet *s = [db executeQuery:@"SELECT location FROM tel_location where _id=?", @([areacode integerValue])];
                if ([s next]) {
                    location = [s stringForColumnIndex:0];
                    [s close];
                }
            } else {
                location = @"本地";
            }
        }
         
        [db close];
    }
   
    return location;
}



@end
