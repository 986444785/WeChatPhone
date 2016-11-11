//
//  ZYAddLinkMan.h
//  YouKeApp
//
//  Created by BBC on 15/8/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ZYAddLinkMan : NSObject<ABNewPersonViewControllerDelegate>

//新建联系人界面
@property(nonatomic,strong) ABNewPersonViewController * myNewController;

/**
 *  @brief  单例
 *
 *  @return ContactWrapper对象
 */
+(ZYAddLinkMan *)shareAddlinkMan;

/**
 *  @brief  添加新联系人
 *
 *  @param phoneNum         添加到已有的电话号码，传入nil表示新建联系人，否则添加到已有的联系人
 *  @param parentController 当前的视图控制器
 */

-(void)addNewContactWithPhone:(NSString *)phoneNum rootViewController:(UIViewController*)addLinkManController;
 

@end
