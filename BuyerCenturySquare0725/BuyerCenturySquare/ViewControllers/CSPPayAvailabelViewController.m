//
//  CSPPayAvailabelViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPayAvailabelViewController.h"
#import "GetPayBalanceDTO.h"
#import "CSPSettingPayPasswordViewController.h"
#import "CSPInputPayPasswordViewController.h"
#import "CSPInputPasswordView.h"
#import "GetPayPayDTO.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CSPOrderViewController.h"
#import "WeChatMobilePayDTO.h"
#import "CSPSettingSafetyVerificationViewController.h"
#import "GUAAlertView.h"
#import "CSPVIPUpdateViewController.h"
#import "CustomBarButtonItem.h"
#import "MembershipUpgradeViewController.h"
#import "BalanceChargeViewController.h"
#import "CSPShoppingCartViewController.h"
#import "LoginDTO.h"
#import "MyOrderViewController.h"
@interface CSPPayAvailabelViewController ()<CSPInputViewDelegate,WXApiDelegate>

{
    //判断是否使用第三方支付
    BOOL isPayBalanceAvailable;
    GetPayBalanceDTO *payBalanceDTO;
    PayPayDTO *paypayDTO_;
    NSString *account;
    UITapGestureRecognizer *gestTap;
    GUAAlertView *alertView;
    
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollowVie;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *payValueView;
//应付金额（元）
@property (weak, nonatomic) IBOutlet UILabel *paytitleLabel;
//显示应付金额
@property (weak, nonatomic) IBOutlet UILabel *payValueLabel;

@property (weak, nonatomic) IBOutlet UIView *balanceView;
@property (weak, nonatomic) IBOutlet UIImageView *balanceImageView;
//预付款不足
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLabel;
//显示不余额
@property (weak, nonatomic) IBOutlet UILabel *balanceValueLabel;
//余额支付按钮
@property (weak, nonatomic) IBOutlet UIButton *balanceButton;

@property (weak, nonatomic) IBOutlet UILabel *moneyMarkLab;
//充值按钮
@property (weak, nonatomic) IBOutlet UIButton *chargeBalanceBtn;
//充值按钮执行的方法
- (IBAction)chargeBalance:(id)sender;

//余额支付按钮的点击事件
- (IBAction)balanceButtonClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdPayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdPadHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *thirdPayView;
//支付宝按钮
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;
//支付宝按钮的点击事件
- (IBAction)aliPayButtonClicked:(UIButton *)sender;
//微信支付按钮
@property (weak, nonatomic) IBOutlet UIButton *wechatPayButton;
//微信支付按钮的点击事件
- (IBAction)wechatPayButtonClicked:(UIButton *)sender;

/**
 *  显示余额支付金额 和 第三方支付金额
 */
@property (weak, nonatomic) IBOutlet UIView *moneyView;
//余额需支付的钱数
@property (weak, nonatomic) IBOutlet UILabel *balancePayLabel;
//第三方需支付的钱数
@property (weak, nonatomic) IBOutlet UILabel *thirdPayLabel;

//确认支付按钮
@property (weak, nonatomic) IBOutlet UIButton *payButton;
//确认支付按钮的点击事件
- (IBAction)payButtonClicked:(UIButton *)sender;

@property (nonatomic,strong)PayPayDTO *paypayDTO;


@end

@implementation CSPPayAvailabelViewController
@synthesize isAvailable = isAvailable_,paypayDTO = paypayDTO_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"支付";
    
    
    self.chargeBalanceBtn.hidden = YES;
    self.chargeBalanceBtn.backgroundColor = [UIColor blackColor];
    self.chargeBalanceBtn.layer.masksToBounds = YES;
    self.chargeBalanceBtn.layer.cornerRadius = 3.0f;

    
    NSLog(@"sel ===== %@",self.dic);
    
    
    
    //@返回按钮
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];

    
    //@进行返回按钮的隐藏
    [self.navigationItem setHidesBackButton:YES];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSArray *accuntArray = [userDefaults arrayForKey:@"myArray"];
    
    if (accuntArray != nil) {
        
        account = accuntArray[0];
    
    }
    
//    if (self.orderCode != nil) {
//        
//        [HttpManager sendHttpRequestForConfirmPay:self.orderCode  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            
//            NSLog(@"dic = %@",dic);
//            
//            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//                
////                self.orderAddDTO = [[OrderAddDTO alloc] init];
////                [self.orderAddDTO setDictFrom:[dic objectForKey:@"data"]];
////                
//                [self setUI];
//                
//                
//            }else{
//                if (alertView) {
//                    [alertView removeFromSuperview];
//                    
//                }
//                alertView = [GUAAlertView alertViewWithTitle:@"请求失败" withTitleClor:nil message:[dic objectForKey:@"errorMessage"]  withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
//                    
//                } dismissAction:^{
//                    
//                }];
//                [alertView show];
//                
//                
//                
//                           }
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
//            NSLog(@"The error description is %@\n",[error localizedDescription]);
//            
//        }];
//        
//    }else
//    {
        [self setUI];
