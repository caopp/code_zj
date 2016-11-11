
//
//  CPSMainViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSMainViewController.h"
#import "RecommendTableViewCell.h"
#import "LetterTableViewCell.h"
#import "MessageTableViewCell.h"
#import "ChatTableViewCell.h"
#import "DownloadTableViewCell.h"
#import "InviteTableViewCell.h"
#import "PicsDownloadViewController.h"
#import "CSPMemberVIPViewController.h"
#import "GetMerchantInfoDTO.h"
#import "GetMerchantMainDTO.h"
#import "InviteTableViewController.h"
#import "CSPRecommendViewController.h"

#import "CPSDownloadImageViewController.h"
#import "CSPMessageCenterTableViewController.h"
#import "CSPLetterDetailTableViewController.h"

#import "CPSMyOrderViewController.h"
#import "DeviceDBHelper.h"
#import "ECSession.h"
#import "ConversationWindowViewController.h"
#import "RecommendHistoryListViewController.h"

#import "CSPVIPUpdateViewController.h"
#import "DownloadLogControl.h"
#import "MyUserDefault.h"

#import "RDVTabBarItem.h"
#import "GUAAlertView.h"
#import "CSPLoginViewController.h"
#import "CSPChangePwdViewController.h"
#import "CPSMyShopViewController.h"
#import "MerchantsPrivilegesViewController.h"
#import "BussinessAreaController.h"
#import "TransactionRecordsViewController.h"
#import "StatisticalViewController.h"//!统计
#import "PrepaiduUpgradeViewController.h"
#import "SecondaryViewController.h"
#import "OrderMainListViewController.h"

#import "ZJSJ_SettingViewController.h"

#import "MyOrderViewController.h"

#import "SettingViewController.h"
#import "ThreePageViewController.h"


#import "OrderMainListViewController.h"

@interface CPSMainViewController ()<MerchantsPrivilegesViewControllerDelegate,PrepaiduUpgradeViewControllerDelegate,SecondaryViewControllerDelegate>

{
    GetMerchantInfoDTO *getMerchantInfoDTO;
    BOOL isMaster;
//    CSPLoginViewController *loginVC;
    CSPChangePwdViewController *changePwdVC;
    
    CPSMyShopViewController *shopVC;// !我的店
    //清除商家特权缓存记录
    MerchantsPrivilegesViewController *merchantsPrivilegesVC;

    PrepaiduUpgradeViewController *prepaiduUpgrade;
    
    BOOL isPost;
    
}
@property (nonatomic,strong) GetMerchantMainDTO *getMerchantMainDTO;
//是否有询单消息
@property (nonatomic,assign)BOOL hasConsultNotification;
@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong)NSArray *unreadMessageList;


@property (nonatomic,copy) NSString *downloadingNum;

//!站内信
@property (weak, nonatomic) IBOutlet UIButton *messasgeCenterButton;

- (IBAction)messageCenterButtonClicked:(id)sender;

@end

@implementation CPSMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    isMaster = YES;
    
    isPost = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    NSNotification *notification = [NSNotification notificationWithName:@"postNotification" object:nil userInfo:nil];
    
       
    
    //    第一次登录的时候进行密码修改。
    //    对用户是否第一次登录来进行判断  如果用于已经安装过，并且已经登录过，这样写还对吗？
    //判断第一进来弹出修改登录密码
    
    if ( [[MyUserDefault defaultLoadAppSetting_firstLogin] isEqualToString:@"0"]) {
        
         [self ejectChangeSecret];
        
         [MyUserDefault removeFirstLogin];
        
    }else
    {
        [[GUAAlertView alertViewWithTitle:@"为了您的账户安全" withTitleClor:nil message:@"请及时修改登录密码!" withMessageColor:nil oKButtonTitle:@"暂不修改" withOkButtonColor:nil cancelButtonTitle:@"修改" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
        } dismissAction:^{
            
            //进入修改登录密码页面
            BOOL isSecret;
            isSecret = YES;
            
            changePwdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePwdViewController"];
            
            changePwdVC.isOK = isSecret;
            
            [self.navigationController pushViewController:changePwdVC animated:YES];
            
        }]dismiss];

    }
    //!这个界面已经不显示消息了
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessageNotification) name:@"addNewsNotification" object:nil];
    
    
    [self customBackBar];
}


