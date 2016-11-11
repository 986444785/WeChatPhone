//
//  ZYPhoneAction.h
//  WeChatphone
//
//  Created by BBC on 16/4/22.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYPhoneAction : NSObject

 
/**
 *  添加联系人1
 */
+(void)addLinkMainWithDict:(NSDictionary *)dict;
/**
 *  添加联系人2
 */
+(void)addWithName:(NSString *)name withPhoneNum:(NSString *)phoneNum;

/**
 *  删除联系人 
 */
//+(void)deleteLinkMainWithName:(NSString *)name WithPhone:(NSString *)phone;
+(void)deleteLinkMainWithDict:(NSDictionary *)dict;

/** 
 * 添加到通讯录
 */
+(void)regreshAddressBookWithName:(NSString *)name WithPhone:(NSString *)phoneNum isadd:(BOOL)isAdd;
@end
 