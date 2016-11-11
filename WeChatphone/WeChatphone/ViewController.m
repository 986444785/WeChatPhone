//
//  ViewController.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ViewController.h"
#import "ZYLinkManController.h"
#import "ZYDialHomeController.h"
#import "ZYProfileController.h"
#import "ZYGetBaseData.h"
#import "PSWebSocketServer.h"
#import "PSWebSocketDriver.h"
#import "People.h"
#import "HttpEngine.h"
#import "ZYPhoneAction.h"
#import "RxWebViewNavigationViewController.h"

#import "AppDelegate.h" 
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


//    [self goMainController];

//        if (![ZYGetBaseData getBaseData]) {
//    
//            [GCDQueue executeInMainQueue:^{
//    
//                NSLog(@"获取不到联系人");
//    
//                [self alterviewNotice];
//            }];
//        }


 
}

//-(void)alterviewNotice
//{
//    UIAlertView * alterView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有允许获'友客'取通讯录信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alterView show];
//}
//
//-(void)goMainController
//{
//    ZYDialHomeController * dialVC   = [[ZYDialHomeController alloc]init];
//    ZYLinkManController * linkmanVC = [[ZYLinkManController alloc]init];
//    ZYProfileController * profileVC = [[ZYProfileController alloc]init];
//
//    RxWebViewNavigationViewController * dialNav    = [[RxWebViewNavigationViewController alloc]initWithRootViewController:dialVC];
//    dialNav.tabBarItem.title            = @"拨号";
//    dialNav.tabBarItem.image            = [[UIImage imageNamed:@"icon_phone_hollow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    dialNav.tabBarItem.selectedImage    = [[UIImage imageNamed:@"icon_nav_phone_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    RxWebViewNavigationViewController * linkmanNav = [[RxWebViewNavigationViewController alloc]initWithRootViewController:linkmanVC];
//    linkmanNav.tabBarItem.title         = @"通讯录";
//    linkmanNav.tabBarItem.image         = [[UIImage imageNamed:@"tabbar_linkman"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    linkmanNav.tabBarItem.selectedImage  =[[UIImage imageNamed:@"tabbar_linkman_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    RxWebViewNavigationViewController * profileNav = [[RxWebViewNavigationViewController alloc]initWithRootViewController:profileVC];
//    profileNav.tabBarItem.title         = @"设置";
//    profileNav.tabBarItem.image         = [[UIImage imageNamed:@"tabbar_profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    profileNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//
//    //设置tabbartitle color
//    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                      [UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    UIColor * titleHeightColor = [UIColor colorWithRed:0.388 green:0.790 blue:0.371 alpha:1.000];
//    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                      titleHeightColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//
//
//    //设置nav颜色
//    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.161 green:0.157 blue:0.173 alpha:1.000]];
//    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//    //状态栏 修改为白色字
//    //    1在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO
//    //    2
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
//
//
//    UITabBarController * tabController  = [[UITabBarController alloc]init];
//    tabController.viewControllers       = @[dialNav,linkmanNav,profileNav];
//
//    /**
//     设置tabbar颜色
//     */
//    UIView * tabbarColor = [[UIView alloc]initWithFrame:tabController.tabBar.bounds];
//    tabbarColor.backgroundColor = [UIColor whiteColor];
//
//    UILabel * lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tabController.tabBar.bounds.size.width, 0.5)];
//    lineLab.backgroundColor = [UIColor colorWithWhite:0.847 alpha:1.000];
//    [tabbarColor addSubview:lineLab];
//
//
//    [tabController.tabBar insertSubview:tabbarColor atIndex:0];
//    tabController.tabBar.opaque = YES;
//
////    self.window.rootViewController = tabController;
//
//    UIApplication * appliction = [UIApplication sharedApplication];
//    AppDelegate * appdele = (AppDelegate *)appliction.delegate;
//
//    UIWindow * window  = appdele.window;
//
//    window.rootViewController = tabController;
//
//
//
//    //监听通讯录 
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//    ABAddressBookRegisterExternalChangeCallback(addressBook, addressBookChanged, (__bridge void *)(linkmanVC));
//    
//    
//}
//
//
// 
//
//#pragma mark -- 监听通讯录变化
//void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
//{
//    NSLog(@"    监听通讯录变化   AddressBook Changed  %@",context);
//    static int changeCount = 0 ;
//    changeCount ++ ;
//    if (changeCount ==3) {
//        changeCount = 0;
//
//        //        ZYLinkManController * linkVC = (__bridge ZYLinkManController *)context;
//        //        [linkVC getLinkManAddreddISRefresh:YES];
//
//        //        +(void)regreshAddressBookWithName:(NSString *)name WithPhone:(NSString *)phoneNum isadd:(BOOL)isAdd
//
//        [ZYPhoneAction regreshAddressBookWithName:nil WithPhone:nil isadd:YES];
//    }
//    //    VC1 *myVC = (__bridge VC1 *)context;
//    //    [myVC getPersonOutOfAddressBook];
//}
//
//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
