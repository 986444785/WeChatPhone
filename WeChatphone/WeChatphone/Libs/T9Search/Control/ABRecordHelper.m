//
//  ABRecordHelper.m
//  jiashuContact
//
//  Created by liushuai on 14-4-4.
//  Copyright (c) 2014年 ftabs. All rights reserved.
//

#import "ABRecordHelper.h"
#import "PrefixHeader.pch"
#import "ChineseToPinyin.h"

@implementation ABRecordHelper

+(NSData *)imageOfPerson:(ABRecordRef)personRecord
{
    BOOL hasImage = ABPersonHasImageData(personRecord);
    if (hasImage) {
        CFDataRef data = ABPersonCopyImageDataWithFormat(personRecord, kABPersonImageFormatThumbnail);
        return (__bridge_transfer NSData *)data;
    }
    return nil;
}

+(NSString *)nameOfPerson:(ABRecordRef)personRecord
{
    NSString *first = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonFirstNameProperty));
    NSString *last = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonLastNameProperty));
    // firstName 对应 名字，，lastName 对应 姓氏
    return [NSString stringWithFormat:@"%@%@",(last!=nil)?last:@"",(first!=nil)?first:@""];
}
+(NSString *)middleNameOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonMiddleNameProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)prefixOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonPrefixProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)suffixOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonSuffixProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)nicknameOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonNicknameProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)firstnamePhoneticOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonFirstNamePhoneticProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)lastnamePhoneticOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonLastNamePhoneticProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)middlenamePhoneticOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonMiddleNamePhoneticProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)companyOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonOrganizationProperty));
    return (tmp == nil || [tmp isEqualToString:@"null"]) ? @"" : tmp;
}
+(NSString *)departmentOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonDepartmentProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSString *)jobOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonJobTitleProperty));
    return (tmp == nil || [tmp isEqualToString:@"null"]) ? @"" : tmp;
}
+(NSString *)noteOfPerson:(ABRecordRef)personRecord
{
    NSString *tmp = (__bridge NSString *)(ABRecordCopyValue(personRecord, kABPersonNoteProperty));
    return (tmp != nil && ![tmp isEqualToString:@"null"]) ? tmp : @"";
}
+(NSDate *)birthdayOfPerson:(ABRecordRef)personRecord
{
    // 经常出现闪退的地方
    NSDate *tmp = (__bridge NSDate *)(ABRecordCopyValue(personRecord, kABPersonBirthdayProperty));
    return tmp;
}
+(NSDate *)creationOfPerson:(ABRecordRef)personRecord
{
    NSDate *tmp = (__bridge NSDate *)(ABRecordCopyValue(personRecord, kABPersonCreationDateProperty));
    return tmp;
}
+(NSDate *)modificationOfPerson:(ABRecordRef)personRecord
{
    NSDate *tmp = (__bridge NSDate *)(ABRecordCopyValue(personRecord, kABPersonModificationDateProperty));
    return tmp;
}

+(NSArray *)phonesOfPerson:(ABRecordRef)personRecord
{
    @synchronized(self) {
        
        @try {
            NSMutableArray *arrayOfPhones = [[NSMutableArray alloc] init];
            // 经常出现闪退的地方，可能是线程原因
            
            ABMultiValueRef thePhoneMulti = ABRecordCopyValue(personRecord, kABPersonPhoneProperty);
            for (int phoneIndex=0; phoneIndex < ABMultiValueGetCount(thePhoneMulti); phoneIndex++) {
                NSString *thePhoneItem = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(thePhoneMulti, phoneIndex));
                //        CFStringRef label = ABMultiValueCopyLabelAtIndex(phone, phoneIndex);
                //        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
                //        NSLog(@"thePhoneItem %@,label %@\n",thePhoneItem,localLabel);
                if (thePhoneItem != nil && ![thePhoneItem isEqualToString:@""]) {
                    [arrayOfPhones addObject:thePhoneItem];
                }
            }
            return arrayOfPhones;
        }
        @catch (NSException *exception) {
//            NSLog(@"exception %@",exception);
        }
        @finally {
            
        }
        
    }
}

