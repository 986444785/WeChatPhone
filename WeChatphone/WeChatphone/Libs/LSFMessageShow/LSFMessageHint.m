//
//  LSFMessageHint.m
//  LSFVideoPlayerDemo
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 ShengfengLee. All rights reserved.
//

#import "LSFMessageHint.h"
#import "NSString+LSFString.h"

#ifndef kScreenHeight
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef kScreenWidth
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#endif

@interface LSFMessageHint ()

@property (nonatomic, retain)UIView *hintView;
@property (nonatomic, retain)UIActivityIndicatorView *activityView;
@property (nonatomic, retain)UILabel *label;

- (void)createLabelWithMessage:(NSString *)message andXpoint:(CGFloat)x;
- (void)createActivityView;
- (void)killShareInstance;
- (void)hideHintViewAfter:(NSTimeInterval)interval;
- (void)hideHintView;
@end

@implementation LSFMessageHint

@synthesize hintView = _hintView;
@synthesize activityView = _activityView;
@synthesize label = _label;

static LSFMessageHint *_shareInstance;
+ (id)shareInstance
{
    if (_shareInstance == nil) {
        _shareInstance = [[LSFMessageHint alloc] init];
    }
    return _shareInstance;
}



/**
 *  创建Label
 *
 *  @param message Label显示的内容
 *  @param x       Label的X坐标
 */
- (void)createLabelWithMessage:(NSString *)message andXpoint:(CGFloat)x
{
    if (self.label != nil) {
        [self.label removeFromSuperview];
        self.label = nil;
    }
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:15.0f];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.text = message;
    self.label.numberOfLines = 0;
//    self.label.backgroundColor = [UIColor redColor];
    //计算Label的size
    CGSize size = [message LSFSizeWithFont:self.label.font constrainedToSize:CGSizeMake(kScreenWidth - 40 - x - 5, kScreenWidth - 100)];
    
    self.label.frame = CGRectMake(0, 0, size.width, size.height);
    
    self.label.center = CGPointMake(size.width/2 + x, size.height/2 + 5);
    
    [self.hintView addSubview:self.label];
}

/**
 *  创建风火轮
 */
- (void)createActivityView
{
    if (self.activityView != nil) {
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(8, 5, 50, 50)];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.activityView startAnimating];
    [self.hintView addSubview:self.activityView];
}

/**
 *  创建提示框
 *
 *  @param activity 是否显示风火轮
 *  @param message  显示文字,如果为nil则不显示
 */
+ (void)showHintViewWithActivity:(BOOL)activity AndMessage:(NSString *)message yOffset:(CGFloat)yOffset
{
    [LSFMessageHint shareInstance];
    
    if (_shareInstance.hintView != nil)
    {
        [_shareInstance.hintView removeFromSuperview];
        _shareInstance.hintView = nil;
    }
    
    _shareInstance.hintView = [[UIView alloc] init];
    _shareInstance.hintView.backgroundColor = [UIColor blackColor];
    _shareInstance.hintView.layer.cornerRadius = 5.0f;
    
    CGFloat x = 5.0f;   //记录宽度
    CGFloat y = 0.0f;   //记录高度
    //带有风火轮
    if (activity) {
        [_shareInstance createActivityView];
        x += 50 + 5;
        y = 60;
    }
    
    if (message) {
        [_shareInstance createLabelWithMessage:message andXpoint:x];
        x += _shareInstance.label.frame.size.width + 5;
        y = _shareInstance.label.frame.size.height + 10;
        //如果有风火轮
        if (activity) {
            if (y < 60) {
                y = 60;
                _shareInstance.label.center = CGPointMake(_shareInstance.label.center.x, 30);
            }
        }
    }
    
    _shareInstance.hintView.frame = CGRectMake(0, 0, x, y);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGSize size = window.bounds.size;
    _shareInstance.hintView.center = CGPointMake(size.width/2, size.height/2 + yOffset);
    [window addSubview:_shareInstance.hintView];
    
}

/**
 *  创建带有风火轮的提示框
 */
+ (void)showHintViewWithYOffset:(CGFloat)yOffset
{
    [LSFMessageHint showHintViewWithActivity:YES AndMessage:nil yOffset:yOffset];
}

/**
 *  创建只有文字的提示框
 *
 *  @param message 文字内容
 */
+ (void)showHintViewWithMessage:(NSString *)message yOffset:(CGFloat)yOffset
{
    [LSFMessageHint showHintViewWithActivity:NO AndMessage:message yOffset:yOffset];
}

/**
 *  隐藏提示框
 *
 *  @param animate 是否伴有动画
 */
+ (void)hideHintViewWithAnimate:(BOOL)animate
{
    if (!animate) {
        [_shareInstance.hintView removeFromSuperview];
        [_shareInstance killShareInstance];
    }
    else
    {
        [UIView animateWithDuration:0.2f animations:^{
            _shareInstance.hintView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [_shareInstance.hintView removeFromSuperview];
            [_shareInstance killShareInstance];
        }];
    }
}
 
/**
 *  隐藏提示框
 */
- (void)hideHintView
{
    [UIView animateWithDuration:0.25f animations:^{
        _shareInstance.hintView.alpha = 0.0f;

    } completion:^(BOOL finished) {
        [_shareInstance.hintView removeFromSuperview];
        [_shareInstance killShareInstance];
    }];
}

/**
 *  指定时间后隐藏提示框
 *
 *  @param interval 指定时间
 */
- (void)hideHintViewAfter:(NSTimeInterval)interval
{
    [self performSelector:@selector(hideHintView) withObject:nil afterDelay:interval];
}

/**
 *  创建只有文字的提示框,并且在2秒后自动隐藏
 *
 *  @param message 文字内容
 */
+ (void)showToolMessage:(NSString *)message yOffset:(CGFloat)yOffset
{
    [LSFMessageHint showToolMessage:message hideAfter:2 yOffset:yOffset];

}

/**
 *  创建只有文字的提示框,并且在指定时间后自动隐藏
 *
 *  @param message  文字内容
 *  @param interval 制定隐藏时间
 */
+ (void)showToolMessage:(NSString *)message hideAfter:(NSTimeInterval)interval yOffset:(CGFloat)yOffset
{
    [LSFMessageHint showHintViewWithMessage:message yOffset:yOffset];
    [_shareInstance hideHintViewAfter:interval];
}

/**
 *  将_shareInstance置空
 */
- (void)killShareInstance
{
    _shareInstance.label = nil;
    _shareInstance.activityView = nil;
    _shareInstance.hintView = nil;
    _shareInstance = nil;
}

- (void)dealloc
{
    [_shareInstance killShareInstance];
}

@end
