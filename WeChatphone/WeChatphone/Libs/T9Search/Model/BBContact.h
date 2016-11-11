//
//  BBContact.h
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BBContactName;
@class BBContactAddress;
@class BBContactOrganization;
@interface BBContact : NSObject 

/**uuid: 在手机端、服务端相同的唯一识别id，(String) */
@property (nonatomic, copy)NSString *uuid;
/**displayName: 显示在手机设备、网页上的名字字符串 (String)*/
@property (nonatomic, copy)NSString *displayName;
/**name: 包含联系人名字所有属性的对象. (ContactName)*/
@property (nonatomic, strong) BBContactName *contactName;
/**nickname: 昵称，由此联系人设定，不可在应用中修改别人的昵称. (String)*/
@property (nonatomic, copy) NSString *nickname;
/**nameRemark: 相当于QQ的姓名备注，可以在应用中修改别人的昵称,服务器数据库中不保存此字段 (String)*/
//@property (nonatomic, copy) NSString *nameRemark;
/**birthday: 生日. (Date) */
@property (nonatomic, copy) NSString *birthday;
/**note: 联系人备注，可输入较长的文本信息. (Text)*/
@property (nonatomic, copy) NSString *note;
/**phoneNumbers: 保存电话号码信息的json对象数组. (ContactField[])*/
@property (nonatomic, strong) NSArray *phoneNumbers;
/**emails: 保存email信息的json对象数组. (ContactField[])*/
@property (nonatomic, strong) NSArray *emails;
/**addresses: 保存地址信息的json对象数组. (ContactAddress[])*/
@property (nonatomic, strong) NSArray *contactAddress;
/**ims: 保存即时通讯帐号的json对象数组. (ContactField[])*/
@property (nonatomic, strong) NSArray *ims;
/**photos: 联系人头像数组. (ContactField[])*/
@property (nonatomic, copy) NSString *photo;
/**categories: 分组(TODO 有待商议). (ContactField[])*/
//@property (nonatomic, strong) NSArray *categories;
/**organizations: 保存公司/组织信息的json对象数组. (ContactOrganization[])*/
@property (nonatomic, strong) BBContactOrganization *contactOrganization;
/**urls: 联系人的主页列表. (ContactField[])*/
@property (nonatomic, strong) NSArray *urls;

#pragma mark - 暂用
@property (nonatomic, strong) NSNumber *localID;
@property (nonatomic, strong) NSDictionary *dic;


@end
