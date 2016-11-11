//
//  ZYLinkManController.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYLinkManController.h"
#import "Header.h"
#import "T9Prompter.h"
#import "LinkManAddressBook.h"
#import "CHAddressEngine.h" 
#import "ZYTelCell.h"
#import "ZYLinkManSingleton.h"
#import "UIBarButtonItem+CH.h"
#import <AddressBook/AddressBook.h>
 #import <AddressBookUI/AddressBookUI.h>
#import "CallTwoViewController.h"
#import "ZYGetBaseData.h"
#import "XYNavigationMenu.h"
#import "ZYPhoneAction.h"
#import "ZYSavemanger.h"
@interface ZYLinkManController ()<ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource ,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,LXActionSheetDelegate,UIAlertViewDelegate>
{
     ABPeoplePickerNavigationController *_abPeoplePickerVc;
    NSDictionary * _dic;
    UITableView     * _tableView2;
    NSMutableArray  * _linkManMutableArray ;
    NSMutableArray  * _resultArray ;
    NSMutableArray  * _nameMutablearray;
    NSMutableArray  * _pinyinArray;
}
@property(nonatomic,assign)      int  collectionSelectIndex;
@property(nonatomic ,assign)     id   delegate ;
@property(nonatomic,copy)        NSString * selectName;
@property(nonatomic,copy)        NSString * selectPhone;
@property(nonatomic,retain)      NSMutableArray * firstCharacterArray ;
@property (nonatomic,strong) XYNavigationMenu * menu;
@end
 
@implementation ZYLinkManController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.title = @"联系人";

    self.view.backgroundColor=[UIColor whiteColor];
    _linkManMutableArray = [NSMutableArray array];
    _resultArray         = [NSMutableArray array];
    _nameMutablearray    = [NSMutableArray array];

    [self getLinkManAddreddISRefresh:NO];

    [self setTableview];
    [self AddSearchBar];

    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem itemWithIcon:@"icon_add_Linkman" highIcon:@"icon_add_Linkman" target:self action:@selector(rigthButtonClick)];

 
    //做一个通知 ， 更新数据
    //接收通知
    NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotification:) name:@"AddressBookChange" object:nil];
}

-(void)receiveNotification:(NSNotification*)notify
{
    NSLog(@"接收到通知 ， 更新界面");
    [self getLinkManAddreddISRefresh:YES];
}

-(void)setTableview
{
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40, VIEW_With, VIEW_Hight-64-49-40) style:UITableViewStylePlain];
    _tableView2.delegate   = self;
    _tableView2.dataSource = self;
    _tableView2.tag        = 500;
    [self.view addSubview:_tableView2];
    _tableView2.tableFooterView = [[UIView alloc]init];

    [_tableView2 registerNib:[UINib nibWithNibName:@"ZYTelCell" bundle:nil] forCellReuseIdentifier:@"ZYTelCell"];
}
 
 
#pragma mark  导入联系人
  
-(void)getLinkManAddreddISRefresh:(BOOL)isRefsh
{ 
    [GCDQueue executeInGlobalQueue:^{

        ZYLinkManSingleton * singleton = [ZYLinkManSingleton defaultSingletonISRefresh:isRefsh];
 
        _linkManMutableArray = singleton.peoples;
 
        [GCDQueue executeInMainQueue:^{
            if (_linkManMutableArray == nil ) {
//                SHOW_ALERT(@"请在设置里允许‘友客’获取通讯录");
            }
            UISearchBar * searchbar = (UISearchBar *)[self.view viewWithTag:30000];
            searchbar.placeholder = [NSString stringWithFormat:@"%lu 个联系人",(unsigned long)_linkManMutableArray.count];

            [self addlinkManAddressbookISResh:isRefsh];
        }];

    }]; 

} 
 
#pragma mark ---- 数组对象

-(void)addlinkManAddressbookISResh:(BOOL)isResh
{
//    NSLog(@"联系人  %lu",(unsigned long)_linkManMutableArray.count);

    [GCDQueue executeInGlobalQueue:^{

        if (isResh) {

            _dic=[T9Prompter pinYinZhuanHuaWithDataArray:_linkManMutableArray WithNameArray:nil];
            //保存数据
            [ZYSavemanger saveLocationDataSaveWithDict:_dic];
        }else
        {
            // 读取缓存
            _dic =  [ZYSavemanger getLocationData];

            if (!_dic && _linkManMutableArray.count>0) {
                _dic=[T9Prompter pinYinZhuanHuaWithDataArray:_linkManMutableArray WithNameArray:nil];
                //保存数据
                [ZYSavemanger saveLocationDataSaveWithDict:_dic];
            }

        }
 
        self.firstCharacterArray = [NSMutableArray arrayWithArray:[_dic allKeys]];
        self.firstCharacterArray = (NSMutableArray *)[_firstCharacterArray sortedArrayUsingSelector:@selector(compare:)];

        [GCDQueue executeInMainQueue:^{
                [_tableView2 reloadData];
        }];

        [self pinyinArray];
        NSMutableArray * resultArray=[LinkManAddressBook LinkMainWithMutablearrayWithDataArray:_linkManMutableArray];
        _nameMutablearray        = resultArray[1];
    }];

}
 
 

