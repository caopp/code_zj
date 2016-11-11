//
//  CSPPersonCenterMainViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BalanceChargeViewController.h"
//#import "BankCardViewController.h"
#import "BankAndOhterPayController.h"
#import "PromptChooseBankView.h"

#import "CSPPersonCenterMainViewController.h"
#import "CSPPesronCenterTopTableViewCell.h"
#import "CSPPersonCenterLetterTableViewCell.h"
#import "CSPPersonCenterShopTableViewCell.h"
#import "CSPPersonCenterOtherTableViewCell.h"
#import "CustomBadge.h"

#import "MembershipGradeRulesViewController.h"
#import "CSPMessageCenterTableViewController.h"
#import "CSPSettingsViewController.h"
#import "CSPAddressMangementViewController.h"
#import "CSPVIPUpdateViewController.h"
#import "CSPCollectionViewController.h"
#import "CSPOrderViewController.h"
#import "CSPLetterDetailTableViewController.h"
#import "CSPPersonCenterMessageTableViewCell.h"//!消息中心的cell
#import "CSPReplenishmentViewController.h"
#import "CSPPictureDownloadViewController.h"
#import "UIImageView+WebCache.h"
#import "CSPBoughtMerchantListViewController.h"
#import "CSPPersonalProfileViewController.h"
#import "ConversationWindowViewController.h"
#import "ConversationWindowViewController.h"

#import "CPSDownloadImageViewController.h"

#import "PersonalCenterDTO.h"
#import "DeviceDBHelper.h"

#import "OrderingMerchantsViewController.h"
#import "CSPShoppingCartViewController.h"//!采购车

//订购过的商家
#import "OrderingMerchantsViewController.h"
//商品收藏
#import "CollectionGoodsViewController.h"
//会员升级
#import "MembershipUpgradeViewController.h"

#import "CSPPayAvailabelViewController.h"

#import "CSPGoodsViewController.h"

#import "UIImageView+WebCache.h"
#import "DownloadLogControl.h"
#import "LoginDTO.h"


#import "AdvancePaymentTableViewCell.h"

#import "MyOrderViewController.h"

//新添加采购车
#import "ShippingTableViewCell.h"
#import "CourierViewController.h"


#import "SettingModel.h"

//收藏
#import "CCWebViewController.h"

//判断申请资料
#import "ApplyTableViewCell.h"


#import "ShowApplyMeth.h"
#import "PaymentRecordController.h"

#import "SettingModel.h"


#define ReceiveMessage @"receiveMessage"

@interface CSPPersonCenterMainViewController ()<UITableViewDataSource,UITableViewDelegate,CSPPersonCenterTopViewDelegate,MembershipUpgradeViewControllerDelegate,CollectionGoodsViewControllerDelegate,OrderingMerchantsViewControllerDelegate,PromptChooseBankDelegate,AdvancePaymentTableViewCellDelegate,CCWebViewControllerDelegate,ApplyTableViewCellDelegate>
{
    PersonalCenterDTO *pcDTO_;
    UIImageView *backImageView;
    BOOL isNeedRefresh;
    MembershipUpgradeViewController *membershipUpgradeVC;
    CollectionGoodsViewController *collectionGoodsVC;
    OrderingMerchantsViewController *orderingMerchantsVC;
    
    //!正在下载的数量
    NSMutableArray * downloadList;
    CCWebViewController * cc;
    BOOL isTitle;
    //显示申请资料显示
    ApplyTableViewCell *applyTableViewCell;
}

//重新设置button显示颜色

@property (weak, nonatomic) IBOutlet UIButton *paymentButton;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

//付款
@property (weak, nonatomic) IBOutlet BadgeImageView *payMentImageView;

@property (weak, nonatomic) IBOutlet BadgeImageView *sendImageView;

@property (weak, nonatomic) IBOutlet BadgeImageView *receviedImageView;

