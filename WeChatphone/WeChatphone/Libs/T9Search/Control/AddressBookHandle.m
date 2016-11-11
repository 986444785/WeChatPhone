//
//  AddressBookHandle.m
//  jiashuContact
//
//  Created by liushuai on 14-4-4.
//  Copyright (c) 2014年 ftabs. All rights reserved.
//

@class AddressBookHandle;



#import "AddressBookHandle.h"
#import "ABRecordHelper.h"
#import "ChineseToPinyin.h"
#import "BBTKAddressBook.h"
#import "BBContact.h"
#import "BBContactName.h"
#import "BBContactPhoneNumber.h"
#import "BBContactOrganization.h"
#import "BBContactPhoto.h"
#import "BBContactEmail.h"
#import "BBContactAddress.h"
#import "BBContactIm.h"
#import "BBContactUrl.h"
#import "PrefixHeader.pch"

#define kAddressWork @"_$!<Work>!$_"
#define kAddressHome @"_$!<Home>!$_"

static AddressBookHandle *handle = nil;
@implementation AddressBookHandle

// 注意，这是单例，多线程引用次方法会导致闪退,本软件里面和联系人打交道最多的一个类的实例
+(AddressBookHandle *)sharedAddressBook
{
    @synchronized(self){
        if (handle == nil) {
            handle = [[AddressBookHandle alloc] init];
            [handle initAddressBook];
        }
        
        return handle;
    }
}

-(void)initAddressBook
{
    __block BOOL gran = NO;
    
    // ABAddressBookRef 实例，不管是多少个线程在使用它，某一个时间点上只能有一个线程
    addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted,CFErrorRef error){
        gran = granted;
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (!gran) {
        addressBookRef = nil;
    }
}

-(ABAddressBookRef)addressBookRef
{
    if (addressBookRef) {
        return addressBookRef;
    }
    return nil;
}

+(BOOL)isContactPermission
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

-(NSArray *)localContact
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        @synchronized(self) {
        
            @try {
                // 经常出现闪退的地方,很有可能是多线程原因或者是 AddressBookRef 问题
//                NSLog(@"ref %@",addressBookRef);
                CFArrayRef arr = ABAddressBookCopyArrayOfAllPeople(addressBookRef);

                if (arr == nil ||  CFArrayGetCount(arr) == 0) {
                    return nil;
                }
                
                NSMutableArray *contactArr = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(arr)];
                for (int i=0; i<CFArrayGetCount(arr); i++) {
                    ABRecordRef record = CFArrayGetValueAtIndex(arr, i);
                    [contactArr addObject:[NSValue valueWithPointer:record]];
                }
                
                return contactArr;
            }
            @catch (NSException *exception) {
//                NSLog(@"local exception %@",exception);
            }
            @finally {
                
            }
        }
        
    }
    return nil;
}

