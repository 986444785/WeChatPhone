//
//  TakeOutDataBase.m
//  YouKeApp
//
//  Created by BBC on 15/9/16.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "TakeOutDataBase.h"
//#import "ShopMenu.h"
#import "FMDatabase.h"
#import "DataBaseUtility.h"
@implementation TakeOutDataBase

#pragma mark  ------- 外卖购物车的表 ------

// 1. 创建
+(void)createTakeOutShopCartTableWithId:(NSString *)shopID
{
    FMDatabase * db = [DataBaseUtility getDataBase];
    if ([db open]==YES) {
        NSString * s = [NSString stringWithFormat:@"TakeOut_Table"];
        NSString * table = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, store_ID text , store_Food_Key_ID text , store_Food_ID text , store_Food_Name text  , store_Food_Price text  , store_Food_Count text , store_All_Food_Count text , store_Food_Sku text );",s];
        BOOL tableResult=[db executeUpdate:table];

        if (tableResult) {
//            NSLog(@"外卖快餐表创建成功");
        }else{
            NSLog(@"外卖快餐表创建失败");
        }
    }
    [db close];
}
 
// 2.查询菜的数量
+(NSString *)hasThisShopWith:(NSString *)store_Food_ID WithFood_Key_id:(NSString*)food_Key_id;
{
    NSString * hasFood = nil ;
    NSString * s = [NSString stringWithFormat:@"TakeOut_Table"];

    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {

        NSString * table = [NSString stringWithFormat:@"select * from %@ where store_Food_Key_ID = %@",s,food_Key_id];

        FMResultSet * set=[db executeQuery:table];
          
        while ([set next]) {
            //获取 oldtime
            hasFood = [set stringForColumn:@"store_Food_Count"];
        }
    }
    [db close];

    return hasFood ;

}

 
// 4. 存储菜单
+(void)addMenuWithShopId:(NSString *)shopID  WithFoodID:(NSString*)foodID WithFoodName:(NSString*)foodName WithFoodPrice:(NSString *)FoodPrice WithAllcount:(NSString *)FoodCount WithfoodSku:(NSString *)foodSku WithfoodKey:(NSString *)food_keyid
{  

    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES){
        BOOL result = [db executeUpdate:@"insert into TakeOut_Table(store_ID,store_Food_ID,store_Food_Name,store_Food_Price ,store_Food_Count , store_Food_Sku ,store_Food_Key_ID)values(?,?,?,?,?,?,?)",shopID,foodID,foodName,FoodPrice,FoodCount,foodSku,food_keyid];

        if (result) {
            NSLog(@"插入菜单成功food_keyid-----%@",food_keyid);
        }else{
            NSLog(@"插入菜单失败");
        }
    }
    [db close]; 
}

// 5. 查询菜单数量 获取这家的总数量
+( NSMutableArray *)selectAllWithStore_ID:(NSString *)store_ID
{

    NSMutableArray * mutablearray = [NSMutableArray array];
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
//        FMResultSet * set=[db executeQuery:@"select * from TakeOut_Table where store_ID = ?",store_ID];
/*
        while ([set next]) {
            ShopMenu * sm = [[ShopMenu alloc]init];
            sm.store_Food_Name  =  [set stringForColumn:@"store_Food_Name"];
            sm.store_Food_Price =  [set stringForColumn:@"store_Food_Price"];
            sm.store_Food_Count =  [set stringForColumn:@"store_Food_Count"];
            sm.store_Food_ID    =  [set stringForColumn:@"store_Food_ID"];
            sm.store_Food_Sku   =  [set stringForColumn:@"store_Food_Sku"]; 
            sm.store_Food_key_id=   [set stringForColumn:@"store_Food_Key_ID"];
            [mutablearray addObject:sm];
        }
 */
    }
    [db close];
    return mutablearray ;
}
  
// 6. 更新数量
+(void)updataCountWith:(NSString *)store_Food_ID With:(NSString *)store_Food_Count WithfoodKey:(NSString *)food_keyid
{
    NSLog(@"更新数量时候 food_keyid----  %@",food_keyid);
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES){

         BOOL result  = [db executeUpdate:@"update TakeOut_Table set store_Food_Count = ?  where store_Food_Key_ID like ?",store_Food_Count,food_keyid];

        if (result) {
            NSLog(@"更新菜单成功");
        }else{
            NSLog(@"更新菜单失败"); 
        } 
    }

    [db close];
}

//删除这张表格
+(void)delelteAboutTakeOutTable
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES){
        [db executeUpdate:@"delete from TakeOut_Table"];
    }
    [db close];
}



@end
