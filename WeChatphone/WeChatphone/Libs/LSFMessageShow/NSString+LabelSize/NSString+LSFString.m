//
//  NSString+LSFString.m
//  GameShow
//
//  Created by apple on 14-3-4.
//  Copyright (c) 2014年 ShengfengLee. All rights reserved.
//

#import "NSString+LSFString.h"

#import <CommonCrypto/CommonDigest.h>

#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER   ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) //ios 7
#endif

@implementation NSString (LSFString)
- (CGSize)LSFSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize reSurltSize;
    if (IOS7_OR_LATER) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGRect frame = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        reSurltSize = frame.size;
    }
    else
    {
      reSurltSize  =   [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;

//        reSurltSize  = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];

    }
    return reSurltSize;
}

@end
