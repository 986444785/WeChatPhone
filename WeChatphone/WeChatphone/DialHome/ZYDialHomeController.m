//
//  ZYDialHomeController.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYDialHomeController.h"
#import "ChineseToPinyin.h"
#import "PrefixHeader.pch"
#import "DealWithDataBases.h"
#import "GuiShuDiDB.h"
#import "SearchCoreManager.h"
#import "BBContact.h"
#import "BBContactPhoneNumber.h" 
#import "CHAddressEngine.h"
#import "CallTwoViewController.h"
#import "ZYTelephoneCell.h"
#import "ZYTitleView.h"
#import "ZYLinkManSingleton.h"
#import "ZYGetBaseData.h"

#import "TipAlertView.h"
#import "ZYAboutToken.h"

#define KDailSearchFunction @"22233344455566677778889999"

@interface ZYDialHomeController ()<UITabBarControllerDelegate,UIAlertViewDelegate>
{
    UIView *    bottonView; 
    NSString *  textLength;
    NSMutableArray *contactSortedArr;
    NSMutableArray *eachLetterNumArr;
    T9SearchStatus _searchStatus;
    BOOL    isEdit;
}
@property (nonatomic, strong) NSArray             *contactArray;
@property (nonatomic, strong) UITableView         *tableview;
@property (nonatomic, strong) NSMutableArray      *searchByPhone;
@property (nonatomic, strong) NSMutableArray      *searchByName;
@property (nonatomic, strong) NSMutableDictionary *contactDic;
@property (nonatomic,strong)  ZYTitleView * titleView;
@end
 
@implementation ZYDialHomeController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callCahngeTable" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
 
    _lastSelectTabbarIndex = 0;
    //创建通话记录表单
    [DealWithDataBases createTableAboutSqlite];

    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, VIEW_With, VIEW_Hight-49-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]init];
    //////////添加第二张表格
 
    [_tableview registerNib:[UINib nibWithNibName:@"ZYTelephoneCell" bundle:nil] forCellReuseIdentifier:@"ZYTelephoneCell"];

        
    self.tabBarController.delegate = self;

    self.contactDic = [[NSMutableDictionary alloc] init];
    self.searchByName = [[NSMutableArray alloc] init];
    self.searchByPhone = [[NSMutableArray alloc] init];

    [self addKeyBoard];

    [self setTitle];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (! [ZYGetBaseData getBaseData]) {
            dispatch_sync(dispatch_get_main_queue(), ^
                          {
                              [self alterviewNotice];
                          });
        }

        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [self refreshData];

                          [self addData];
 
                      });
    });
 
    //接收通知
    NSNotificationCenter * center2=[NSNotificationCenter defaultCenter];
    [center2 addObserver:self selector:@selector(receiveNotification:) name:@"callCahngeTable" object:nil];
    [self receiveNotification:nil];

#pragma mark ---- 这个暂时先不显示 --- 有用
//    [ZYAboutToken  unLinkWithWXwebviewWithObject:self];
}
 

-(void)alterviewNotice
{
    UIAlertView * alterView =[[UIAlertView alloc]initWithTitle:@"无法显示联系人" message:@"前往设置允许访问您的通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:  nil];
    [alterView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [HttpEngine systemSetting];
}


-(void)setTitle
{
    self.titleView= [[ZYTitleView alloc]initWithFrame:CGRectMake(0, 0, VIEW_With, 44)];
    self.navigationItem.titleView = _titleView;

    __weak ZYDialHomeController * vc = self;
    _titleView.editButtonClick = ^(NSString *str){
        //编辑按钮点击
        [vc editAction];
    };
}

-(void)editAction
{
    isEdit = !isEdit;
    if (isEdit) {
        [_tableview setEditing:YES animated:YES];
    }else{
        [_tableview setEditing:NO animated:YES];
    }
    [self.titleView titleChangeWithText:nil WithEdit:isEdit titleHiden:NO];
}


-(void)showNothingView:(BOOL)show
{
    NothingNoticeView * nothingView  = (NothingNoticeView *)[self.view viewWithTag:999];
    if (show) {
        nothingView.alpha = 1.0;
        _tableview.alpha = 0.0;
    }else{
        nothingView.alpha = 0.0;
        _tableview.alpha = 1.0;
    }
}
  

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }

}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    int customSelectindex = (int)tabBarController.selectedIndex;
    if (customSelectindex ==0  && _lastSelectTabbarIndex == 0){
        if (bottonView.frame.origin.y==VIEW_Hight ){
            [UIView beginAnimations:nil context:nil];
            [UIView animateWithDuration:0.5 animations:^{
                bottonView.frame = CGRectMake(0, VIEW_Hight-bottonView.frame.size.height, VIEW_With, bottonView.frame.size.height);
                } completion:^(BOOL finished) { 
                    if (textLength.length>0){
                        [TabbarShowHiden tabbarHidenWithdelegate:self];
                    }
                }];
                [UIView commitAnimations];
            }else{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                bottonView.frame = CGRectMake(0, VIEW_Hight, VIEW_With, bottonView.frame.size.height);
                [UIView commitAnimations];
            }
    }else if (customSelectindex == 0 && textLength.length>0){
        bottonView.frame = CGRectMake(0, VIEW_Hight-bottonView.frame.size.height, VIEW_With, bottonView.frame.size.height);
        [TabbarShowHiden tabbarHidenWithdelegate:self];
    }
    _lastSelectTabbarIndex = customSelectindex;
}
 