-(void)pinyinArray
{
    _pinyinArray=[NSMutableArray array];
    _pinyinArray=[T9Prompter pinYinZhuanHuaWithNameArray:_nameMutablearray];
}
#pragma mark 表的协议方法 - 构建单元格

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==500){
    return [_firstCharacterArray objectAtIndex:section];
    }else{
     return @"#";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==500)
    {
        return [[_dic objectForKey:[_firstCharacterArray objectAtIndex:section]] count];
    }else
    {
        return _resultArray.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==500)
    {
        return _firstCharacterArray.count;
    }else
    {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in _firstCharacterArray)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;

}  
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYTelCell * teleCell = [tableView dequeueReusableCellWithIdentifier:@"ZYTelCell" forIndexPath:indexPath];
    People * p  = nil;

    if (tableView.tag==500)
    {
        p = [[_dic objectForKey:[_firstCharacterArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }else
    {
        p = [_resultArray objectAtIndex:indexPath.row];
    }

    [teleCell upDataCellWithPeople:p WithIndex:indexPath];
    return teleCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    People * p = nil;

    if (tableView.tag == 500)
    {
       p= [[_dic objectForKey:[_firstCharacterArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }else
    {
        if (_resultArray.count>indexPath.row) {
         p = _resultArray[indexPath.row];
        }
    }
    self.selectName = p.name;
    self.selectPhone = p.phoneNum;

    [self upMessage];
}

  
-(void)upMessage
{
    NSArray * titleSArray=@[@"软件拨打",@"系统拨打"];
    LXActionSheet * acction=[[LXActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titleSArray];
    [acction showInView:self.view];
}

-(void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    if ((int)buttonIndex==0) {
        CallTwoViewController * callVC = [[CallTwoViewController alloc]init];
        callVC.phoneNumber = self.selectPhone ;
        callVC.calledName = self.selectName;
        [self presentViewController:callVC animated:YES completion:nil];

    }else if ((int)buttonIndex==1){
        NSString * str=[NSString stringWithFormat:@"tel://%@",self.selectPhone];
        NSURL * myUrl=[NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:myUrl];
    }
}
 
#pragma mark  查询联系人

-(void)AddSearchBar
{
    UISearchBar * _searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, VIEW_With, 40)];
    _searchbar.searchResultsButtonSelected=YES;
    _searchbar.delegate=self;
    _searchbar.tag = 30000;
    [self.view addSubview:_searchbar];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (_tableView2.tag == 500 ) {

        [_tableView2 reloadData];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length==0)
    {
        [self.view endEditing: YES];
        _tableView2.tag = 500;
 
    }else
    {
        searchText=[searchText lowercaseString];
        //先判断是字母还是文字
        BOOL rect1=[CHAddressEngine isValidateTelNumber:searchText];
        if (rect1) {
            //是纯数字
            _resultArray=[T9Prompter numberSearchResultWithNmaeMutableArray:_nameMutablearray WithSearchText:searchText];
        }else
        {
            _resultArray    = [T9Prompter selectResultwithPinYinResult:_pinyinArray WithSearchText:searchText WithNameArray:_nameMutablearray];
        }
        _tableView2.tag = 501;
    }
    [_tableView2 reloadData];

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark    _tableView2.tag=500是联系人状态，501 是搜索状态
#pragma mark ---右侧搜索字母
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
    for(char c = 'A';c<='Z';c++)
        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    
    return toBeReturned;
}


#pragma mark --- 下拉菜单
-(void)rigthButtonClick
{
    if (self.menu.isOpen) {
        [self.menu dismiss];
    } else {
        [self.menu showInNavigationController:self.navigationController didTapBlock:^(UIButton *button) {
            if ((long)button.tag == 0) {
                UIAlertView * alterview = [[UIAlertView alloc]initWithTitle:@"添加联系人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alterview.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                UITextField * nameTextField = [alterview textFieldAtIndex:0];
                nameTextField.placeholder = @"姓名:";
                UITextField * phoneTextField = [alterview textFieldAtIndex:1];
                phoneTextField.secureTextEntry = NO;
                phoneTextField.placeholder =  @"电话号码";
                phoneTextField.keyboardType = UIKeyboardTypeNumberPad;

                [alterview show];
            }else{
                //同步到服务器

                [HttpEngine upLoadAddressBookWithArrays:_linkManMutableArray WithObject:self Complate:^(NSDictionary *responseDic) {

                }];
            }
        }];
    }
} 
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField * nameTextField =  [alertView textFieldAtIndex:0];
        UITextField * phoneTextField =[alertView textFieldAtIndex:1];
        NSLog(@"nameTextField: %@    phoneTextField:%@",nameTextField.text,phoneTextField.text);
 
        //添加到通讯录

        if (nameTextField.text.length > 0 && phoneTextField.text.length > 6) {

            [ZYPhoneAction addWithName:nameTextField.text withPhoneNum:phoneTextField.text];
        }else{
            [LSFMessageHint showToolMessage:@"输入正确格式！！！" hideAfter:2.0 yOffset:0];
        }

    }
    
}





#pragma mark - getter and setter
- (XYNavigationMenu *)menu {
    if (!_menu ) {

        NSMutableArray * mutablearray = [NSMutableArray array];

        NSArray * titles = @[@"添加联系人",@"同步通讯录"];
        for (NSString * text in titles) {

            XYMenuButton *button1 = [[XYMenuButton alloc] initWithTitle:text buttonIcon:[UIImage imageNamed:@""]];

            [mutablearray addObject:button1];
        }

        _menu = [[XYNavigationMenu alloc] initWithItems:mutablearray];

    }
    return _menu;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
 
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick  beginLogPageView:@"ZYLinkManController.m"];
}
 
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"ZYLinkManController.m"];
}

@end
