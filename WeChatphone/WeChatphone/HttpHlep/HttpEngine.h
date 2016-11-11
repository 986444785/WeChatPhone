//
//  HttpEngine.h
//  WeChatphone
//
//  Created by BBC on 16/4/19.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Header.h"
@interface HttpEngine : NSObject

/**
 *  关于二维码
 */
+(void)getTwoCodeComplate:(void (^)(NSDictionary *response))complate;



/**
 *  前往系统设置
 */
+(void)systemSetting;
 
/**
 *  拨打电话
 */
//+(void)telephoneCallWithCompate:(void(^)(NSDictionary *responsedic))complate;
//+(void)telephoneCallWithObject:(id)object Compate:(void(^)(NSDictionary *responsedic))complate;
+(void)telephoneCallWithPhoneNum:(NSString *)phoneNum  Object:(id)object Compate:(void(^)(NSDictionary *responsedic))complate;
/**
 *  果断电话
 */
+(void)telePhoneHandleUpWithPhoneNum:(NSString *)phoneNum;
 
/**
 *  验证token
 */
+(void)verifyTokenWithStr:(NSString *)token Complate:(void(^)(BOOL isToken))complate;

/**
 *  profile 
 */
//+(void)getProfileComplate:(void(^)(NSDictionary *responseDic))complate;
+(void)getProfileWithObject:(id)Object Complate:(void(^)(NSDictionary *responseDic))complate;

/**
 *  上传通讯录
 */
+(void)upLoadAddressBookWithArrays:(NSArray *)arrays WithObject:(id)object Complate:(void(^)(NSDictionary *responseDic))complate;

/**
 *  获取验证码
 */
+(void)getMessageTokenWithPhoneNumber:(NSString *)phoneNumber Complate:(void(^)(NSDictionary*response))complate;

/**
 *  绑定手机号码
 */
+(void)bindingPhoneNumber:(NSString *)phoneNumber withMesssageToken:(NSString *)messageToken Complate:(void(^)(NSDictionary * response))complate;



/**
 *  socket server event
 *
 *  @param message
 */
+(NSString *)eventWorkWithMessage:(NSString *)message;

/**
 * 
 *  保存token
 */
//+(void)getTokenWIthDataDic:(NSDictionary *)dataDic;


/**
 *  json转化
 */
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

/**
 *  字典转化字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/**
 *  整形判断
 */
+ (BOOL)isPureInt:(NSString *)string;


@end
 