//
//  ZYPhoneAction.m
//  WeChatphone
//
//  Created by BBC on 16/4/22.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYPhoneAction.h"
#import "Header.h"
#import "AddressBookHandle.h"
#import "LinkManAddressBook.h"
#import "ZYGetBaseData.h"
@implementation ZYPhoneAction

/**
 *  添加联系人
 */
+(void)addLinkMainWithDict:(NSDictionary *)dict
{

    NSDictionary * argdic = dict[@"args"];
    [self getAddressBookToken];

    NSString * name = argdic[@"name"];
    NSString * phoneNum = argdic[@"phone"];
    [self addWithName:name withPhoneNum:phoneNum];
}

 
+(void)addWithName:(NSString *)name withPhoneNum:(NSString *)phoneNum
{
    //name
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(name), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, @"", &error);

    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //    ABMultiValueAddValueAndLabel(multiPhone,@" houseNumber.text123", kABPersonPhoneHomeFAXLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone,(__bridge CFTypeRef)(phoneNum), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
    CFRelease(multiPhone);

    //picture

    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);

    [self regreshAddressBookWithName:name WithPhone:phoneNum isadd:YES];
}



/**
 *  删除联系人
 */ 
+(void)deleteLinkMainWithDict:(NSDictionary *)dict
{

    NSDictionary * argdic = dict[@"args"];
    [self getAddressBookToken];

    NSString * name = argdic[@"name"];
    NSString * phoneNum = argdic[@"phone"];

        //取得本地通信录名柄
        ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
        NSArray* tmpPersonArray = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
        for(id tmpPerson in tmpPersonArray)
        {

            //读取电话多值
            ABMultiValueRef phone = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
            for (int k = 0; k<ABMultiValueGetCount(phone); k++)
            {

                //获取該Label下的电话值
                NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);

                if ( [[LinkManAddressBook trimString:personPhone] isEqualToString:phoneNum]) {
                    NSLog(@"删除成功    %@----%@",name,phoneNum);
                    ABAddressBookRemoveRecord(tmpAddressBook, (__bridge ABRecordRef)(tmpPerson), nil);
                    //保存电话本
                    ABAddressBookSave(tmpAddressBook, nil);
                    //释放内存
                    //    [tmpPersonArray release];
                    CFRelease(tmpAddressBook);
                    [self regreshAddressBookWithName:name WithPhone:phoneNum isadd:NO];

                    return ;
                }

            }

        }

}
   
+(void)regreshAddressBookWithName:(NSString *)name WithPhone:(NSString *)phoneNum isadd:(BOOL)isAdd
{
    [GCDQueue executeInGlobalQueue:^{

        BBFmdbTool * bbfmdb =  [BBFmdbTool shareFmdbTool];

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSetupDataBase];
        [[NSUserDefaults standardUserDefaults]synchronize];

        BOOL insert = NO;
        insert =[bbfmdb deleteAllFromTable];

        //重新读取数据？
        if (insert) {
            NSLog(@"插入数据成功 ---   需要重新读取");
            [ZYGetBaseData getBaseData];

            //发通知，外面刷新记录表
            NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
            NSNotification * notify=[[NSNotification alloc]initWithName:@"AddressBookChange" object:self userInfo:nil];
            [center postNotification:notify];
            
        }

    }];

}
 




+(void)getAddressBookToken
{
    
    ABAddressBookRef addressBook = NULL;
    __block BOOL accessGranted = NO;

    if (&ABAddressBookRequestAccessWithCompletion != NULL) {

        addressBook=ABAddressBookCreateWithOptions(NULL, NULL);

        //        NSLog(@"on iOS 6 or later, trying to grant access permission");

        dispatch_semaphore_t sema = dispatch_semaphore_create(0);

        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }

    if (accessGranted) {
    }else{

        NSLog(@"没有获取权限");
    }
}

@end
