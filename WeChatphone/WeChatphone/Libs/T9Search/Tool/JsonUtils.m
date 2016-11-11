//
//  JsonUtils.m
//  auto
//
//  Created by peacock on 14-7-17.
//  Copyright (c) 2014年 sutao. All rights reserved.
//

#import "JsonUtils.h"

@implementation JsonUtils
+ (NSString*)DataToPrettyJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}  

+ (NSString*)DataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    if (!object) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
