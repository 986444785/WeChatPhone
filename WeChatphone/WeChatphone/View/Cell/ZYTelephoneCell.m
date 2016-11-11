//
//  ZYTelephoneCell.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYTelephoneCell.h"
#import "TimeTest.h"
#import "GuiShuDiDB.h"
@implementation ZYTelephoneCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
} 
 

-(void)updataCellWithPeople:(People *)people
{
    self.timeLable.text = nil;
    self.dayLab.text = nil;
    self.nameLab.text = people.name;
    self.phoneLab.text  = people.phoneNum;

    if (people.callTime) {
        __block NSString * timeStr = nil; __block NSString * dayStr = nil;
        [TimeTest timeTrangFormWithTime:people.callTime Complate:^(NSString *time, NSString *day) {
            timeStr = time;   dayStr = day;
        }];
            self.timeLable.text = timeStr;
            self.dayLab.text = dayStr;

       NSString * addressStr =  [GuiShuDiDB locationForPhoneNumber:people.phoneNum];
        self.phoneLab.text  = [NSString stringWithFormat:@"%@  %@",people.phoneNum,addressStr];
    }

}


@end