+(NSArray *)mailsOfPerson:(ABRecordRef)personRecord
{
    NSMutableArray *array = [NSMutableArray array];
    
    ABMultiValueRef emails = ABRecordCopyValue(personRecord, kABPersonEmailProperty);
    for (int i=0; i < ABMultiValueGetCount(emails); i++) {
        NSString *single = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, i));
        if (single && ![single isEqualToString:@""]) {
            [array addObject:single];
        }
    }
    
    if (array.count > 0) {
        return array;
    }
    return nil;
}
+(NSMutableArray *)mergedArrFromPersons:(NSArray *)persons
{
    NSMutableArray *mergedArr = [NSMutableArray array];
    
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *nameArr = [NSMutableArray array];
    ABMutableMultiValueRef phoneMulti = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMutableMultiValueRef mailMulti = ABMultiValueCreateMutable(kABPersonEmailProperty);
    ABMutableMultiValueRef addressMulti = ABMultiValueCreateMutable(kABPersonAddressProperty);
    ABMutableMultiValueRef urlMulti = ABMultiValueCreateMutable(kABPersonURLProperty);
    ABMutableMultiValueRef dateMulti = ABMultiValueCreateMutable(kABPersonDateProperty);
    ABMutableMultiValueRef imMulti = ABMultiValueCreateMutable(kABPersonInstantMessageProperty);
    ABMutableMultiValueRef relatedMulti = ABMultiValueCreateMutable(kABPersonRelatedNamesProperty);
    ABMutableMultiValueRef socialMulti = ABMultiValueCreateMutable(kABPersonSocialProfileProperty);
    NSMutableArray *departArr = [NSMutableArray array];
    NSMutableArray *jobArr = [NSMutableArray array];
    NSMutableArray *birthdayArr = [NSMutableArray array];
    NSMutableArray *noteArr = [NSMutableArray array];
    NSMutableArray *companyArr = [NSMutableArray array];
    NSMutableArray *prefixArr = [NSMutableArray array];
    NSMutableArray *suffixArr = [NSMutableArray array];
    NSMutableArray *nickArr = [NSMutableArray array];
    
    for (NSDictionary *dicItem in persons) {
        
        ABRecordRef record = ((NSValue *)dicItem[keyPointer]).pointerValue;
        
        NSData *image = [ABRecordHelper imageOfPerson:record];
        if (image != nil) {
            [imageArr addObject:image];
        }
        
        NSString *name = [ABRecordHelper nameOfPerson:record];
        if (name != nil && ![name isEqualToString:@""]) {
            [nameArr addObject:name];
        }
        
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for (int i=0; i < ABMultiValueGetCount(phone); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(phone, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(phone, i);
            ABMultiValueAddValueAndLabel(phoneMulti, value, label, NULL);
        }
        
        ABMultiValueRef mail = ABRecordCopyValue(record, kABPersonEmailProperty);
        for (int i=0; i < ABMultiValueGetCount(mail); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(mail, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(mail, i);
            ABMultiValueAddValueAndLabel(mailMulti, value, label, NULL);
        }
        
        ABMultiValueRef address = ABRecordCopyValue(record, kABPersonAddressProperty);
        for (int i=0; i < ABMultiValueGetCount(address); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(address, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(address, i);
            ABMultiValueAddValueAndLabel(addressMulti, value, label, NULL);
        }
        
        ABMultiValueRef url = ABRecordCopyValue(record, kABPersonURLProperty);
        for (int i=0; i < ABMultiValueGetCount(url); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(url, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(url, i);
            ABMultiValueAddValueAndLabel(urlMulti, value, label, NULL);
        }
        
        ABMultiValueRef date = ABRecordCopyValue(record, kABPersonDateProperty);
        for (int i=0; i < ABMultiValueGetCount(date); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(date, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(date, i);
            ABMultiValueAddValueAndLabel(dateMulti, value, label, NULL);
        }
        
        ABMultiValueRef instance = ABRecordCopyValue(record, kABPersonInstantMessageProperty);
        for (int i=0; i < ABMultiValueGetCount(instance); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(instance, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(instance, i);
            ABMultiValueAddValueAndLabel(imMulti, value, label, NULL);
        }
        
        ABMultiValueRef related = ABRecordCopyValue(record, kABPersonRelatedNamesProperty);
        for (int i=0; i < ABMultiValueGetCount(related); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(related, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(related, i);
            ABMultiValueAddValueAndLabel(relatedMulti, value, label, NULL);
        }
        
        ABMultiValueRef social = ABRecordCopyValue(record, kABPersonSocialProfileProperty);
        for (int i=0; i < ABMultiValueGetCount(social); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(social, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(social, i);
            ABMultiValueAddValueAndLabel(socialMulti, value, label, NULL);
        }
        
        NSString *depart = [ABRecordHelper departmentOfPerson:record];
        if (depart != nil && ![depart isEqualToString:@""]) {
            [departArr addObject:depart];
        }
        
        NSString *job = [ABRecordHelper jobOfPerson:record];
        if (job != nil && ![job isEqualToString:@""]) {
            [jobArr addObject:job];
        }
        
        NSDate *birthday = [ABRecordHelper birthdayOfPerson:record];
        if (birthday != nil) {
            [birthdayArr addObject:birthday];
        }
        
        NSString *note = [ABRecordHelper noteOfPerson:record];
        if (note != nil && ![note isEqualToString:@""]) {
            [noteArr addObject:note];
        }
        
        NSString *company = [ABRecordHelper companyOfPerson:record];
        if (company != nil && ![company isEqualToString:@""]) {
            [companyArr addObject:company];
        }
        
        NSString *prefix = [ABRecordHelper prefixOfPerson:record];
        if (prefix != nil && ![prefix isEqualToString:@""]) {
            [prefixArr addObject:prefix];
        }
        
        NSString *suffix = [ABRecordHelper suffixOfPerson:record];
        if (suffix != nil && ![suffix isEqualToString:@""]) {
            [suffixArr addObject:suffix];
        }
        
        NSString *nick = [ABRecordHelper nicknameOfPerson:record];
        if (nick != nil && ![nick isEqualToString:@""]) {
            [nickArr addObject:nick];
        }
        
    }
    
    if (imageArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeImage,@"value":imageArr,@"type":@(0)}];
    }
    if (nameArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeName,@"value":nameArr,@"type":@(0)}];
    }
    
    for (int i=0; i < ABMultiValueGetCount(phoneMulti)-1; i++) {
        NSString *baseValue = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        for (int j = i + 1; j < ABMultiValueGetCount(phoneMulti); j++) {
            NSString *theValue = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneMulti, j));
            if ([theValue isEqualToString:baseValue]) {
                ABMultiValueRemoveValueAndLabelAtIndex(phoneMulti, j);
                j--;
            }
            
        }
        
    }
    if (ABMultiValueGetCount(phoneMulti) > 0) {
        [mergedArr addObject:@{@"key": mergePhone,@"value":[NSValue valueWithPointer:phoneMulti],@"type":@(1)}];
    }
    if (ABMultiValueGetCount(mailMulti) > 0) {
        [mergedArr addObject:@{@"key": mergeMail,@"value":[NSValue valueWithPointer:mailMulti],@"type":@(1)}];
    }
    if (ABMultiValueGetCount(addressMulti) > 0) {
        [mergedArr addObject:@{@"key": mergeAddress,@"value":[NSValue valueWithPointer:addressMulti],@"type":@(1)}];
    }
    if (ABMultiValueGetCount(urlMulti) > 0) {
        [mergedArr addObject:@{@"key": mergeURL,@"value":[NSValue valueWithPointer:urlMulti],@"type":@(1)}];
    }
    if (ABMultiValueGetCount(dateMulti) > 0) {
        [mergedArr addObject:@{@"key": mergeDate,@"value":[NSValue valueWithPointer:dateMulti],@"type":@(1)}];
    }
    if (ABMultiValueGetCount(imMulti) > 0) {
        [mergedArr addObject:@{@"key": mergeIM,@"value":[NSValue valueWithPointer:imMulti],@"type":@(1)}];
    }
    if (ABMultiValueGetCount(relatedMulti) > 0) {
        [mergedArr addObject:@{@"key": mergeRelate,@"value":[NSValue valueWithPointer:relatedMulti],@"type":@(1)}];
    }
    if (ABMultiValueGetCount(socialMulti) > 0) {
        [mergedArr addObject:@{@"key": mergeSocial,@"value":[NSValue valueWithPointer:socialMulti],@"type":@(1)}];
    }
    if (departArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeDepart,@"value":departArr,@"type":@(0)}];
    }
    if (jobArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeJob,@"value":jobArr,@"type":@(0)}];
    }
    if (birthdayArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeBirthday,@"value":birthdayArr,@"type":@(0)}];
    }
    if (noteArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeNote,@"value":noteArr,@"type":@(0)}];
    }
    if (companyArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeCompany,@"value":companyArr,@"type":@(0)}];
    }
    if (prefixArr.count > 0) {
        [mergedArr addObject:@{@"key": mergePrefix,@"value":prefixArr,@"type":@(0)}];
    }
    if (suffixArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeSuffix,@"value":suffixArr,@"type":@(0)}];
    }
    if (nickArr.count > 0) {
        [mergedArr addObject:@{@"key": mergeNick,@"value":nickArr,@"type":@(0)}];
    }
    
    return mergedArr;
}
+(ABRecordRef)mergedPersonFromPersons:(NSArray *)persons
{
    ABRecordRef mergedPerson = ABPersonCreate();
    
    // name
    NSDictionary *tmp = persons[0];
    ABRecordRef record = ((NSValue *)tmp[keyPointer]).pointerValue;
    NSString *name = [ABRecordHelper nameOfPerson:record];
    ABRecordSetValue(mergedPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(name), nil);
    
    NSMutableString *middleName = [NSMutableString string];
    NSMutableString *prefix = [NSMutableString string];
    NSMutableString *suffix = [NSMutableString string];
    NSMutableString *nickName = [NSMutableString string];
    NSMutableString *firstNamePhonetic = [NSMutableString string];
    NSMutableString *lastNamePhonetic = [NSMutableString string];
    NSMutableString *middleNamePhonetic = [NSMutableString string];
    NSMutableString *organization = [NSMutableString string];
    NSMutableString *job = [NSMutableString string];
    NSMutableString *department = [NSMutableString string];
    NSMutableString *note = [NSMutableString string];
    NSDate *birthday;
    
    ABMutableMultiValueRef phoneMulti = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMutableMultiValueRef mailMulti = ABMultiValueCreateMutable(kABPersonEmailProperty);
    ABMutableMultiValueRef imMulti = ABMultiValueCreateMutable(kABPersonInstantMessageProperty);
    ABMutableMultiValueRef urlMulti = ABMultiValueCreateMutable(kABPersonURLProperty);
    ABMutableMultiValueRef relatedMulti = ABMultiValueCreateMutable(kABPersonRelatedNamesProperty);
    ABMutableMultiValueRef socialMulti = ABMultiValueCreateMutable(kABPersonSocialProfileProperty);
    ABMutableMultiValueRef dateMulti = ABMultiValueCreateMutable(kABPersonDateProperty);
    ABMutableMultiValueRef addressMulti = ABMultiValueCreateMutable(kABPersonAddressProperty);
    
    for (NSDictionary *tmpDic in persons) {
        
        ABRecordRef record = ((NSValue *)tmpDic[keyPointer]).pointerValue;
        
        [middleName appendString:[ABRecordHelper middleNameOfPerson:record]];
        [prefix appendString:[ABRecordHelper prefixOfPerson:record]];
        [suffix appendString:[ABRecordHelper suffixOfPerson:record]];
        [nickName appendString:[ABRecordHelper nicknameOfPerson:record]];
        [firstNamePhonetic appendString:[ABRecordHelper firstnamePhoneticOfPerson:record]];
        [lastNamePhonetic appendString:[ABRecordHelper lastnamePhoneticOfPerson:record]];
        [middleNamePhonetic appendString:[ABRecordHelper middlenamePhoneticOfPerson:record]];
        [organization appendString:[ABRecordHelper companyOfPerson:record]];
        [job appendString:[ABRecordHelper jobOfPerson:record]];
        [department appendString:[ABRecordHelper departmentOfPerson:record]];
        [note appendString:[ABRecordHelper noteOfPerson:record]];
        NSDate *bir = [ABRecordHelper birthdayOfPerson:record];
        if (bir != nil) {
            birthday = bir;
        }
        
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for (int i=0; i < ABMultiValueGetCount(phone); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(phone, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(phone, i);
            ABMultiValueAddValueAndLabel(phoneMulti, value, label, NULL);
        }
        
        ABMultiValueRef mail = ABRecordCopyValue(record, kABPersonEmailProperty);
        for (int i=0; i < ABMultiValueGetCount(mail); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(mail, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(mail, i);
            ABMultiValueAddValueAndLabel(mailMulti, value, label, NULL);
        }
        
        ABMultiValueRef instance = ABRecordCopyValue(record, kABPersonInstantMessageProperty);
        for (int i=0; i < ABMultiValueGetCount(instance); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(instance, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(instance, i);
            ABMultiValueAddValueAndLabel(imMulti, value, label, NULL);
        }
        
        ABMultiValueRef url = ABRecordCopyValue(record, kABPersonURLProperty);
        for (int i=0; i < ABMultiValueGetCount(url); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(url, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(url, i);
            ABMultiValueAddValueAndLabel(urlMulti, value, label, NULL);
        }
        
        ABMultiValueRef related = ABRecordCopyValue(record, kABPersonRelatedNamesProperty);
        for (int i=0; i < ABMultiValueGetCount(related); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(related, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(related, i);
            ABMultiValueAddValueAndLabel(relatedMulti, value, label, NULL);
        }
        
        ABMultiValueRef social = ABRecordCopyValue(record, kABPersonSocialProfileProperty);
        for (int i=0; i < ABMultiValueGetCount(social); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(social, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(social, i);
            ABMultiValueAddValueAndLabel(socialMulti, value, label, NULL);
        }
        
        ABMultiValueRef date = ABRecordCopyValue(record, kABPersonDateProperty);
        for (int i=0; i < ABMultiValueGetCount(date); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(date, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(date, i);
            ABMultiValueAddValueAndLabel(dateMulti, value, label, NULL);
        }
        
        ABMultiValueRef address = ABRecordCopyValue(record, kABPersonAddressProperty);
        for (int i=0; i < ABMultiValueGetCount(address); i++) {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(address, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(address, i);
            ABMultiValueAddValueAndLabel(addressMulti, value, label, NULL);
        }
        
    }
    
    if (middleName != nil && ![middleName isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(middleName), nil);
    }
    if (prefix != nil && ![prefix isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonPrefixProperty, (__bridge CFTypeRef)(prefix), nil);
    }
    if (suffix != nil && ![suffix isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonSuffixProperty, (__bridge CFTypeRef)(suffix), nil);
    }
    if (nickName != nil && ![nickName isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonNicknameProperty, (__bridge CFTypeRef)(nickName), nil);
    }
    if (firstNamePhonetic != nil && ![firstNamePhonetic isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonFirstNamePhoneticProperty, (__bridge CFTypeRef)(firstNamePhonetic), nil);
    }
    if (lastNamePhonetic != nil && ![lastNamePhonetic isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonLastNamePhoneticProperty, (__bridge CFTypeRef)(lastNamePhonetic), nil);
    }
    if (middleNamePhonetic != nil && ![middleNamePhonetic isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonMiddleNamePhoneticProperty, (__bridge CFTypeRef)(middleNamePhonetic), nil);
    }
    if (organization != nil && ![organization isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)(organization), nil);
    }
    if (job != nil && ![job isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)(job), nil);
    }
    if (department != nil && ![department isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonDepartmentProperty, (__bridge CFTypeRef)(department), nil);
    }
    if (birthday != nil) {
        ABRecordSetValue(mergedPerson, kABPersonBirthdayProperty, (__bridge CFTypeRef)(birthday), nil);
    }
    if (note != nil && ![note isEqualToString:@""]) {
        ABRecordSetValue(mergedPerson, kABPersonNoteProperty, (__bridge CFTypeRef)(note), nil);
    }
    
    ABRecordSetValue(mergedPerson, kABPersonPhoneProperty, phoneMulti, nil);
    ABRecordSetValue(mergedPerson, kABPersonEmailProperty, mailMulti, nil);
    ABRecordSetValue(mergedPerson, kABPersonInstantMessageProperty, imMulti, nil);
    ABRecordSetValue(mergedPerson, kABPersonURLProperty, urlMulti, nil);
    ABRecordSetValue(mergedPerson, kABPersonRelatedNamesProperty, relatedMulti, nil);
    ABRecordSetValue(mergedPerson, kABPersonSocialProfileProperty, socialMulti, nil);
    ABRecordSetValue(mergedPerson, kABPersonDateProperty, dateMulti, nil);
    ABRecordSetValue(mergedPerson, kABPersonAddressProperty, addressMulti, nil);
    
    return mergedPerson;
}

+(ABRecordRef)handMergedPersonFromMergedArr:(NSMutableArray *)mergedArr selectStateArr:(NSMutableArray *)selStateArr
{
    ABRecordRef mergedPerson = ABPersonCreate();
    
    for (int i = 0; i < mergedArr.count; i++) {
        NSArray *state = selStateArr[i];
        NSDictionary *item = mergedArr[i];
        NSString *key = item[@"key"];
        NSNumber *type = item[@"type"];
        if (type.intValue == 0) {
            
            NSArray *tmp = item[@"value"];
            for (int j = 0; j < tmp.count ; j++) {
                if (((NSNumber *)state[j]).boolValue) {
                    
                    if ([key isEqualToString:mergeImage]) {
                        NSData *image = tmp[j];
                        ABPersonSetImageData(mergedPerson, (__bridge CFDataRef)(image), nil);
                    }else if ([key isEqualToString:mergeName]){
                        NSString *name = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(name), nil);
                    }else if ([key isEqualToString:mergeDepart]){
                        NSString *depart = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonDepartmentProperty, (__bridge CFTypeRef)(depart), nil);
                    }else if ([key isEqualToString:mergeJob]){
                        NSString *job = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)(job), nil);
                    }else if ([key isEqualToString:mergeBirthday]){
                        NSDate *birthday = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonBirthdayProperty, (__bridge CFTypeRef)(birthday), nil);
                    }else if ([key isEqualToString:mergeNote]){
                        NSString *note = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonNoteProperty, (__bridge CFTypeRef)(note), nil);
                    }else if ([key isEqualToString:mergeCompany]){
                        NSString *company = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)(company), nil);
                    }else if ([key isEqualToString:mergePrefix]){
                        NSString *prefix = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonPrefixProperty, (__bridge CFTypeRef)(prefix), nil);
                    }else if ([key isEqualToString:mergeSuffix]){
                        NSString *suffix = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonSuffixProperty, (__bridge CFTypeRef)(suffix), nil);
                    }else if ([key isEqualToString:mergeNick]){
                        NSString *nick = tmp[j];
                        ABRecordSetValue(mergedPerson, kABPersonNicknameProperty, (__bridge CFTypeRef)(nick), nil);
                    }
                    
                    break;
                }
            }
            
        }else if (type.intValue == 1){
            
            ABMultiValueRef multi = ((NSValue *)item[@"value"]).pointerValue;
            
            ABMutableMultiValueRef direction = ABMultiValueCreateMutableCopy(multi);
            for (int j = ABMultiValueGetCount(direction)-1; j >= 0; j--) {
                if (((NSNumber *)state[j]).boolValue == 0) {
                    ABMultiValueRemoveValueAndLabelAtIndex(direction, j);
                }
            }
            
            if (ABMultiValueGetCount(direction) > 0) {
                
                if ([key isEqualToString:mergePhone]) {
                    ABRecordSetValue(mergedPerson, kABPersonPhoneProperty, direction, nil);
                }else if ([key isEqualToString:mergeMail]){
                    ABRecordSetValue(mergedPerson, kABPersonEmailProperty, direction, nil);
                }else if ([key isEqualToString:mergeAddress]){
                    ABRecordSetValue(mergedPerson, kABPersonAddressProperty, direction, nil);
                }else if ([key isEqualToString:mergeURL]){
                    ABRecordSetValue(mergedPerson, kABPersonURLProperty, direction, nil);
                }else if ([key isEqualToString:mergeDate]){
                    ABRecordSetValue(mergedPerson, kABPersonDateProperty, direction, nil);
                }else if ([key isEqualToString:mergeIM]){
                    ABRecordSetValue(mergedPerson, kABPersonInstantMessageProperty, direction, nil);
                }else if ([key isEqualToString:mergeRelate]){
                    ABRecordSetValue(mergedPerson, kABPersonRelatedNamesProperty, direction, nil);
                }else if ([key isEqualToString:mergeSocial]){
                    ABRecordSetValue(mergedPerson, kABPersonSocialProfileProperty, direction, nil);
                }
                
            }
        }
    }
    
    return mergedPerson;
}

