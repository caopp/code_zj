//
//  CSPSettingsViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSettingsViewController.h"
#import "CSPPersonalProfileViewController.h"
#import "CSPApplyDataTableViewController.h"
#import "CSPAddressMangementViewController.h"
#import "CSPAccountAndSaftyTableViewController.h"
#import "CSPGenerSettingTableViewController.h"
#import "CSPVIPUpdateViewController.h"
#import "CSPApplyEditeViewController.h"
#import "AboutViewController.h"

#import "ConsigneeDTO.h"

#import "CSPBaseTableViewCell.h"
#import "CSPLoginViewController.h"
#import "CSPNavigationController.h"
#import "CSPFeedBackViewController.h"
#import "ChatManager.h"
#import "MHImageDownloadManager.h"

#import "CSMoneyReconrdViewController.h"

#import "SaveUserIofo.h"

#pragma mark ----h5交互页面-----
#import "InformationApplyViewController.h"

#import "CCWebViewController.h"
#import "ZJ_InformationViewController.h"
#import "WebViewJavascriptBridge.h"
#import "PrepaiduUpgradeViewController.h"

#import "ShowApplyMeth.h"

//模型数据
#import "PersonalCenterSetModel/PersonlCenterSetGroup.h"
#import "PersonalCenterSetModel/PersonlCeterSetSingle.h"
#import "PersonalCenterSetCell/PersonalCenterSetCell.h"
#import "TokenLoseEfficacy.h"

#import "FeedBackViewController.h"


#import "SettingModel.h"
#import "PersonCenterSetGroupsShow.h"

@interface CSPSettingsViewController ()<InformationApplyViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    NSArray *imageNameArray;// !图片名字
    NSArray *titleArray; // !每行名称
    //清除个人信息记录缓存
    ZJ_InformationViewController *informationApplyVC;
    
    BOOL isPost;
}

@property WebViewJavascriptBridge* bridge;


@property (nonatomic,strong)NSMutableArray *groups;
//展示cell显示样式
@property (nonatomic,strong)NSMutableArray *groupsShow;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logoutButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CSPSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"setting",@"设置");
    
    isPost = YES;
    [self.logoutButton setTitle:NSLocalizedString(@"loginOut", @"退出当前账户") forState:UIControlStateNormal];
    
    //添加返回按钮
    [self addCustombackButtonItem];
    [self setExtraCellLineHidden:self.tableView];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    
    //线顶头
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    
    if ([[MyUserDefault loadH5RegistFlagAccount] isEqualToString:@"1"]) {
        
        [self setupGroupShow];
    }else
    {
        [self setupGroups];
    }
    
    
    //初始化数据模型
    
    //    self.tableView.scrollEnabled = NO;
    
    [_logoutButton setBackgroundColor:[UIColor colorWithHexValue:0x1a1a1a alpha:1]];
    
    
}
//初始化数据模型
-(void)setupGroups
{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}

-(void)setupGroupShow
{
    [self setupGroup3];
    [self setupGroup4];
}



//第一组数组数据进行初始化
-(void)setupGroup0
{
    PersonlCenterSetGroup *group = [PersonlCenterSetGroup group];
    [self.groups addObject:group];
    
    PersonlCeterSetSingle *item = [PersonlCeterSetSingle itemWithTitle:@"资金交易记录" icon:@"icon_recharge"];
    //设置组的所有行的数据
    group.items =@[item];
}

//第二组数据数据进行初始化
-(void)setupGroup1
{
    PersonlCenterSetGroup *group = [PersonlCenterSetGroup group];
    [self.groups addObject:group];
    PersonlCeterSetSingle *item = [PersonlCeterSetSingle itemWithTitle:@"个人资料" icon:@"setPersonData"];
    PersonlCeterSetSingle *item1 = [PersonlCeterSetSingle itemWithTitle:@"申请资料" icon:@"setApply"];
    PersonlCeterSetSingle *item2 = [PersonlCeterSetSingle itemWithTitle:@"收货地址" icon:@"setTakeAddress"];
    //设置组的所有行的数据
    group.items =@[item,item1,item2];
}
-(void)setupGroup2
{
    
    PersonlCenterSetGroup *group = [PersonlCenterSetGroup group];
    [self.groups addObject:group];
    PersonlCeterSetSingle *item = [PersonlCeterSetSingle itemWithTitle:@"账户与安全" icon:@"setSecurity"];
    PersonlCeterSetSingle *item1 = [PersonlCeterSetSingle itemWithTitle:@"通用" icon:@"setGeneral"];
    PersonlCeterSetSingle *item2 = [PersonlCeterSetSingle itemWithTitle:@"会员等级规则" icon:@"setLevel"];
    PersonlCeterSetSingle *item3 = [PersonlCeterSetSingle itemWithTitle:@"关于叮咚欧品" icon:@"setAbout"];
    PersonlCeterSetSingle *item4 = [PersonlCeterSetSingle itemWithTitle:@"意见反馈" icon:@"setFeedback"];
    
    //设置组的所有行的数据
    group.items =@[item,item1,item2,item3,item4];
}


