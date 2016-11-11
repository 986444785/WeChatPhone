//
//  T9Prompter.m
//  ZYPhoneCall
//
//  Created by t on 15-3-21.
//  Copyright (c) 2015年 RZL. All rights reserved.
//

#import "T9Prompter.h"
#import "People.h"
#import "LinkManAddressBook.h"


@implementation T9Prompter
NSMutableArray * _pingyinArray;

+(NSMutableArray *)getPinYinWithStr:(NSString *)pstr
{
    static int pk = 0;  pk++;

    if (!_pingyinArray) {
        _pingyinArray=[[NSMutableArray alloc]initWithCapacity:0];
    }
    
    NSMutableString *ms = [[NSMutableString alloc] initWithString:pstr];
    (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO))  ;
    
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO))
    { 
        
        [_pingyinArray addObject:ms];
        NSMutableString * szmString=ms;
        NSArray * mingArray=[szmString componentsSeparatedByString:@"+++"];
        
        NSMutableString * mingziString=mingArray[0];
        NSString * phoneStr=[NSString stringWithFormat:@"+++%@",mingArray[1]];
        NSArray * nameArray=[mingziString componentsSeparatedByString:@" "];
        NSString * nameString=@"";
        for (NSString * t in nameArray) {
            if (t.length>0) {
                NSString * t2=[t substringToIndex:1];
                nameString=[nameString stringByAppendingString:t2];
                
            }
        }
        
        [_pingyinArray addObject:[nameString stringByAppendingString:phoneStr]];
    }
        return _pingyinArray;
}




+(NSMutableArray * )pinYinZhuanHuaWithNameArray:(NSMutableArray *)_nameMutablearray
{

        NSMutableArray      * pingyinArray=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i =0 ; i<_nameMutablearray.count; i++)
        {
            People * p = [_nameMutablearray objectAtIndex:i];
            //在这将名字转化为拼音 
            if (p.name.length>0 && p.phoneNum.length>0) {
                NSMutableString *ms = [[NSMutableString alloc] initWithString:p.name];
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                    
                }
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO))
                {
                    //                        NSLog(@"拼音 %@",ms);
                    //将名字和号码拼接一块
                    NSString * str=[NSString stringWithFormat:@"%@+++%@",p.name,p.phoneNum];
                    [pingyinArray addObject:str];
                    //获取首字母
                    NSString * phoneStr=[NSString stringWithFormat:@"+++%@",p.phoneNum];
                    NSArray * nameArray=[ms componentsSeparatedByString:@" "];
                    NSString * nameString=@"";
                    for (NSString * t in nameArray) {
                        if (t.length>0) {
                            NSString * t2=[t substringToIndex:1];
                            nameString=[nameString stringByAppendingString:t2];
                            
                        }
                    }
                    //               NSLog(@"凭借后首字母  %@",nameString);
                    [pingyinArray addObject:[nameString stringByAppendingString:phoneStr]];
                }
                
            }
            
        }
        
    return pingyinArray;
}

+(NSMutableArray * )numberSearchResultWithNmaeMutableArray:(NSMutableArray *)_nameMutablearray WithSearchText:(NSString *)searchText
{
    NSMutableArray * resultArray=[NSMutableArray array];
    for (int i =0 ; i<_nameMutablearray.count; i++)
    {
        People * p = [_nameMutablearray objectAtIndex:i];

        if (p.phoneNum.length>0) {
            NSRange range = [[p.phoneNum lowercaseString] rangeOfString:searchText];
            if (range.location != NSNotFound)
            {
                People * p=_nameMutablearray[i];
                [resultArray addObject:p];
            }else{
                NSRange range = [[p.name lowercaseString] rangeOfString:searchText];
                if (range.location != NSNotFound)
                {
                    People * p=_nameMutablearray[i];
                    p.lastNameStr = [p.name substringFromIndex:p.name.length -1];
                    [resultArray addObject:p];
                }
            }
        }
        
    }
    return resultArray;
}


 
+(NSMutableArray *)selectResultwithPinYinResult:(NSMutableArray *)pingyinArray WithSearchText:(NSString *)searchText WithNameArray:(NSMutableArray *)nameMutablearray
{
    searchText = [searchText lowercaseString];
    
    NSMutableArray *_resultArray=[NSMutableArray array];
    NSPredicate *pred02 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    NSArray *pred1Arr =[pingyinArray filteredArrayUsingPredicate:pred02];
    
    
    NSMutableArray * mutablearay1=[[NSMutableArray alloc]initWithCapacity:0];
    People * p=nil;
    for (int t=0; t<nameMutablearray.count; t++) {
        
        p=nameMutablearray[t];
        NSString * text=[NSString stringWithFormat:@"%@+++%@",p.name,p.phoneNum];
        [mutablearay1 addObject:text];
    }
 
    NSPredicate * predict2=[NSPredicate predicateWithFormat:@"SELF  CONTAINS[C] %@ ",searchText];
    NSArray     * resultArray2=[mutablearay1 filteredArrayUsingPredicate:predict2];
  
    for (int k = 0; k<resultArray2.count; k++) {
        NSMutableString * muStr=resultArray2[k];
            NSArray * strArray=[muStr componentsSeparatedByString:@"+++"];
            People * p3=[[People alloc]init];
            p3.name=strArray[0];
            p3.phoneNum=strArray[1];
        p3.lastNameStr = [p3.name substringFromIndex:p3.name.length -1];
        [_resultArray addObject:p3];
    }
  
    for (NSMutableString * muStr in pred1Arr) {
        NSArray * strArray=[muStr componentsSeparatedByString:@"+++"];
        People * p=[[People alloc]init];
        p.phoneNum=strArray[1];
      
        NSPredicate * predict=[NSPredicate predicateWithFormat:@"SELF  ENDSWITH[c] %@ ",p.phoneNum];
        NSArray     * resultArray=[mutablearay1 filteredArrayUsingPredicate:predict];
        if (resultArray)
        {
            NSMutableString * muStr=resultArray[0];
            NSArray * strArray=[muStr componentsSeparatedByString:@"+++"];
            People * p2=[[People alloc]init];
            p2.name=strArray[0];
            p2.phoneNum=strArray[1];
            
            int  cont = 0 ;
            
            for (int k = 0; k<_resultArray.count; k++) {
                People * pk=_resultArray[k];
                if ([p2.name isEqualToString:pk.name]) {
                    cont = 1 ;
            
                }
            }
            if (cont==0) {
                
                [_resultArray addObject:p2];
            }
            
            
        }
    }
    return _resultArray;
}
 