- (void)customBackBar{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心主页_设置"] style:UIBarButtonItemStyleDone target:self action:@selector(backBarButtonClick:)];
    self.navigationItem.rightBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    SettingViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}



//弹出框子
-(void)ejectChangeSecret
{
//    if ([[MyUserDefault defaultLoadAppSetting_firstLogin] isEqualToString:@"0"]) {
        //1、创建
        [[GUAAlertView alertViewWithTitle:@"为了您的账户安全" withTitleClor:nil message:@"请及时修改登录密码!" withMessageColor:nil oKButtonTitle:@"暂不修改" withOkButtonColor:nil cancelButtonTitle:@"修改" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
        } dismissAction:^{
            
            //进入修改登录密码页面
            BOOL isSecret;
            isSecret = YES;
            
            changePwdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePwdViewController"];
            
            changePwdVC.isOK = isSecret;
            
            [self.navigationController pushViewController:changePwdVC animated:YES];
            
        }]show];
//    }
    
    
}




- (void)viewWillAppear:(BOOL)animated{
    
//    [self navigationBarSettingShow:NO];
    [self tabbarHidden:NO];
    
    // !获取商家信息
    [self getMerchantInfo];
    
    //!B商家中心主页接口
    [self getMerchantMain];
    
//    self.navigationController.navigationBar.translucent = NO;

//    self.navigationController.navigationBarHidden = YES;
 

    
}

- (void)viewWillDisappear:(BOOL)animated{
    
//    self.navigationController.navigationBarHidden = NO;

//    [self navigationBarSettingShow:YES];
    
    
}



#pragma mark - HttpRequest  

- (void)getMerchantMain{
    
    // !B商家中心主页接口
    [HttpManager sendHttpRequestForGetMerchantMain:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getMerchantMainDTO = [GetMerchantMainDTO sharedInstance];
                [_getMerchantMainDTO setDictFrom:[dic objectForKey:@"data"]];
                
                // !显示主页的数量提示
                [self updateState];
                
                // !改变tabbar bage数量
                [self changeTabbarBageNum];
        
            }
            
        }else{
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        
    } ];
    
    
}

// !大B商家信息接口
- (void)getMerchantInfo{
    
    
    [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                // !是否是主账号
                [MyUserDefault setJudgeUserAccount:dic[@"data"][@"isMaster"]];
                
                getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                
                [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
                isMaster = getMerchantInfoDTO.isMaster;
                
                NSString *title = getMerchantInfoDTO.merchantName;
                
                self.title = title;
                
//                [_shopNameBtn setTitle:title forState:UIControlStateNormal];
//                [_shopNameBtn setTitle:title forState:UIControlStateHighlighted];
                
                [_levelButton setTitle:[NSString stringWithFormat:@"V%@",getMerchantInfoDTO.level] forState:UIControlStateNormal];
                [_levelButton setTitle:[NSString stringWithFormat:@"V%@",getMerchantInfoDTO.level] forState:UIControlStateHighlighted];
                
                NSString *imgName = [NSString stringWithFormat:@"04_商家中心主页_v%@会员",getMerchantInfoDTO.level];
                
                [_levelButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [_levelButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
                
                [self.tableView reloadData];
                
            }
            
        }else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    } ];
}


