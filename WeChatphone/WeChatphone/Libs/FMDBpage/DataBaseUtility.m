//
//  DataBaseUtility.m
//  FMDB存储
//
//  Created by t on 15-3-18.
//  Copyright (c) 2015年 Chen. All rights reserved.
//
 
#import "DataBaseUtility.h"
static FMDatabase * _db=nil;
@implementation DataBaseUtility
+(FMDatabase*)getDataBase
{
    if (_db==nil) {
        NSString * toPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dataBase.sqlite"];
        _db=[[FMDatabase alloc]initWithPath:toPath];
        
    } 
    return _db;
}
@end