@property (strong, nonatomic) IBOutlet UIView *VIPView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameLabelWithConstraint;

@property (strong, nonatomic) IBOutlet UIImageView *VIPImage;

@property (strong, nonatomic) IBOutlet UILabel *VIPLabel;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
- (IBAction)messageButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
- (IBAction)settingButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *VIPlevelBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *VIPlevelImageView;
@property (weak, nonatomic) IBOutlet UILabel *VIPlevelLabel;
@property (weak, nonatomic) IBOutlet UIButton *memberLevelUpdateButton;
- (IBAction)memberLevelUpdateButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addressManagerButton;
- (IBAction)addressManagerButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *collectionGoodsButton;
- (IBAction)collectionGoodsButtonClicked:(id)sender;

@property (nonatomic,strong)  PersonalCenterDTO *pcDTO ;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;

@property (nonatomic, strong) NSArray *chatArray;


@property (weak, nonatomic) IBOutlet UIView *messageBadge;//!消息中心有消息提示--》改成了 站内信的有消息提示


//待发货
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;

//带收货
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
//待付款
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
//全部采购单
@property (weak, nonatomic) IBOutlet UILabel *allListLabel;

@end

@implementation CSPPersonCenterMainViewController
@synthesize pcDTO = pcDTO_;

//待付款事件
- (IBAction)didClickPayMentBtnAction:(id)sender {
    
    isNeedRefresh = NO;
    MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
    myOrder.currentOrderState = 1;
    [self.navigationController pushViewController:myOrder animated:YES];

}
- (IBAction)didClickSendBtnAction:(id)sender {
    isNeedRefresh = NO;

    MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
    myOrder.currentOrderState = 2;
    [self.navigationController pushViewController:myOrder animated:YES];
}
- (IBAction)didClickGoodBtnAction:(id)sender {
    
    isNeedRefresh = NO;

    MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
    myOrder.currentOrderState = 3;
    [self.navigationController pushViewController:myOrder animated:YES];
}

- (IBAction)didClickOrderBtnAction:(id)sender {
    
    MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
    myOrder.currentOrderState = 0;
    [self.navigationController pushViewController:myOrder animated:YES];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //名称
    [self.nickNameLabel setTextColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
    [self.memberLevelUpdateButton setTitleColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1] forState:(UIControlStateNormal)];
    [self.addressManagerButton setTitleColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1] forState:(UIControlStateNormal)];
    [self.collectionGoodsButton setTitleColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1] forState:(UIControlStateNormal)];
    
    
    //待发货
    [self.deliveryLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    //带收货
    [self.goodsLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    //待付款
    [self.payLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    //全部采购单
    //待付款
    [self.allListLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    
    [self.paymentButton setBackgroundImage:[UIImage imageNamed:@"白色"] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"白色"] forState:UIControlStateNormal];
    [self.goodButton setBackgroundImage:[UIImage imageNamed:@"白色"] forState:UIControlStateNormal];
    [self.orderButton setBackgroundImage:[UIImage imageNamed:@"白色"] forState:UIControlStateNormal];
    
    self.tableView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    //    self.tableView.scrollEnabled = NO;//!设计要求去掉
    
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    isNeedRefresh = NO;
    isTitle = YES;
    
    //    [self getData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needRefresh) name:personalCenterRefresh object:nil];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    backImageView = [[UIImageView alloc]init];
    backImageView.image = [UIImage imageNamed:@"会员信息"];
    [self.headerBackgroundView insertSubview:backImageView atIndex:0];
    
    self.headerImageView.layer.masksToBounds=YES;
    self.headerImageView.layer.cornerRadius = 30;
    
    //头像上添加手势，打开image交互
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTaped:)];
    [self.headerImageView addGestureRecognizer:tap];
    self.headerImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTaped:)];
    [self.nickNameLabel addGestureRecognizer:tap2];
    self.nickNameLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(levelUpdateTaped:)];
    [self.VIPlevelBackgroundView addGestureRecognizer:tap3];
    self.VIPlevelBackgroundView.userInteractionEnabled = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.VIPView.layer.masksToBounds = YES;
    self.VIPView.layer.cornerRadius = 2.0f;
    
    [self setExtraCellLineHidden:self.tableView];
    
    //点击vip进入h5等级页面
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickGestureRecognizerAction)];
    [self.VIPView addGestureRecognizer:tapRecognizer];
    
}


