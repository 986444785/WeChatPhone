//
//  TabbarShowHiden.h
//  ZYPhoneCall
//
//  Created by t on 15-3-24.
//  Copyright (c) 2015年 RZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabbarShowHiden : NSObject
 
@property(nonatomic,assign) id delegate;
/**
 *  出现tabbar 
 *
 *  @param tabbardelegate 代理
 */
+(void)tabbarShowWithdelegate:(id)tabbardelegate;//bigvc
/**
 *  隐藏tabbar
 *
 *  @param tabbardelegate 代理
 */
+(void)tabbarHidenWithdelegate:(id)tabbardelegate; 
  
 

@end
 