#pragma mark - 获取消息 接收到消息会进入这里
- (void)getMessageNotification{
    
    NSArray * tabbarItmes  = [[[self rdv_tabBarController] tabBar]items];
    
    // !叮咚
    RDVTabBarItem * dingDongItem = tabbarItmes[2];
      dingDongItem.badgeValue = @" ";

//        // !消息
//        _unreadMessageList = [[DeviceDBHelper sharedInstance]getUnReadSession];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//
//        NSInteger msgRemindCount = [_getMerchantMainDTO.noticeStationNum integerValue];
//        
//        dingDongItem.badgeValue = @"";
//        
//
//        if (_unreadMessageList.count==0 && msgRemindCount == 0) {
//            
//            dingDongItem.badgeValue = @"";
//
//        }else if(_unreadMessageList.count !=0 || msgRemindCount != 0){
//            
//            dingDongItem.badgeValue = @" ";
//            
//        }
    
        
   // });
   
}


//// !站内信 未读消息数量
//- (void)messageCenterRemind{
//    
//    //    NSInteger msgRemindCount = [_getMerchantMainDTO.noticeStationNum integerValue]+[_unreadMessageList count];
//    
//    NSInteger msgRemindCount = [_getMerchantMainDTO.noticeStationNum integerValue];
//    
//    if (msgRemindCount>0) {
//        
//        [self noticeCenterRemind:YES];
//        
//    }else{
//        
//        [self noticeCenterRemind:NO];
//        
//    }
//    
//}
////站内信提醒红点
//- (void)noticeCenterRemind:(BOOL)show{
//    
//    if (show) {
//        
//        //Show
//        [_noticeCenter changeViewToBadgeWithString:@"" withScale:0.2];
//        _noticeCenter.hidden = NO;
//        
//        
//    }else{
//        
//        //Hide
//        _noticeCenter.hidden = YES;
//        
//    }
//    
//}

//是否有询单
- (void)updateConsultNotification:(BOOL)hasConsultNotification{
    
    _hasConsultNotification = hasConsultNotification;
    [_tableView reloadData];
    
}



#pragma mark 显示主页的数量提示

- (void)updateState{

    
    int num1 = [_getMerchantMainDTO.unshippedNum intValue];
    int num2 = [_getMerchantMainDTO.unshippedCNum intValue];
    
    int num3 = num1 + num2;
    NSString *unshippedNum = [NSString stringWithFormat:@"%d",num3];
    
    if ([unshippedNum integerValue]==0) {
        
        _waitingForDeliveryBadge.hidden = YES;
        
    }else{
        
        _waitingForDeliveryBadge.hidden = NO;
        unshippedNum =[unshippedNum integerValue]>99?@"99+": unshippedNum;
        
        [_waitingForDeliveryBadge changeViewToBadgeWithString:unshippedNum withScale:0.7];
        
        //!重新直接通过约束改变宽度
        [self autoBadgeSizeWithString:unshippedNum];

        
    }
    
    
    // !站内信 未读消息数量
//    [self messageCenterRemind];

    
    //商品图片下载
    NSArray *list = [[DownloadLogControl sharedInstance]downloadingLogItems];
    _downloadingNum = [NSString stringWithFormat:@"%zi",list.count];
    

    [self.tableView reloadData];

    
}
- (void) autoBadgeSizeWithString:(NSString *)badgeString
{
    
    CGFloat badgeScaleFactor = 0.7;
    CGSize retValue;
    CGFloat rectWidth, rectHeight;
    NSDictionary *fontAttr = @{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:12] };
    CGSize stringSize = [badgeString sizeWithAttributes:fontAttr];
    CGFloat flexSpace;
    if ([badgeString length]>=2) {
        
        flexSpace = [badgeString length];
        rectWidth = 25 + (stringSize.width + flexSpace); rectHeight = 25;
        retValue = CGSizeMake(rectWidth*badgeScaleFactor, rectHeight*badgeScaleFactor);
        
    } else {
        
        retValue = CGSizeMake(25*badgeScaleFactor, 25*badgeScaleFactor);
        
    }
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
    
    self.deliverBageWith.constant = retValue.width;

//    [self layoutIfNeeded];
    
    
}