-(void)addData
{
    //添加到搜索库
    NSArray  *contacts = [[BBFmdbTool shareFmdbTool] QueryDatabase];

    for (int i = 0; i<contacts.count; i++) {
 
        BBContact *contact = contacts[i];
        NSMutableArray *phoneArray = [NSMutableArray array];
        NSArray *phones = contact.phoneNumbers;
        for (BBContactPhoneNumber *phone in phones) {
            [phoneArray addObject:phone.value];
        }
        contact.localID = [NSNumber numberWithInt:i];
        [[SearchCoreManager share] AddContact:contact.localID name:contact.displayName phone:phoneArray];
        [self.contactDic setObject:contact forKey:contact.localID];
    }
}

-(void)receiveNotification:(NSNotification*)notify
{
    _callHistoryArray=[NSMutableArray arrayWithArray:[DealWithDataBases selectTableAboutCollection]];
    _tableState = 0;

    if (_callHistoryArray.count<1) {

            [self.titleView titleChangeWithText:nil WithEdit:NO titleHiden:YES];
    }

    [_tableview reloadData]; 
    [TabbarShowHiden tabbarShowWithdelegate:self];
}
   
 
#pragma mark 表的协议方法 - 构建单元格
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableState==0) {
        if (_callHistoryArray.count < 1) {
            return 1;
        }
        return _callHistoryArray.count;
    }
    return [self.searchByName count] + [self.searchByPhone count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableState == 0 && _callHistoryArray.count == 0) {
        return VIEW_With*1.00/1.5;
    }
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_tableState==0 )
    { 
        if (_callHistoryArray.count == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                UIImageView *        imageView0 = [[UIImageView alloc]init];

                imageView0.frame  =  CGRectMake(0, 0, VIEW_With,  VIEW_With*1.00/1.5);

                imageView0.image = [UIImage imageNamed:@"img_noHistory"];
                
                [cell.contentView addSubview:imageView0];

            }
 
            [_tableview setEditing:NO animated:YES];
            [self.titleView titleChangeWithText:nil WithEdit:NO titleHiden:YES];
            cell.contentView.backgroundColor = [UIColor grayColor];
            return cell;

        }else{ 
            ZYTelephoneCell * telCell  = [tableView dequeueReusableCellWithIdentifier:@"ZYTelephoneCell" forIndexPath:indexPath];
            People * p=_callHistoryArray[indexPath.row];

            [telCell updataCellWithPeople:p];
                    return telCell;
        }
    }else{
            ZYTelephoneCell * telCell  = [tableView dequeueReusableCellWithIdentifier:@"ZYTelephoneCell" forIndexPath:indexPath];
        People * p = [self getPeopleWithIndex:indexPath didSelect:NO];
        [telCell updataCellWithPeople:p];
        return telCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableState == 0 && _callHistoryArray.count == 0) {
        return ;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_tableState==0) {

        People * p=_callHistoryArray[indexPath.row];
        self.selectIndexName = p.name;
        self.selectIndexPhoneNum = p.phoneNum;
    }else{

        [self getPeopleWithIndex:indexPath didSelect:YES];
    }
        [self upMessage];

}


#pragma mark --
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && _callHistoryArray.count > indexPath.row) {
        People * p=_callHistoryArray[indexPath.row];
        self.selectIndexPhoneNum = p.phoneNum;
        [self deleteCallHistory];
    }
}

