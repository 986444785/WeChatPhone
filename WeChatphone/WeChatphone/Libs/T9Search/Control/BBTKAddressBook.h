//
//  BBTKAddressBook.h
//  123
//
//  Created by 李灵斌 on 15-4-11.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBTKAddressBook : NSObject

/**名字*/
@property (nonatomic, copy) NSString *name;
 
//**recordID*/
@property (nonatomic,assign)int recordID;
 
/**头像*/
@property (nonatomic, strong) NSData *heardImage;

/**工作*/
@property (nonatomic, copy) NSString *job;

/**公司*/
@property (nonatomic, copy) NSString *company;

/**电话号码*/
@property (nonatomic, strong) NSArray *phones;

/**邮件*/
@property (nonatomic, strong) NSArray *mails;

/**创建时间*/
@property (nonatomic, copy) NSString *createTime;

/**生日*/
@property (nonatomic, copy) NSString *birthday;

/**描述*/
@property (nonatomic, copy) NSString *detail;

/**不带头像的明信片*/
@property (nonatomic, strong) NSData *vCardWithoutPortrait;

/**带头像的明信片*/
@property (nonatomic, strong) NSData *vCardWithPortrait;

//**组名称*/
@property (nonatomic, copy) NSString *groupName;

//**组的成员*/
@property (nonatomic, strong) NSArray *groupMembers;

@end
