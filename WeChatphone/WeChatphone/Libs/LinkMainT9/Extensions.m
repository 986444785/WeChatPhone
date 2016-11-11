//
//  Extensions.m
//  ZYPhoneCall
//
//  Created by t on 15-3-11.
//  Copyright (c) 2015年 RZL. All rights reserved.
//

#import "Extensions.h"

@implementation NSString (Extensions)

- (void)enumerateCharsUsingBlock:(void (^)(unichar character, NSUInteger idx, BOOL *stop))block
{
    for (NSUInteger idx = 0; idx < self.length; idx++) {
        unichar character = [self characterAtIndex:idx];
        BOOL stop = NO;
        block(character, idx, &stop);
        if (stop) {
            break;
        }
    }
}

@end
