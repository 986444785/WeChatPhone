//
//  DealWithDataBases.m
//  FMDB存储
//
//  Created by t on 15-3-18.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "DealWithDataBases.h"
#import "FMDatabase.h"
#import "DataBaseUtility.h"
//#import "ShopCartModel.h"
@implementation DealWithDataBases
 
//创建表
+(void)createTableAboutSqlite{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        //创建表
        BOOL tableResult=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS collection_people (id integer PRIMARY KEY AUTOINCREMENT, peopleName text , peoplePhoneNum text  , callTime text);"];
        if (tableResult) {
            NSLog(@"collection_people创建表成功1");
        }else{
            NSLog(@"collection_people创建表失败");
        }
    }
    [db close];
}
 
 
//插入数据
+(void)insertMessageWithPeopleName:(NSString *)peopleName WithPeoplePhoneNum:(NSString*)PhoneNum WithTime:(NSString *)Time
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        [db executeUpdate:@"insert into collection_people(peopleName,peoplePhoneNum,callTime)values(?,?,?)",peopleName,PhoneNum,Time];
  
    }
    [db close];
}


//查询   只返回最新时间
+(NSMutableArray *)selectTableAboutCollection
{
    NSMutableArray * mutableArray=nil;
    
    FMDatabase * db =[DataBaseUtility getDataBase];
    if ([db open]==YES) {
               mutableArray=[NSMutableArray array];
      
        FMResultSet * setResult=[db executeQuery:@"select * from collection_people order by callTime desc"];

        while ([setResult next]) {
            People * p=[[People alloc]init];
            p.name=[setResult stringForColumn:@"peopleName"];
            p.phoneNum = [setResult stringForColumn:@"peoplePhoneNum"];
            p.callTime=[setResult stringForColumn:@"callTime"];
            //取oldTime
          
            NSArray * timeArray = [p.callTime componentsSeparatedByString:@"|"];
            p.callTime=timeArray.lastObject;
            [mutableArray addObject:p];

        }
 
    }
       [db close];

    return mutableArray;
}

//查询一个人所有信息
+(People *)selectAllMessageTableAboutCollectionWithPhoneNUm:(NSString *)phoneNUm
{
    People * p = [[People alloc]init];
    
    FMDatabase * db =[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        
         FMResultSet * setResult =[db executeQuery:@"select * from collection_people where peoplePhoneNum = ?",phoneNUm];
        while ([setResult next]) {
         
            p.name=[setResult stringForColumn:@"peopleName"];
            p.phoneNum = [setResult stringForColumn:@"peoplePhoneNum"];
            p.callTime=[setResult stringForColumn:@"callTime"];

        }
        
    }
    [db close];
    return p;
}

//删除记录 
+(void)delateCollectPeopleWithPhoneNum:(NSString *)phoneNum
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
        
        [db executeUpdate:@"delete from collection_people where peoplePhoneNum = ?",phoneNum];
     
    }
    [db close];
}

//根据手机号码查询，返回时间
+(NSString *)selectCollectionFromTableWithPhoneNum:(NSString *)PhoneNum
{
    NSString * oldTime = nil ;
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {

        FMResultSet * set=[db executeQuery:@"select * from collection_people where peoplePhoneNum = ?",PhoneNum];
        
        while ([set next]) {
            //获取 oldtime
            oldTime = [set stringForColumn:@"callTime"];
        } 
    }
    [db close];
    return oldTime ;
    
} 

//更新操作
+(void )updateOrderWithPhoneNum:(NSString *)phoneNum  WithNewTime:(NSString *)newTime WithOldTime:(NSString *)oldTime
{
    FMDatabase *db=[DataBaseUtility getDataBase];
    if ([db open]==YES)
    {
        NSString * time = newTime; //只记录最新一次的时间

        [db executeUpdate:@"update collection_people set callTime = ?  where peoplePhoneNum like ?",time,phoneNum];
    }
    
   [db close];
    
}









