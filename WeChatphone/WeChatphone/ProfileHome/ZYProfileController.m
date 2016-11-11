//
//  ZYProfileController.m
//  WeChatphone
//
//  Created by BBC on 16/4/18.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ZYProfileController.h"
#import "Header.h"
#import "ZYAvatarCell.h"
#import "ZYTileMenuView.h"
#import "RxWebViewController.h"

@interface ZYProfileController ()
@property(nonatomic,strong) UIView * menuView ;
@property(nonatomic,strong) UITableView * tableview;
@property(nonatomic,strong) NSDictionary * userinfoDic ;
@property(nonatomic,strong) NSArray * app_infos;
@end

@implementation ZYProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"我的";

    [self profileData];

    [self setTableview];

    [self getTestData];
}

#pragma mark --测试数据
-(void)getTestData
{
    
}



-(void)setTableview
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_With, VIEW_Hight) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"ZYAvatarCell" bundle:nil] forCellReuseIdentifier:@"ZYAvatarCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }

    if (self.app_infos.count>0) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.5;
    }
    return 15;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return _menuView.frame.size.height;
}
  

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZYAvatarCell * avaCell = [tableView dequeueReusableCellWithIdentifier:@"ZYAvatarCell" forIndexPath:indexPath];
        [avaCell upDataCellWith:self.userinfoDic];
        return avaCell;
    }

    UITableViewCell * menuCell = [tableView  dequeueReusableCellWithIdentifier:@"menuCell"];
    if (!menuCell) {
        menuCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
        menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [menuCell.contentView addSubview:_menuView];
    return menuCell;

} 
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    [self profileData];
}

#pragma mark --- 创建九宫格
-(void)createBottomWitharrays:(NSArray *)arrays
{
    if (_menuView ) {
        return ;
    }

    __weak ZYProfileController * vc = self;
    ZYTileMenuView * titleMenu = [[ZYTileMenuView alloc]initWithFrame:CGRectMake(0, 0, VIEW_With, 0)];

    [titleMenu createMenuViewWithContents:arrays WithMaxTag:0 WithIsopen:YES ];
    titleMenu.tileBtnClick = ^(int selectIndex){

        [vc profileDidclick:selectIndex];

    };
    _menuView = titleMenu;

    _menuView.frame = CGRectMake(0, 0, VIEW_With, _menuView.frame.size.height);
    
    [_tableview reloadData];
} 

-(void)profileDidclick:(int)index
{
//    [TabbarShowHiden tabbarHidenWithdelegate:self];

    NSDictionary * dic =  self.app_infos[index];

    NSURL * url = [NSURL URLWithString:dic[@"link"]];

    RxWebViewController * webVC = [[RxWebViewController alloc]initWithUrl:url];

    webVC.hidesBottomBarWhenPushed = YES ;

    [self.navigationController pushViewController:webVC animated:YES];

}

-(void)profileData
{
    __block ZYProfileController * vc = self;
    [GCDQueue executeInBackgroundPriorityGlobalQueue:^{
        [HttpEngine getProfileWithObject:self Complate:^(NSDictionary *responseDic) {

          [GCDQueue executeInMainQueue:^{
              vc.userinfoDic = responseDic[@"user_info"];
              vc.app_infos = responseDic[@"app_info"];
              [vc createBottomWitharrays:responseDic[@"app_info"]];
              [vc.tableview reloadData];
          }];

        }];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick  beginLogPageView:@"ZYProfileController.m"];

    if (!self.userinfoDic) {
        [self profileData];
    }
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [TabbarShowHiden tabbarShowWithdelegate:self];
        [MobClick endEvent:@"ZYProfileController.m"];
}


@end
