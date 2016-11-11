//
//  ZYAvatarCell.h
//  WeChatphone
//
//  Created by BBC on 16/4/22.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYAvatarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;


@property (weak, nonatomic) IBOutlet UILabel *nickLable;

@property (weak, nonatomic) IBOutlet UILabel *chargeLable;
 

-(void)upDataCellWith:(NSDictionary *)dic;

@end
