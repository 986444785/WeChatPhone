//
//  ZYDialHomeController.h
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h" 
#import "KeyBordView.h"
#import "ZYPhoneAction.h"
typedef enum{
    kT9SearchStatusNormal = 0,
    kT9SearchStatusInit,
    kT9SearchStatusSearch
}T9SearchStatus;
@interface ZYDialHomeController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,LXActionSheetDelegate>
{
    int              _lastSelectTabbarIndex; 
    int              _tableState;
    NSMutableArray   * _callHistoryArray;
}
@property (nonatomic,copy                         ) NSString              * selectIndexName;
@property (nonatomic,copy                         ) NSString              * selectIndexPhoneNum;


 
@end
 