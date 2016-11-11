//
//  ZYTelephoneCell.h
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"
@interface ZYTelephoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *dayLab;

 
/**
 *  更新cell 
 */

-(void)updataCellWithPeople:(People *)people;
 
@end
