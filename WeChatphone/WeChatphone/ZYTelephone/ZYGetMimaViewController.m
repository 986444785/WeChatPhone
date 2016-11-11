//
//  ZYGetMimaViewController.m
//  YouKeApp
//
//  Created by BBC on 15-6-14.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ZYGetMimaViewController.h"
#import "Header.h"
#import "CallTwoViewController.h"

@interface ZYGetMimaViewController ()<UITextFieldDelegate>
{
    NSTimer * timerGet;
    UIButton * daojishiBtn;
}
@end 
 
@implementation ZYGetMimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    if (_isRegist) {
//         self.title = @"注册";
//    }else{
//         self.title = @"找回密码";
//    }

    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHide)];
    [self.view addGestureRecognizer:tap];

    [self setTopNavigationView];

    [self createUI];
}

/**
 *  topnav
 */
-(void)setTopNavigationView
{ 
 
    UIView * topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, VIEW_With, 64);
    topView.backgroundColor  = NavBar_Color;
    [self.view addSubview:topView];

    UIButton *btn=[[UIButton alloc]init];
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片左移15
    //[btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    btn.frame=CGRectMake(15, 30, btn.currentImage.size.width, btn.currentImage.size.height);
    [btn addTarget:self action:@selector(dismissGetView) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];


    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake((VIEW_With-200)/2, 30, 200, 20)];
    titleLable.text  = @"绑定手机号码";
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLable];

}


-(void)dismissGetView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)keyboardHide
{
    [self.view endEditing:YES];
}
 

-(void)createUI 
{

    float offsetY = -64;

    UIScrollView * bigScrollview    = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, VIEW_With, VIEW_Hight-64)];

    bigScrollview.contentSize       = CGSizeMake(VIEW_With, 800);
    bigScrollview.backgroundColor   = [UIColor colorWithWhite:0.936 alpha:1.000];
    [self.view addSubview:bigScrollview];

    NSArray * titlearray0           = @[@"手机号",@"验证码",@"请输入手机号",@"输入验证码"];
    NSInteger numbers = titlearray0.count/2;

    UIView * backGroundView         = [[UIView alloc]initWithFrame:CGRectMake(0, 84+offsetY, VIEW_With, 50*numbers)];
    backGroundView.backgroundColor  = [UIColor whiteColor];
    [bigScrollview addSubview:backGroundView];
    for (int i                      = 0; i<numbers; i++) {
    UILabel * lineLab               = [[UILabel alloc]initWithFrame:CGRectMake(0, 50+i*50, VIEW_With, 1)];
    lineLab.backgroundColor         = [UIColor colorWithWhite:0.685 alpha:1.000];
        [backGroundView addSubview:lineLab];

    UILabel * titleLab              = [[UILabel alloc]initWithFrame:CGRectMake(10, 50*i, 95, 50)];
    titleLab.text                   = titlearray0 [i];
    titleLab.textColor              = [UIColor grayColor];
        [backGroundView addSubview:titleLab];

    UITextField * textfiel          = [[UITextField alloc]initWithFrame:CGRectMake(90, 50*i, VIEW_With-120, 50)];
    textfiel.clearButtonMode        = UITextFieldViewModeWhileEditing;
    textfiel.tag                    = i + 400 ;
    textfiel.delegate               = self ;
    textfiel.placeholder            = titlearray0[i + numbers];
        [backGroundView addSubview:textfiel];


        if (i<2) {
            textfiel.keyboardType           = UIKeyboardTypePhonePad ;
        }


        if (i==1) {
    daojishiBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    daojishiBtn.frame               = CGRectMake(VIEW_With-80, 50*i+10, 70, 30);
            [daojishiBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [daojishiBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [daojishiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    daojishiBtn.backgroundColor     = [UIColor colorWithWhite:0.735 alpha:1.000];
    daojishiBtn.layer.masksToBounds = YES ;
    daojishiBtn.layer.cornerRadius  = 5 ;
    daojishiBtn.tag                 = 450;
            [daojishiBtn addTarget:self action:@selector(daojishiClick:) forControlEvents:UIControlEventTouchUpInside];
            [backGroundView addSubview:daojishiBtn];
        }

    }


    UILabel * tishiLab              = [[UILabel alloc]initWithFrame:CGRectMake(30, backGroundView.frame.size.height+backGroundView.frame.origin.y, VIEW_With-60, 40)];
    tishiLab.text                   = @"验证码将以短信形式发送到手机中，请注意查收";
    tishiLab.font                   = [UIFont systemFontOfSize:12];
    tishiLab.textColor              = [UIColor grayColor];
    [bigScrollview addSubview:tishiLab];

    UIButton * sureBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor         = [UIColor colorWithRed:0.289 green:0.714 blue:0.213 alpha:1.000];
    sureBtn.frame                   = CGRectMake(20,tishiLab.frame.origin.y + tishiLab.frame.size.height, VIEW_With-40, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];

    sureBtn.layer.masksToBounds     = YES ;
    sureBtn.layer.cornerRadius      = 5 ;
    [sureBtn addTarget:self action:@selector(changemima) forControlEvents:UIControlEventTouchUpInside];
    [bigScrollview addSubview:sureBtn];

} 

-(void)daojishiClick:(UIButton *)sender
{
    UITextField * tf = (UITextField *)[self.view viewWithTag:400];
    if (tf.text.length != 11) {
        [LSFMessageHint showToolMessage:@"请输入正确手机号码" hideAfter:1.5 yOffset:-100];
        return ;
    }
    if (!timerGet) {
        timerGet = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGetMove) userInfo:nil repeats:YES];
    }

    [HttpEngine  getMessageTokenWithPhoneNumber:tf.text Complate:^(NSDictionary *response) {

        [LSFMessageHint showToolMessage:response[@"message"] hideAfter:2.0 yOffset:0];

    }];

}

