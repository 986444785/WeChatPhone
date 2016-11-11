//
//  People.m
//  YouKeApp
//
//  Created by t on 15-3-25.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "People.h"

@implementation People

//归档顶用这个方法
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_phoneNum forKey:@"phone"];
    [aCoder encodeObject:_callTime forKey:@"time"];
}

//解归档调用这个方法
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phoneNum = [aDecoder decodeObjectForKey:@"phone"];
        self.callTime = [aDecoder decodeObjectForKey:@"time"];
    }
    return self ;
}

@end