//    }
}


/**
 *  设置支付显示页面
 */

- (void)setUI
{
    
    if (self.dic) {
        self.payValueLabel.text =  [NSString stringWithFormat:@"%@",self.dic[@"totalAmount"]];
        
    }else
    {
        
        //应付金额
        self.payValueLabel.text =  [NSString stringWithFormat:@"%@",[CSPUtils stringFromNumber:self.orderAddDTO.totalAmount]];
    }
    
    /**
     *  支付商品页面
     */
    if (isAvailable_ == YES) {
        //余额查询
        [HttpManager sendHttpRequestForGetPayBalance:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                
                //参数需要保存
                if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    /*
                     *  将请求过来的数据，封装到GetPayBalanceDT类里面 :
                     1.可用余额:availableAmount
                     2.被冻结的额度:freezeAmount
                     3.小B会员编号:memberNo 
                     4.总共的余额(类型为Double,含冻结额度)
                     */
                    payBalanceDTO = [[GetPayBalanceDTO alloc] init];
                    
                    [payBalanceDTO setDictFrom:[dic objectForKey:@"data"]];
                    
                    
                    //显示余额价格
                    self.balanceValueLabel.text = [CSPUtils stringFromNumber:payBalanceDTO.availableAmount];
                    
                    /**
                     *  判断用户余额与需支付金额做对比
                     */
                    if (payBalanceDTO.availableAmount.doubleValue - self.orderAddDTO.totalAmount.doubleValue < 0 ) {
                        isPayBalanceAvailable = NO;
                    }else{
                        isPayBalanceAvailable = YES;
                    }
                    
                    /**
                     *  可使用第三方混合支付
                     */
                    if (isPayBalanceAvailable == NO) {
                        //提示余额不足，并设置颜色
                        self.balanceTitleLabel.text = @"预付货款余额不足:";
                        self.balanceTitleLabel.textColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
                        self.balanceValueLabel.textColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
                        self.moneyMarkLab.textColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
                        
                                                                     
                        
                        //!如果是苹果审核账号，隐藏充值按钮
                         if ([MyUserDefault loadIsAppleAccount]) {
                            self.chargeBalanceBtn.hidden = YES;

                        }else
                        {
                            self.chargeBalanceBtn.hidden = NO;

                        }
                        

                        
                        if (payBalanceDTO.availableAmount.doubleValue ==0) {
                            //余额不足，默认可用余额支付
                            self.balanceButton.selected = NO;
                            self.balanceButton.hidden = YES;

                            
                        }else
                        {
                            //余额不足，默认可用余额支付
                            self.balanceButton.selected = YES;
                            self.balanceButton.hidden = NO;
                        }
                        
                        //混合支付显示账户需支付余额和 第三方需支付金额
                        self.moneyView.hidden = NO;
    
                        //显示金额
                        self.balancePayLabel.text = [NSString stringWithFormat:@"   余额支付: ¥%@",payBalanceDTO.availableAmount.stringValue];
                        //第三方支付金额（默认为0）
                        self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付: ¥0"];
                  
                    }else
                    {
                        
                        /**
                         *  当账户余额充足的时候
                         */
                        self.balanceTitleLabel.text = @"预付款余额:";
                        self.balanceTitleLabel.textColor = [UIColor blackColor];
                        
                        //添加手势，点击余额就跳转到支付页面
                        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
                        tapGesture.numberOfTapsRequired = 1; //点击次数
                        tapGesture.numberOfTouchesRequired = 1; //点击手指数
                        [self.balanceView addGestureRecognizer:tapGesture];
                        
                        //设置余额支付按钮，更改为">"
                        [self.balanceButton setBackgroundImage:nil forState:UIControlStateNormal];
                        [self.balanceButton setBackgroundImage:nil forState:UIControlStateSelected];
                        [self.balanceButton setImage:[UIImage imageNamed:@"10_设置_进入"] forState:UIControlStateNormal];
                        self.balanceButton.enabled = NO;
                        self.chargeBalanceBtn.hidden = YES;
           
                    }
                    
                    //设置“确认去支付”按钮不可点击，并更改背景颜色
                    self.payButton.backgroundColor = [UIColor colorWithHexValue:0x999999    alpha:1];
                    self.payButton.enabled = NO;
                    
                }
                
                
            }else{
                
                //请求失败提示错误信息
                if (alertView) {
                    [alertView removeFromSuperview];
                }
                alertView = [GUAAlertView alertViewWithTitle:@"请求失败" withTitleClor:nil message:[dic objectForKey:@"errorMessage"]  withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                    
                } dismissAction:^{
                    
                }];
                [alertView show];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
        }];
    }
    else
    {
        /**
         *  购买下载次数
         */
        self.balanceView.hidden = YES;
        self.thirdPayConstraint.constant = 10;
        self.thirdPadHeightConstraint.constant = 1000;
        self.payButton.enabled = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.aliPayButton.enabled  = YES;
    self.payButton.enabled = YES;
    self.wechatPayButton.enabled = YES;
    self.balanceButton.enabled = YES;

    
    //设置添加通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatPaySuccessMethod) name:@"weChatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayfailureMethod) name:@"weChatPayfailure" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowInteractionMethod) name:@"allowInteraction" object:nil];
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

//手势方法 如果添加
- (void)tapGesture:(UITapGestureRecognizer *)gest
{
    
    //为了防止多次请求跳转
    if (gestTap) {
        gestTap = nil;
        return;
    }
    
    gestTap = gest;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //请求查询是否有支付密码
    [HttpManager sendHttpRequestForGetIsHasPaymentPassword:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            BOOL isPayPassword;
            NSString *pass = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
            
            if ([pass isEqualToString:@"1"]) {
                isPayPassword = YES;
            }else{
                isPayPassword = NO;
            }
            
            
            /**
             *  如果isPayPassword==YES，则跳转输入支付密码
                如果isPayPassword==NO，则跳转设置支付密码
             */
            if (isPayPassword == YES) {
                //支付密码
                CSPInputPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPInputPayPasswordViewController"];
                nextVC.orderAddDTO = self.orderAddDTO;
                nextVC.payBalanceDTO = payBalanceDTO;
                nextVC.payType = CSPPayNone;
                nextVC.isGoods = self.isGoods;
                [self.navigationController pushViewController:nextVC animated:YES];
            }else{
                //设置支付密码
                CSPSettingPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingPayPasswordViewController"];
                nextVC.orderAddDTO = self.orderAddDTO;
                nextVC.payType = CSPPayNone;
                nextVC.isGoods = self.isGoods;
    
                nextVC.payBalanceDTO = payBalanceDTO;
                [self.navigationController pushViewController:nextVC animated:YES];
                
            }
            
        }else{
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"weChatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"weChatPayfailure" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"allowInteraction" object:nil];
}


/***************************************************************************
 *  支付流程，余额支付和第三方支付显示价格：A,B,C分别表示：余额，支付宝，微信三种支付方式。
 *  1.如果只有A选中，则余额显示，第三方支付显示为0￥。
 *  2.如果A选中，B和C只选中其中一个 则都显。
 *  3.如果A不选中，B和C只选中一个，则余额显示：0￥，第三方显示全部价格。
 *  4 如果都不选中，则都显示0￥。
 * 支付宝和位微信显示与此方式相同。
 ***************************************************************************
 */


//余额不足时支付
- (IBAction)balanceButtonClicked:(UIButton *)sender {
    //判断是否是商品支付
    if (isAvailable_ ==YES) {
        
        //如果点击了第三方支付
        if (isPayBalanceAvailable == YES) {
            sender.selected = !sender.selected;
            if (sender.selected == YES) {
                
                self.aliPayButton.selected = NO;
                self.wechatPayButton.selected = NO;
            }
            
            
            
        }else{
            /**
             *  判断是否选中第三方支付
             */
            if (self.aliPayButton.selected == NO && self.wechatPayButton.selected == NO) {
                sender.selected = !sender.selected;
                //如果没有则不允许点击确认去支付按钮
                self.payButton.enabled = NO;
                
                
                //判断是否点击余额 有则显示，没有则为0
                if (sender.selected == YES) {
                    
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:¥%@",payBalanceDTO.availableAmount.stringValue];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:¥0"];
                    
                }else{
                    //如果没有选中 则都为0
                    
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:¥0"];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:¥0"];
                    
                }

                
            }else
            {
                //允许点击“确认去支付”按钮
                  self.payButton.enabled = YES;
                //判断是否选中余额支付
                sender.selected = !sender.selected;
                //如果选中了
                if (sender.selected == YES) {
                    
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:¥%@",payBalanceDTO.availableAmount.stringValue];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:¥%.2f",self.orderAddDTO.totalAmount.doubleValue-payBalanceDTO.availableAmount.doubleValue];
                    
                }else{
                    //如果没有选中
                    
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:¥0"];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:¥%@",self.orderAddDTO.totalAmount.stringValue];
                }
                
            }
            
        }
    }
    
    /**
     *  判断是否选中了第三方支付
     */
    if (self.aliPayButton.selected||self.wechatPayButton.selected) {

            self.payButton.backgroundColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
            self.payButton.enabled = YES;
        
        
    }else
    {
        self.payButton.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        self.payButton.enabled = NO;

    }
    
    
}

