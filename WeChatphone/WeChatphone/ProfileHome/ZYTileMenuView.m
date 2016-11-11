//
//  ZYTileMenuView.m
//  YouKeApp
//
//  Created by BBC on 16/1/7.
//  Copyright (c) 2016年 Chen. All rights reserved.
//

#import "ZYTileMenuView.h"
#import "Header.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation ZYTileMenuView
 
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
    }
    return self;
} 


#pragma mark --- 改变控件的高度
-(void)setHeight:(UIView *)view newHeight:(CGFloat)height
{
    CGRect  rect     = view.frame;
    rect.size.height = height;
    view.frame       = rect;
}
  

-(void)createMenuViewWithContents:(NSArray *)contents WithMaxTag:(int)maxTag   WithIsopen:(BOOL)isOpen
{

    int hangshu =(int) contents.count/4;
    if (contents.count%4!=0){
        hangshu = hangshu +1;
    }
 
    float heightSapce = 0;
    float height2 = VIEW_With/4 ;
    float width2 =  VIEW_With/4 ;

    UIView * menuView = [[UIView alloc]initWithFrame:CGRectMake(0,0, VIEW_With, height2*hangshu + heightSapce)];

    float  imgWidth  = 30.00 * VIEW_With / 320;
    float  imgY      = 15.00 * VIEW_With / 320;

    int count1= 0;
    for (int k =0; k< hangshu; k++)
    {
        for (int j=0; j< 4; j++)
        {

            NSDictionary * dict = contents[count1];

            count1 ++;
 
            UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame             = CGRectMake(j*VIEW_With/4, k* height2 + heightSapce, VIEW_With/4, height2);
            btn.tag               = count1-1 + maxTag;
            [btn addTarget:self action:@selector(menuViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [menuView addSubview:btn];

            UIImageView * menuImageview =[[UIImageView alloc]initWithFrame:CGRectMake((width2-imgWidth)/2+j*width2, k * height2 + imgY + heightSapce, imgWidth, imgWidth)];
            [menuImageview sd_setImageWithURL:[NSURL URLWithString:dict[@"icon"]]];
            [menuView addSubview:menuImageview];

            UILabel * textLab     = [[UILabel alloc]initWithFrame:CGRectMake(j*width2, menuImageview.frame.size.height+menuView.frame.origin.y + k*height2 + imgY + 5, width2, 30)];
            textLab.textAlignment = NSTextAlignmentCenter ;

            textLab.font          = [UIFont systemFontOfSize:13];
            [menuView addSubview:textLab];

            textLab.text          = dict[@"name"];
   
            if (count1 == contents.count) {
                break ;
            }

        }

    }

//    创建一横线，三竖线

    for (int j = 0; j< 4 ; j++) {
        UILabel * lineShulab2       = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_With/4*(j+1), heightSapce, 0.5 ,  height2*hangshu )];
        lineShulab2.backgroundColor = [UIColor colorWithWhite:0.803 alpha:1.000];
        lineShulab2.alpha           = 0.8;
        [menuView addSubview:lineShulab2];
    }

    for (int k = 0; k<hangshu; k++) {

        UILabel * lineHengLab       = [[UILabel alloc]initWithFrame:CGRectMake(0,heightSapce + k*height2,VIEW_With,0.5)];
        lineHengLab.backgroundColor = [UIColor colorWithWhite:0.803 alpha:1.000];
        lineHengLab.alpha           = 0.5;
        [menuView addSubview:lineHengLab];
    }

    menuView.backgroundColor = [UIColor whiteColor];

    [self setHeight:self newHeight:menuView.frame.size.height];

    [self addSubview:menuView];
//    return menuView;
 
}
 
-(void)menuViewButtonClick:(UIButton *)sender
{
    self.tileBtnClick((int)sender.tag);
}



@end
