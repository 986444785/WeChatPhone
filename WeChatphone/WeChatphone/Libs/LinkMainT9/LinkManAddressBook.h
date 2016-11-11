//
//  LinkManAddressBook.h
//  YouKeApp
//
//  Created by t on 15-3-25.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface LinkManAddressBook : NSObject

//@property(nonatomic,)


+(NSMutableArray * )getAddressBook;

+(NSString*)trimString:(NSString *)str;
 
+(NSMutableArray * )LinkMainWithMutablearrayWithDataArray:(NSMutableArray *)dataArray;
@end 