+(NSString *)detailInfoOfPerson:(ABRecordRef)personRecord
{
    NSMutableString *detail = [[NSMutableString alloc] init];
    
    NSString *name = [ABRecordHelper nameOfPerson:personRecord];
    if (name != nil && ![name isEqualToString:@""]) {
        [detail appendFormat:@"%@:%@\n",NSLocalizedString(@"nameString", nil),name];
    }
    
    ABMultiValueRef phone = ABRecordCopyValue(personRecord, kABPersonPhoneProperty);
    for (int i=0; i < ABMultiValueGetCount(phone); i++) {
        NSString *tel = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phone, i));
        CFStringRef label = ABMultiValueCopyLabelAtIndex(phone, i);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        if (tel && ![tel isEqualToString:@""]) {
            [detail appendFormat:@"%@%@:%@\n",localLabel,NSLocalizedString(@"phoneString", nil),tel];
        }
    }
    
    ABMultiValueRef mail = ABRecordCopyValue(personRecord, kABPersonEmailProperty);
    for (int i=0; i < ABMultiValueGetCount(mail); i++) {
        NSString *value = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(mail, i));
        CFStringRef label = ABMultiValueCopyLabelAtIndex(mail, i);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        if (value && ![value isEqualToString:@""]) {
            [detail appendFormat:@"%@%@:%@\n",localLabel,NSLocalizedString(@"mailString", nil),value];
        }
    }
    
    ABMultiValueRef address = ABRecordCopyValue(personRecord, kABPersonAddressProperty);
    for (int i=0; i < ABMultiValueGetCount(address); i++) {
        NSDictionary *value = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(address, i));
        CFStringRef label = ABMultiValueCopyLabelAtIndex(address, i);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        NSString *text = [NSString stringWithFormat:@"%@%@%@%@",value[@"Country"],value[@"State"],value[@"City"],value[@"Street"]];
        if (text && ![text isEqualToString:@""]) {
            [detail appendFormat:@"%@%@:%@\n",localLabel,NSLocalizedString(@"addressString", nil),text];
        }
    }
    
    ABMultiValueRef url = ABRecordCopyValue(personRecord, kABPersonURLProperty);
    for (int i=0; i < ABMultiValueGetCount(url); i++) {
        NSString *value = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(url, i));
        CFStringRef label = ABMultiValueCopyLabelAtIndex(url, i);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        if (value && ![value isEqualToString:@""]) {
            [detail appendFormat:@"%@%@:%@\n",localLabel,@"URL",value];
        }
    }
    
    ABMultiValueRef date = ABRecordCopyValue(personRecord, kABPersonDateProperty);
    for (int i=0; i < ABMultiValueGetCount(date); i++) {
        NSDate *value = (__bridge NSDate *)(ABMultiValueCopyValueAtIndex(date, i));
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日"];
        NSString *text = [formatter stringFromDate:value];
        CFStringRef label = ABMultiValueCopyLabelAtIndex(date, i);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        if (text && ![text isEqualToString:@""]) {
            [detail appendFormat:@"%@%@:%@\n",localLabel,NSLocalizedString(@"dateString", nil),text];
        }
    }
    
    ABMultiValueRef instance = ABRecordCopyValue(personRecord, kABPersonInstantMessageProperty);
    for (int i=0; i < ABMultiValueGetCount(instance); i++) {
        NSDictionary *value = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(instance, i));
        NSString *text = [NSString stringWithFormat:@"%@(%@)",value[@"username"],value[@"service"]];
        CFStringRef label = ABMultiValueCopyLabelAtIndex(instance, i);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        if (text && ![text isEqualToString:@""]) {
            [detail appendFormat:@"%@:%@\n",localLabel,text];
        }
    }
    
    ABMultiValueRef related = ABRecordCopyValue(personRecord, kABPersonRelatedNamesProperty);
    for (int i=0; i < ABMultiValueGetCount(related); i++) {
        NSString *value = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(related, i));
        CFStringRef label = ABMultiValueCopyLabelAtIndex(related, i);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        if (value && ![value isEqualToString:@""]) {
            [detail appendFormat:@"%@:%@\n",localLabel,value];
        }
    }
    
    ABMultiValueRef social = ABRecordCopyValue(personRecord, kABPersonSocialProfileProperty);
    for (int i=0; i < ABMultiValueGetCount(social); i++) {
        NSDictionary *value = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(social, i));
        NSString *text = [NSString stringWithFormat:@"%@:%@\n",value[@"service"],value[@"username"]];