//第二组数据数据进行初始化
-(void)setupGroup3
{
    PersonCenterSetGroupsShow *groupShow = [PersonCenterSetGroupsShow groupShow];
    [self.groupsShow addObject:groupShow];
    PersonlCeterSetSingle *item = [PersonlCeterSetSingle itemWithTitle:@"个人资料" icon:@"setPersonData"];
    PersonlCeterSetSingle *item1 = [PersonlCeterSetSingle itemWithTitle:@"申请资料" icon:@"setApply"];
    PersonlCeterSetSingle *item2 = [PersonlCeterSetSingle itemWithTitle:@"收货地址" icon:@"setTakeAddress"];
    //设置组的所有行的数据
    groupShow.items =@[item,item1,item2];
    
}

-(void)setupGroup4
{
    PersonCenterSetGroupsShow *groupShow = [PersonCenterSetGroupsShow groupShow];
    [self.groupsShow addObject:groupShow];
    PersonlCeterSetSingle *item = [PersonlCeterSetSingle itemWithTitle:@"账户与安全" icon:@"setSecurity"];
    PersonlCeterSetSingle *item1 = [PersonlCeterSetSingle itemWithTitle:@"通用" icon:@"setGeneral"];
    PersonlCeterSetSingle *item2 = [PersonlCeterSetSingle itemWithTitle:@"关于叮咚欧品" icon:@"setAbout"];
    PersonlCeterSetSingle *item3 = [PersonlCeterSetSingle itemWithTitle:@"意见反馈" icon:@"setFeedback"];
    
    //设置组的所有行的数据
    groupShow.items =@[item,item1,item2,item3];
}




//懒加载
-(NSMutableArray *)groups
{
    if ( _groups == nil) {
        self.groups = [NSMutableArray array];
    }
    return  _groups;
}

