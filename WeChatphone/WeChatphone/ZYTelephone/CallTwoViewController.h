//
//  CallTwoViewController.h
//  ZYPhoneCall
//
//  Created by t on 14-12-30.
//  Copyright (c) 2014年 RZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCall.h>
#import "AppDelegate.h"
//#import "LDProgressView.h" 
@interface CallTwoViewController : UIViewController<UIAlertViewDelegate>
{ 
    AppDelegate  * _appDelegate; 
    CTCallCenter * _callCenter; 
}
@property (nonatomic,assign) id           Delegate;
@property (nonatomic,copy  ) NSString     * phoneNumber;
@property (nonatomic,copy  ) NSString     * calledName;
//@property (nonatomic,strong) LDProgressView * progressView ;
@property (nonatomic,strong) NSTimer      * timer;


 
@end   
 