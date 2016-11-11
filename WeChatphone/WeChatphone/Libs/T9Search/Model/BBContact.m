//
//  BBContact.m
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import "BBContact.h"
#import "BBContactPhoneNumber.h"
#import "BBContactEmail.h"
#import "BBContactAddress.h"
#import "BBContactIm.h"
#import "BBContactPhoto.h"
#import "BBContactUrl.h"
@implementation BBContact

+ (NSDictionary *)objectClassInArray{
    
    return @{@"phoneNumbers" : [BBContactPhoneNumber class],@"ims" : [BBContactIm class], @"emails" : [BBContactEmail class], @"contactAddress" : [BBContactAddress class], @"urls":[BBContactUrl class]};
    
}

@end
