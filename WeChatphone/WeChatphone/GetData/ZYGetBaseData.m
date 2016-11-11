//
//  ZYGetBaseData.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYGetBaseData.h"
#import "Header.h"


@implementation ZYGetBaseData

//
  
/**
 *  获取通讯录
 */ 
+(BOOL)getBaseData
{
  NSLog(@"getBaseData");

    // 是否需要插入数据库
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kSetupDataBase]) {
//         程序第一次启动

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
            if (addressBook!=nil) {
                CFRelease(addressBook);

            }
            [self baseDataUtillty];
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }

}
 
 


+(void)baseDataUtillty
{
    NSArray *array = [[AddressBookHandle sharedAddressBook] getContactInfos];

    NSArray *dicArray = [BBContact keyValuesArrayWithObjectArray:array];

    for (int i = 0; i <dicArray.count; i++) {

        NSDictionary *dic = dicArray[i];
        NSString *email = [JsonUtils DataToJsonString:[dic valueForKey:@"emails"]];
        NSString *ims =   [JsonUtils DataToJsonString:[dic valueForKey:@"ims"]];
        NSString *phoneNumbers = [JsonUtils DataToJsonString:[dic valueForKey:@"phoneNumbers"]];
        NSString *contactAddress = [JsonUtils DataToJsonString:[dic valueForKey:@"contactAddress"]];
        NSString *urls = [JsonUtils DataToJsonString:[dic valueForKey:@"urls"]];
        NSString *uuid = [dic valueForKey:@"uuid"];
        NSString *displayName = [dic valueForKey:@"displayName"];
        NSString *contactName = [JsonUtils DataToJsonString:[dic valueForKey:@"contactName"]];
        NSString *nickname = dic[@"nickname"];
        NSString *birthday = dic[@"birthday"];



        NSString *note = dic[@"note"];
        NSString *contactOrganization = [JsonUtils DataToJsonString:[dic valueForKey:@"contactOrganization"]];
        NSString *photo = dic[@"photo"];

        [[BBFmdbTool shareFmdbTool] insertContact:uuid displayName:displayName contactName:contactName nickname:nickname  phoneNumbers:phoneNumbers emails:email contactAddress:contactAddress ims:ims contactOrganization:contactOrganization birthday:birthday note:note photo:photo urls:urls];

        BBContact *contact = array[i];
        for (int j = 0; j<contact.phoneNumbers.count; j++) {
            BBContactPhoneNumber *phones = contact.phoneNumbers[j];
            NSString *phoneStr = phones.value;
            [[BBFmdbTool shareFmdbTool] insertTel:phoneStr classid:(i+1)];
        }
        
    }  

    
    [[NSUserDefaults standardUserDefaults] setValue:@"successInsert" forKey:kSetupDataBase];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

  
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
