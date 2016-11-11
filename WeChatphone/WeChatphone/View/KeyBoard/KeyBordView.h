//
//  KeyBordView.h
//  ZYPhoneCall
//
//  Created by t on 14-12-30.
//  Copyright (c) 2014年 RZL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YKBoHaoViewController.h"
#import "ZYDialHomeController.h"
@interface KeyBordView : UIView <UIScrollViewDelegate>

@property(nonatomic,assign) id Delegate; 
@property(nonatomic,assign) id keyDelegate;
@property (nonatomic,copy)     UITextField * textFile1;
@property(nonatomic,copy)   void(^changeClickSee)(NSString * clickSee);//用block传值，用于联系人查询 
//@property(nonatomic,copy)   void(^changeScrollViewDown)(NSString * clickSee);//用block传值，用于联系人查询
@property(nonatomic,assign)   id   ViewControl;
@property(nonatomic,assign)   BOOL selectIndex; 
@property(nonatomic,assign)   id   RightDelegate;

@end       
 
   