
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

// 通讯录参考资料  http://blog.sina.com.cn/s/blog_71715bf801019oy8.html

@interface AddressBookHandle : NSObject
{
    ABAddressBookRef addressBookRef;
    ABRecordRef personRecordRef;
    ABRecordRef groupRecordRef;
}

+(AddressBookHandle *)sharedAddressBook;

-(ABAddressBookRef)addressBookRef;

+(BOOL)isContactPermission;

-(void)initAddressBook;

// person

-(NSArray *)localContact;

-(NSArray *)sortedLocalContact;

-(void)addPerson:(ABRecordRef)record;

-(void)deletePersons:(NSArray *)personArr;
-(void)deletePersonsInDic:(NSArray *)personArr;

-(void)mergePersons:(NSArray *)personArr;

-(void)setPersonName:(NSString *)personName toPerson:(ABRecordRef)record;


#pragma mark 根据排完续的数组设置到模型中属性
- (NSArray *)getContactInfos;

// group

-(NSArray *)localGroup;
-(NSArray *)sortedLocalGroup;

-(void)addNewGroupWithName:(NSString *)groupName members:(NSArray *)members;

-(void)removeGroup:(ABRecordRef)record;

-(void)setGroupName:(NSString *)groupName toGroup:(ABRecordRef)group;

-(void)addMember:(ABRecordRef)toAddPerson toGroup:(ABRecordRef)group;
-(void)addMembers:(NSArray *)members toGroup:(ABRecordRef)group;

-(void)removeMember:(ABRecordRef)toRemovePerson fromGroup:(ABRecordRef)group;
-(void)removeMembers:(NSArray *)members fromGroup:(ABRecordRef)group;

@end
