//
//  ZYTelCell.h
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"
@interface ZYTelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lastStrLable;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property(nonatomic,strong) NSArray * colors;

/**
 *  cell数据
 *
 *  @param people 
 */
-(void)upDataCellWithPeople:(People *)people WithIndex:(NSIndexPath *)index;

 
@end