//轻拍会员升级小图，进行会员升级h5页面
-(void)didClickGestureRecognizerAction
{
    cc = [[CCWebViewController alloc]init];
    cc.delegate = self;
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    cc.isTitle = isTitle;
    [self.navigationController pushViewController:cc animated:YES];
}




-(void)viewWillLayoutSubviews
{
    backImageView.frame = self.headerBackgroundView.frame;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:personalCenterRefresh];
}


#pragma mark 顶部头像点击事件

-(void)headerImageViewTaped:(UITapGestureRecognizer *)gesture{
    
    isNeedRefresh = NO;
    CSPPersonalProfileViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPersonalProfileViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)levelUpdateTaped:(UITapGestureRecognizer*)gesture
{
    isNeedRefresh = NO;
    CSPVIPUpdateViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
    
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    downloadList = (NSMutableArray *)[[DownloadLogControl sharedInstance]downloadingLogItems];
    
    //根据接口进行苹果账号判断
    SettingModel *settingModel = [[SettingModel alloc]init];
    
    [settingModel setShowMoneyPage:^(NSString *str) {
        
        [MyUserDefault saveRegistFlagAcount:str];
        
    }];
    
    //我的详细页面数据请求
    [self getData];
    [self getInfo];
}


//我的详细页面数据请求
-(void)getData{
    
    [HttpManager sendHttpRequestForPersonalCenterSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        self.pcDTO = [[PersonalCenterDTO alloc]init];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"000"]) {
            
            [self.pcDTO setDictFrom:[dic objectForKey:@"data"]];
            
            NSLog(@"%@",[self getNumber:self.pcDTO.notPayOrderNum]);
            
            //            self.payMentImageView.badgeNumber = [self getNumber:self.pcDTO.notPayOrderNum];
            
            self.payMentImageView.badgeNumber = [self getNumber:self.pcDTO.notPayOrderNum];
            
            
            self.sendImageView.badgeNumber = [self getNumber: self.pcDTO.unshippedNum];
            
            self.receviedImageView.badgeNumber = [self getNumber:self.pcDTO.untakeOrderNum];

            [self.tableView reloadData];
            
        }else{
            
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeMessage:@"获取失败" duration:2.0f position:@"center"];
    }];
    
    
   }



-(void)getInfo
{

    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.VIPLabel.text = [NSString stringWithFormat:@"V%@",dic[@"data"][@"memberLevel"]];
            
            if ([[MemberInfoDTO sharedInstance].iconUrl isEqualToString:@""]) {

                self.headerImageView.image = [UIImage imageNamed:@"10_个人中心_默认头像区块"];
                
            }else{
                
                //!改成异步的
                NSString *iconUrl =  [MemberInfoDTO sharedInstance].iconUrl;
                
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"10_个人中心_默认头像区块"]];
            }
            
            
            if (![[MemberInfoDTO sharedInstance].nickName isEqualToString:@""] && [MemberInfoDTO sharedInstance].nickName!=nil) {
                
                self.nickNameLabel.text = [MemberInfoDTO sharedInstance].nickName;
                
            }else{
                
                if (![[MemberInfoDTO sharedInstance].memberName isEqualToString:@""] && [MemberInfoDTO sharedInstance].memberName!=nil) {
                    self.nickNameLabel.text = [MemberInfoDTO sharedInstance].memberName;
                }else{
                    self.nickNameLabel.text = [MyUserDefault defaultLoadAppSetting_loginPhone];
                }
                
            }
            
            //自适应label
            UIFont *fnt = [UIFont systemFontOfSize:20];
            self.nickNameLabel.font = fnt;
            self.nickNameLabel.numberOfLines = 1;
            self.nickNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGRect tmpRect = [self.nickNameLabel.text boundingRectWithSize:CGSizeMake(400, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
            self.nickNameLabelWithConstraint.constant = tmpRect.size.width;
            
            self.VIPImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"个人中心_v%ld会员",[MemberInfoDTO sharedInstance].memberLevel.integerValue]];
            
            self.VIPlevelLabel.text = [NSString stringWithFormat:@"V%@",[MemberInfoDTO sharedInstance].memberLevel.stringValue];
            
            [self.tableView reloadData];
            
            
        }
        //                [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //                [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeMessage:@"获取失败" duration:2.0f position:@"center"];
    }];

}



- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    if ([self.pcDTO.applyFlag isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        return 2;
        
    }else if([self.pcDTO.applyFlag isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        return 1;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0 :
            //!如果是苹果审核账号，去除下载次数购买记录行
            if ([[MyUserDefault loadRegistFlagAccount] isEqualToString:@"1"]) {
                return 3;
            }else
            {
                return 5;
            }
            break;
        case 1 :
        {
            if ([self.pcDTO.applyFlag isEqualToNumber:[NSNumber numberWithInt:0]]) {
                
                return 1;
                
            }else if([self.pcDTO.applyFlag isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                return 0;
            }
            
        }
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AdvancePaymentTableViewCell *advancePaymentCell = [tableView dequeueReusableCellWithIdentifier:@"AdvancePaymentTableViewCell"];
    advancePaymentCell.delegate = self;
    advancePaymentCell.payLabel.text = [NSString stringWithFormat:@"余额:¥%.2lf",self.pcDTO.payNum.doubleValue];
    
    //申请资料cell
    applyTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ApplyTableViewCell"];
    
    applyTableViewCell.delegate = self;
    applyTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!applyTableViewCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ApplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyTableViewCell"];
        applyTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ApplyTableViewCell"];
    }
    
    applyTableViewCell.applyButton.enabled = YES;
    
    //!如果是苹果审核账号，去除下载次数购买记录行
    if ([[MyUserDefault loadRegistFlagAccount] isEqualToString:@"1"]) {
        advancePaymentCell.hidden = YES;
    }else
    {
        advancePaymentCell.hidden = NO;
    }
    
#pragma mark   重新建cell
    ShippingTableViewCell *shippingCell = [tableView dequeueReusableCellWithIdentifier:@"shipCell"];
    if (shippingCell == nil) {
        shippingCell = [[ShippingTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"shipCell"];
    }
    
    shippingCell.accessoryType = 1;
    
    if (!advancePaymentCell) {
        [tableView registerNib:[UINib nibWithNibName:@"AdvancePaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdvancePaymentTableViewCell"];
        advancePaymentCell = [tableView dequeueReusableCellWithIdentifier:@"AdvancePaymentTableViewCell"];
    }
    
    if (indexPath.section == 0) {
        
        if ([[MyUserDefault loadRegistFlagAccount] isEqualToString:@"1"]) {
            if (indexPath.row == 0) {
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_shopCart"];
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"采购车（%d）",self.pcDTO.cartNum.intValue];
                shippingCell.lineLabel.hidden = NO;
                if (self.pcDTO.cartNum.intValue != 0) {
                    shippingCell.iconRed.hidden = YES;
                }else
                {
                    shippingCell.iconRed.hidden = YES;
                }

                return shippingCell;
                
            }else if (indexPath.row == 1)
            {
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"补货商品（%d）",self.pcDTO.replenishNum.intValue];
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_goods"];
                shippingCell.lineLabel.hidden = NO;
                 shippingCell.iconRed.hidden = YES;

                return shippingCell;
                
            }else if (indexPath.row == 2)
            {
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"订购过的商家（%d）",self.pcDTO.subscribeNum.intValue];
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_merchant"];
                shippingCell.iconRed.hidden = YES;

                shippingCell.lineLabel.hidden = NO;
                return shippingCell;
            }
            else
            {
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"商品图片下载（%lu）",(unsigned long)downloadList.count];
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_Download"];
                shippingCell.iconRed.hidden = YES;


                shippingCell.lineLabel.hidden = YES;
                return shippingCell;
            }
            
        }else
        {
            if (indexPath.row == 0) {
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_shopCart"];
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"采购车（%d）",self.pcDTO.cartNum.intValue];
                shippingCell.lineLabel.hidden = NO;
                
                if (self.pcDTO.cartNum.intValue != 0) {
                  shippingCell.iconRed.hidden = YES;
                }else
                {
                shippingCell.iconRed.hidden = YES;
                }
                

                return shippingCell;
                
            }else if (indexPath.row == 1)
            {
                return advancePaymentCell;
                
            }else if (indexPath.row == 2)
            {
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"补货商品（%d）",self.pcDTO.replenishNum.intValue];
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_goods"];
                shippingCell.lineLabel.hidden = NO;
                shippingCell.iconRed.hidden = YES;

                return shippingCell;
                
            }else if (indexPath.row == 3)
            {
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"订购过的商家（%d）",self.pcDTO.subscribeNum.intValue];
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_merchant"];
                shippingCell.iconRed.hidden = YES;

                shippingCell.lineLabel.hidden = NO;
                return shippingCell;
            }else
            {
                shippingCell.detailLabel.text = [NSString stringWithFormat:@"商品图片下载（%lu）",(unsigned long)downloadList.count];
                shippingCell.iconView.image = [UIImage imageNamed:@"personCenter_Download"];
                shippingCell.iconRed.hidden = YES;

                shippingCell.lineLabel.hidden = YES;
                return shippingCell;
            }
            
        }
        
    }else
    {
        return applyTableViewCell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else if (section == 1)
    {
        return 15;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if ([[MyUserDefault loadRegistFlagAccount] isEqualToString:@"1"])
        {
            switch (indexPath.row) {
                case 0:// !采购车
                {
                    
                    isNeedRefresh = YES;
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
                    shopVC.isBlockUp = YES;
                    shopVC.fromPersonCenterShopCart = YES;//!从 我的-》采购车进入的时候，这个值为yes
                    [self.navigationController pushViewController:shopVC animated:YES];
                }
                    
                    break;
                    
                case 1://!补货商品
                {
                    isNeedRefresh = NO;
                    CSPReplenishmentViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPReplenishmentViewController"];
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                    
                    break;
                case 2://!订购过的商家
                {
                    
                    cc = [[CCWebViewController alloc]init];
                    
                    cc.delegate = self;
                    cc.titleVC = @"订购过的商家";
                    cc.file = [HttpManager orderMerchantNetworkRequestWebView];
                    
                    [self.navigationController pushViewController:cc animated:YES];
                    
                }
                    
                    break;

                default:
                    break;
            }
            
        }else
        {
            switch (indexPath.row) {
                case 0:// !采购车
                {
                    
                    isNeedRefresh = YES;
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
                    shopVC.isBlockUp = YES;
                    shopVC.fromPersonCenterShopCart = YES;//!从 我的-》采购车进入的时候，这个值为yes
                    [self.navigationController pushViewController:shopVC animated:YES];
                }
                    
                    break;
                    
                case 1:
                {
                    CCWebViewController *webView = [[CCWebViewController alloc]init];
                    webView.file = [HttpManager advancePaymentRequestWebView];
                    webView.isOK = YES;
                    [self.navigationController pushViewController:webView animated:YES];
                    


                }
                    break;
                    
                case 2://!补货商品
                {
                    isNeedRefresh = NO;
                    CSPReplenishmentViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPReplenishmentViewController"];
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                    
                    break;
                case 3://!订购过的商家
                {
                    
                    cc = [[CCWebViewController alloc]init];
                    
                    cc.delegate = self;
                    cc.titleVC = @"订购过的商家";
                    cc.file = [HttpManager orderMerchantNetworkRequestWebView];
                    
                    [self.navigationController pushViewController:cc animated:YES];
                    
                }
                    
                    break;
                case 4://!商品图片下载
                {
                    isNeedRefresh = NO;
                    CPSDownloadImageViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSDownloadImageViewController"];
                    //!如果有正在下载的商品
                    if (downloadList.count) {
                        nextVC.isDownLoading = YES;
                    }
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
        
        
    }else
    {
        
        
    }
    
}


#pragma mark---------------根据给的讯单号和名字进行聊天接口请求---------
//讯单接口进行请求页面
-(void)enterTheChatPageOfTheServiceDic:(NSDictionary *)dic
{
    NSString *merchantNoStr = [NSString stringWithFormat:@"%@",dic[@"merchantNo"]];
    NSString *merchantNameStr = [NSString stringWithFormat: @"%@",dic[@"merchantName"]];
    
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNoStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];

            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

//            NSString* jId = [dic objectForKey:@"data"];
            
            //请求成功后，根据商家的名字 参数 merchantNoStr，进行商家讯单
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:merchantNameStr  jid:jid withMerchantNo:merchantNoStr];
            conversationVC.timeStart = time;
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;

            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询商家聊天账号失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
    
}


#pragma mark-----点击商家列表进入详情页买（进入口味点击过的商家列表传递的参数值）----
//进入商家详情列表传递参数值进入商家列表的详情页面
-(void)enterTheDetailsPageDic:(NSDictionary *)dic
{
    
    CSPGoodsViewController *goodsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsViewController"];
    MerchantListDetailsDTO* merchantDetail = [[MerchantListDetailsDTO alloc]init];
    //h5给的参数类型进行商品详细页面的请求
    merchantDetail.merchantNo = dic[@"merchantNo"];
    merchantDetail.id  = dic[@"id"];
    merchantDetail.blacklistFlag = dic[@"blacklistFlag"];
    merchantDetail.categoryName = dic[@"categoryName"];
    merchantDetail.closeEndTime = dic[@"closeEndTime"];
    merchantDetail.closeStartTime = dic[@"closeStartTime"];
    merchantDetail.goodsNum = dic[@"goodsNum"];
    merchantDetail.merchantName = dic[@"merchantName"];
    merchantDetail.merchantStatus = dic[@"merchantStatus"];
    merchantDetail.operateStatus = dic[@"operateStatus"];
    merchantDetail.pictureUrl = dic[@"pictureUrl"];
    merchantDetail.stallNo = dic[@"stallNo"];
    merchantDetail.flag = @"0";
    goodsVC.merchantDetail = merchantDetail;
    
    goodsVC.style = CSPGoodsViewStyleSingleMerchant;
    
    [self.navigationController pushViewController:goodsVC animated:YES];
    
}


-(void)backEliminateOrderingMerchantsVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ECSession *session = self.chatArray[indexPath.row];
        BOOL isSuccess = [[DeviceDBHelper sharedInstance]clearOneSessionUnReadCount:session];
        if (isSuccess) {
            self.chatArray = [[DeviceDBHelper sharedInstance] getUnReadSession];
            if  (self.chatArray.count == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:clearNoticeNotification object:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:addNoticeNotification object:nil];
            }
            
            [self.tableView reloadData];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


#pragma mark 消息中心--》改成站内信
- (IBAction)messageButtonClicked:(id)sender {
    
    isNeedRefresh = YES;
    CSPLetterDetailTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLetterDetailTableViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}


//点击设置按钮产生事件
- (IBAction)settingButtonClicked:(id)sender {
    isNeedRefresh = NO;
    CSPSettingsViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
#pragma mark 会员等级
//会员升级按钮点击事件
- (IBAction)memberLevelUpdateButtonClicked:(id)sender {
    /*
     isNeedRefresh = NO;
     //会员升级
     membershipUpgradeVC = [[MembershipUpgradeViewController alloc]init];
     [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
     
     membershipUpgradeVC.file = [HttpManager membershipUpgradeNetworkRequestWebView];
     
     
     membershipUpgradeVC.delegate = self;
     
     [self.navigationController pushViewController:membershipUpgradeVC animated:YES];
     */
    
    
    cc = [[CCWebViewController alloc]init];
    cc.delegate = self;
    cc.isTitle = isTitle;
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    [self.navigationController pushViewController:cc animated:YES];

}

////消除会员升级缓存
//-(void)backEliminateTheController
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

//地址管理点击事件
- (IBAction)addressManagerButtonClicked:(id)sender {
    
    isNeedRefresh = NO;
    
    CSPAddressMangementViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAddressMangementViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}



//我的收藏按钮点击事件
- (IBAction)collectionGoodsButtonClicked:(id)sender {
    
    isNeedRefresh = NO;
    //    cc = [[CCWebViewController alloc]init];
    //
    //    cc.titleVC = @"我的收藏";
    //    cc.file = [HttpManager collectionGoodNetworkRequestWebView];
    //
    //    [self.navigationController pushViewController:cc animated:YES];
    
    
    collectionGoodsVC = [[CollectionGoodsViewController alloc]init];
    collectionGoodsVC.delegate = self;
    [self.navigationController pushViewController:collectionGoodsVC animated:YES];
}




-(void)collectionGoodsListDetailPageDic:(MerchantListDetailsDTO *)dic merchantNo:(NSString *)merchantNo
{
    
    CSPGoodsViewController *goodsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsViewController"];
    
    goodsVC.merchantDetail = dic;
    
    goodsVC.style = CSPGoodsViewStyleSingleMerchant;
    
    [self.navigationController pushViewController:goodsVC animated:YES];
    
}

//立即申请代理方法
-(void)jumpApplyPage
{
    if (applyTableViewCell.applyButton.enabled == YES) {
        ShowApplyMeth *showApply = [[ShowApplyMeth alloc] init];
        [showApply verApplyCode:self];
    }
    applyTableViewCell.applyButton.enabled = NO;
}




//消除商品收藏的缓存
-(void)backEliminateCollectionGoodsWebView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toPayClicked
{
    
}
- (void)toDeliverClicked{
    
}
- (void)toReciveClicked{
    
}
- (void)allClicked{
    
    isNeedRefresh = NO;
    CSPOrderViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPOrderViewController"];
    nextVC.orderMode = CSPOrderModeAll;
    [self.navigationController pushViewController:nextVC animated:YES];
    
}



- (NSString *)getNumber:(NSNumber *)number
{
    
    if (number.intValue>99) {
        return @"99+";
    }else{
        return number.stringValue;
    }
    
}

#pragma mark 接受到消息 需要修改cell上面显示的数量 不需要修改站内信显示先来
-(void)newMessage
{
    self.chatArray = [[DeviceDBHelper sharedInstance] getUnReadSession];
    
    
    [self.tableView reloadData];
    
}
#pragma mark !判断是否显示底部的红点提示
-(void)setTabbarBage{
    
    if (self.chatArray.count == 0) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:clearNoticeNotification object:nil];
        
    }else{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:addNoticeNotification object:nil];
    }
    
    
}


-(void)needRefresh
{
    isNeedRefresh = YES;
}



#pragma mark 充值
- (IBAction)putAccountInClick:(id)sender {
    
    
}



-(void)didClickAdvancePaymentPage
{
    BalanceChargeViewController *balance = [[BalanceChargeViewController alloc] init];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    [self.navigationController pushViewController:balance animated:YES];
    
}


@end