//支付宝支付
- (IBAction)aliPayButtonClicked:(UIButton *)sender {
  
    
    //判断是否是商品支付
    if (isAvailable_ == YES) {
        
        self.payButton.enabled = YES;
        if (isPayBalanceAvailable == YES) {
            sender.selected = !sender.selected;
            if (sender.selected == YES) {
                
                self.balanceButton.selected = NO;
                self.wechatPayButton.selected = NO;
            }
 
        }else{
            //设置点击事件
            sender.selected = !sender.selected;
            
            //判断是否使用支付宝支付
            if (sender.selected) {
                //微信支付设置不可点击
                self.wechatPayButton.selected = NO;
                //如果选中 则显示余额，如果没有选中 则显示0
                if (self.balanceButton.selected == YES) {
                    
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥%@",payBalanceDTO.availableAmount.stringValue];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥%.2f",self.orderAddDTO.totalAmount.doubleValue-payBalanceDTO.availableAmount.doubleValue];
                }else
                {
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥0"];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥%.2f",self.orderAddDTO.totalAmount.doubleValue];
                }

            }else
            {
                //如果选中 则显示余额，如果没有选中 则显示0
                if (self.balanceButton.selected == YES) {
                    
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥%@",payBalanceDTO.availableAmount.stringValue];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥0"];
                }else
                {
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥0"];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥0"];
                    
                }
            }
            
        }
    }else
    {
        
        
        /**
         *  购买下载图片支付
         */
        sender.selected = !sender.selected;
        if (sender.selected== YES) {
            self.payButton.enabled = YES;
            
            self.wechatPayButton.selected = NO;

            
        }
    }
    
    //判断支付宝是否点击
    if (self.aliPayButton.selected) {
        
        self.payButton.backgroundColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
        self.payButton.enabled = YES;
        
        
    }else
    {
        self.payButton.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        self.payButton.enabled = NO;
    }
    
    
}

