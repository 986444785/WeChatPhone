//
//  ChineseToPinyinHelper.h
//  DialContact
//
//  Created by lczh on 12-2-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseToPinyinHelper : NSObject
+ (NSString *)FindLetter:(int) nCode;
+ (char)pinyinFirstLetter:(unsigned short) hanzi;
@end