-(NSArray *)sortedLocalContact
{
    NSArray *localContact = [self localContact];
    if (localContact.count == 0) {
        return nil;
    }
    
    NSMutableArray *contactSortedArr = [NSMutableArray arrayWithCapacity:localContact.count];
    
    for (int i=0; i < localContact.count; i++) {
        NSValue *value = localContact[i];
        ABRecordRef record = (ABRecordRef)[value pointerValue];
        NSString *name = [ABRecordHelper nameOfPerson:record];
        
        
        NSString *pinyinName = [ChineseToPinyin translatePinyinFromString:name];
        if ([pinyinName isEqualToString:@""] || pinyinName == nil) {
            pinyinName = @"#";
        }
        
        NSDictionary *dic = @{keyPointer: value,ZYkeyName:pinyinName};
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

////////////////////////////////////////////////////////////////////////////////////
#pragma mark 根据排完续的数组设置到模型中属性
- (NSArray *)getContactInfos{
    
// http://www.cnblogs.com/qingjoin/archive/2012/11/19/2777212.html
    
    NSArray *contactSortedArr = [self sortedLocalContact];
    NSMutableArray *contactInfos = [NSMutableArray array];
    for (int i = 0; i<contactSortedArr.count; i++) {
//        BBTKAddressBook *iphoneContact = [[BBTKAddressBook alloc] init];
        BBContact *contact = [[BBContact alloc] init];
        NSDictionary *dic = contactSortedArr[i];
        NSValue *value = dic[keyPointer];
        ABRecordRef record = value.pointerValue;
        
        // uuid
        contact.uuid = [NSString stringWithFormat:@"%tu", (int)ABRecordGetRecordID(record)];
        
        // displayName
        contact.displayName = [ABRecordHelper nameOfPerson:record];
        
        // nickname
        contact.nickname = (__bridge NSString*)ABRecordCopyValue(record, kABPersonNicknameProperty);
        
        // nameRemark 空
         
        // birthday
        NSDate *birth = [ABRecordHelper birthdayOfPerson:record];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *birthday = [formatter stringFromDate:birth];
        contact.birthday = birthday;
        
        // note
        contact.note = (__bridge NSString*)ABRecordCopyValue(record, kABPersonNoteProperty);
        
        // BBContactName
        BBContactName *contactName = [[BBContactName alloc] init];
        contactName.givenName = (__bridge NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        
        contactName.familyName = (__bridge NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
        contactName.middleName = (__bridge NSString*)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
           
        contactName.formatted = [ABRecordHelper nameOfPerson:record];

        contactName.honorificPrefix = (__bridge NSString*)ABRecordCopyValue(record, kABPersonPrefixProperty);
        contactName.honorificSuffix = (__bridge NSString*)ABRecordCopyValue(record, kABPersonSuffixProperty);
        contactName.pinName = dic[ZYkeyName];
        contact.contactName = contactName;
        
        // 电话多值
        NSMutableArray *phoneNumbers = [NSMutableArray array];
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            BBContactPhoneNumber *phoneNumber = [[BBContactPhoneNumber alloc] init];
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if ([personPhone hasPrefix:@"+86"]) {
                
                personPhone = [personPhone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            }
            phoneNumber.type = personPhoneLabel;
            phoneNumber.value = personPhone;
            [phoneNumbers addObject:phoneNumber];
        }
        contact.phoneNumbers = phoneNumbers;
        
        // emails
        NSMutableArray *contactEmails = [NSMutableArray array];
        ABMultiValueRef email = ABRecordCopyValue(record, kABPersonEmailProperty);
        CFIndex emailcount = ABMultiValueGetCount(email);
        for (int x = 0; x < emailcount; x++)
        {
            BBContactEmail *contactEmail = [[BBContactEmail alloc] init];
            //获取email Label
            NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
            //获取email值
            NSString* emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, x);
            contactEmail.type = emailLabel;
            contactEmail.value = emailContent;
            [contactEmails addObject:contactEmail];
        }
        contact.emails = contactEmails;
        
        // contactAddress
        NSMutableArray *contactAddresses = [NSMutableArray array];
        ABMultiValueRef address = ABRecordCopyValue(record, kABPersonAddressProperty);
        CFIndex count = ABMultiValueGetCount(address);
        
        for(int j = 0; j < count; j++)
        {
            BBContactAddress *contactAddress = [[BBContactAddress alloc] init];
            //获取地址Label
            NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            
            if ([addressLabel isEqualToString:kAddressHome]) {
                addressLabel = @"home";
            } else {
                
                addressLabel = @"work";
            }
            
            contactAddress.type = addressLabel;
            
            //获取該label下的地址6属性
            NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            
            contactAddress.country = country;
            
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            
            contactAddress.city = city;
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            contactAddress.province = state;
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            contactAddress.streetAddress = street;
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            contactAddress.postalCode = zip;
            [contactAddresses addObject:contactAddress];
        }
        contact.contactAddress = contactAddresses;
        
        // ims
        NSMutableArray *contactIms = [NSMutableArray array];
        ABMultiValueRef instantMessage = ABRecordCopyValue(record, kABPersonInstantMessageProperty);
        for (int l = 0; l < ABMultiValueGetCount(instantMessage); l++)
        {
            
            BBContactIm *contactIm = [[BBContactIm alloc] init];
            //获取IM Label
            NSString* instantMessageLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
            contactIm.type = instantMessageLabel;
            //获取該label下的2属性
            NSDictionary* instantMessageContent =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            
            
//            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
            contactIm.value = username;
            [contactIms addObject:contactIm];
            
        }
        contact.ims = contactIms;
        
        // photos
//        NSMutableArray *contactPhotos = [NSMutableArray array];
//        BBContactPhoto *contactPhoto = [[BBContactPhoto alloc] init];
        NSData *photoData = [ABRecordHelper imageOfPerson:record];
        NSString *photoStr = [photoData base64EncodedStringWithOptions:0];
//        contactPhoto.photoUrl = photoStr;
//        [contactPhotos addObject:contactPhoto];
        contact.photo = photoStr;
        
        BBContactOrganization *contactOrganization = [[BBContactOrganization alloc] init];
        
        //读取organization公司
        NSString *organization = (__bridge NSString*)ABRecordCopyValue(record, kABPersonOrganizationProperty);
        contactOrganization.name = organization;
        //读取jobtitle工作
        NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(record, kABPersonJobTitleProperty);
        contactOrganization.title = jobtitle;
        //读取department部门
        NSString *department = (__bridge NSString*)ABRecordCopyValue(record, kABPersonDepartmentProperty);
        contactOrganization.department = department;
        
        //获取URL多值
        NSMutableArray *contactUrls = [NSMutableArray array];
        ABMultiValueRef url = ABRecordCopyValue(record, kABPersonURLProperty);
        for (int m = 0; m < ABMultiValueGetCount(url); m++)
        {
            
            BBContactUrl *contactUrl = [[BBContactUrl alloc] init];
            //获取电话Label
            NSString * urlLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
            contactUrl.type = urlLabel;
            //获取該Label下的电话值
            NSString * urlContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(url,m);
            contactUrl.value = urlContent;
            
            [contactUrls addObject:contactUrl];
        }
        contact.urls = contactUrls;
        

        // 头像
//        NSData *imageData = [ABRecordHelper imageOfPerson:record];
//        iphoneContact.heardImage = imageData;
//        
//        // 名称
//        NSString *name = [ABRecordHelper nameOfPerson:record];
//        iphoneContact.name = name;
//        
//        // 工作
//        NSString *job = [ABRecordHelper jobOfPerson:record];
//        iphoneContact.job = job;
//        
//        // 公司
//        NSString *company = [ABRecordHelper companyOfPerson:record];
//        iphoneContact.company = company;
//        
//        // 生日
//        NSDate *birth = [ABRecordHelper birthdayOfPerson:record];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *birthday = [formatter stringFromDate:birth];
//        iphoneContact.birthday = birthday;
//
//        // recordID
//       iphoneContact.recordID = (int)ABRecordGetRecordID(record);
//        
//        // 电话
//        iphoneContact.phones = [ABRecordHelper phonesOfPerson:record];
//        
//        // 邮件
//        iphoneContact.mails = [ABRecordHelper mailsOfPerson:record];
//        
//        // 创建时间
//        //实例化一个NSDateFormatter对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *createTime = [dateFormatter stringFromDate:[ABRecordHelper creationOfPerson:record]];
//        iphoneContact.createTime = createTime;
//        
//        // 描述
//        iphoneContact.detail = [ABRecordHelper detailInfoOfPerson:record];
        
        // 添加到数组中
//        [contactInfos addObject:iphoneContact];
        [contactInfos addObject:contact];
    }
    
    return contactInfos;
}


-(void)addPerson:(ABRecordRef)record
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        CFErrorRef error;
        ABAddressBookAddRecord(addressBookRef, record, &error);
        ABAddressBookSave(addressBookRef, &error);
    });
}
-(void)deletePersons:(NSArray *)personArr
{
    if (personArr.count > 0) {
        for (NSValue *item in personArr) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                ABRecordRef record = item.pointerValue;
                ABAddressBookRemoveRecord(addressBookRef, record, nil);
                CFErrorRef error;
                ABAddressBookSave(addressBookRef, &error);
            });
        }
    }
}
-(void)deletePersonsInDic:(NSArray *)personArr
{
    if (personArr.count > 0) {
        for (NSDictionary *item in personArr) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                ABRecordRef record = ((NSValue *)item[keyPointer]).pointerValue;
                ABAddressBookRemoveRecord(addressBookRef, record, nil);
                CFErrorRef error;
                ABAddressBookSave(addressBookRef, &error);
            });
        }
    }
}
-(void)mergePersons:(NSArray *)personArr
{
    ABRecordRef record = [ABRecordHelper mergedPersonFromPersons:personArr];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        CFErrorRef error;
        ABAddressBookAddRecord(addressBookRef, record, &error);
        ABAddressBookSave(addressBookRef, &error);
    });
    
    for (NSDictionary *item in personArr) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            ABRecordRef record = ((NSValue *)item[keyPointer]).pointerValue;
            ABAddressBookRemoveRecord(addressBookRef, record, nil);
            CFErrorRef error;
            ABAddressBookSave(addressBookRef, &error);
        });
    }
    
}

