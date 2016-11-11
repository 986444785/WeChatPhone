//
//  BBContactAddress.h
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBContactAddress : NSObject

/**type: 地址类型，比如 work, home/personal. (String)*/
@property (nonatomic, copy) NSString *type;
/**pref: 是否为优先. (boolean)*/
@property (nonatomic, assign) BOOL pref;
/**formatted: 将地址全部信息格式化显示的字符串. (String)*/
@property (nonatomic, copy) NSString *formatted;
/**streetAddress: 街道详情，比如西二旗上地十街辉煌国际2号楼. (String)*/
@property (nonatomic, copy) NSString *streetAddress;
/**region: 城区，比如海淀区. (String)*/
@property (nonatomic, copy) NSString *region;
/**city: 城市. (String)*/
@property (nonatomic, copy) NSString *city;
/**province: 省份. (String)*/
@property (nonatomic, copy) NSString *province;
/**country: 国家. (String)*/
@property (nonatomic, copy) NSString *country;
/**postalCode: 邮政编码. (String)*/
@property (nonatomic, copy) NSString *postalCode;

@end
