//
//  ABRecordHelper.h
//  jiashuContact
//
//  Created by liushuai on 14-4-4.
//  Copyright (c) 2014年 ftabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

// 通讯录参考资料  http://blog.sina.com.cn/s/blog_71715bf801019oy8.html

@interface ABRecordHelper : NSObject

// person

+(NSData *)imageOfPerson:(ABRecordRef)personRecord;

+(NSString *)nameOfPerson:(ABRecordRef)personRecord;

+(NSString *)jobOfPerson:(ABRecordRef)personRecord;

+(NSString *)companyOfPerson:(ABRecordRef)personRecord;

+(NSArray *)phonesOfPerson:(ABRecordRef)personRecord;

+(NSArray *)mailsOfPerson:(ABRecordRef)personRecord;


#pragma /////
+(ABRecordRef)mergedPersonFromPersons:(NSArray *)persons;

+(NSMutableArray *)mergedArrFromPersons:(NSArray *)persons;

+(ABRecordRef)handMergedPersonFromMergedArr:(NSMutableArray *)mergedArr selectStateArr:(NSMutableArray *)selStateArr;

+(NSDate *)creationOfPerson:(ABRecordRef)personRecord; // 联系人创建时期

+(NSDate *)birthdayOfPerson:(ABRecordRef)personRecord;

+(NSString *)detailInfoOfPerson:(ABRecordRef)personRecord;

+(NSData *)vCardWithoutPortraitOfPerson:(ABRecordRef)personRecord;

+(NSData *)vCardsOfPersons:(NSArray *)persons;

+(ABRecordRef)personFromVcard:(NSString *)vCard;

// group

+(NSString *)nameOfGroup:(ABRecordRef)groupRecord;

+(NSArray *)membersOfGroup:(ABRecordRef)groupRecord;

@end