-(void)upMessage
{
    NSArray * titleSArray=@[@"软件拨打",@"系统拨打"];
    LXActionSheet * acction=[[LXActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titleSArray];
    [acction showInView:self.view];
}

#pragma mark -- 去拨打电话
-(void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    if ((int)buttonIndex==0) {
        textLength=nil;
        CallTwoViewController * callVC = [[CallTwoViewController alloc]init];
        callVC.phoneNumber = self.selectIndexPhoneNum ;
        callVC.calledName = self.selectIndexName;
        [self presentViewController:callVC animated:YES completion:nil];

    }else if ((int)buttonIndex==1){
        NSString * str=[NSString stringWithFormat:@"tel://%@",self.selectIndexPhoneNum];
        NSURL * myUrl=[NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:myUrl];
    }
}


-(People *)getPeopleWithIndex:(NSIndexPath *)indexPath didSelect:(BOOL)didSelect
{
    NSNumber *localID = nil;
    if (indexPath.row < [_searchByName count]) {
        localID = [self.searchByName objectAtIndex:indexPath.row];

    }else {
        localID = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
    }
    People * p = [[People alloc]init];
    BBContact *contact = self.contactDic[localID];
    if (contact.phoneNumbers.count>0) {
        BBContactPhoneNumber *phone = contact.phoneNumbers[0];
        p.phoneNum = phone.value;
    }
    p.name = contact.displayName;
    if (didSelect) {
        self.selectIndexName = p.name;
        self.selectIndexPhoneNum = p.phoneNum;
    }
    return p;
}

-(void)deleteCallHistory
{
    //删除这个记录
    [DealWithDataBases delateCollectPeopleWithPhoneNum:self.selectIndexPhoneNum];
    _callHistoryArray=[DealWithDataBases selectTableAboutCollection];
    [_tableview reloadData];
}
 
//从数据库中拿出通讯录
- (void)refreshData
{   
//    [GCDQueue executeInGlobalQueue:^{
        _contactArray = [[BBFmdbTool shareFmdbTool] QueryDatabase];


        NSLog(@"_contactArray   ----------------  %lu",(unsigned long)_contactArray.count);

        contactSortedArr = [[NSMutableArray alloc] initWithArray:self.contactArray];

        eachLetterNumArr = [[NSMutableArray alloc] initWithCapacity:27];
        for (int i=0; i<27; i++) {
            [eachLetterNumArr addObject:@(0)];
        }

        for (int i=0; i<contactSortedArr.count; i++) {
            BBContact *contact = contactSortedArr[i];

            NSString *contactName = contact.displayName;
            NSString *pinyinName = [ChineseToPinyin translatePinyinFromString:contactName];
            if ([pinyinName isEqualToString:@""] || pinyinName == nil) {
                pinyinName = @"#";
            }
            NSString *pinyin = pinyinName;
            NSInteger position = [pinyin characterAtIndex:0] - 'A';
            if(position >= 0 && position < 26 ){
                NSNumber *num = eachLetterNumArr[position];
                [eachLetterNumArr replaceObjectAtIndex:position withObject:@(num.intValue +1)];
            }else{
                NSNumber *num = eachLetterNumArr.lastObject;
                [eachLetterNumArr replaceObjectAtIndex:eachLetterNumArr.count-1 withObject:@(num.intValue +1)];
            }
        }

//        [ZYLinkManSingleton defaultSingletonISRefresh:NO];
//    }];
}

#pragma mark  添加键盘
-(void)addKeyBoard
{
    bottonView=[[UIView alloc]initWithFrame:CGRectMake(0, VIEW_Hight, VIEW_With, VIEW_Hight-64)];
    KeyBordView * keyVC=[[KeyBordView alloc]init];    //这里又调用了一次
    keyVC.Delegate = self;
    keyVC.ViewControl = self;
    bottonView=keyVC;
    __weak ZYDialHomeController * leVC = self;
    keyVC.changeClickSee=^(NSString *text){
        [leVC createSeeLianXiRen:text];

    };

    [self.view addSubview:bottonView];
}

#pragma mark  查询联系人
-(void)createSeeLianXiRen:(NSString *)text{

    [self titleChangeText:text];
    textLength= text ;
    if (text.length==0) {
        _tableState                 = 0;
    }else{
        [[SearchCoreManager share] SearchWithFunc:KDailSearchFunction searchText:text searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
        _tableState                 = 1;
    }
    [self.tableview reloadData];
}

#pragma mark----  上面的数字变化
-(void)titleChangeText:(NSString*)text
{
    if (isEdit) {
        [self editAction];
    }

    [self.titleView titleChangeWithText:text WithEdit:NO titleHiden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //隐藏键盘
    [self keyBoardDown];
}

-(void)keyBoardDown
{
    [TabbarShowHiden tabbarShowWithdelegate:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    bottonView.frame = CGRectMake(0, VIEW_Hight, VIEW_With, bottonView.frame.size.height);
    [UIView commitAnimations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick  beginLogPageView:@"ZYDialHomeController.m"];
}
 
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"ZYDialHomeController.m"];
}

@end
