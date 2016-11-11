//
//  ZYTelCell.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYTelCell.h"

@implementation ZYTelCell


- (void)awakeFromNib {
    // Initialization code
    self.lastStrLable.layer.masksToBounds = YES;
    self.lastStrLable.layer.cornerRadius = 20;

    if (!_colors) {
        _colors = @[[UIColor colorWithRed:0.388 green:0.790 blue:0.371 alpha:1.000],
                    [UIColor colorWithRed:0.718 green:0.581 blue:1.000 alpha:1.000],
                    [UIColor orangeColor],
                    [UIColor colorWithRed:0.826 green:0.000 blue:0.831 alpha:1.000],
                    [UIColor colorWithRed:0.406 green:0.681 blue:1.000 alpha:1.000],
                    [UIColor colorWithRed:0.453 green:0.925 blue:0.690 alpha:1.000]];
    }

}
     
-(void)upDataCellWithPeople:(People *)people WithIndex:(NSIndexPath *)index
{
    if (people.name.length > 0) {
         self.lastStrLable.text =  [people.name substringFromIndex:people.name.length -1];
    }else{
        self.lastStrLable.text =  [people.name substringFromIndex:people.name.length ];
    }

    self.nameLable.text = people.name;
    self.lastStrLable.backgroundColor  =   _colors[index.row %5];
}

  

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