//        CFStringRef label = ABMultiValueCopyLabelAtIndex(social, i);
//        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        [detail appendString:text];
    }
    
    NSString *depart = [ABRecordHelper departmentOfPerson:personRecord];
    if (depart != nil && ![depart isEqualToString:@""]) {
        [detail appendString:[NSString stringWithFormat:@"%@:%@\n",NSLocalizedString(@"departString", nil),depart]];
    }
    
    NSString *job = [ABRecordHelper jobOfPerson:personRecord];
    if (job != nil && ![job isEqualToString:@""]) {
        [detail appendString:[NSString stringWithFormat:@"%@:%@\n",NSLocalizedString(@"jobString", nil),job]];
    }
    
    NSDate *birthday = [ABRecordHelper birthdayOfPerson:personRecord];
    if (birthday != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日"];
        NSString *text = [formatter stringFromDate:birthday];
        [detail appendString:[NSString stringWithFormat:@"%@:%@\n",NSLocalizedString(@"birthdayString", nil),text]];
    }
    
    NSString *note = [ABRecordHelper noteOfPerson:personRecord];
    if (note != nil && ![note isEqualToString:@""]) {
        [detail appendString:[NSString stringWithFormat:@"%@:%@\n",NSLocalizedString(@"noteString", nil),note]];
    }
    
    NSString *company = [ABRecordHelper companyOfPerson:personRecord];
    if (company != nil && ![company isEqualToString:@""]) {
        [detail appendString:[NSString stringWithFormat:@"%@:%@\n",NSLocalizedString(@"companyString", nil),company]];
    }
    
    NSString *prefix = [ABRecordHelper prefixOfPerson:personRecord];
    if (prefix != nil && ![prefix isEqualToString:@""]) {
        [detail appendString:[NSString stringWithFormat:@"%@:%@\n",NSLocalizedString(@"prefixString", nil),prefix]];
    }
    
    NSString *suffix = [ABRecordHelper suffixOfPerson:personRecord];
    if (suffix != nil && ![suffix isEqualToString:@""]) {
        [detail appendString:[NSString stringWithFormat:@"%@:%@\n",NSLocalizedString(@"sufficString", nil),suffix]];
    }
    
    NSString *nick = [ABRecordHelper nicknameOfPerson:personRecord];
    if (nick != nil && ![nick isEqualToString:@""]) {
        [detail appendString:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"nickString", nil),nick]];
    }
    
    return detail;
}

