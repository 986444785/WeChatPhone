//
//  ZYTitleView.h
//  WeChatphone
//
//  Created by BBC on 16/4/19.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYTitleView : UIView
/** 
 *  编辑按钮 
 */
@property(nonatomic,copy) void(^editButtonClick)(NSString *str);

/**   
 *    title变化处理事件
 * 
 *  @param text
 *  @param isEdit
 *  @param titeHiden 隐藏标题
 */
-(void)titleChangeWithText:(NSString *)text WithEdit:(BOOL)isEdit titleHiden:(BOOL)titeHiden;

@end

  