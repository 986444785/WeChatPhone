//
//  BBContactName.h
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBContactName : NSObject
 
/**全名称*/
@property (nonatomic, copy)NSString *formatted;
/**姓*/
@property (nonatomic, copy)NSString *familyName;
/**名*/
@property (nonatomic, copy)NSString *givenName;
/**中名*/
@property (nonatomic, copy)NSString *middleName;
/**前缀 称呼前缀 (Mr. or Dr.) (String)*/
@property (nonatomic, copy)NSString *honorificPrefix;
/**后缀 称呼后缀 (Esq.). (String)*/
@property (nonatomic, copy)NSString *honorificSuffix;

/**pinName*/
@property (nonatomic, copy)NSString *pinName;

@end
