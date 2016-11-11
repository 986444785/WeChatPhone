//
//  ZYTileMenuView.h
//  YouKeApp
//
//  Created by BBC on 16/1/7.
//  Copyright (c) 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYTileMenuView : UIView

/**
 *  方法
 */ 
@property(nonatomic,copy)void(^tileBtnClick)(int selectIndex);


-(instancetype)initWithFrame:(CGRect)frame;

/**
 *  创建视图
 *
 *  @param dic
 *  @param maxTag
 *  @param titles 标题
 *  @param imgs   图
 *  @param isOpen 判断按钮能不能用
 */
//-(void)createMenuViewWithDic:(NSDictionary *)dic WithMaxTag:(int)maxTag WithTitles:(NSArray*)titles  WithImgs:(NSArray *)imgs  WithIsopen:(BOOL)isOpen;

/**
 *  创建视图
 * 
 *  @param contents 内容
 *  @param maxTag   图
 *  @param isOpen   判断按钮能不能用
 */
//-(void)createMenuViewWithContents:(NSArray *)contents WithMaxTag:(int)maxTag   WithIsopen:(BOOL)isOpen;
-(void)createMenuViewWithContents:(NSArray *)contents WithMaxTag:(int)maxTag   WithIsopen:(BOOL)isOpen ;
@end
