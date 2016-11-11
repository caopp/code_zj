
//
//  InviteTableViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "InviteTableViewController.h"
#import "RDVTabBarController.h"
#import "GetMerchantNotAuthTipDTO.h"
#import "InviteContactsViewController.h"
#import "CSPAuthorityPopView.h"
#import "CSPVIPUpdateViewController.h"
#import "GUAAlertView.h"
#import "CSPUtils.h"
#import "PurchaserLevelViewController.h"
#import "MerchantsPrivilegesViewController.h"
#import "PrepaiduUpgradeViewController.h"
#import "SecondaryViewController.h"
#import "TransactionRecordsViewController.h"
typedef void(^RequestBlock)(NSString* authorityMsg);

@interface InviteTableViewController ()<UIAlertViewDelegate,CSPAuthorityPopViewDelegate,PurchaserLevelViewControllerDelegate,SecondaryViewControllerDelegate>
{
    
    BOOL isLevelInitState;
    NSInteger shopLevel;
    GUAAlertView *alertView;
    CSPAuthorityPopView *authPopView;
    //清除采购商等级缓存
    PurchaserLevelViewController *purchaserLevelVC;
    
    //!需要邀请的电话号码
    NSString * invitePhoneNum;
    
    
}
@property (nonatomic,copy) RequestBlock authorityBlock;

//!发送邀请码
@property (weak, nonatomic) IBOutlet UIButton *sendInviteCodeBtn;

@end

@implementation InviteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isLevelInitState = YES;
    [self customBackBarButton];
    
    // !导航右按钮
    [self rightBarButton];
    
    
    //!添加 点击其他地方收起键盘事件
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //不加会屏蔽到TableView的点击事件等
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];
    

    
}
// !导航右按钮 --》采购商
-(void)rightBarButton{
    
    UIButton * levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [levelBtn setFrame:CGRectMake(0, 0, 100, 20)];
    [levelBtn setTitle:@"采购商等级" forState:UIControlStateNormal];
    [levelBtn setTitleColor:[UIColor colorWithHex:0xe2e2e2] forState:UIControlStateNormal];
    [levelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [levelBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [levelBtn addTarget:self action:@selector(levelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:levelBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}
//!取消键盘
-(void)hideKeyboard{
    
    [self.view endEditing:YES];
    
}
//采购商等级
- (void)levelBtnClick{
    
    
    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgradeVC.file = [HttpManager purchaserLevelNetworkRequestWebView];
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
}

-(void)removeMiningRecordCache
{

    [purchaserLevelVC.webView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self navigationBarSettingShow:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    // !读取用户是否可设定用户等级
    [self getAuthTipRequest];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    if (isLevelInitState) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:3];
        
        shopLevel = 3;
        btn.selected = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Private Functions
#pragma mark 等级按钮
- (IBAction)levelButtonClicked:(id)sender {
    
    // !如果没有请求回来可选等级，则请求
    if (_getMerchantNotAuthTipDTO) {
        
        // !判断是否可以设定
        if ([self authTips]) {
            
            return;
        }
        
    }else{
        
        [self getAuthTipRequest];
        
        return;
    }
    
    isLevelInitState = NO;
    
    UIButton *btn = (UIButton *)sender;
    
    for (int i = 0;i<6;i++) {
        
        UIButton *tmpBtn =(UIButton *)[self.view viewWithTag:i+1];
        if (tmpBtn.tag==btn.tag) {
         
            shopLevel = i+1;
            tmpBtn.selected = YES;
        }else{
            tmpBtn.selected = NO;
        }
    }
    
    
}

- (NSString*)getMobileList:(NSArray *)arr{
    
    if (!arr) {
        return nil;
    }
    
    NSString *mobileList = [[NSString alloc]init];
    
    for (NSString *tmpTel in arr) {
        
        [mobileList stringByAppendingFormat:@"%@,",tmpTel];
    }
    
    [mobileList substringToIndex:mobileList.length-1];
    
    return mobileList;
}
#pragma mark 邀请按钮
- (IBAction)sendInviteButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    //!组成新的手机号
    [self combinNewPhoneNum:_onlyPhoneNum.text];
    
    
    
    //!验证手机号是否正确 不正确则不进入下一步
    if (![self verityPhoneNum]) {
        
        return ;
    }
    
    if (alertView) {
        
        [alertView removeFromSuperview];
        
    }
    
    
    self.sendInviteCodeBtn.enabled = NO;
    
    // !先判断是否已经是会员等
    [self authorityRequest:^(NSString *authorityMsg) {
        
        NSString *msg = [NSString stringWithFormat:@"确定向手机号%@发送邀请码？",invitePhoneNum];
        
        if ([authorityMsg isEqualToString:@"Pass"]) {
            
            alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:msg withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
                // !发送邀请码
                [self sendInviteCodeHttpRequest];

                
            } dismissAction:nil];
           
            
            
        }else{// !已经是会员等情况，不用再发送
            
            
            msg = authorityMsg;
            
            alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:msg withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:nil dismissAction:nil];
            

        }
        [alertView show];
        
        self.sendInviteCodeBtn.enabled = YES;
        
        
    }];
    
    
}
//!组成新的手机号，截取掉多余的内容
-(void)combinNewPhoneNum:(NSString *)phoneNum{

    NSString *newPhoneNum = phoneNum;

    if (newPhoneNum.length > 0) {
        
        //!去掉所有-
        newPhoneNum =  [newPhoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        //!去掉所有空格
        newPhoneNum =  [newPhoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //!复制通讯录最顶部自己的手机号会有这样的字符串
        newPhoneNum =  [newPhoneNum stringByReplacingOccurrencesOfString:@"\U0000202c" withString:@""];
 

        

        
        //!判断前面3位数字是否为+86
//        NSString * headerStr = [newPhoneNum substringToIndex:4];
//        
//        if ([headerStr isEqualToString:@"+86"]) {
//            
//            newPhoneNum = [newPhoneNum substringFromIndex:3];
//        }
        NSArray *componentArray = [newPhoneNum componentsSeparatedByString:@"+86"];
        newPhoneNum = componentArray[componentArray.count-1];
        
        
        
        
    }
    
    invitePhoneNum = newPhoneNum;
    

}

// !验证手机号是否正确
-(BOOL)verityPhoneNum
{
    if (invitePhoneNum.length == 0 && invitePhoneNum.length > 11) {
        
        [self.view makeMessage:@"请输入手机号" duration:2.0f position:@"center"];
        return  NO;
        
    }
    
    if (![CSPUtils checkMobileNumber:invitePhoneNum]) {
        
        [self.view makeMessage:@"手机号码格式错误" duration:2.0f position:@"center"];
        return NO;
    }
    
    return YES;
    
}


-(BOOL)verityPassword
{

    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}
#pragma mark - 发送邀请码
- (void)sendInviteCodeHttpRequest{
    
    NSNumber*  level = [NSNumber numberWithInteger:shopLevel];
    
    NSString *mobile = invitePhoneNum;
    
    if (!mobile) {
        return;
    }
    
    if (!level) {
        return;
    }
    
    NSString* mobileList = [NSString stringWithFormat:@"%@,%@",mobile,level];
    
    self.sendInviteCodeBtn.enabled = NO;
    
    [HttpManager sendHttpRequestForMemberInvite:mobileList success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [self.view makeMessage:@"发送成功" duration:3 position:@"center"];
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:3 position:@"center"];

        }
        
        self.sendInviteCodeBtn.enabled = YES;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"发送失败" duration:3 position:@"center"];
        
        self.sendInviteCodeBtn.enabled = YES;

    }];
    
    
}
#pragma mark 验证输入的手机号 是否已经是会员
- (void)authorityRequest:(RequestBlock)block{

    
    if (self) {
        
        self.authorityBlock = [block copy];
    }
    
    __block NSString *msg;
    
    NSString *mobilePhone = invitePhoneNum;
    
    [HttpManager sendHttpRequestForValidateMemberInvite:mobilePhone success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            msg = @"Pass";
            
        }else{
            
            msg = dic[@"errorMessage"];
        }
        
        if (self.authorityBlock) {
            
            self.authorityBlock(msg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DebugLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
        
    }];
    
    
    
}


