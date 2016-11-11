//
//  BalanceChargeViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BalanceChargeViewController.h"

#import "HttpManager.h"
#import "PrepaidGoodsView.h"
#import "BalanceChangeBto.h"
#import "PrepaidGoodsMaxView.h"
#import "BankAndOhterPayController.h"
#import "Masonry.h"
#import "BankCardViewController.h"
#import "OrderAddDTO.h"
#import "CustomBarButtonItem.h"
#import "PromptChooseBankView.h"
#import "MembershipUpgradeViewController.h"
#import "PrepaiduUpgradeViewController.h"
#import "CSPPayAvailabelViewController.h"//支付
#import "CCWebViewController.h"
//#import "BalanceBTO.h"
@interface BalanceChargeViewController ()<PrepaidGoodsMaxDelegate,PrepaidGoodsDelegate,MembershipUpgradeViewControllerDelegate,CCWebViewControllerDelegate>
{
    CCWebViewController *cc;
    BOOL isPrepay;
}
@property (nonatomic ,strong) BalanceChangeBto *balanceDto;


@end

@implementation BalanceChargeViewController
-(void)viewWillAppear:(BOOL)animated
{

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    self.navigationController.navigationBar.translucent = NO;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    /************V1-V5************/
    /**************V6*************/
    self.view.backgroundColor = [UIColor whiteColor];
    
    //!导航
    self.title = @"预付货款充值";
    
    isPrepay = YES;

    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"会员等级" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [rightBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 60, 13);
    [rightBtn addTarget:self action:@selector(rightNavClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    
    [HttpManager sendHttpRequestForPaymentUpgradeListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"dic = %@", dic);
        
        BalanceChangeBto *balanceChange = [[BalanceChangeBto alloc] init];
        
        [balanceChange setDictFrom:dic[@"data"]];
        self.balanceDto = balanceChange;
        
        
        if ([balanceChange.level integerValue] == 6) {
            PrepaidGoodsMaxView *paidGoods = [[PrepaidGoodsMaxView alloc] init];
            paidGoods.delegate = self;
            paidGoods.balanceBto =balanceChange;
            [self.view addSubview:paidGoods];
            
            [paidGoods mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }else
        {
            PrepaidGoodsView *paidView = [[PrepaidGoodsView alloc] initWithFrame:self.view.frame BalanceDto:balanceChange];
            paidView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            paidView.delegate = self;
            [self.view addSubview:paidView];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //!点击空白收起键盘的事件
    [self addTapHideKeyBoard];
    
}

-(void)rightNavClick{
    
    
    //会员升级
    /*
    MembershipUpgradeViewController * membershipUpgradeVC = [[MembershipUpgradeViewController alloc]init];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    membershipUpgradeVC.delegate = self;
    [self.navigationController pushViewController:membershipUpgradeVC animated:YES];
    */
    
    //进行点击
    
    cc = [[CCWebViewController alloc]init];
//    cc.delegate = self;
    cc.isPrepay = isPrepay;
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    [self.navigationController pushViewController:cc animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -PrepaidGoodsMaxDelegate 
//V6时传过来价格
- (void)prepaidGoodsMaxMoney:(NSNumber *)money skuNO:(NSInteger)no
{
    BankAndOhterPayController *bankPay = [[BankAndOhterPayController alloc] init];
    bankPay.balanceDto = self.balanceDto;
    bankPay.skuLevel = no;
    
    bankPay.payLevel = [NSNumber numberWithInt:6];
    bankPay.payMoney = money;
    [self.navigationController pushViewController:bankPay animated:YES];
}

/**
 *  跳转到下一页面
 */
- (void)PrepaidGoodsMaxJumpVC:(NSNumber *)money skuNo:(NSInteger)no
{
    
    BankCardViewController *bankCar = [[BankCardViewController alloc] init];
    bankCar.balanceDto = self.balanceDto;
    bankCar.payMoney = money;
    bankCar.skuLevel = no;
    
    //允许更改价格
    bankCar.changeMoneyTF = YES;
    
    [self.navigationController pushViewController:bankCar animated:YES];
}
#pragma mark -PrepaidGoodsDelegate
/**
 *  V6以后选择次金额
 *
 *  @param level 等级
 *  @param money 金额
 *  @param no sku的对应的等级
 */
- (void)prepaidGoodsLevel:(NSNumber *)level topupMoney:(NSNumber *)money skuNo:(NSInteger)no
{
    
    [HttpManager sendHttpRequestForpaymentCheckMoneylevel:level amount:money success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
           NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);
        if ([dic[@"code"]isEqualToString:@"000"]) {
            BankAndOhterPayController *bankPay = [[BankAndOhterPayController alloc] init];
            bankPay.payLevel = level;
            bankPay.payMoney = money;
            bankPay.balanceDto = self.balanceDto;
            bankPay.skuLevel = no;

            [self.navigationController pushViewController:bankPay animated:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"操作失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"wqeweqw");
        
 
        
    }];

//
//    //根据钱数判断获取self.balanceBto.prepayListArr数组中的商品信息
//    NSInteger numb;
//    if (level.integerValue >=0) {
//        numb = 6- level.integerValue;
//        
//    }else
//    {
//        numb = self.balanceDto.prepayListArr.count;
//        
//    }
//    PrepayList *list = self.balanceDto.prepayListArr[numb];
//    //请求采购单
//    [HttpManager sendHttpRequestForaddVirtualOrder:[NSNumber numberWithInt:1] goodsNo:list.goodsNo.stringValue skuNo:list.skuNo.stringValue serviceType:[NSNumber numberWithInt:4] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//     
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//
//        DebugLog(@"dic = %@", dic);
//        if ([dic[@"CODE"] isEqualToString:@"000"]) {
//            OrderAddDTO *orderDto = [[OrderAddDTO alloc] init];
//            [orderDto setDictFrom:[dic objectForKey:@"data"]];
//            
//            
//
//        }
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        
//        
//    }];

    
    
  }


/**
 *  跳转到下一页面
 */
- (void)PrepaidGoodsJumpVCMoney:(NSNumber *)money skuNo:(NSInteger)no
{
    
    BankCardViewController *bankCar = [[BankCardViewController alloc] init];
    bankCar.balanceDto = self.balanceDto;
    //允许更改价格
    bankCar.changeMoneyTF = YES;
    bankCar.payMoney = money;
    bankCar.skuLevel = no;
    
    
    [self.navigationController pushViewController:bankCar animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark 会员等级的代理方法
//会员升级（会员想要升级，调起下面的代理方法，进行参数传递）
-(void)jumpToPayInterfaceDic:(NSDictionary *)dic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];


    CSPPayAvailabelViewController *payAvailabelViewC = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
    payAvailabelViewC.dic = dic;
    
    [self.navigationController pushViewController:payAvailabelViewC animated:YES];
    
}
//返回上一层
-(void)backEliminateTheController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
