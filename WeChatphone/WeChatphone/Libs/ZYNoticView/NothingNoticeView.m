//
//  NothingNoticeView.m
//  YouKeApp
//
//  Created by BBC on 15/9/26.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NothingNoticeView.h"

@implementation NothingNoticeView
//
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
    }
    return self ;
}
   
-(void)getBgViewWithMessage:(NSString *)message withNotice:(NSString *)noticeStr WithShowImg:(NSString *)showImg
{

    float width = self.frame.size.width;
    float height = self.frame.size.height;

    UIView * bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bigView.backgroundColor = [UIColor whiteColor];



    UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake((width-80)/2,height/2-100 , 80, 80)];
    imgview.image = [UIImage imageNamed:showImg];
    [bigView addSubview:imgview];



    UILabel * bgtitleLable = [[UILabel alloc]initWithFrame:CGRectMake(width/2-100, height/2, 200, 30)];
    bgtitleLable.text = message;
    bgtitleLable.numberOfLines = 0;
    bgtitleLable.textAlignment = NSTextAlignmentCenter ;
    [bigView addSubview:bgtitleLable];

    float btnwidth = [self getTextLengthWith:noticeStr];

    UIButton * bgBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBackBtn.frame =CGRectMake((width-btnwidth)/2, height/2+35, btnwidth, 30);
    [bgBackBtn setTitle:noticeStr forState:UIControlStateNormal];
    [bgBackBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    bgBackBtn.layer.masksToBounds = YES ;
    bgBackBtn.layer.cornerRadius = 5;   
    bgBackBtn.layer.borderWidth = 1.0 ;
    bgBackBtn.layer.borderColor = [UIColor colorWithWhite:0.619 alpha:1.000].CGColor;
    bgBackBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bgBackBtn addTarget:self action:@selector(backbtnclickOut:) forControlEvents:UIControlEventTouchUpInside];

    [bigView addSubview:bgBackBtn];

     [self addSubview:bigView];
} 

-(void)backbtnclickOut:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(changeBtnClick:)]) {
        [self.delegate changeBtnClick:sender.titleLabel.text];
    }

}
 

 

 #pragma mark --- 计算文字长度
 -(CGFloat)getTextLengthWith:(NSString *)text
 {
     float width = [text boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
     return (width + 15);
 }



@end
