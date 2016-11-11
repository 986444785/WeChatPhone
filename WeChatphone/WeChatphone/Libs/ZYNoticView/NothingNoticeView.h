//
//  NothingNoticeView.h
//  YouKeApp
//
//  Created by BBC on 15/9/26.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NothingNoticeView : UIView

@property(nonatomic,assign) id delegate;

//-(void)getBgViewWithMessage:(NSString *)message withNotice:(NSString *)noticeStr;
-(void)getBgViewWithMessage:(NSString *)message withNotice:(NSString *)noticeStr WithShowImg:(NSString *)showImg;

@end 

@protocol NothingNoticeViewDelegate <NSObject>

-(void)changeBtnClick:(NSString*)str;

@end       