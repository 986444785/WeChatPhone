//
//  DataBaseUtility.h
//  FMDB存储
//
//  Created by t on 15-3-18.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
@interface DataBaseUtility : NSObject
+(FMDatabase*)getDataBase ;
@end 
