//
//  KeyBordView.m
//  ZYPhoneCall
//
//  Created by t on 14-12-30.
//  Copyright (c) 2014年 RZL. All rights reserved.
//

#import "KeyBordView.h" 
#import "Header.h"
#import "AppDelegate.h"
#import "CallTwoViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZYLinkManSingleton.h"
#import "People.h"
@implementation KeyBordView
//定义屏幕的宽
#define VIEW_With [UIScreen mainScreen].bounds.size.width
//定义屏幕的高度
#define VIEW_Hight  [UIScreen mainScreen].bounds.size.height
#define kLineWidth  1
#define kNumFont [UIFont systemFontOfSize:20]
{
    UIView * botView;
    NSArray *arrLetter;
    NSArray *numArray;

} 

-(id)init
{
  
    self=[super initWithFrame:CGRectMake(0,VIEW_Hight-keyboard_Hight*4-50, VIEW_With, keyboard_Hight*4+50)];
    if (self) {
 

        arrLetter = [NSArray arrayWithObjects:@"o_o",@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ",@"清空",@"+",@"删除", nil];
        numArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"c",@"0",@"x"];

        self.backgroundColor=[UIColor whiteColor];
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                button.backgroundColor=[UIColor clearColor];

                [self addSubview:button];
                
            }
        }
        UIColor *color = [UIColor colorWithRed:0.799 green:0.817 blue:0.798 alpha:1.000];
        //
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(VIEW_With/3-1, 0, kLineWidth, keyboard_Hight*4)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(VIEW_With/3*2, 0, kLineWidth, keyboard_Hight*4)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<5; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, keyboard_Hight*(i+1)-(keyboard_Hight), VIEW_With, 0.8)];//调节五条横线的位置
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
         _textFile1=[[UITextField alloc]initWithFrame:CGRectMake(1, 1, 1,1)];

        //增加下面的打电话的view
        botView=[self createBottonView];
        [self addSubview:botView];
    }
    //    //接收通知
    NSNotificationCenter * center2=[NSNotificationCenter defaultCenter];
    [center2 addObserver:self selector:@selector(receiveNotificationClerNumber:) name:@"callCahngeTable" object:nil];

    return self;
} 

-(void)receiveNotificationClerNumber:(NSNotification *)notify
{
    [self clearAll];
}

 

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    //   lab.text = i==0 ? @"价格:" : @"数量:";   // 三目运算
    CGFloat frameX =0;
    CGFloat frameW =0;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = VIEW_With == 320 ? 106.0 : VIEW_With*1.00/3;
            break;
        case 1:
            frameX = VIEW_With == 320 ?  105.0 : VIEW_With*1.00/3 ;
            frameW = VIEW_With == 320 ?  110.0 : VIEW_With*1.00/3 ;
            break;
        case 2:
            frameX = VIEW_With == 320 ?  214.0 : VIEW_With*1.00/3*2 ;
            frameW = VIEW_With == 320 ?  106.0 : VIEW_With*1.00/3 ;
            break;
             
        default:
            break;
    }
    CGFloat frameY = keyboard_Hight*x;//调节字母的位置
    
    UIButton*  button=[UIButton buttonWithType:UIButtonTypeCustom];
    int h = 50 ;
    if (VIEW_Hight>480 ) {
        h =  VIEW_With == 320 ?  58 : 68 ;
    }

    button.frame=CGRectMake(frameX, frameY, frameW, h);

    NSInteger num = y+3*x+1;
    button.tag = num;

    [button addTarget:self action:@selector(btnVClick:) forControlEvents:UIControlEventTouchUpInside];


    UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameW*2.0/3, h)];
    labelNum.textColor = [UIColor blackColor];
    labelNum.textAlignment = NSTextAlignmentCenter;
    labelNum.font = kNumFont;
    [button addSubview:labelNum];

    labelNum.text = numArray[num-1];

        UILabel *labelLetter = [[UILabel alloc] initWithFrame:CGRectMake(frameW/2, labelNum.center.y-2, frameW/2, 15)];
        labelLetter.text = [arrLetter objectAtIndex:num-1];
        labelLetter.textColor = [UIColor grayColor];
        labelLetter.font = [UIFont systemFontOfSize:12];
        [button addSubview:labelLetter];

    return button;
}
 

