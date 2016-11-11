//
//  BBFmdbTool.m
//  123
//
//  Created by T on 15/4/16.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import "BBFmdbTool.h"
#import "BBContact.h"
#import "BBContactName.h"
#import "BBContactEmail.h"
#import "BBContactAddress.h"
#import "BBContactIm.h"  
#import "BBContactPhoneNumber.h"
#import "BBContactUrl.h"
#import "BBContactOrganization.h"
//#import "ns"
#import "NSObject+MJKeyValue.h"

#define BBContactDatabase @"BBContactDatabase.sqlite"

@implementation BBFmdbTool

+ (instancetype)shareFmdbTool{
     
        static BBFmdbTool *tools = nil;
    
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tools = [[BBFmdbTool alloc] init];
        });
    return tools;
}

static FMDatabase *_fmdb;
+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:BBContactDatabase];
    
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    if ([_fmdb open]) {
        
        NSLog(@"打开数据库成功");
        // 创建表

     BOOL success1 =  [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS bbx_contact("
         "id INTEGER PRIMARY KEY,"
         "uuid varchar(255),"
         "displayName varchar(255),"
         "name text,"
         "nickname varchar(255),"
//         "nameRemark varchar(255),"
         "phoneNumbers text,"
         "emails text ,"
         "addresses text ,"
         "ims text ,"
         "organizations varchar(255) ,"
         "birthday datetime,"
         "note text,"
         "photo text,"
         "urls text"
         ");"];
        
        NSString *SQL2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS bbx_tel(id INTEGER PRIMARY KEY,class_id INTEGER,tel text,foreign key (class_id) references bbx_contact(id) on delete cascade on update cascade)"];
        BOOL success2 = [_fmdb executeUpdate:SQL2];

        
        if (success1 && success2) {
            NSLog(@"创建表成功");
        } else{
            NSLog(@"创建表失败");
        }

    }
}
 

-(BOOL)deleContactWithPhoneNum:(NSString *)phone WithName:(NSString *)name
{
    NSString * deleteSql = [NSString stringWithFormat:@"delete from bbx_contact where phoneNumbers = %@",phone];

    return [_fmdb executeUpdate:deleteSql];
}
  
