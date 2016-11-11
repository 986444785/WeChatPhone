//
//  People.h
//  YouKeApp
//
//  Created by t on 15-3-25.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject<NSCoding>
  
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * phoneNum;
@property(nonatomic,copy) NSString  * callTime;

@property(nonatomic,copy) NSString * lastNameStr; //后缀

@end 
 