- (IBAction)waitDispatchGoodsButtonClicked:(id)sender {
    
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
    
    myOrderVC.currentOrderState = 2;
    

    if ([[GetMerchantMainDTO sharedInstance].unshippedCNum intValue] != 0 && [[GetMerchantMainDTO sharedInstance].unshippedNum intValue] != 0) {
        myOrderVC.channelType = 0;
    }
    
    if ([[GetMerchantMainDTO sharedInstance].unshippedCNum intValue] == 0 && [[GetMerchantMainDTO sharedInstance].unshippedNum intValue] != 0) {
        myOrderVC.channelType = 0;
    }

    if ([[GetMerchantMainDTO sharedInstance].unshippedCNum intValue] != 0 && [[GetMerchantMainDTO sharedInstance].unshippedNum intValue] == 0) {
        myOrderVC.channelType = 1;
    }

    
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

#pragma mark 等级按钮--》商家特权

- (IBAction)VIPLevelDetailButton:(id)sender {
    
//    CSPVIPUpdateViewController *vipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
//    [self.navigationController pushViewController:vipVC animated:YES];
    
    ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
    
    threePageVC.file = [HttpManager privilegesNetworkRequestWebView];
    
    [self.navigationController pushViewController:threePageVC animated:YES];

}

//清除商家特权记录缓存
-(void)clearBusinessFranchiseRecord
{
//    [merchantsPrivilegesVC.webView removeFromSuperview];
}


-(void)pushTransactionRecordsVC
{
    TransactionRecordsViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}


//!商店名称（把点击效果去掉了）
- (IBAction)shopNameButtonClicked:(id)sender {
  
    
    CSPVIPUpdateViewController *vipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
    
    [self.navigationController pushViewController:vipVC animated:YES];
    
}
#pragma mark 我的店

- (IBAction)myShopBtnClick:(id)sender {
    
    
//    if (shopVC) {
//        
//        shopVC = nil;
//    }
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CPSMyShopViewController"];
//    
//  [self.navigationController pushViewController:shopVC animated:YES];
    
    shopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSMyShopViewController"];
    
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

#pragma mark 叮咚商圈

- (IBAction)bussinessArea:(id)sender {
    
    BussinessAreaController * bussinessVC = [[BussinessAreaController alloc]init];
    bussinessVC.makrNotification = @"yes";
    
    [self.navigationController pushViewController:bussinessVC animated:YES];
}

#pragma mark 判断是否是子账号
- (BOOL)isNotMatser{
    
    NSString * isMasters = [MyUserDefault JudgeUserAccount];
    
    // !(0/YES:主账户 1/NO:子账户)
    if ([isMasters isKindOfClass:[NSString class]] && isMasters != nil) {
        
        // !如果是子账号登录，则返回上一次点击index
        if ([isMasters isEqualToString:@"1"]) {
            
            return YES;
            
        }
    }
    
    return NO;
    
    
}
#pragma mark 改变tabbar bage数量
-(void)changeTabbarBageNum{
    
   NSArray * tabbarItmes  = [[[self rdv_tabBarController] tabBar]items];
    
    // !采购单
    RDVTabBarItem * orderItem = tabbarItmes[3];

    // !商品
    RDVTabBarItem * goodsItme = tabbarItmes[4];
    
    
    // !新发布未上架商品未读数量 不为0  并且是主账号
    if ([_getMerchantMainDTO.unReadGoodsNum intValue] && ![self isNotMatser]) {
        
        //!有新发布的商品
        [MyUserDefault defaultSetUpGoods];
        
        NSNumber * unReadGoodsNum = _getMerchantMainDTO.unReadGoodsNum;
        
        if ([unReadGoodsNum intValue] > 99) {
            
//            goodsItme.badgeValue = @"99+";
            
            goodsItme.badgeValue = @" ";// !为了不显示数目，按图给出显示，所以没有数量


        }else{
        
//            goodsItme.badgeValue = [NSString stringWithFormat:@"%@",_getMerchantMainDTO.unReadGoodsNum];

            goodsItme.badgeValue = @" ";// !为了不显示数目，按图给出显示 =@“” 就是把红点去掉

            
        }
        
        
    }else{
        
        //!没有新发布的商品
        [MyUserDefault removeUpGoods];
        
    
    }
    
    

    
    // !采购单未读数量 不为0
    if ([_getMerchantMainDTO.unReadOrderNum integerValue]) {
        
        NSNumber * unReadOrderNum = _getMerchantMainDTO.unReadOrderNum;
        
        if ([unReadOrderNum intValue] >99 ) {
            
//            orderItem.badgeValue = @"99+";
            orderItem.badgeValue = @" ";// !为了不显示数目，按图给出显示


        }else{
        
//            orderItem.badgeValue = [NSString stringWithFormat:@"%@",_getMerchantMainDTO.unReadOrderNum];
            orderItem.badgeValue = @" ";// !为了不显示数目，按图给出显示

            
        }
    }
    // !读取消息
//    [self getMessageNotification];
}

                                                          
#pragma mark - Badge
- (void)updateButtonBadge{
    
    [_myShopBadge changeViewToBadgeWithString:@"1"];
    
    [_waitingForDeliveryBadge changeViewToBadgeWithString:@"1"];
    
    [_inviteBadge changeViewToBadgeWithString:@"1"];
    
    [self updateConsultNotification:YES];
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (isMaster) {
        
        return 2;
    
    }else{
    
        return 1;
    
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_hasConsultNotification) {
//    
//        switch (section) {
//            case 2:
//                //询单信息cell数量
//                return _unreadMessageList.count;
//                break;
//            default:
//                return 1;
//                break;
//        }
//        
//    }else{
    
        //无询单状态
//        return 1;
    
//    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section  = indexPath.section;
    
    //推荐商品进行隐藏
    RecommendTableViewCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell"];
    
//    MessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    
    ChatTableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    
    DownloadTableViewCell *downloadCell = [tableView dequeueReusableCellWithIdentifier:@"DownloadTableViewCell"];
    
//    InviteTableViewCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteTableViewCell"];
    
    
//    if (!recommendCell) {
//        
//        [tableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendTableViewCell"];
//        recommendCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell"];
//    }
    
//    if (!messageCell) {
//        
//        [tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageTableViewCell"];
//        messageCell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
//    }
    
    if (!chatCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChatTableViewCell"];
        chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    }
    
    if (!downloadCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"DownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"DownloadTableViewCell"];
        downloadCell = [tableView dequeueReusableCellWithIdentifier:@"DownloadTableViewCell"];
    }
    
//    if (!inviteCell) {
//        
//        [tableView registerNib:[UINib nibWithNibName:@"InviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"InviteTableViewCell"];
//        inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteTableViewCell"];
//    }
    
    // Configure the cell...
//    if (_getMerchantMainDTO!=nil) {
    
//        NSString *noticeStationNum = [_getMerchantMainDTO.noticeStationNum stringValue];
        
        //!站内信-->消息
//        if (_unreadMessageList.count==0) {
//        
//            [messageCell updateBadge:@""];
//
//        }else{
//        
//            [messageCell updateBadge:[NSString stringWithFormat:@"%lu",(unsigned long)_unreadMessageList.count]];
//
//
//        }
        
        
//    }
    
//    if (_hasConsultNotification) {
//        //有询单状态
//    
//        if (isMaster) {
//            //主账户
//            
//            switch (section) {
//                case 0:
//                    return recommendCell;
//                    break;
//                    
//                case 1:
//                    
//                    return messageCell;
//                    break;
//                    
//                case 2:
//                {
//                    ECSession *ecSession = [[ECSession alloc]init];
//                    ecSession = _unreadMessageList[indexPath.row];
//                    chatCell.type = ecSession.type;
//                    chatCell.ecSession = ecSession;
//                    return chatCell;
//                }
//                    
//                    break;
//                case 3:
//                    return downloadCell;
//                    break;
//                default:
//                    return nil;
//                    break;
//            }
//        }else{
//            //子账号
//            
//            switch (section) {
//                case 0:
//                    return recommendCell;
//                    break;
//                case 1:
//                    return messageCell;
//                    break;
//                case 2:
//                {
//                    ECSession *ecSession = [[ECSession alloc]init];
//                    ecSession = _unreadMessageList[indexPath.row];
//                    chatCell.type = ecSession.type;
//                    chatCell.ecSession = ecSession;
//                    return chatCell;
//                }
//                    
//                    break;
//                default:
//                    return nil;
//                    break;
//            }
//        }
//        
//        
//    }else{
        //无询单状态
//        
//        if (isMaster == 0) {
            //主账户
            switch (section) {
//                case 0:
//                    return recommendCell;
//                    break;
                case 0:
                    //!统计
                    
                    [downloadCell.leftImageView setImage:[UIImage imageNamed:@"Main_count"]];
                    [downloadCell updateNum:@"0" WithTitle:@"统计"];

                    return downloadCell;
                    break;
                    
                case 1:
                    
                    //商品下载
                    [downloadCell.leftImageView setImage:[UIImage imageNamed:@"Main_download"]];
                    [downloadCell updateNum:_downloadingNum WithTitle:@"商品图片下载"];
                    return downloadCell;
                    break;
//                case 3:
//                    return inviteCell;
//                    break;
                default:
                    return nil;
                    break;
            }
//        }else{
//            
//            //子账户
//            switch (section) {
//                case 0:
//                    return recommendCell;
//                    break;
//                case 1:
//                    //!统计
//                    [downloadCell.leftImageView setImage:[UIImage imageNamed:@"Main_count"]];
//                    [downloadCell updateNum:@"0" WithTitle:@"统计"];
//                    
//                    break;
////                case 2:
////                    return inviteCell;
////                    break;
//                default:
//                    return nil;
//                    break;
//            }
//        }
//        
//        
        
//    }
    
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
            
        case 0:
            return 0.1;
            break;
            
        default:
            break;
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    if (indexPath.section==0) {
//    
//        
//        RecommendHistoryListViewController *recHistoryListVC = [storyboard instantiateViewControllerWithIdentifier:@"RecommendHistoryListViewController"];
//        
//        [self.navigationController pushViewController:recHistoryListVC animated:YES];
//        
//        
//    }else
    
        if(indexPath.section == 0)// !统计
    {
        
        StatisticalViewController * purchaseVC = [[StatisticalViewController alloc]init];

        [self.navigationController pushViewController:purchaseVC animated:YES];
        

    }
    
    
//    if (_hasConsultNotification) {
//        
//        //有询单
//        if (indexPath.section==2) {
//            
//            ConversationWindowViewController *cwVC = [[ConversationWindowViewController alloc]initWithSession:_unreadMessageList[indexPath.row]];
//            
//            [self.navigationController pushViewController:cwVC animated:YES];
//        }
//        
//        
//        if (indexPath.section==3&&indexPath.row==0) {
//            
//            CPSDownloadImageViewController *downloadImageViewController = [storyboard instantiateViewControllerWithIdentifier:@"CPSDownloadImageViewController"];
//            
//            [self.navigationController pushViewController:downloadImageViewController animated:YES];
//            
//        }
//        
//    }else{
    
        //无询单
        
        if (!isMaster) {
            return;
        }
        //主账户
        if (indexPath.section==1&&indexPath.row==0) {
            
            CPSDownloadImageViewController *downloadImageViewController = [storyboard instantiateViewControllerWithIdentifier:@"CPSDownloadImageViewController"];
                        
            [self.navigationController pushViewController:downloadImageViewController animated:YES];
            
        }
        
//    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark 消息中心点击事件 更改为---》站内信列表

- (IBAction)messageCenterButtonClicked:(id)sender {
    CSPLetterDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailTableViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    

    
    
}

////进行设计页面跳转(进入设计页面)
//- (IBAction)didClickSettingAction:(id)sender {
//    
//    ZJSJ_SettingViewController *setting = [[ZJSJ_SettingViewController alloc]init];
//    [self.navigationController  pushViewController:setting animated:YES];
//}
@end
