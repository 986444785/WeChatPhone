//
//  ZYSavemanger.m
//  WeChatphone
//
//  Created by BBC on 16/4/26.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYSavemanger.h"
#import "ZYLinkManSingleton.h"
#import "People.h"
@implementation ZYSavemanger


 

#pragma mark -- 保存本地数据
//本地缓存
+(void)saveLocationDataSaveWithDict:(NSDictionary *)dict
{
    NSString * path = [self getSortViewSavePath];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:path atomically:YES];
}

//读取存储
+(NSDictionary *)getLocationData
{

    NSDictionary * responseDic = nil;
    NSString * path = [self getSortViewSavePath];
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isExit = [fileManger fileExistsAtPath:path];
    if (isExit) {
        NSData * data = [NSData dataWithContentsOfFile:path];

        responseDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//                NSLog(@"读取数据 responseDic：%@",responseDic);

//        [self handleDataWithDIct:dict];

    }else{
        //表的数据源数组 ；放的元素为联系人People类的对象
                NSLog(@"失败了");
//        [self loadNewList];
    }
    return responseDic;
} 



//存储路径
+(NSString *)getSortViewSavePath
{
    NSString * path = NSHomeDirectory();
    NSString * filePath = [path stringByAppendingString:@"/Documents/PhoneDatas.plist"];
    return filePath;
}


//----------

/**
 *  事件处理   通讯录 ----   网页授权
 */


//获取通讯录
+(NSArray *)getTongXunLuWithargs:(NSDictionary *)argDic
{
    NSDictionary * dic = argDic[@"args"];
    NSMutableArray  * mutables= [NSMutableArray array];
    int offset = [dic[@"offset"] intValue];
    int limit  =[dic[@"limit"] intValue];
    //    [GCDQueue executeInGlobalQueue:^{

    ZYLinkManSingleton * singleton = [ZYLinkManSingleton defaultSingletonISRefresh:NO];

    NSInteger ofset_0 = 0; NSInteger limit_0 = 0;
    if (singleton.peoples.count > offset+limit) {
        // 所有  ofset---- lim
        ofset_0 = offset; limit_0 = limit+offset;
    }else{
  
        if (singleton.peoples.count > offset) {
            // ofset---- singleton.peoples.count
            ofset_0 = offset; limit_0 = singleton.peoples.count;
        }else{
            // 0 --- count
            ofset_0 = 0; limit_0 = 0;
        }
    }

    for (NSInteger i = ofset_0; i<limit_0; i++) {

        People * p = singleton.peoples[i];
        NSDictionary * dic = [NSDictionary
                              dictionaryWithObjectsAndKeys:p.name,@"name",p.phoneNum,@"phone", nil];
        [mutables addObject:dic];
    }

    return mutables;
}






@end
