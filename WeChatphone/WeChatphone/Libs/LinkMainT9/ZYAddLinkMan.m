//
//  ZYAddLinkMan.m
//  YouKeApp
//
//  Created by BBC on 15/8/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ZYAddLinkMan.h"

static ZYAddLinkMan * static_ZYAddLinkMan ;

@implementation ZYAddLinkMan
{
    UIViewController * navcontroller ;
}

+(ZYAddLinkMan *)shareAddlinkMan
{
     @synchronized(self)
    {
        if (static_ZYAddLinkMan == nil) {
            static_ZYAddLinkMan = [[ZYAddLinkMan alloc]init];
        }
    }
    return static_ZYAddLinkMan ;
} 

-(void)addNewContactWithPhone:(NSString *)phoneNum rootViewController:(UIViewController *)addLinkManController
{
    if (nil == addLinkManController) {
        return ;
    }

    navcontroller = addLinkManController ;

    NSString * phoneNumber = phoneNum ? [NSString stringWithFormat:@"%@",phoneNum] : @"";
    ABRecordRef aContact = ABPersonCreate();
    CFErrorRef anError = NULL;
    ABMutableMultiValueRef phoneLabe = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneLabe,(__bridge CFStringRef)phoneNumber, kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(aContact, kABPersonPhoneProperty, phoneLabe, &anError);

    self.myNewController = [[ABNewPersonViewController alloc] init];
    self.myNewController.newPersonViewDelegate = self;
    self.myNewController.displayedPerson = aContact;

    UINavigationController *aNav = [[UINavigationController alloc] initWithRootViewController:self.myNewController];
#if TARGET_IPHONE_SIMULATOR
#else
//    [ContactManager shareInstance].canLoadData = NO;
#endif
    [addLinkManController  presentViewController:aNav animated:YES completion:NULL];

}
 
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    NSLog(@"添加或者取消   ------ -    %@",person);
    //新建联系人，刷新
    if (person!=nil) {
         NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
        NSNotification * notify=[[NSNotification alloc]initWithName:@"AddNewLinkMan" object:self userInfo:nil];
        [center postNotification:notify];
    }
    //    [ContactManager shareInstance].canLoadData = YES;

    self.myNewController.newPersonViewDelegate = nil;
    [newPersonView.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


@end
