//
//  CallTwoViewController.m
//  ZYPhoneCall
//
//  Created by t on 14-12-30.
//  Copyright (c) 2014年 RZL. All rights reserved.
//

#import "CallTwoViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Header.h"
#import "DealWithDataBases.h"
#import "ZYGetMimaViewController.h"
@interface CallTwoViewController ()<UIAlertViewDelegate>

@property(nonatomic,assign) int timeCount;
 
@end

@implementation CallTwoViewController

-(void)dealloc 
{
    NSLog(@"页面释放了calltwo");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callCahngeTable" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

//先判断有没有token
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN];
    if (token == nil) {

        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未获取微信验证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];


    }else{
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imgview.image = [UIImage imageNamed:@"call_bg_img"];
        [self.view addSubview:imgview];

        [self saveTongHuaJiLu];

        //创建
        [self createOther];

        __weak CallTwoViewController * vc     = self;
        if(!_callCenter){
            _callCenter                           = [[CTCallCenter alloc] init];
            _callCenter.callEventHandler          = ^(CTCall* call) {
                if([call.callState isEqualToString:CTCallStateIncoming])
                {
                    [vc beginGoOut];
                }
            };
        }
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark----用fmdb存储通话记录
-(void)saveTongHuaJiLu  //存储通话记录
{
    //    [GCDQueue executeInGlobalQueue:^{
    //获得当前时间
    NSDateFormatter * datefmate=[[NSDateFormatter alloc]init];
    [datefmate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * date2=[datefmate stringFromDate:[NSDate date]];

    if (self.calledName==nil) {
        self.calledName    = self.phoneNumber;
    }

    // 数据库
    //先查询数据库中有没有这个号码 ， 有的话增加拨打时间，没有就新增记录
    NSString * oldTime = [DealWithDataBases selectCollectionFromTableWithPhoneNum:self.phoneNumber];
    if (oldTime!=nil) {
        [DealWithDataBases updateOrderWithPhoneNum:self.phoneNumber WithNewTime:date2 WithOldTime:oldTime];
    }else
    {
        [DealWithDataBases insertMessageWithPeopleName:self.calledName WithPeoplePhoneNum:self.phoneNumber WithTime:date2];

    }
    //    }];
    //    拨打电话
    [self createCall];
}

-(void)createOther
{
    NSArray * titleArray = @[self.calledName,self.phoneNumber,@"正在接通请稍等片刻......",];
    for (int i = 0; i<3; i++) {
        UILabel * nameLab=[[UILabel alloc]initWithFrame:CGRectMake(VIEW_With/2-100, 100+i*50, 200, 30)];
        nameLab.textColor = [UIColor whiteColor];
        nameLab.text             = titleArray[i];
        nameLab.textAlignment    = NSTextAlignmentCenter;
        if (i==0) {
            nameLab.font = [UIFont boldSystemFontOfSize:25];
        }else if (i==1){
            nameLab.font = [UIFont systemFontOfSize:20];
        }else{
            nameLab.font = [UIFont systemFontOfSize:14];
            nameLab.tag = 100 ;
        }

        [self.view addSubview:nameLab];
    }

    UIButton * cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame            = CGRectMake(VIEW_With/2-52, VIEW_Hight/2+70+70+20, 105, 40);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"guaduan.png"] forState:UIControlStateNormal];
    [ cancelBtn addTarget:self action:@selector(stopCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

} 

-(void)stopCall
{
    [GCDQueue executeInGlobalQueue:^{

        [HttpEngine telePhoneHandleUpWithPhoneNum:self.phoneNumber];
    }];
    [self beginGoOut];
//    ZYGetMimaViewController * getProfile = [[ZYGetMimaViewController alloc]init];
//
//    [self presentViewController:getProfile animated:YES completion:nil];

 
}



-(void)createCall 
{

    __weak CallTwoViewController * vc=self;

    [HttpEngine telephoneCallWithPhoneNum:vc.phoneNumber Object:vc Compate:^(NSDictionary *responsedic) {

        NSString * text = [responsedic objectForKey:@"success"];

        UITextField * tf =(UITextField *)[self.view viewWithTag:100];

        tf.text         = [responsedic objectForKey:@"message"];

        if ([text intValue]!=1) {

            if ([responsedic[@"code"] intValue]==301) {

                ZYGetMimaViewController * getProfile = [[ZYGetMimaViewController alloc]init];
            
                [self presentViewController:getProfile animated:YES completion:nil];

            }else{

                [LSFMessageHint showToolMessage:tf.text hideAfter:1.5 yOffset:0];
                [self beginGoOut];
            }

        }else{

            [self gogogo];
        }
    }];

}

-(void)gogogo
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMove) userInfo:nil repeats:YES];
}

-(void)senderNotification
{ 
    //发通知，外面刷新记录表
    NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
    NSNotification * notify=[[NSNotification alloc]initWithName:@"callCahngeTable" object:self userInfo:nil]; 
    [center postNotification:notify];

    [self dismissViewControllerAnimated:YES completion:nil];

}
 
-(void)beginGoOut
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil ;
    }
    [self senderNotification];
}


-(void)timerMove
{

    _timeCount++;
    if (_timeCount<20) {

//        self.progressView.progress = 1.00/8*_timeCount ;
    }else{

        [self beginGoOut];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    if (_callCenter) {
        _callCenter = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     NSString * bindText =           [[NSUserDefaults standardUserDefaults]objectForKey:@"bindingsuccess"];
    if (bindText) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"bindingsuccess"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self createCall];
    }
            
}
 

@end
