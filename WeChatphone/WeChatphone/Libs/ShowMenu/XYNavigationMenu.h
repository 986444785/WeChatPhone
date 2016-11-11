//
//  XYNavigationMenu.h
//  NavigationMenuDemo
//
//  Created by 汪鑫源 on 15/7/26.
//  Copyright (c) 2015年 汪鑫源. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYMenuButton : NSObject

/*!
 @brief Button title
 */
@property (copy, nonatomic, readonly) NSString *title;

/*!
 @brief Button icon 
 */
@property (strong, nonatomic, readonly) UIImage *icon;

/*!
 @brief Button init
 @param title title
 @param icon icon
 */
- (instancetype)initWithTitle:(NSString *)title buttonIcon:(UIImage *)icon;

@end  

@interface XYNavigationMenu : UIView

@property (copy, nonatomic, readonly) NSArray *items;
@property (strong, nonatomic) UIView *background;
@property (copy, nonatomic) void (^didTapBtnBlock)(UIButton *button);
  
@property BOOL isOpen; 
@property CGRect beforeAnimationFrame;
@property CGRect afterAnimationFrame;

/*!
 @brief Menu init
 @param items Items of XYMenuButton
 */
- (instancetype)initWithItems:(NSArray *)items;

/*!
 @brief Show menu
 @param navigationController Menu's NavigationController
 @param didTapBlock block of tap button done
 */
- (void)showInNavigationController:(UINavigationController *)navigationController didTapBlock:(void(^)(UIButton *button))didTapBlock;

/*!
 @brief dismiss menu
 */
- (void)dismiss;

@end
