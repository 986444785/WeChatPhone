//
//  JsonUtils.h
//  auto
//
//  Created by peacock on 14-7-17.
//  Copyright (c) 2014年 sutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject
+ (NSString*)DataToPrettyJsonString:(id)object;
+ (NSString*)DataToJsonString:(id)object;
@end 
    