#pragma mark  -----   收藏表  ----   操作

//创建收藏的表
+(void)createCollectionTableAboutSqlite{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        //创建表
        BOOL tableResult=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS collection_linkman (id integer PRIMARY KEY AUTOINCREMENT, peopleName text , peoplePhoneNum text );"];
        if (tableResult) {
//            NSLog(@"创建表成功2");
        }else{
            NSLog(@"创建表失败");
        }
    }
    [db close];
}

//插入数据
+(void)insertCollectionLinkManWithPeopleName:(NSString *)peopleName WithPeoplePhoneNum:(NSString *)PhoneNum
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        [db executeUpdate:@"insert into collection_linkman(peopleName,peoplePhoneNum)values(?,?)",peopleName,PhoneNum];
    }
    [db close];
}

//删除记录
+(void)delateCollectLinkManWithPhoneNum:(NSString *)phoneNum
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
        [db executeUpdate:@"delete from collection_linkman where peoplePhoneNum = ?",phoneNum];
    }
    [db close];
}

//查询
+(BOOL)selectCollectionLinkManFromTableWithPhoneNum:(NSString *)PhoneNum
{
    BOOL isCollected=NO;
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
        FMResultSet * set=[db executeQuery:@"select * from collection_linkman where peoplePhoneNum = ?",PhoneNum];
        while ([set next]) {
//            NSLog(@"找到的目标 %@",[set stringForColumn:@"peoplePhoneNum"]);
            isCollected =YES ;
        }
    }
    [db close];

    return isCollected;

}

//查询所有
+(NSMutableArray *)selectLinkManTableAboutCollection
{
    NSMutableArray * mutableArray=nil;
    
    FMDatabase * db =[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        mutableArray=[NSMutableArray array];
        
        FMResultSet * setResult=[db executeQuery:@"select * from collection_linkman "];
        while ([setResult next]) {
            People * p=[[People alloc]init];
            p.name=[setResult stringForColumn:@"peopleName"];
            p.phoneNum = [setResult stringForColumn:@"peoplePhoneNum"];
            [mutableArray addObject:p];
        }
    }
    [db close];
    return mutableArray;
}
 

//-----------------------
#pragma mark -----  创建购物车的表
 
//创建领取表格
+(void)createShopCartTable
{
    //  产品 id   名字   价格    邮费     图片      数量  尺寸   大小
    
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        //创建表
        BOOL tableResult=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS shopCart_table (id integer PRIMARY KEY AUTOINCREMENT, shop_ID text , shop_count text , shop_Name text , shop_ImgUrl text , shop_PotMoney text , shop_Price text , shop_description text , shop_color text , shop_size text);"];
        if (tableResult) {
//            NSLog(@"购物车的表成功1");
        }else{ 
            NSLog(@"购物车的表失败");
        }
    }
    [db close];
}

//插入一个新的数据

+(void)addNewDataWithID:(NSString *)aID WithName:(NSString *)name WithPrice:(NSString *)price WithPostPrice:(NSString *)postPrice  WithImageUrl:(NSString *)imgUrl WithCount:(NSString *)count WithDescription:(NSString *)description WithSize:(NSString *)size WithColor:(NSString *)color
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES){
        
            [db executeUpdate:@"insert into shopCart_table(shop_ID,shop_Name,shop_Price,shop_PotMoney,shop_ImgUrl,shop_count,shop_description,shop_color,shop_size)values(?,?,?,?,?,?,?,?,?)",aID,name,price,postPrice,imgUrl,count,description,color,size];
    }
    [db close];
}




//更新数量数据
+(void)updataShopCartWithShopID:(NSString *)shopID WithShopCount:(NSString *)shopCount
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES){
        
         [db executeUpdate:@"update shopCart_table set shop_count = ?  where shop_ID like ?",shopCount,shopID];

    }
    [db close];
}
 
 
//查询购物车数据
+(NSString *)selectShopCartFromTableWithShopID:(NSString *)shopID
{
    NSString * shopCount = nil ;
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
        
        FMResultSet * set=[db executeQuery:@"select * from shopCart_table where shop_ID = ?",shopID];
        
        while ([set next]) {
            //获取 oldtime
            shopCount = [set stringForColumn:@"shop_count"];
        }
    }
    [db close];
    return shopCount ;
}


