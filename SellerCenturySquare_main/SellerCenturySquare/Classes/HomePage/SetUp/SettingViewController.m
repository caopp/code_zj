//
//  SettingViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/12.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SettingViewController.h"
#import "HttpManager.h"
#import "CSPMemberVIPViewController.h"
#import "CSPLoginViewController.h"
#import "CSPVIPUpdateViewController.h"
#import "CSPNavigationController.h"
#import "ChatManager.h"

#import "AboutViewController.h"
#import "SaveUserIofo.h"
#import "MyUserDefault.h"

#import "MerchantsPrivilegesViewController.h"
#import "DownloadLogControl.h"
#import "PrepaiduUpgradeViewController.h"
#import "TransactionRecordsViewController.h"
#import "SecondaryViewController.h"
#import "ThreePageViewController.h"

@interface SettingViewController ()<PrepaiduUpgradeViewControllerDelegate,SecondaryViewControllerDelegate>
{
    PrepaiduUpgradeViewController *prepaiduUpgrade;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customBackBarButton];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushTransactionRecordsVC) name:@"BuyDownloadNotification" object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.translucent = YES;
    
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明.png"] forBarMetrics:UIBarMetricsDefault];
//    
//    NSShadow* shadow = [[NSShadow alloc]init];
//    
//    shadow.shadowColor = [UIColor clearColor];
//    
//    shadow.shadowOffset = CGSizeMake(0, 0);
//    
//    NSDictionary* attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]};
//    
//    self.navigationController.navigationBar.titleTextAttributes = attributes;
//    
//    [self.navigationController.navigationBar setTintColor:LGNOClickColor];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
//                                                 forBarPosition:UIBarPositionAny
//                                                     barMetrics:UIBarMetricsDefault];
//       
//    //设置导航栏线体的颜色
//    UILabel *navLineLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
//    navLineLabel.backgroundColor = LGNOClickColor;
//    [self.navigationController.navigationBar addSubview:navLineLabel];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    statusBarView.backgroundColor=[UIColor blackColor];
//    
//    [self.view addSubview:statusBarView];
//    [self setNeedsStatusBarAppearanceUpdate];
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

#pragma mark - Private Functions
- (IBAction)loginOut:(id)sender {
    
    CSPLoginViewController *loginVC =[self.storyboard instantiateViewControllerWithIdentifier:@"CSPLoginViewController"];
    CSPNavigationController *navigationController = [[CSPNavigationController alloc]initWithRootViewController:loginVC];
    loginVC.pswTextField.text = nil;
    
    //删除用户信息
    SaveUserIofo *userIofo = [[SaveUserIofo alloc]init];
    [userIofo deleteIofoDTO];
    
    //删除用户登录时候采用的密码和账号
    [MyUserDefault removePassword];
    [MyUserDefault removePhone];
    [MyUserDefault removeFirstLogin];
    
    
    [ChatManager shareInstance].xmppUserName = nil;
    [ChatManager shareInstance].xmppPassWord = nil;
    
    //发送离线请求
    [[ChatManager shareInstance] disconnectToServer];
    
    [[[[UIApplication sharedApplication]delegate] window] setRootViewController:navigationController];
    
    //!暂停所有下载
    [[DownloadLogControl sharedInstance] suspendAllDownLoad];

    
}


#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *accountIdentifier = @"AccountCell";
    NSString *normalIdentifier = @"NormalCell";
    NSString *privilegeIdentifier = @"PrivilegeCell";
    NSString *aboutIdentifier = @"AboutCell";
    NSString *feedbackIdentifier = @"FeedbackCell";
    
    UITableViewCell *accountCell = [tableView dequeueReusableCellWithIdentifier:accountIdentifier];

    
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
    
    UITableViewCell *privilegeCell = [tableView dequeueReusableCellWithIdentifier:privilegeIdentifier];
    
    UITableViewCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:aboutIdentifier];
    
    UITableViewCell *feedbackCell = [tableView dequeueReusableCellWithIdentifier:feedbackIdentifier];

    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, accountCell.frame.size.height - 1, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
   
    
    if (accountCell == nil)
    {
        accountCell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accountIdentifier];
     
    }
    
    if (normalCell == nil)
    {
        normalCell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
        

        
    }
    
    if (privilegeCell == nil)
    {
        privilegeCell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:privilegeIdentifier];
    }
    
    

    if (aboutCell == nil)
    {
        aboutCell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aboutIdentifier];
        
    }
    
    
    
    
    switch (indexPath.row) {
        case 0:
            [accountCell addSubview:lineLabel];
            return accountCell;
            break;
        case 1:
            [normalCell addSubview:lineLabel];

            return normalCell;
            break;
        case 2:
             [privilegeCell addSubview:lineLabel];
            return privilegeCell;
            break;
        case 3:
            [aboutCell addSubview:lineLabel];
            return aboutCell;
            break;
            
        case 4:
            [feedbackCell addSubview:lineLabel];
            return feedbackCell;
            
            break;
            
        default:
            break;
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        
        ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
        
        threePageVC.file = [HttpManager privilegesNetworkRequestWebView];
        
        [self.navigationController pushViewController:threePageVC animated:YES];
        
    }else if (indexPath.row == 3){
    
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }
}

-(UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{


    return nil;

}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;

}


//剩余下载次数
-(void)pushTransactionRecordsVC
{
    TransactionRecordsViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [self navigationBarSettingShow:YES];
}


@end
