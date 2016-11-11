//
//  LinkManAddressBook.m
//  YouKeApp
//
//  Created by t on 15-3-25.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "LinkManAddressBook.h"
#import "People.h"
#import "LSFMessageHint.h"
#import "BBFmdbTool.h"
#import "Header.h" 

@implementation LinkManAddressBook
 
 #pragma mark----导入联系人
+(NSMutableArray * )getAddressBook
{
    NSMutableArray * _dataArray = [NSMutableArray array];
 
    NSArray  *contacts = [[BBFmdbTool shareFmdbTool] QueryDatabase];
//    NSLog(@"---导入联系人  个数变化  %lu",(unsigned long)contacts.count);
 
 
    for (int i = 0; i<  contacts.count; i++) {

        BBContact *contact =   contacts[i];
        NSMutableArray *phoneArray = [NSMutableArray array];
        NSArray *phones = contact.phoneNumbers;

        for (BBContactPhoneNumber *phone in phones) {
            [phoneArray addObject:phone.value];
            break ;
        }
  
        People * p = [[People alloc]init];
        p.name = contact.displayName ;

        if (phoneArray.count > 0) {
            p.phoneNum = [self trimString:[phoneArray firstObject]];
        }


        if (p.name!= nil && p.phoneNum !=nil) {

            [_dataArray addObject:p];

        }

    }
     
    return _dataArray;
}
 


 
+(NSMutableArray * )LinkMainWithMutablearrayWithDataArray:(NSMutableArray *)dataArray
{
    NSMutableArray * _phonemutablearray=[NSMutableArray array];
//    NSMutableArray * _nameMutablearray=[NSMutableArray array];
    NSMutableArray * resultArray=[NSMutableArray array];
    
    //遍历数组
    for (int i = 0;i < dataArray.count;i++){
        //获得联系人的名字
        People * p = [dataArray objectAtIndex:i];
        if (p.name.length>1 && p.phoneNum.length>1) {
            [_phonemutablearray addObject:[NSString stringWithFormat:@"%@+++%@",p.name,p.phoneNum]];
//            [_nameMutablearray addObject:p];
        }

    }
    [resultArray addObject:_phonemutablearray];
    [resultArray addObject:dataArray];
    return  resultArray ;
}

 
#pragma mark  ---  取出特殊字符
+(NSString*)trimString:(NSString *)str
{
    if (str==nil) { 
        return str;
    }
    NSMutableString * mutableStr=[[NSMutableString alloc]initWithString:str];
    NSRange range=[mutableStr rangeOfString:@"("];
    if (range.location!=NSNotFound) {
        [mutableStr deleteCharactersInRange:range];
    }
    range=[mutableStr rangeOfString:@")"];
    if (range.location!=NSNotFound) {
        [mutableStr deleteCharactersInRange:range];
        
    }
    range=[mutableStr rangeOfString:@"-"];
    while (range.location!=NSNotFound) {
        [mutableStr deleteCharactersInRange:range];
        range=[mutableStr rangeOfString:@"-"];
    }
    range=[mutableStr rangeOfString:@"+"];
    if (range.location!=NSNotFound) {
        [mutableStr deleteCharactersInRange:range];
    }
    range=[mutableStr rangeOfString:@" "];
    while (range.location!=NSNotFound) {
        [mutableStr deleteCharactersInRange:range];
        range=[mutableStr rangeOfString:@" "];
    }
    range=[mutableStr rangeOfString:@" "];
    while (range.location!=NSNotFound) {
        [mutableStr deleteCharactersInRange:range];
        range=[mutableStr rangeOfString:@" "];
    }
    return [NSString stringWithString:mutableStr];
}

 
@end
