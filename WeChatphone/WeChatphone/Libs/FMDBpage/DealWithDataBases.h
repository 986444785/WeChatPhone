//
//  DealWithDataBases.h
//  FMDB存储
//
//  Created by t on 15-3-18.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "People.h"
@interface DealWithDataBases : NSObject

//创建一个表
+(void)createTableAboutSqlite;
     
//插入东西
+(void)insertMessageWithPeopleName:(NSString *)peopleName WithPeoplePhoneNum:(NSString*)PhoneNum WithTime:(NSString *)Time;
//查询  只返回最新时间
+(NSMutableArray *)selectTableAboutCollection;
//查询所有的
+(People *)selectAllMessageTableAboutCollectionWithPhoneNUm:(NSString *)phoneNUm;
//删除
+(void)delateCollectPeopleWithPhoneNum:(NSString*)phoneNum;
//查询单个
+(NSString *)selectCollectionFromTableWithPhoneNum:(NSString*)PhoneNum;
//更新操作
+(void )updateOrderWithPhoneNum:(NSString *)phoneNum  WithNewTime:(NSString *)newTime WithOldTime:(NSString *)oldTime;
 
//----------------------收藏的方法

//创建收藏的表
+(void)createCollectionTableAboutSqlite;
//删除记录
+(void)delateCollectLinkManWithPhoneNum:(NSString *)phoneNum;
//插入数据
+(void)insertCollectionLinkManWithPeopleName:(NSString *)peopleName WithPeoplePhoneNum:(NSString*)PhoneNum;
//查询所有
+(NSMutableArray *)selectLinkManTableAboutCollection;
//查询
+(BOOL)selectCollectionLinkManFromTableWithPhoneNum:(NSString *)PhoneNum;


#pragma mark  ------- 购物车数据 ------

//创建领取表格
+(void)createShopCartTable;
//舒心数据
+(void)updataShopCartWithShopID:(NSString *)shopID WithShopCount:(NSString *)shopCount;
//查询购物车数据
+(NSString *)selectShopCartFromTableWithShopID:(NSString *)shopID;
//插入一个新的数据
+(void)addNewDataWithID:(NSString *)aID WithName:(NSString *)name WithPrice:(NSString *)price WithPostPrice:(NSString *)postPrice  WithImageUrl:(NSString *)imgUrl WithCount:(NSString *)count WithDescription:(NSString *)description WithSize:(NSString *)size WithColor:(NSString *)color;

//根据id删除购物车
+(void)delegateShopingCartWithId:(NSString *)shopID;

// 查询所有商品总个数

+(NSString * )selectAllGoodsCount;
//查询所有
+(NSMutableArray *)selectAllInShopCartTable;


#pragma mark ---  搜索记录      

//创建搜索记录
+(void)CreateSearchRecordTable;
//查询所有
+(NSMutableArray *)selectAllInSearchRecord_Table;
//插入数据
+(void)addNewDataWithName:(NSString *)name;
//删除搜索记录
+(void)deleteAllRecoredInSearchRecord_Table;

@end
