//
//  ZYLinkManSingleton.m
//  WeChatphone
//
//  Created by BBC on 16/4/19.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYLinkManSingleton.h"
#import "LinkManAddressBook.h"
static ZYLinkManSingleton * __singleton ;

@implementation ZYLinkManSingleton
 
+(ZYLinkManSingleton *)defaultSingletonISRefresh:(BOOL)isRefresh
{
     //为了防止多个线程同时判断单例是否存在，从而导致同时创建单例。判断的时候必须加线程同步。
    @synchronized(self) {
        if (!__singleton) {
            __singleton = [[ZYLinkManSingleton alloc]init];

        } 
    }
     [__singleton doSomethingWithIsRefresh:isRefresh];
    return __singleton;
}

//为了防止人为创建单例类，重写alloc方法。
+(id)alloc
{
    //单例类的创建最好用dispatch_once。
    //使用dispatch_once就不需要再进行判断，也不需要关心线程同步。
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        __singleton = [super alloc];
    });
    return __singleton; 
}
 
-(void)doSomethingWithIsRefresh:(BOOL)isRefresh
{ 
//    NSLog(@"doSomething");
 
    if (!self.peoples) { 
 
        NSLog(@"建最好用dispatch_once。使用dispatch_once就不需要再进行判断，也不需要关心线程同步。");
        self.peoples = [LinkManAddressBook getAddressBook];
    }else if (isRefresh){
        self.peoples = [LinkManAddressBook getAddressBook];

    }

}

 


@end
