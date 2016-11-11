//
//  ZYLinkManSingleton.h
//  WeChatphone
//
//  Created by BBC on 16/4/19.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYLinkManSingleton : NSObject
  
/** 
 *  保存的联系人
 */
@property(nonatomic,strong) NSMutableArray * peoples;


/**  
 *  实现一个单例的获得方法 
 * 
 *  @return
 */
//+(ZYLinkManSingleton *)defaultSingleton;
+(ZYLinkManSingleton *)defaultSingletonISRefresh:(BOOL)isRefresh;

/**
 *  单例去做的事情
 */
//-(void)doSomething;
-(void)doSomethingWithIsRefresh:(BOOL)isRefresh;


@end