-(void)setPersonName:(NSString *)personName toPerson:(ABRecordRef)record
{
    ABRecordSetValue(record, kABPersonOrganizationProperty, (__bridge CFTypeRef)(personName), nil);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        CFErrorRef err;
        ABAddressBookSave(addressBookRef, &err);
    });
}

-(NSArray *)localGroup
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {

        // 经常出现闪退的地方
        
        @synchronized(self) {
            
            @try {
                // 经常出现闪退的地方,很有可能是多线程原因
                CFArrayRef arr = ABAddressBookCopyArrayOfAllGroups(addressBookRef);
                
                NSMutableArray *groupArr = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(arr)];
                for (int i=0; i<CFArrayGetCount(arr); i++) {
                    ABRecordRef record = CFArrayGetValueAtIndex(arr, i);
                    [groupArr addObject:[NSValue valueWithPointer:record]];
                }
                return groupArr;
            }
            @catch (NSException *exception) {
//                NSLog(@"local exception %@",exception);
            }
            @finally {
                
            }
        }
        
    }
    
    return nil;
}

-(NSArray *)sortedLocalGroup
{
    NSArray *localGroup = [self localGroup];
    if (localGroup.count == 0) {
        return nil;
    }
    
    NSMutableArray *groupSortedArr = [NSMutableArray arrayWithCapacity:localGroup.count];
    
    for (int i=0; i < localGroup.count; i++) {
        NSValue *value = localGroup[i];
        ABRecordRef record = (ABRecordRef)[value pointerValue];
        NSString *name = [ABRecordHelper nameOfGroup:record];
        
        NSString *pinyinName = [ChineseToPinyin translatePinyinFromString:name];
        if ([pinyinName isEqualToString:@""] || pinyinName == nil) {
            pinyinName = @"#";
        }
        NSDictionary *dic = @{keyPointer: value,ZYkeyName:pinyinName};
        [groupSortedArr addObject:dic];
    }
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:ZYkeyName ascending:YES];
    [groupSortedArr sortUsingDescriptors:@[sortDes]];
    
    NSInteger speLetterBeforeACount = 0;
    NSInteger speLetterAfterZCount = 0;
    for (int i=0; i < groupSortedArr.count; i++) {
        NSDictionary *dic = groupSortedArr[i];
        NSInteger position = [dic[ZYkeyName] characterAtIndex:0] - 'A';
        if (position < 0) {
            speLetterBeforeACount ++;
        }else if (position >= 26){
            speLetterAfterZCount ++;
        }
    }
    NSArray *subArr = [groupSortedArr subarrayWithRange:NSMakeRange(0, speLetterBeforeACount)];
    if (subArr.count > 0) {
        for (int i=0; i<subArr.count; i++) {
            [groupSortedArr insertObject:subArr[i] atIndex:groupSortedArr.count-speLetterAfterZCount];
        }
        [groupSortedArr removeObjectsInRange:NSMakeRange(0, speLetterBeforeACount)];
    }
    
    return groupSortedArr;
}

