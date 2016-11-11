//
//  UIBarButtonItem+CH.h
//  新闻
//
//  Created by Think_lion on 15/5/4.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CH)
+(UIBarButtonItem*)itemWithIcon:(NSString *)icon highIcon:(NSString*)highIcon target:(id)target action:(SEL)action;

/**
 *  设置文字方法
 */ 
+(UIBarButtonItem *)itemWithTitle:(NSString *)title WithTitleColor:(UIColor *)color  withFont:(NSInteger)font target:(id)target action:(SEL)action;

@end
