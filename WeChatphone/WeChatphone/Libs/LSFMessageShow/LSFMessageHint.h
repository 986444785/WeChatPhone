//
//  LSFMessageHint.h
//  LSFVideoPlayerDemo
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 ShengfengLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LSFMessageHint : NSObject
{
    UIView *_hintView;  //提示框
    UIActivityIndicatorView *_activityView; //风火轮
    UILabel *_label;  // a label
    
//    CGFloat _xOffset;    //x方向偏移量
//    CGFloat _yOffset;    //y方向偏移量
} 
/** 
 *  创建提示框 
 *
 *  @param activity 是否显示风火轮
 *  @param message  显示文字,如果为nil则不显示
 */
+ (void)showHintViewWithActivity:(BOOL)activity AndMessage:(NSString *)message yOffset:(CGFloat)yOffset;

/**
 *  隐藏提示框
 *
 *  @param animate 是否伴有动画
 */
+ (void)hideHintViewWithAnimate:(BOOL)animate;

/**
 *  创建只有风火轮的提示框
 */
+ (void)showHintViewWithYOffset:(CGFloat)yOffset;

/**
 *  创建只有文字的提示框
 *
 *  @param message 文字内容
 */
+ (void)showHintViewWithMessage:(NSString *)message yOffset:(CGFloat)yOffset;

/**
 *  创建只有文字的提示框,并且在2秒后自动隐藏
 *
 *  @param message 文字内容
 */
+ (void)showToolMessage:(NSString *)message yOffset:(CGFloat)yOffset;

/**
 *  创建只有文字的提示框,并且在指定时间后自动隐藏
 *
 *  @param message  文字内容
 *  @param interval 制定隐藏时间
 */
+ (void)showToolMessage:(NSString *)message hideAfter:(NSTimeInterval)interval yOffset:(CGFloat)yOffset;
@end