#pragma mark 判断是否可以 采购商等级权限
- (void)getAuthTipRequest{
    
    NSString * authType = @"1";
    
    [HttpManager sendHttpRequestForGetMerchantNotAuthTip:authType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                _getMerchantNotAuthTipDTO = [[GetMerchantNotAuthTipDTO alloc ]init];
                
                [_getMerchantNotAuthTipDTO setDictFrom:[dic objectForKey:@"data"]];
                
            }
            
        }else{
            
//            NSLog(@" 无权限提示接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];

}

- (BOOL)authTips{
    
    if (_getMerchantNotAuthTipDTO.hasAuth) {
        
        return NO;
        
    }else{
        
        //等级提示
        authPopView = [self instanceAuthorityPopView];
        authPopView.delegate = self;
        authPopView.frame = self.view.bounds;
        authPopView.displayAutoGradeLabel.text = @"设定采购商等级:";
        authPopView.tipLackIntegralLabel.text =  @"营业额积分还差:";
        [authPopView setGoodsNotLevelTipDTO:_getMerchantNotAuthTipDTO];
        
        [self.view addSubview:authPopView];
        
        return YES;
    }
    
}

- (CSPAuthorityPopView*)instanceAuthorityPopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

#pragma mark 等级规则
- (void)showLevelRules{
    
    //等级规则
    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CSPVIPUpdateViewController *vipVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"]; 
//    [self.navigationController pushViewController:vipVC animated:YES];
    
    SecondaryViewController *secondaryVC = [[SecondaryViewController alloc]init];
    
    secondaryVC.delegate = self;
    
    secondaryVC.file = [HttpManager privilegesNetworkRequestWebView];
    
    [self.navigationController pushViewController:secondaryVC animated:YES];

}

-(void)pushTransactionRecordsVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    TransactionRecordsViewController *nextVC = [storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 通讯录批量导入
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:@"contactsInfo"]) {
        
        InviteContactsViewController *inviteContactsVC = segue.destinationViewController;
        inviteContactsVC.getMerchantNotAuthTipDTO = _getMerchantNotAuthTipDTO;
    }
    
}


@end
