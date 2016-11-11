//
//  CHAddressEngine.m
//  FoodWorld
//
//  Created by t on 15-3-9.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "CHAddressEngine.h"


@implementation CHAddressEngine


//验证数字
+(BOOL)isValidateTelNumber:(NSString *)number {
    
    //    NSString *strRegex = @"[0-9]{11,11}";
    NSString *strRegex = @"[0-9]{0,11}";
    
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    
    return rt;
    
}


+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression

{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
    return [predicate evaluateWithObject:strDestination];
    
}


+(BOOL)isMobilePhoneWith:(NSString *)phoneNum
{

    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[024-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0127-9]|78|8[23478])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|45|76|5[56]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|7[07]|8[019])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phoneNum] == YES)
        || ([regextestcm evaluateWithObject:phoneNum] == YES)
        || ([regextestct evaluateWithObject:phoneNum] == YES)
        || ([regextestcu evaluateWithObject:phoneNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



+(NSString*)ismobilePhoneWith:(NSString *)mobileNum
{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{0,8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0127-9]|78|8[23478])\\d)\\d{0,7}$";
    NSString * CU = @"^1(3[0-2]|45|76|5[56]|8[56])\\d{0,8}$";
    NSString * CT = @"^1((33|53|7[07]|8[019])[0-9]|349)\\d{0,7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum])
        || ([regextestcm evaluateWithObject:mobileNum])
        || ([regextestct evaluateWithObject:mobileNum])
        || ([regextestcu evaluateWithObject:mobileNum]))
    {
        if([regextestcm evaluateWithObject:mobileNum]) {
            
            return @"中国移动";
        } else if([regextestct evaluateWithObject:mobileNum]) {
            
            return @"中国电信";
        } else if ([regextestcu evaluateWithObject:mobileNum]) {
            
            return @"中国联通";
        } else {
            
            return  @" ";
        }
        
    }
    return @" ";
    
    
}



@end
