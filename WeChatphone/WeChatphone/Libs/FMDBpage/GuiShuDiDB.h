//
//  GuiShuDiDB.h
//  YouKeApp
//
//  Created by t on 15-3-29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface GuiShuDiDB : NSObject


//@property (nonatomic, strong) FMDatabase *db;

+(NSString *)locationForPhoneNumber:(NSString *)phoneNumber ;

@end
