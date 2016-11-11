//
//  BBFmdbTool.h
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FMDB.h"
#import "FMDatabase.h"
@class BBContact;
@interface BBFmdbTool : NSObject

+ (instancetype)shareFmdbTool; 

- (BOOL)insertContact:(NSString *)uuid displayName:(NSString *)displayName contactName:(NSString *)contactName nickname:(NSString *)nickname  phoneNumbers:(NSString *)phoneNumbers emails:(NSString *)emails contactAddress:(NSString *)contactAddress ims:(NSString *)ims contactOrganization:(NSString *)contactOrganization birthday:(NSString *)birthday note:(NSString *)note photo:(NSString *)photo urls:(NSString *)urls;

- (NSArray *)QueryDatabase;

- (BOOL)insertTel:(NSString *)tel classid:(int)classid;

/** 
 *  删除一条
 */
-(BOOL)deleContactWithPhoneNum:(NSString *)phone WithName:(NSString *)name;

-(BOOL)deleteAllFromTable;

@end  
 