//微信支付
- (IBAction)wechatPayButtonClicked:(UIButton *)sender {
    
    //判断是否是商品支付
    if (isAvailable_ == YES) {
        
        //设置“确认去支付”允许交互
        self.payButton.enabled = YES;
        
        //判断是否余额是否充足
        if (isPayBalanceAvailable == YES) {
            sender.selected = !sender.selected;
            if (sender.selected==YES) {
                self.balanceButton.selected = NO;
                self.aliPayButton.selected = NO;
            }
          
        }else
        {
            //设置微信支付的状态
            sender.selected = !sender.selected;
            
            //如果是微信支付
            if (sender.selected) {
                
            //支付宝取消选中
            self.aliPayButton.selected = NO;
            
            //如果选中余额支付
            if (self.balanceButton.selected == YES) {
                
                self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥%@",payBalanceDTO.availableAmount.stringValue];
                self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥%.2f",self.orderAddDTO.totalAmount.doubleValue-payBalanceDTO.availableAmount.doubleValue];
            }else
            {
                self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥0"];
                self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥%.2f",self.orderAddDTO.totalAmount.doubleValue];
                }
            }else
            {
                
                //如果选中余额支付
                if (self.balanceButton.selected == YES) {
                    
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥%@",payBalanceDTO.availableAmount.stringValue];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥0"];
                }else
                {
                    self.balancePayLabel.text = [NSString stringWithFormat:@"余额支付:￥0"];
                    self.thirdPayLabel.text = [NSString stringWithFormat:@"第三方支付:￥0"];
                }
            }
            
        }
    }else
    {
        sender.selected = !sender.selected;
        if (sender.selected ) {
            self.payButton.enabled = YES;
            self.aliPayButton.selected = NO;
        }
      
    }
    
    if (self.aliPayButton.selected||self.wechatPayButton.selected) {
        
        self.payButton.backgroundColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
        self.payButton.enabled = YES;
        
    }else
    {
        self.payButton.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        self.payButton.enabled = NO;
        
    }
    
}

