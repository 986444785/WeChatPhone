//
//  BBContactIm.h
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBContactIm : NSObject
/**type: 类型，英文，无空格等空白字符 (String)*/
@property (nonatomic, copy) NSString *type;
/**value: 值. (String)*/
@property (nonatomic, copy) NSString *value;
/**pref: 是否为优先，比如有多个号码，被标注为pref为true后表示优先使用这个号码打电话. (boolean)*/
@property (nonatomic, assign) BOOL pref;
@end
