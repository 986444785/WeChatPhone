//
//  TabbarShowHiden.m
//  ZYPhoneCall
//
//  Created by t on 15-3-24.
//  Copyright (c) 2015年 RZL. All rights reserved.
// 

#import "TabbarShowHiden.h"
#import "Header.h"

@implementation TabbarShowHiden
  
+(void)tabbarShowWithdelegate:(id)tabbardelegate
{ 
 
    UIViewController * big=tabbardelegate;
    NSArray * array=big.tabBarController.view.subviews;
    for (int i=0; i<array.count; i++) {
        UIView * view=array[i];
        if ([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, VIEW_Hight-49, view.frame.size.width, view.frame.size.height)];
            break ;
        }
    }

}   
 

+(void)tabbarHidenWithdelegate:(id)tabbardelegate
{

    int height = VIEW_Hight + 100;
    UIViewController * big=tabbardelegate;
    NSArray * array=big.tabBarController.view.subviews;
    for (int i=0; i<array.count; i++) {
        UIView * view=array[i];
        if ([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, height, view.frame.size.width, view.frame.size.height)];
            break ;
        }
    }

}




@end
