//
//  CHAddressEngine.h
//  FoodWorld
//
//  Created by t on 15-3-9.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHAddressEngine : NSObject

+(BOOL)isMobilePhoneWith:(NSString*)phoneNum;

+(NSString*)ismobilePhoneWith:(NSString *)mobileNum;

//验证数字
+(BOOL)isValidateTelNumber:(NSString *)number;

+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression;

@end