-(NSMutableArray *)groupsShow
{
    if (_groupsShow == nil) {
        self.groupsShow = [NSMutableArray array];
    }
    
    return _groupsShow;
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //根据接口进行苹果账号判断
    SettingModel *settingModel = [[SettingModel alloc]init];
    
    [settingModel setShowMoneyPage:^(NSString *str) {
        
        [MyUserDefault saveH5RegistFlagAcount:str];
        
    }];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[MyUserDefault loadH5RegistFlagAccount] isEqualToString:@"1"]) {
        
        return self.groupsShow.count;
        
    }else
    {
        return  self.groups.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return  9;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    if ([[MyUserDefault loadH5RegistFlagAccount] isEqualToString:@"1"]) {
        
        PersonCenterSetGroupsShow *groupsShow = self.groupsShow[section];
        
        return groupsShow.items.count;
        
    }else
    {
        PersonlCenterSetGroup *group = self.groups[section];
        
        return group.items.count;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalCenterSetCell *cell = [PersonalCenterSetCell cellWithTableView:tableView];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    
    if ([[MyUserDefault loadH5RegistFlagAccount] isEqualToString:@"1"]) {
        
        PersonCenterSetGroupsShow *groupsShow = self.groupsShow[indexPath.section];
        cell.item = groupsShow.items[indexPath.row];
        
    }else
    {
        PersonlCenterSetGroup *group = self.groups[indexPath.section];
        cell.item = group.items[indexPath.row];
        
        if (0 == indexPath.section) {
            cell.lineLabel.hidden = YES;
        }
        if (1 == indexPath.section) {
            if (2 == indexPath.row) {
                cell.lineLabel.hidden = YES;
                
            }
        }
        if (2 == indexPath.section) {
            if (4 == indexPath.row) {
                cell.lineLabel.hidden = YES;
            }
        }
        
    }
    
    cell.accessoryType = 1;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//本人这步没办法了，才这样写。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if ([[MyUserDefault loadH5RegistFlagAccount] isEqualToString:@"1"]) {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0) {
                CSPPersonalProfileViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPersonalProfileViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }else if (indexPath.row == 1)
            {
                ShowApplyMeth *showApply = [[ShowApplyMeth alloc] init];
                [showApply verApplyCode:self];
                
            }else
            {
                CSPAddressMangementViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAddressMangementViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }
        }else
        {
            if (indexPath.row == 0) {
                CSPAccountAndSaftyTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAccountAndSaftyTableViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }else if (indexPath.row == 1)
            {
                CSPGenerSettingTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGenerSettingTableViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (indexPath.row == 2)
            {
                AboutViewController *nextVC = [[AboutViewController alloc]init];
                [self.navigationController pushViewController:nextVC animated:YES];
            }else
            {
                
                FeedBackViewController * feedBackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
                [self.navigationController pushViewController:feedBackVC animated:YES];
            }
        }
        
        
    }else
    {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                CSMoneyReconrdViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSMoneyReconrdViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
                
                
            }
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0) {
                CSPPersonalProfileViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPersonalProfileViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }else if (indexPath.row == 1)
            {
                ShowApplyMeth *showApply = [[ShowApplyMeth alloc] init];
                [showApply verApplyCode:self];
                
                //            CCWebViewController * cc = [[CCWebViewController alloc]init];
                //
                //            cc.titleVC = @"申请资料";
                //            cc.file = [HttpManager applicationMaterialRequestWebView];
                //
                //            [self.navigationController pushViewController:cc animated:YES];
                
                
                
                
                //            informationApplyVC = [[ZJ_InformationViewController alloc]init];
                //
                //            [self.navigationController pushViewController:informationApplyVC animated:YES];
                
                
            }else
            {
                CSPAddressMangementViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAddressMangementViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }
        }else
        {
            if (indexPath.row == 0) {
                CSPAccountAndSaftyTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAccountAndSaftyTableViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }else if (indexPath.row == 1)
            {
                CSPGenerSettingTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGenerSettingTableViewController"];
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (indexPath.row == 2)//!会员等级规则
            {
                
                //进行点击
                PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
                
                prepaiduUpgradeVC.file = [HttpManager membershipRequestWebView];
                
                prepaiduUpgradeVC.isOK = isPost;
                
                [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
                
                
                
            }else if (indexPath.row == 3)
            {
                AboutViewController *nextVC = [[AboutViewController alloc]init];
                [self.navigationController pushViewController:nextVC animated:YES];
            }else
            {
                
                FeedBackViewController * feedBackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
                [self.navigationController pushViewController:feedBackVC animated:YES];
                
                //            CSPFeedBackViewController *feedBackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFeedBackViewController"];
                //            [self.navigationController pushViewController:feedBackVC animated:YES];
            }
        }
        
    }
    
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//清除个人信息缓存记录
-(void)removePersonalInformationRecordsCache
{
    //    [informationApplyVC.webView removeFromSuperview];
}
//清除会员规则缓存
-(void)clearRulesOfMembershipGradeRecordCache
{
    
}



- (IBAction)logoutButtonClicked:(id)sender {
    
    //    //!退出 此处更改
    //    CSPLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLoginViewController"];
    //    CSPNavigationController *nav = [[CSPNavigationController alloc]initWithRootViewController:loginViewController];
    //    [self presentViewController:nav animated:YES completion:nil];
    //
    //    loginViewController.passwordTextField.text = nil;
    //    //删除用户信息
    //    SaveUserIofo *userInfo = [[SaveUserIofo alloc]init];
    //    [userInfo deleteIofoDTO];
    //
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //
    //    [self.rdv_tabBarController setSelectedIndex:0];
    //
    //    //进行密码和账号删除
    //    [MyUserDefault removeLoginPhone];
    //    [MyUserDefault removeLoginPassword];
    //
    //
    //    [ChatManager shareInstance].xmppUserName = nil;
    //    [ChatManager shareInstance].xmppPassWord = nil;
    //    //发送离线请求
    //    [[ChatManager shareInstance] disconnectToServer];
    //
    //    [MHImageDownloadManager suspendAllProcessor];
    //
    //    [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];
    
    TokenLoseEfficacy *tokenLose = [[TokenLoseEfficacy alloc]init];
    [tokenLose showLoginVC];
    
    //!移除本地保存的苹果审核的判断值
    [MyUserDefault removeIsAppleAccount];
    
    
}


@end