-(void)addNewGroupWithName:(NSString *)groupName members:(NSArray *)members
{
    ABRecordRef group = ABGroupCreate(); // 关于新建群组，必须先把ABRecordRef类型的group保存了，才能在给这个group增加成员,同样要增加的成员必须是以保存在通讯录里面的联系人
    
    [self setGroupName:groupName toGroup:group];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        CFErrorRef error;
        ABAddressBookAddRecord(addressBookRef, group, &error);
        ABAddressBookSave(addressBookRef, &error);
        
        [self addMembers:members toGroup:group];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            CFErrorRef error;
            ABAddressBookAddRecord(addressBookRef, group, &error);
            ABAddressBookSave(addressBookRef, &error);
        });
        
    });
}

-(void)removeGroup:(ABRecordRef)record
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        CFErrorRef error;
        ABAddressBookRemoveRecord(addressBookRef, record, &error);
        ABAddressBookSave(addressBookRef, &error);
    });
}

-(void)setGroupName:(NSString *)groupName toGroup:(ABRecordRef)group
{
    ABRecordSetValue(group, kABGroupNameProperty, (__bridge CFTypeRef)(groupName), nil);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        CFErrorRef err;
        ABAddressBookSave(addressBookRef, &err);
    });
}

-(void)addMember:(ABRecordRef)toAddPerson toGroup:(ABRecordRef)group
{
    CFErrorRef error;
    ABGroupAddMember(group, toAddPerson, &error);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        CFErrorRef err;
        ABAddressBookSave(addressBookRef, &err);
    });
}

-(void)addMembers:(NSArray *)members toGroup:(ABRecordRef)group
{
    for (NSDictionary *item in members) {
        NSValue *value = item[keyPointer];
        ABRecordRef record = value.pointerValue;
        [self addMember:record toGroup:group];
    }
}

-(void)removeMember:(ABRecordRef)toRemovePerson fromGroup:(ABRecordRef)group
{
    CFErrorRef error;
    ABGroupRemoveMember(group, toRemovePerson, &error);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        CFErrorRef err;
        ABAddressBookSave(addressBookRef, &err);
    });
}

-(void)removeMembers:(NSArray *)members fromGroup:(ABRecordRef)group
{
    for (NSDictionary *item in members) {
        NSValue *value = item[keyPointer];
        ABRecordRef record = value.pointerValue;
        [self removeMember:record fromGroup:group];
    }
}

@end