//确认去支付
- (IBAction)payButtonClicked:(UIButton *)sender {
    
    NSLog(@"点击了");
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(resetBtn) userInfo:nil repeats:NO];
    
    sender.enabled = NO;
    
    self.aliPayButton.enabled  = NO;
    self.payButton.enabled = NO;
    self.wechatPayButton.enabled = NO;
    self.balanceButton.enabled = NO;
    
    
    //余额
    BOOL isbalacnePay = NO;
    //支付宝
    BOOL isAliPay = NO;
    //微信
    BOOL isweChatPay = NO;
    
    /**
     *  判断三中支付
     */
    
    //余额
    if (self.balanceButton.selected == YES) {
        
        isbalacnePay = YES;
    }
    
    //支付宝
    if (self.aliPayButton.selected == YES) {
        
        isAliPay = YES;
    }
    
    //微信
    if (self.wechatPayButton.selected == YES) {
        isweChatPay = YES;
    }
    
    //余额为0时 无法支付？。
    if (payBalanceDTO.availableAmount.doubleValue == 0 && isbalacnePay == YES) {
        
        [self.view makeMessage:@"余额为0,无法用余额支付" duration:2.0f position:@"center"];

        return;
    }
    
    //判断是否是商品支付
    if (isAvailable_ == YES) {
        
        /**
         *  余额的时候只能选中一种支付方式，如果不充值的时候可以混合支付
         */
        if (isPayBalanceAvailable == YES) {
            //选中余额
            if (isbalacnePay == YES) {
                
                //查询是否有支付密码
                [HttpManager sendHttpRequestForGetIsHasPaymentPassword:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    NSLog(@"dic = %@",dic);
                    
                    if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                        
                        BOOL isPayPassword;
                        NSString *pass = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                    
                        if ([pass isEqualToString:@"1"]) {
                            isPayPassword = YES;
                        }else{
                            isPayPassword = NO;
                        }
                        
                        
                        
                        //如果有支付密码
                        if (isPayPassword == YES) {
                            //跳转到支付页面
                            CSPInputPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPInputPayPasswordViewController"];
                            nextVC.orderAddDTO = self.orderAddDTO;
                            nextVC.payBalanceDTO = payBalanceDTO;
                            nextVC.payType = CSPPayNone;
                            [self.navigationController pushViewController:nextVC animated:YES];
                        }else{
                            //否则去支付
                            CSPSettingPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingPayPasswordViewController"];
                            nextVC.orderAddDTO = self.orderAddDTO;
                            nextVC.payType = CSPPayNone;
                            nextVC.payBalanceDTO = payBalanceDTO;
                            [self.navigationController pushViewController:nextVC animated:YES];

                        }
                        
                    }else{
                        
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                }];
            }
            
            //只用支付宝支付
            if (isAliPay == YES) {
                
                self.paypayDTO = [[PayPayDTO alloc]init];
                self.paypayDTO.tradeNo = self.orderAddDTO.tradeNo;
                self.paypayDTO.useBalance = @"1";
                self.paypayDTO.balanceAmount = nil;
                self.paypayDTO.password = nil;
                self.paypayDTO.payAmount = self.orderAddDTO.totalAmount;
                self.paypayDTO.payMethod = @"AlipayQuick";
                
                [self payMethod:self.paypayDTO];
                
            }
            
            //使用微信支付
            if (isweChatPay == YES) {
                //微信支付
                
                self.paypayDTO = [[PayPayDTO alloc]init];
                
                self.paypayDTO.tradeNo = self.orderAddDTO.tradeNo;
                self.paypayDTO.useBalance = @"1";
                self.paypayDTO.balanceAmount = nil;
                self.paypayDTO.password = nil;
                self.paypayDTO.payAmount = self.orderAddDTO.totalAmount;
                self.paypayDTO.payMethod = @"WeChatMobile";
                [self payMethod:self.paypayDTO];
            }
            
        }
        
        //余额不足
        else
        {
            //不选择余额支付，只能使用微信或者支付宝支付宝
            if(isbalacnePay == NO)
            {
                self.paypayDTO = [[PayPayDTO alloc]init];
                self.paypayDTO.tradeNo = self.orderAddDTO.tradeNo;
                self.paypayDTO.useBalance = @"1";
                self.paypayDTO.balanceAmount = nil;
                self.paypayDTO.password = nil;
                self.paypayDTO.payAmount = self.orderAddDTO.totalAmount;
                if (isAliPay == YES) {
                    //支付宝支付
                    
                    self.paypayDTO.payMethod = @"AlipayQuick";
                    [self payMethod:self.paypayDTO];
                }else
                {
                    //微信支付
                    
                    self.paypayDTO.payMethod = @"WeChatMobile";
                    [self payMethod:self.paypayDTO];
                }
            }
            //混合支付
            else
            {
                //请求查询是否有支付密码
                [HttpManager sendHttpRequestForGetIsHasPaymentPassword:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    NSLog(@"dic = %@",dic);
                    
                    if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                        
                        
                        //弹窗显示支付密码
                      
                        BOOL isPayPassword;
                        NSString *pass = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                        
                        if ([pass isEqualToString:@"1"]) {
                            isPayPassword = YES;
                        }else{
                            isPayPassword = NO;
                        }
                        
                        if (isPayPassword == YES) {
                        
                            //如果有支付密码，弹出支付密码
                            CSPInputPasswordView *passwordView = [[[NSBundle mainBundle] loadNibNamed:@"CSPInputPasswordView" owner:self options:nil] objectAtIndex:0];
                            
//                            [self allowInteractionMethod];
                            
                            passwordView.delegate = self;
                            double otherPrice =     self.orderAddDTO.totalAmount.doubleValue-payBalanceDTO.availableAmount.doubleValue;
                            passwordView.MoneyLabel.text = [NSString stringWithFormat:@"￥%.2lf",payBalanceDTO.availableAmount.doubleValue];
                            //添加到根视图中
                            UIWindow *window = [UIApplication sharedApplication].keyWindow ;
                            passwordView.frame = window.frame;
                            [window addSubview:passwordView];
                            
                            //添加支付
                            self.paypayDTO = [[PayPayDTO alloc]init];
                            self.paypayDTO.tradeNo = self.orderAddDTO.tradeNo;
                            self.paypayDTO.useBalance = @"0";
                            self.paypayDTO.balanceAmount = payBalanceDTO.availableAmount;
                            self.paypayDTO.payAmount = nil;
                            
                            //判断支付方式
                            if (isAliPay == YES) {
                                self.paypayDTO.payMethod = @"AlipayQuick";
                            }
                            if(isweChatPay == YES ){
                                self.paypayDTO.payMethod = @"WeChatMobile";
                            }
                            //设置支付金额
                            self.paypayDTO.payAmount = [NSNumber numberWithDouble:otherPrice];
                        
                        }else{
                            
                            
                            CSPPayType type;
                            if (isAliPay == YES) {
                                type = CSPAliPay;
                            }else{
                                type = CSPWeChatPay;
                            }
                            
                            CSPSettingPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingPayPasswordViewController"];
                            nextVC.payType = type;
                            nextVC.orderAddDTO = self.orderAddDTO;
                            nextVC.payBalanceDTO = payBalanceDTO;
                            nextVC.isGoods = self.isGoods;
                            [self.navigationController pushViewController:nextVC animated:YES];
                        }
                        
                    }else{
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                }];
            }
        }
        
    }
    //无法用余额支付
    else
    {
        self.paypayDTO = [[PayPayDTO alloc]init];
        
        if (self.dic) {
            self.paypayDTO.tradeNo = self.dic[@"tradeNo"];
            self.paypayDTO.payAmount = self.dic[@"totalAmount"];
            
            
        }else
        {
            self.paypayDTO.tradeNo = self.orderAddDTO.tradeNo;
            self.paypayDTO.payAmount = self.orderAddDTO.totalAmount;

        }
        self.paypayDTO.useBalance = @"1";
        self.paypayDTO.balanceAmount = nil;
        self.paypayDTO.password = nil;
        
        if (isAliPay == YES) {
            //支付宝支付
            
            self.paypayDTO.payMethod = @"AlipayQuick";
            [self payMethod:self.paypayDTO];
        }else{
            //微信支付
            
            self.paypayDTO.payMethod = @"WeChatMobile";
            [self payMethod:self.paypayDTO];
        }
    }
    
    
}
- (void)resetBtn
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    }

