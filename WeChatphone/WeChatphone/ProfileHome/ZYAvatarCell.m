//
//  ZYAvatarCell.m
//  WeChatphone
//
//  Created by BBC on 16/4/22.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYAvatarCell.h"
#import "UIButton+WebCache.h"

@implementation ZYAvatarCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 
-(void)upDataCellWith:(NSDictionary *)dic
{
    if (dic) {

        NSString * chargeStr = [dic objectForKey:@"money"];
        if (![chargeStr isEqual:[NSNull null]]) {
            self.nickLable.text = [dic objectForKey:@"nickname"];
            self.chargeLable.text =[NSString stringWithFormat:@"余额￥:%@",[dic objectForKey:@"money"]];
            [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString: [dic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_unLogin"]];
        }

    }else{
        [self.avatarButton setBackgroundImage:[UIImage imageNamed:@"icon_unLogin"] forState:UIControlStateNormal];
        self.nickLable.text = @"暂未登录";
        self.chargeLable.text = @"余额￥:0.00";
    }
}
 

 

@end
