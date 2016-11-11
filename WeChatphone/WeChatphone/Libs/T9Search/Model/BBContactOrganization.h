//
//  BBContactOrganization.h
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBContactOrganization : NSObject

/**pref: 是否为默认. (boolean)*/
@property (nonatomic, assign) BOOL pref;
/**type: 类型(String)*/
@property (nonatomic, copy) NSString *type;
/**name: 公司、组织名称(String)*/
@property (nonatomic, copy) NSString *name;
/**department: 部门. (String)*/
@property (nonatomic, copy) NSString *department;
/**title: 头衔. (String)*/
@property (nonatomic, copy) NSString *title;

@end