#pragma  mark--
#pragma CSPInputViewDelegate

//使用代理传值
-(void)confirmClickedwithPassword:(NSString *)string
{
    
    self.paypayDTO.password = string;
    [self payMethod:self.paypayDTO];
}

/**
 *  忘记支付密码
 */
-(void)forgetPasswordClicked
{
    CSPSettingSafetyVerificationViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingSafetyVerificationViewController"];
    nextVC.changePassword = CSPForgetPayPassword;
    nextVC.account = account;
    [self.navigationController pushViewController:nextVC animated:YES];
    [self cspInputViewcancelSelfViewMethod];
    
}

/**
 *  取消或者删除本视图的时候允许所有按钮交互
 */
- (void)cspInputViewcancelSelfViewMethod
{
    [self allowInteractionMethod];
    
}

//调用第三方支付
-(void)payMethod:(PayPayDTO *)payPayDTO
{


    if( BCSHttpRequestParameterIsLack == [HttpManager sendHttpRequestForGetPayPay:payPayDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self allowInteractionMethod];

        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                
                /**
                 *  将支付获取到数据将其封装。1.支付结果：payStatus 2.在线支付方式:payMethod 3.AlipayQuickSignData: 签名数据 4.WeChatMobileSignData:签名数据
                 */
                GetPayPayDTO* getPayPayDTO = [[GetPayPayDTO alloc] init];
                
                [getPayPayDTO setDictFrom:[dic objectForKey:@"data"]];
                
                //余额支付
                if ([getPayPayDTO.payMethod isEqualToString:@"Balance"]) {
                    //判断支付结果
                    if (getPayPayDTO.payStatus == YES) {
                        //跳转到我的采购单页面
                        [self backToOrderViewControllerwith:CSPOrderModeAll];
                    }else
                    {
                        //余额支付失败
                        [self.view makeMessage:@"支付密码错误" duration:2.0f position:@"center"];

                    }
                
                  
                    //支付宝支付
                }else if([getPayPayDTO.payMethod isEqualToString:@"AlipayQuick"]){
                    
                    BOOL isAliInstalled;
                    
                    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];

                    isAliInstalled =[[UIApplication sharedApplication] canOpenURL:myURL_APP_A];
                    
                    if (isAliInstalled) {

                        if (alertView) {
                            [alertView removeFromSuperview];
                            
                        }
                        alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                            
                            
                            if (self.isAvailable) {
                                
                                if (self.isHomePage) {
                                    [self backRootViewController];
                                    
                                }else
                                {
//                                    [self backToOrderViewControllerwith:CSPOrderModeAll];
                                    [self backToOrderViewControllerwith:CSPOrderModeToDispatch];
                                    
                                }

                                
                            }else
                            {
                                [self.navigationController popViewControllerAnimated:YES];

                            }
                        } dismissAction:^{
                            
                            if (self.isAvailable) {
                                if (self.isHomePage) {
                                    [self backCSPVIPUpdateViewController];
                                    
                                }else
                                {
                                    [self backToOrderViewControllerwith:CSPOrderModeToPay];
                                    
                                }
                            }else{
                            [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        }];
                        [alertView show];
                    }
                    
                    
                    
                    
                    
                    
                    
                    NSString *appScheme = @"leftKey";
                    //调起支付宝支付
                    
                    [[AlipaySDK defaultService] payOrder:getPayPayDTO.AlipayQuickSignData fromScheme:appScheme callback:^(NSDictionary *resultDic) {

                        NSLog(@"memo = %@",resultDic[@"memo"]);
                        NSLog(@"    %@",resultDic);
                    

                        
                        if (self.dic) {
                            
                        }
                        
                        
                        if (!isAliInstalled) {
                            if (alertView) {
                                [alertView removeFromSuperview];
                                
                            }
                            
                            alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                                
                                
                                
                                if (self.isAvailable) {
                                    if (self.isHomePage) {
                                        [self backRootViewController];
                                        
                                    }else
                                    {
//                                        [self backToOrderViewControllerwith:CSPOrderModeAll];
                                        //跳转到待发货
                                        [self backToOrderViewControllerwith:CSPOrderModeToDispatch];
                                    }

                                }else
                                {
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                               
                                
                                
                            } dismissAction:^{
                                
                                
                                
                                
                                
                                if (self.isAvailable) {
                                    if (self.isHomePage) {
                                        [self backCSPVIPUpdateViewController];
                                        
                                    }else
                                    {
                                        [self backToOrderViewControllerwith:CSPOrderModeToPay];
                                        
                                    }
    
                                }else
                                {
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                                
                                
                            }];
                            [alertView show];
                        
                        }
                    
                    }];
                    
                }else{
                    
                    /**
                     *  微信支付
                     */

                    
                    if ([WXApi isWXAppInstalled]) {
                        
                 
                        //调起微信支付
                        WeChatMobilePayDTO *weChatDTO = [[WeChatMobilePayDTO alloc]init];
                        [weChatDTO setDictFrom:getPayPayDTO.WeChatMobileSignData];
                        PayReq *request = [[PayReq alloc]init];
                        request.openID  = weChatDTO.appId;
                        request.partnerId = weChatDTO.partnerId;
                        request.prepayId = weChatDTO.prepayId;
                        request.package = weChatDTO.package;
                        request.nonceStr = weChatDTO.nonceStr;
                        request.timeStamp = weChatDTO.timeStamp.intValue;
                        request.sign = weChatDTO.sign;
                        [WXApi sendReq:request];
                        
                        
                    }else{
                        
                         [self.view makeMessage:@"没有安装微信客户端" duration:2.0f position:@"center"];
                        
                        /**
                         *  没有安装客户端的时候也会调用这个方法
                         */
                        self.aliPayButton.enabled  = YES;
                        self.payButton.enabled = YES;
                        self.wechatPayButton.enabled = YES;
                        self.balanceButton.enabled = YES;

                        return ;
                    }
                }
                
            }
        }else if([[dic objectForKey:@"code"]isEqualToString:@"121"])
        {
            [self.view makeMessage:@"支付密码错误" duration:2.0f position:@"center"];
        }else if([[dic objectForKey:@"code"]isEqualToString:@"126"]){
            [self.view makeMessage:@"输入错误次数过多，请稍后再试" duration:2.0f position:@"center"];

        }else{
            [self.view makeMessage:@"支付失败" duration:2.0f position:@"center"];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        
        [self allowInteractionMethod];

    }])
    {
        NSLog(@"Parameter is lack\n");
    }
    
}