// 查询所有商品总个数 
+(NSString * )selectAllGoodsCount
{
    int shopCount = 0 ;
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
        
        FMResultSet * set=[db executeQuery:@"select * from shopCart_table "];
        
        while ([set next]) {
            //获取 oldtime
            shopCount = [[set stringForColumn:@"shop_count"] intValue] + shopCount;
        }
    }
    [db close];
    return [NSString stringWithFormat:@"%d",shopCount];
}
 

//根据id删除购物车
+(void)delegateShopingCartWithId:(NSString *)shopID
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
          [db executeUpdate:@"delete from shopCart_table where shop_ID = ?",shopID];
    }
     [db close];
}

//查询所有，返回一个数组

//查询所有 
+(NSMutableArray *)selectAllInShopCartTable
{
    NSMutableArray * mutableArray=nil;
    FMDatabase * db =[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        mutableArray=[NSMutableArray array];
         
        FMResultSet * setResult=[db executeQuery:@"select * from shopCart_table"];
        while ([setResult next]) {
/*
            ShopCartModel * shop = [[ShopCartModel alloc]init];
            shop.s_aID = [setResult stringForColumn:@"shop_ID"];
             shop.s_name = [setResult stringForColumn:@"shop_Name"];
             shop.s_price = [setResult stringForColumn:@"shop_Price"];
             shop.s_PostPrice = [setResult stringForColumn:@"shop_PotMoney"];
             shop.s_ImgUrl = [setResult stringForColumn:@"shop_ImgUrl"];
             shop.s_count = [setResult stringForColumn:@"shop_count"];
             shop.s_description = [setResult stringForColumn:@"shop_description"];
             shop.s_color = [setResult stringForColumn:@"shop_color"];
             shop.s_size = [setResult stringForColumn:@"shop_size"];
             [mutableArray addObject:shop];
 */
        }
    }  
    [db close];
    return mutableArray;
    
} 

#pragma mark ---  创建搜索记录
 
+(void)CreateSearchRecordTable
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        //创建表
        BOOL tableResult=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS SearchRecord_Table (id integer PRIMARY KEY AUTOINCREMENT, Search_Name text );"];
        if (tableResult) {
//                        NSLog(@" 创建搜索记录表成功1");
        }else{
            NSLog(@" 创建搜索记录的表失败");
        }
    }
    [db close];
}

//查询所有
+(NSMutableArray *)selectAllInSearchRecord_Table
{
    NSMutableArray * mutableArray=nil;
    FMDatabase * db =[DataBaseUtility getDataBase];
    if ([db open]==YES) {
        mutableArray=[NSMutableArray array];

        FMResultSet * setResult=[db executeQuery:@"select * from SearchRecord_Table"];
        while ([setResult next]) {

            NSString * name =  [setResult stringForColumn:@"Search_Name"];
            [mutableArray addObject:name];
        }
    }
    [db close];
    return mutableArray;
}

+(void)addNewDataWithName:(NSString *)name
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]==YES){

      BOOL result =  [db executeUpdate:@"insert into SearchRecord_Table(Search_Name)values(?)",name];
        if (result) {
//            NSLog(@" 创建搜索记录插入成功");
        }else{
            NSLog(@" 创建搜索记录插入失败");
        }
    }
    [db close]; 
}
//删除搜索记录
+(void)deleteAllRecoredInSearchRecord_Table
{
    FMDatabase * db=[DataBaseUtility getDataBase];
    if ([db open]) {
        [db executeUpdate:@"delete from SearchRecord_Table "];
    }
    [db close];
}

@end