//增加下面的打电话的view
-(UIView * )createBottonView
{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, keyboard_Hight*4, VIEW_With, 50)];

    UILabel * labline=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEW_With, 1)];
    labline.backgroundColor= [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1]; 
    [view addSubview:labline];
   
    NSArray * imgArray=@[@"icon_arrow_down",@"call_call.png",@"icon_add_user"];
    for (int i=0; i<3; i++) {

        UIButton * bohaoBt=[UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) { 
            bohaoBt.frame=CGRectMake(20, 10, 30, 30);
               [bohaoBt setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        }else if (i==1){
            bohaoBt.frame=CGRectMake(VIEW_With/2-75, 6, 150, 36);
            bohaoBt.backgroundColor =[UIColor colorWithRed:0.198 green:0.574 blue:1.000 alpha:1.000];

            [bohaoBt setTitle:@"拨打" forState:UIControlStateNormal];
        }else{
            bohaoBt.frame=CGRectMake(VIEW_With-60, 10, 30, 30);

            [bohaoBt setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        }

        [bohaoBt addTarget:self action:@selector(downBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        bohaoBt.tag=i+1;
       
        [view addSubview:bohaoBt];
        
    }
    
    return view;
}
 

//点击按钮，下面的view消失，tabbar出现
-(void)downBtnClick2:(UIButton*)sender
{
    if (sender.tag==1) {
        
        //将虚拟键盘隐藏，tabbar出现
        ZYDialHomeController * leVC=self.ViewControl;

        NSArray * array=leVC.tabBarController.view.subviews;
        for (int i=0; i<array.count; i++) {
            UIView * view=array[i];
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, VIEW_Hight-49, view.frame.size.width, view.frame.size.height)];
            }
            
            [UIView animateWithDuration:0.27 animations:^{
                self.frame=CGRectMake(0, VIEW_Hight, VIEW_With, self.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }else if (sender.tag==2)
    {
        [self NewCall];
    }

}
 
-(void)NewCall
{
    //要清除
    _changeClickSee(nil);

    //查询本地是否有这个号码

    NSString * nameStr = _textFile1.text;

    ZYLinkManSingleton * singleton = [ZYLinkManSingleton defaultSingletonISRefresh:NO];
    for (int i = 0; i<singleton.peoples.count; i++) {
        People * p=[singleton.peoples objectAtIndex:i];
        if (p.phoneNum!=nil) {
            if ([  p.phoneNum  isEqualToString:_textFile1.text]) {
                nameStr                                = p.name;
                break ;
            }
        }
    }
 
    CallTwoViewController * callVC = [[CallTwoViewController alloc]init];
    callVC.phoneNumber = _textFile1.text;
    callVC.calledName = nameStr;
    [self.Delegate presentViewController:callVC animated:YES completion:nil];

    _textFile1.text=nil;
}

#pragma mark ---   数字按钮 点击
-(void)btnVClick:(UIButton*)sender
{

    if (sender.tag == 10) {

        [self clearAll];
        return ;
    }else if (sender.tag == 12){
        [self clearBtnWith];
        return ;
    }

    [UIView animateWithDuration:0.05 animations:^{
        [sender setBackgroundColor:[UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000]];
    } completion:^(BOOL finished) {

        [sender setBackgroundColor:[UIColor clearColor]];
    }];

    NSArray * arraytitle=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"#"];
    NSString * text1=arraytitle[sender.tag-1];
    
    
//#pragma mark---- 添加按键声音
    SystemSoundID myAlertSound;
    int soundId=(int)sender.tag;
    if (sender.tag==11) {
        soundId=0;
    }else if (sender.tag==12)
    {
        soundId=11;
    }
    myAlertSound=1200+soundId;
    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/begin_video_record.caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
    AudioServicesPlaySystemSound(myAlertSound);
    
    _textFile1.text=[_textFile1.text stringByAppendingString:[NSString stringWithFormat:@"%@",text1]];
    _changeClickSee(_textFile1.text);
    [self hidenTabbarClick];
    
}

#pragma mark---   隐藏下面tabbar
-(void)hidenTabbarClick
{
    [TabbarShowHiden tabbarHidenWithdelegate:self.ViewControl];
}

-(void)showTabbarClick
{
    //出现下面的
    [TabbarShowHiden tabbarShowWithdelegate:self.ViewControl];
}

#pragma mark----长按清除所有
-(void)clearAll
{
    if (_textFile1.text.length>0) {
        _textFile1.text=nil; 
        _changeClickSee(_textFile1.text);
    }
     [self showTabbarClick];
}
-(void)clearBtnWith
{
    if (_textFile1.text.length>0) {
        _textFile1.text=[_textFile1.text substringToIndex:_textFile1.text.length-1];
        
    }
    _changeClickSee(_textFile1.text);
    if (_textFile1.text.length==0) {
        [self showTabbarClick];
    }
}




@end
