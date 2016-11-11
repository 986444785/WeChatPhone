//
//  ZYTitleView.m
//  WeChatphone
//
//  Created by BBC on 16/4/19.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYTitleView.h"
#import "CHAddressEngine.h"
@interface ZYTitleView ()
@property(nonatomic,strong)  UIButton * lefButton;
@property(nonatomic,strong)   UILabel * titleLab ;
@end

@implementation ZYTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
//        self.backgroundColor = [UIColor redColor];
        [self setTitleView];
    }
    return self;
}

-(void)setTitleView
{
    self.lefButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lefButton.frame = CGRectMake(0, 0, 40, 40);
    [_lefButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_lefButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _lefButton.titleLabel.font = [UIFont systemFontOfSize:14];

    [self addSubview:_lefButton];


    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.frame.size.width-50*2, 40)];
            self.titleLab.text = @"拨出记录";
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];

}

-(void)leftButtonClick{
    NSLog(@"编辑"); 
    _editButtonClick(nil);
}

/**
 *  变化处理事件
 */    
-(void)titleChangeWithText:(NSString *)text WithEdit:(BOOL)isEdit titleHiden:(BOOL)titeHiden
{
     
    if (text.length>0) {
        self.lefButton.alpha = 0;
        self.lefButton.userInteractionEnabled = NO;
        if (text.length>2 && text.length<=11)
        {
            self.titleLab.text=[NSString stringWithFormat:@"%@ %@",[CHAddressEngine ismobilePhoneWith:text],text];
        }else{
            self.titleLab.text                                 = text;
        }
    }else
    {
        self.titleLab.text = @"拨出记录";
        self.lefButton.alpha = 1;
        self.lefButton.userInteractionEnabled = YES;

        if (isEdit) {
            [_lefButton setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [_lefButton setTitle:@"编辑" forState:UIControlStateNormal];
        }

        if (titeHiden) {
            _lefButton.alpha = 0.0;
        }else{
            _lefButton.alpha = 1.0;
        }
    }

}


@end
