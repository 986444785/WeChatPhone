//
//  TakeOutDataBase.h
//  YouKeApp
//
//  Created by BBC on 15/9/16.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeOutDataBase : NSObject

#pragma mark  ------- 外卖购物车的表 ------

// 1. 创建
+(void)createTakeOutShopCartTableWithId:(NSString *)shopID ;

// 2. 查询菜单
+(NSString *)hasThisShopWith:(NSString *)store_Food_ID WithFood_Key_id:(NSString*)food_Key_id;;
  
// 4.存储菜单
+(void)addMenuWithShopId:(NSString *)shopID  WithFoodID:(NSString*)foodID WithFoodName:(NSString*)foodName WithFoodPrice:(NSString *)FoodPrice WithAllcount:(NSString *)FoodCount WithfoodSku:(NSString *)foodSku WithfoodKey:(NSString *)food_keyid;

// 5. 查询菜单数量
+(NSMutableArray *)selectAllWithStore_ID:(NSString *)store_ID;


// 6. 更新数量
+(void)updataCountWith:(NSString *)store_Food_ID With:(NSString *)store_Food_Count WithfoodKey:(NSString *)food_keyid;
//+(void)updataCountWith:(NSString *)store_Food_ID With:(NSString *)store_Food_Count;



//删除外卖这张表格
+(void)delelteAboutTakeOutTable;


@end