+(NSData *)vCardWithoutPortraitOfPerson:(ABRecordRef)personRecord
{
//    ABRecordRef newRecord = ABPersonCreateInSource(personRecord);//因为这个方法不会用，所以先将ABRecordRef类型转换为vCard，再由vCard转换为ABRecordRef类型,最后再移除掉image属性，输出vCard，绕了个大圈子
    
    CFMutableArrayRef array = CFArrayCreateMutable(NULL, 1, NULL);
    CFArrayAppendValue(array, personRecord);
    
    CFDataRef data = ABPersonCreateVCardRepresentationWithPeople(array);
    
    CFArrayRef persons = ABPersonCreatePeopleInSourceWithVCardRepresentation(NULL, data);
    
    if (CFArrayGetCount(persons) == 0) {
        return nil;
    }
    
    ABRecordRef newRecord =  CFArrayGetValueAtIndex(persons, 0);
    
    if (ABPersonHasImageData(newRecord)) {
        ABPersonRemoveImageData(newRecord, nil);
    }
    
    CFMutableArrayRef tmp = CFArrayCreateMutable(NULL, 1, NULL);
    CFArrayAppendValue(tmp, newRecord);
    
    return (__bridge NSData *)(ABPersonCreateVCardRepresentationWithPeople(tmp));
}