-(BOOL)deleteAllFromTable
{
    NSString * deleteSql = [NSString stringWithFormat:@"delete from bbx_contact"];
  
    return [_fmdb executeUpdate:deleteSql];
}


 
- (BOOL)insertContact:(NSString *)uuid displayName:(NSString *)displayName contactName:(NSString *)contactName nickname:(NSString *)nickname  phoneNumbers:(NSString *)phoneNumbers emails:(NSString *)emails contactAddress:(NSString *)contactAddress ims:(NSString *)ims contactOrganization:(NSString *)contactOrganization birthday:(NSString *)birthday note:(NSString *)note photo:(NSString *)photo urls:(NSString *)urls{
 
 
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO bbx_contact(uuid, displayName, name, nickname, phoneNumbers, emails, addresses, ims, organizations, birthday, note, photo, urls) VALUES ('%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", uuid, displayName,contactName,nickname, phoneNumbers, emails, contactAddress, ims, contactOrganization, birthday, note, photo, urls];
    

    return [_fmdb executeUpdate:insertSql];
}

- (BOOL)insertTel:(NSString *)tel classid:(int)classid{
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO bbx_tel(class_id, tel) VALUES ('%d', '%@')", classid, tel];

    return [_fmdb executeUpdate:insertSql];
}

- (NSArray *)QueryDatabase{
    
    NSString *querySql = @"SELECT * FROM bbx_contact";
    FMResultSet *set = nil;
    NSMutableArray *contacts = [NSMutableArray array];
    set = [_fmdb executeQuery:querySql];
    while ([set next]) {
        
        // uuid
        BBContact *contact = [[BBContact alloc] init];
        NSData *uuid = [set dataForColumn:@"uuid"];
        NSString *uuidStr = [[NSString alloc] initWithData:uuid encoding:NSUTF8StringEncoding];
        contact.uuid = uuidStr;
        
         
        // displayName
        NSData *displayName = [set dataForColumn:@"displayName"];
        NSString *displayNameStr = [[NSString alloc] initWithData:displayName encoding:NSUTF8StringEncoding];
        contact.displayName = displayNameStr;
        
        
        // name
//        BBContactName *contactName = [[BBContactName alloc] init];
        NSData *name = [set dataForColumn:@"name"];
//        NSDictionary *dicName = [NSJSONSerialization JSONObjectWithData:name options:0 error:NULL];
        BBContactName *contactName = [BBContactName objectWithJSONData:name];
        contact.contactName = contactName;
        
        // nickname
        NSData *nickname = [set dataForColumn:@"nickname"];
        NSString *nicknameStr = [[NSString alloc] initWithData:nickname encoding:NSUTF8StringEncoding];
        contact.nickname = nicknameStr;
        
        // nameRemark
//        NSData *nameRemark = [set dataForColumn:@"nameRemark"];
//        NSString *nameRemarkStr = [[NSString alloc] initWithData:nameRemark encoding:NSUTF8StringEncoding];
//        contact.nameRemark = nameRemarkStr;

        //phoneNumbers
        NSMutableArray *phones = [NSMutableArray array];
        NSData *phoneNumbers = [set dataForColumn:@"phoneNumbers"];
        NSArray *phoneNumberArray = [NSJSONSerialization JSONObjectWithData:phoneNumbers options:0 error:NULL];
        for (NSDictionary *dic in phoneNumberArray) {
            
            BBContactPhoneNumber *contactPhone = [BBContactPhoneNumber objectWithKeyValues:dic];
            [phones addObject:contactPhone];
        }
        contact.phoneNumbers = phones;
        
        //emails
        NSMutableArray *emails = [NSMutableArray array];
        NSData *emailsNumbers = [set dataForColumn:@"emails"];
        NSArray *emailsNumberArray = [NSJSONSerialization JSONObjectWithData:emailsNumbers options:0 error:NULL];
        for (NSDictionary *dic in emailsNumberArray) {
            
            BBContactEmail *contactEmail = [BBContactEmail objectWithKeyValues:dic];
            [emails addObject:contactEmail];
        }
        contact.emails = phones;
        
        //addresses
        NSMutableArray *addresses = [NSMutableArray array];
        NSData *addressesNumbers = [set dataForColumn:@"addresses"];
        NSArray *addressesNumberArray = [NSJSONSerialization JSONObjectWithData:addressesNumbers options:0 error:NULL];
        for (NSDictionary *dic in addressesNumberArray) {
            
            BBContactAddress *contactAddress = [BBContactAddress objectWithKeyValues:dic];
            [addresses addObject:contactAddress];
        }
        contact.contactAddress = addresses;
        
        // ims
        NSMutableArray *ims = [NSMutableArray array];
        NSData *imsNumbers = [set dataForColumn:@"ims"];
        NSArray *imsNumberArray = [NSJSONSerialization JSONObjectWithData:imsNumbers options:0 error:NULL];
        for (NSDictionary *dic in imsNumberArray) {
            
            BBContactIm *contactIm = [BBContactIm objectWithKeyValues:dic];
            [ims addObject:contactIm];
        }
        contact.contactAddress = ims;
        
        // organizations
        NSData *organizations = [set dataForColumn:@"organizations"];
        BBContactOrganization *contacorganization = [BBContactOrganization objectWithJSONData:organizations];
        contact.contactOrganization = contacorganization;
        
        // birthday
        NSData *birthday = [set dataForColumn:@"birthday"];
        NSString *birthdayStr = [[NSString alloc] initWithData:birthday encoding:NSUTF8StringEncoding];
        contact.birthday = birthdayStr;
        
        // note
        NSData *note = [set dataForColumn:@"note"];
        NSString *noteStr = [[NSString alloc] initWithData:note encoding:NSUTF8StringEncoding];
        contact.note = noteStr;
        
        
        // photo
        NSData *photo = [set dataForColumn:@"photo"];
        NSString *photoStr = [[NSString alloc] initWithData:photo encoding:NSUTF8StringEncoding];
        contact.photo = photoStr;
        
        //urls
        NSMutableArray *urls = [NSMutableArray array];
        NSData *urlsNumbers = [set dataForColumn:@"urls"];
        NSArray *urlsNumberArray = [NSJSONSerialization JSONObjectWithData:urlsNumbers options:0 error:NULL];
        for (NSDictionary *dic in urlsNumberArray) {
            
            BBContactUrl *contacturls = [BBContactUrl objectWithKeyValues:dic];
            [urls addObject:contacturls];
        }
        contact.urls = urls;
        
        [contacts addObject:contact];
    }
    return contacts;
}

@end