-(void)timerGetMove
{
    static int  time1                  = 60 ;
    time1--;
    [daojishiBtn setTitle:[NSString stringWithFormat:@"%d秒重发",time1] forState:UIControlStateNormal];
    daojishiBtn.backgroundColor        = [UIColor colorWithWhite:0.884 alpha:1.000];

    daojishiBtn.userInteractionEnabled = NO ;
    if (time1==0 && timerGet) {
        [timerGet invalidate];
    timerGet                           = nil ;
    time1                              = 60 ;
    daojishiBtn.userInteractionEnabled = YES ;
         [daojishiBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    daojishiBtn.backgroundColor        = [UIColor colorWithWhite:0.735 alpha:1.000];
    }
}

-(void)changemima
{
    UITextField * tfPhone         = (UITextField *)[self.view viewWithTag:400];
    UITextField * tfYanZhengMa    = (UITextField *)[self.view viewWithTag:401];

    if (tfPhone.text.length != 11) {
        [LSFMessageHint showToolMessage:@"请输入正确手机号" hideAfter:1.0 yOffset:-160];
        return ;
    }
    if (tfYanZhengMa.text.length <3) {
        [LSFMessageHint showToolMessage:@"请输入正确验证码" hideAfter:1.0 yOffset:-120];
        return ;
    }

    MBProgressHUD  * hud          = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText                 = @"请稍后.....";
    hud.dimBackground             = YES ;
    hud.removeFromSuperViewOnHide = YES ;


    __block ZYGetMimaViewController  * getVC = self;
    [HttpEngine bindingPhoneNumber:tfPhone.text  withMesssageToken:tfYanZhengMa.text Complate:^(NSDictionary *response) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

        [LSFMessageHint showToolMessage:response[@"message"] hideAfter:1.0 yOffset:0];
        if ([response[@"success"] integerValue]==1) {
 
            [[NSUserDefaults standardUserDefaults]setObject:@"bindingsuccess" forKey:@"bindingsuccess"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            [getVC dismissViewControllerAnimated:YES completion:nil];

        }

    }];

}
 

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing: YES];
    
    return YES;
}


@end
