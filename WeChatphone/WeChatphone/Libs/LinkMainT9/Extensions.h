//
//  Extensions.h
//  ZYPhoneCall
//
//  Created by t on 15-3-11.
//  Copyright (c) 2015年 RZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)
- (void)enumerateCharsUsingBlock:(void (^)(unichar character, NSUInteger idx, BOOL *stop))block;
@end