- (void)backCSPVIPUpdateViewController
{
    
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[CSPVIPUpdateViewController class]]) { //这里判断是否为你想要跳转的页面
            [self.navigationController popToViewController:controller animated:YES];
        }

    }
    
    
}

- (void)backRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
/**
 *  跳转到支付我的采购单
 *
 *
 */
-(void)backToOrderViewControllerwith:(CSPOrderMode)mode
{
    
//    CSPOrderViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPOrderViewController"];
//    nextVC.orderMode = mode;
//    [self.navigationController pushViewController:nextVC animated:YES];
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
    myOrderVC. currentOrderState = mode;
    if (self.isGoods) {
        myOrderVC.goodsShopping = @"shopping";
    }
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

/**
 *  通知调用的方法
 */
-(void)weChatPaySuccessMethod
{
    
    
    if (alertView) {
        [alertView removeFromSuperview];
        
    }
    alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        
        
        
        if (self.isAvailable) {
            
            
            if (self.isHomePage) {
                [self backRootViewController];
                
            }else
            {
//                [self backToOrderViewControllerwith:CSPOrderModeAll];
                //跳转到代发货列表
                [self backToOrderViewControllerwith:CSPOrderModeToDispatch];
                
                
            }
            
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } dismissAction:^{
        
        
        if (self.isAvailable) {
            if (self.isHomePage) {
                [self backCSPVIPUpdateViewController];
                
            }else
            {
                [self backToOrderViewControllerwith:CSPOrderModeToPay];
                
            }
            
            
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }];
    [alertView show];

    

    
    
//    NSString *tradeNo;
//    if (self.dic) {
//        tradeNo = self.dic[@"tradeNo"];
//        
//    }else
//    {
//        
//        tradeNo =self.orderAddDTO.tradeNo;
//    
//    }
//    
//    if (tradeNo && ![tradeNo isEqualToString:@""]) {
//        
//
//    [HttpManager sendHttpRequestForGetPaymentStatus:tradeNo payMethod:@"WeChatMobile"   success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        NSLog(@"***************dic = %@",dic);
//        if (self.dic) {
//            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//                NSDictionary *payDic = dic[@"data"];
////                if ([payDic[@"paymentStatus"]isEqualToString:@"true"]) {
////                    NSLog(@"********%d",true);
////                    NSLog(@"&&&&&&&&&%d",false);
////                    
//////                    self.payStatus(true);
////                    
////                }else
////                {
//////                    self.payStatus(false);
////    
////                }
//                
//                
//            }else{
//                
//                
//            }
//        }else
//        {
//            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//                
//                
//                
//            }else{
//                
//                
//            }
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
//}
}

//支付失败
- (void)weChatPayfailureMethod
{
    
    if (alertView) {
        [alertView removeFromSuperview];
        
    }
    alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        
        
        
        if (self.isAvailable) {
            
            
            if (self.isHomePage) {
                [self backRootViewController];
                
            }else
            {
//                [self backToOrderViewControllerwith:CSPOrderModeAll];
                [self backToOrderViewControllerwith:CSPOrderModeToDispatch];
                
                
            }
            
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } dismissAction:^{
        
        
        if (self.isAvailable) {
            if (self.isHomePage) {
                [self backCSPVIPUpdateViewController];
                
            }else
            {
                [self backToOrderViewControllerwith:CSPOrderModeToPay];
                
            }
            
            
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }];
    [alertView show];
    
}


/**
 *  返回到客户端调用此方法
 */
- (void)allowInteractionMethod
{
    self.aliPayButton.enabled  = YES;
    self.payButton.enabled = YES;
    self.wechatPayButton.enabled = YES;
    self.balanceButton.enabled = YES;
    
}



- (void)backBarButtonClick:(id)sender {
    

    if (self.isAvailable) {
        if (alertView) {
            [alertView removeFromSuperview];
            
        }
        alertView = [GUAAlertView alertViewWithTitle:@"确定放弃本次支付？" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"确定"  withOkButtonColor:nil cancelButtonTitle:@"取消"withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            //从商品加入采购车的时候。为YES 取消支付跳转到采购车CSPShoppingCartViewController
            if (self.isGoods) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    
                    if ([controller isKindOfClass:[CSPShoppingCartViewController class]]) {
                        
                        [self.navigationController popToViewController:controller animated:YES];
                        
                    }
                    
                }
}else
            {
            [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } dismissAction:^{
            
        }];
        [alertView show];
    }else
    {
        if (alertView) {
            [alertView removeFromSuperview];
            
        }
        alertView = [GUAAlertView alertViewWithTitle:@"确定放弃本次支付？" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"确定"  withOkButtonColor:nil cancelButtonTitle:@"取消"withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            //从商品加入采购车的时候。为YES 取消支付跳转到采购车CSPShoppingCartViewController
            if (self.isGoods) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    
                    if ([controller isKindOfClass:[CSPShoppingCartViewController class]]) {
                        
                        [self.navigationController popToViewController:controller animated:YES];
                        
                    }
                    
                }
            }else
            {
            [self.navigationController popViewControllerAnimated:YES];
            }
            
        } dismissAction:^{
            
         
        }];
        [alertView show];
    }
    
  
}

/**
 *  充值按钮触发地方方法
 *
 *  @param sender
 */
- (IBAction)chargeBalance:(id)sender {
    BalanceChargeViewController *balance =[[BalanceChargeViewController alloc] init];
    [self.navigationController pushViewController:balance animated:YES];
    

}
@end