+(NSData *)vCardsOfPersons:(NSArray *)persons
{
    CFMutableArrayRef array = CFArrayCreateMutable(NULL, persons.count, NULL);
    for (NSDictionary *item in persons) {
        ABRecordRef record = ((NSValue *)item[keyPointer]).pointerValue;
        CFArrayAppendValue(array, record);
    }
    
    CFDataRef data = ABPersonCreateVCardRepresentationWithPeople(array);
    
    return (__bridge NSData *)(data);
}

+(ABRecordRef)personFromVcard:(NSString *)vCard
{
    NSData *data = [vCard dataUsingEncoding:NSUTF8StringEncoding];
    CFArrayRef array = ABPersonCreatePeopleInSourceWithVCardRepresentation(NULL, (__bridge CFDataRef)(data));
    ABRecordRef tmp = CFArrayGetValueAtIndex(array, 0);
    return tmp;
}

// group

+(NSString *)nameOfGroup:(ABRecordRef)groupRecord
{
    return (__bridge NSString *)(ABRecordCopyValue(groupRecord, kABGroupNameProperty));
}

+(NSArray *)membersOfGroup:(ABRecordRef)groupRecord
{
    // 闪退的地方
    CFArrayRef array = ABGroupCopyArrayOfAllMembers(groupRecord);

    if (array == nil || CFArrayGetCount(array) == 0) {
        return nil;
    }
    
    NSMutableArray *contactSortedArr = [NSMutableArray arrayWithCapacity:CFArrayGetCount(array)];
    
    for (int i=0; i < CFArrayGetCount(array); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(array, i);
        NSString *name = [ABRecordHelper nameOfPerson:record];
        NSString *pinyinName = [ChineseToPinyin translatePinyinFromString:name];
        if ([pinyinName isEqualToString:@""] || pinyinName == nil) {
            pinyinName = @"#";
        }
        NSDictionary *dic = @{keyPointer: [NSValue valueWithPointer:record],ZYkeyName:pinyinName};
        [contactSortedArr addObject:dic];
    }
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:ZYkeyName ascending:YES];
    [contactSortedArr sortUsingDescriptors:@[sortDes]];
    
    NSInteger speLetterBeforeACount = 0;
    NSInteger speLetterAfterZCount = 0;
    for (int i=0; i < contactSortedArr.count; i++) {
        NSDictionary *dic = contactSortedArr[i];
        NSInteger position = [dic[ZYkeyName] characterAtIndex:0] - 'A';
        if (position < 0) {
            speLetterBeforeACount ++;
        }else if (position >= 26){
            speLetterAfterZCount ++;
        }
    }
    NSArray *subArr = [contactSortedArr subarrayWithRange:NSMakeRange(0, speLetterBeforeACount)];
    if (subArr.count > 0) {
        for (int i=0; i<subArr.count; i++) {
            [contactSortedArr insertObject:subArr[i] atIndex:contactSortedArr.count-speLetterAfterZCount];
        }
        [contactSortedArr removeObjectsInRange:NSMakeRange(0, speLetterBeforeACount)];
    }
    
    return contactSortedArr;
}

@end