//联系人拼音化
+(NSMutableDictionary *)pinYinZhuanHuaWithDataArray:(NSMutableArray *)dataArray WithNameArray:(NSMutableArray *)_nameMutablearray
{
    NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
    for (int i = 0;i < dataArray.count;i++){
        //获得联系人的名字
        People * p = [dataArray objectAtIndex:i];
        NSString * name = p.name ;


        if (name.length>0) {
            //把name中汉字转化为拼音 ；


            CFStringRef aCFString = (__bridge CFStringRef)name;
            CFMutableStringRef string1 = CFStringCreateMutableCopy(NULL,0, aCFString);
            CFStringTransform(string1, NULL, kCFStringTransformMandarinLatin, NO);
            CFStringTransform(string1, NULL, kCFStringTransformStripDiacritics, NO);
 

            NSString * name2 = (__bridge NSString*)string1 ;
            //获得姓名的首字母
            NSString *  firstCharacer = [name2 substringToIndex:1];

            firstCharacer = [firstCharacer uppercaseString];

            CFRelease(string1);
            //isHave是 看字典的key中是否存在这个首字符
            BOOL isHave = NO;
            NSArray * allKeys = [dic allKeys];

//            遍历所有的key值
            for (NSString * key in allKeys){
                //看字典的key中是否存在这个首字符
                if ([key isEqualToString:firstCharacer]){
                    //如果有，把联系人添加到这个key对应的数组中；
                    isHave = YES;
                    NSMutableArray * array = [dic objectForKey:key];
                    [array addObject:p];
                    break ;
                }
            } 
            //字典里面没有这个key
            if (isHave == NO){
                //字典里面添加一个键值对
                NSMutableArray * array = [NSMutableArray array];
                [dic setObject:array forKey:firstCharacer];
                [array addObject:p];
            }
        }
    }
//    NSLog(@"dic \n %@",dic);
    return dic;
}
 

+(NSMutableArray *)pinyinMutableArrayWithPinYinresultArray:(NSArray *)pinyinResultArray WithPhoneArray:(NSMutableArray *)phonemutablearray
{

    NSMutableArray * _pinyinResultArray =[NSMutableArray array];
    for (int j=0; j<pinyinResultArray.count; j++) {
        NSMutableString * muString=pinyinResultArray[j];
        NSArray * array2=[muString componentsSeparatedByString:@"+++"];
        People * p=[[People alloc]init];
        p.phoneNum=array2[1];
        //将结果号码纯在数组
      
        NSPredicate * predict=[NSPredicate predicateWithFormat:@"SELF  ENDSWITH[c] %@ ",p.phoneNum];
        NSArray     * resultArray=[phonemutablearray filteredArrayUsingPredicate:predict];
        if (resultArray)
        {
            NSMutableString * muStr=resultArray[0];
            NSArray * strArray=[muStr componentsSeparatedByString:@"+++"];
            People * p2=[[People alloc]init];
            p2.name=strArray[0];
            p2.phoneNum=strArray[1];
            [_pinyinResultArray addObject:p2];
//            NSLog(@"拼音 p.name%@  p.phone %@   ",p.name,p.phoneNum);
 
        }
    }
    return _pinyinResultArray;
} 

+(NSMutableArray *)numberSearchResultWithPhoneArray:(NSMutableArray *)phonemutablearray WithpinYinResultArray:(NSMutableArray *)pinyinResultArray  WithSearchText:(NSString *)text
{
     
        NSMutableArray * _seemutableArray =[NSMutableArray array];
   
        NSPredicate * predict=[NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",text];
        NSArray     * resultArray=[phonemutablearray filteredArrayUsingPredicate:predict];
        
        for (int i=0; i<resultArray.count; i++) {
            NSMutableString * muStr=resultArray[i];
            NSArray * strArray=[muStr componentsSeparatedByString:@"+++"];
            People * p=[[People alloc]init];
            p.name=strArray[0];
            p.phoneNum=strArray[1];
            [_seemutableArray addObject:p];
    
        }
        
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in  %@)", _seemutableArray];
        
        NSArray * theSameArray=[pinyinResultArray filteredArrayUsingPredicate:thePredicate];
        [_seemutableArray addObjectsFromArray:theSameArray];
    
    
    
    NSMutableArray * lastResultArray = [NSMutableArray array];
    for (int k = 0; k<_seemutableArray.count; k++) {
        People * p = _seemutableArray[k];

        BOOL statues = NO ;
        for (int j = 0; j<lastResultArray.count; j++) {
            People * p2 =lastResultArray[j];
            if ([p.name isEqualToString:p2.name]) {
                statues = YES ;
            }
        }
        if (statues == NO) {
            [lastResultArray addObject:_seemutableArray[k]];
        }
        
    }


    return lastResultArray;
}



@end
