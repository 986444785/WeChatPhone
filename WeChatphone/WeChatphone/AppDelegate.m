//
//  AppDelegate.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYLinkManController.h"
#import "ZYDialHomeController.h"
#import "ZYProfileController.h"
#import "ZYGetBaseData.h"
#import "PSWebSocketServer.h"
#import "PSWebSocketDriver.h"
#import "People.h"
#import "HttpEngine.h" 
#import "ZYPhoneAction.h"
//#import "MobClick.h"
#import "BackgroundRunner.h"

#import "RxWebViewNavigationViewController.h"

#import "YFStartView.h"
#import "StartButtomView.h"v  v


@interface AppDelegate ()<PSWebSocketServerDelegate>
@property (nonatomic, strong) PSWebSocketServer *server;
@property(nonatomic,strong) NSMutableArray * Storages;
@property (nonatomic,strong) PSWebSocket  * psWebSockte;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.



//    YFStartView *startView = [YFStartView startView];
//    startView.isAllowRandomImage = YES;
//
//    startView.randomImages = @[@"http://img4.duitang.com/uploads/item/201510/05/20151005190434_CzmhJ.jpeg"];
//
//    startView.logoPosition = LogoPositionButtom;
//    StartButtomView *startButtomView = [[[NSBundle mainBundle] loadNibNamed:@"StartButtomView" owner:self options:nil] lastObject];
//
//    startView.logoView = startButtomView;
//
//    [startView configYFStartView];




    [GCDQueue executeInGlobalQueue:^{

//        [self setWebSocketServer];

//        [MobClick startWithAppkey:@"572049e767e58ebf1b001470" reportPolicy:BATCH channelId:@"WeChatPhone"];
    }];

    [self goMainController];

    [self.window makeKeyAndVisible];

    YFStartView *startView = [YFStartView startView];
    startView.isAllowRandomImage = YES;

    startView.randomImages = @[@"http://img4.duitang.com/uploads/item/201510/05/20151005190434_CzmhJ.jpeg"];

    startView.logoPosition = LogoPositionButtom;
    StartButtomView *startButtomView = [[[NSBundle mainBundle] loadNibNamed:@"StartButtomView" owner:self options:nil] lastObject];

    startView.logoView = startButtomView;

    [startView configYFStartView];
     
    return YES;
} 
 


 
-(void)goMainController
{
    ZYDialHomeController * dialVC   = [[ZYDialHomeController alloc]init];
    ZYLinkManController * linkmanVC = [[ZYLinkManController alloc]init];
    ZYProfileController * profileVC = [[ZYProfileController alloc]init];

    RxWebViewNavigationViewController * dialNav    = [[RxWebViewNavigationViewController alloc]initWithRootViewController:dialVC];
    dialNav.tabBarItem.title            = @"拨号";
    dialNav.tabBarItem.image            = [[UIImage imageNamed:@"icon_phone_hollow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dialNav.tabBarItem.selectedImage    = [[UIImage imageNamed:@"icon_nav_phone_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
    RxWebViewNavigationViewController * linkmanNav = [[RxWebViewNavigationViewController alloc]initWithRootViewController:linkmanVC];
    linkmanNav.tabBarItem.title         = @"通讯录";
    linkmanNav.tabBarItem.image         = [[UIImage imageNamed:@"tabbar_linkman"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    linkmanNav.tabBarItem.selectedImage  =[[UIImage imageNamed:@"tabbar_linkman_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    RxWebViewNavigationViewController * profileNav = [[RxWebViewNavigationViewController alloc]initWithRootViewController:profileVC];
    profileNav.tabBarItem.title         = @"设置";
    profileNav.tabBarItem.image         = [[UIImage imageNamed:@"tabbar_profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

 
    //设置tabbartitle color
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    UIColor * titleHeightColor = [UIColor colorWithRed:0.388 green:0.790 blue:0.371 alpha:1.000];
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      titleHeightColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    //设置nav颜色 
    [[UINavigationBar appearance]setBarTintColor:NavBar_Color];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    //状态栏 修改为白色字
//    1在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO
//    2
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];


    UITabBarController * tabController  = [[UITabBarController alloc]init];
    tabController.viewControllers       = @[dialNav,linkmanNav,profileNav];

    /**
     设置tabbar颜色
     */
    UIView * tabbarColor = [[UIView alloc]initWithFrame:tabController.tabBar.bounds];
    tabbarColor.backgroundColor = [UIColor whiteColor];

    UILabel * lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tabController.tabBar.bounds.size.width, 0.5)];
    lineLab.backgroundColor = [UIColor colorWithWhite:0.847 alpha:1.000];
    [tabbarColor addSubview:lineLab];


    [tabController.tabBar insertSubview:tabbarColor atIndex:0];
    tabController.tabBar.opaque = YES;

    self.window.rootViewController = tabController;

    //监听通讯录
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRegisterExternalChangeCallback(addressBook, addressBookChanged, (__bridge void *)(linkmanVC));

    [self performSelectorInBackground:@selector(runningInBackground) withObject:nil];

}


 
#pragma mark - -后台定时器
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        [[BackgroundRunner shared] run];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[BackgroundRunner shared] stop];

}

- (void)runningInBackground
{
    while (1) {
        [NSThread sleepForTimeInterval:1];
        _backgroundRunningTimeInterval  ++;
//        NSLog(@"%d",(int)_backgroundRunningTimeInterval);
    }
}


#pragma mark -- 监听通讯录变化
void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    static int changeCount = 0 ;
    changeCount ++ ;
    if (changeCount ==3) {
        changeCount = 0;
        [ZYPhoneAction regreshAddressBookWithName:nil WithPhone:nil isadd:YES];
    }

}


#pragma mark -- 开启websocket server

-(void)setWebSocketServer 
{ 
    _Storages = [NSMutableArray array];

    self.server = [PSWebSocketServer serverWithHost:@"0.0.0.0" port:6088];
    self.server.delegate = self;
    [self.server start];
} 

#pragma mark - PSWebSocketServerDelegate

- (void)serverDidStart:(PSWebSocketServer *)server {

    NSLog(@"PSWebSocketServer   star");
}
- (void)server:(PSWebSocketServer *)server didFailWithError:(NSError *)error {
    [NSException raise:NSInternalInconsistencyException format:error.localizedDescription];

    NSLog(@"PSWebSocketServer 222 ");
}
- (void)serverDidStop:(PSWebSocketServer *)server {
    [NSException raise:NSInternalInconsistencyException format:@"Server stopped unexpected."];
    NSLog(@"PSWebSocketServer 333 ");
}

- (void)server:(PSWebSocketServer *)server webSocketDidOpen:(PSWebSocket *)webSocket {

    //有设备连接上，
    self.psWebSockte = webSocket;
    [self getLoginToken];
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {

    // 判断是不是数字
    self.psWebSockte = webSocket;

    if ([HttpEngine isPureInt:message]) {
        int heart = [message intValue] + 1 ;
        [webSocket send:[NSString stringWithFormat:@"%d",heart]];
    }else{

        NSLog(@"接收消息 %@",message);

        NSString * jsonStr = [HttpEngine eventWorkWithMessage:message];


        if (jsonStr) {
            [self.psWebSockte send:jsonStr];
        }

    }
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {

    NSLog(@"didFailWithError %@",error);
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Server websocket did close with code: %@, reason: %@, wasClean: %@", @(code), reason, @(wasClean));
}

- (void)server:(PSWebSocketServer *)server webSocketDidFlushInput:(PSWebSocket *)webSocket
{
    //    [webSocket send:@"send out--输出"];
}

 
#warning mark --- 4 后台刷新？？

#pragma mark -- 请求一个验证
-(void)getLoginToken
{
    NSString * requestStr = @"{\"flag\":0,\"msg_id\":1,\"data\":{\"cmd\":\"auth\",\"args\":{}}}";
    [self.psWebSockte send:requestStr];
}
 
#pragma mark -- 回到前台工作

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"回到前台工作");
}


- (void)applicationWillResignActive:(UIApplication *)application {

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
