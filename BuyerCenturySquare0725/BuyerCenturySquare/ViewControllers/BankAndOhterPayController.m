//
//  BankAndOhterPayController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BankAndOhterPayController.h"
#import "BankAndOhterPayView.h"
#import "BankCardViewController.h"
#import "OrderAddDTO.h"
#import "PayPayDTO.h"
#import "GetPayPayDTO.h"
#import "GUAAlertView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WeChatMobilePayDTO.h"
#import "CustomBarButtonItem.h"
#import "CSPPayAvailabelViewController.h"
#import "MembershipUpgradeViewController.h"


@interface BankAndOhterPayController ()<BankAndOhterPayDelegate ,MembershipUpgradeViewControllerDelegate>
{
    GUAAlertView *alertView;
    
}

@property (nonatomic ,strong) PayPayDTO *paypayDTO;

@property (nonatomic ,strong) BankAndOhterPayView *bankView;

@end

@implementation BankAndOhterPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];

    self.title = @"支付";

 //   BankAndOhterPayView *otherView = [[BankAndOhterPayView alloc] init];
   // [self.view addSubview:otherView];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"BankAndOhterPayView"
                            
                                                         owner:nil                                                               options:nil];
    BankAndOhterPayView *bankView = [nibContents lastObject];
    bankView.delegate = self;
    self.bankView = bankView;
    bankView.payMoney = self.payMoney;
    self.view = bankView;
    
  

    // Do any additional setup after loading the view.
}

//直接到银行转账
- (void)bankAndOhterPayJumpVC
{
    BankCardViewController *bankCar = [[BankCardViewController alloc] init];
    bankCar.balanceDto = self.balanceDto;
    bankCar.skuLevel = self.skuLevel;
    bankCar.payMoney = self.payMoney;
    
    [self.navigationController pushViewController:bankCar animated:YES];
}
/**
 *  支付宝或微信支付
 */
- (void)bankAndOhterPayMethodPayment:(NSString *)method
{
    
    //1。先生成采购单
        //根据钱数判断获取self.balanceBto.prepayListArr数组中的商品信息
        NSInteger numb;
//        if (self.payLevel.integerValue >=0) {
//            numb = 6- self.payLevel.integerValue;
//    
//        }else
//        {
//            numb = self.balanceDto.prepayListArr.count;
//    
//        }

//        PrepayList *list = self.balanceDto.prepayListArr[numb];
    PrepayList *list ;
    for (PrepayList *pricelist in self.balanceDto.prepayListArr) {
        if (pricelist.level.integerValue == self.skuLevel) {
            list = pricelist;
        }
    }
    if (!list ) {
        list = [self.balanceDto.prepayListArr lastObject];
    }
    
    //充值类型 4-预付款会员升级 5-自定义预付货款
    NSInteger serviceType = 5;
    if (self.skuLevel == -1) {
        serviceType = 5;
    }else
    {
        serviceType = 4;
    }
    
    
    
    NSString *goodsNo = [NSString stringWithFormat:@"%@",list.goodsNo];
    NSString *skuNo  =[NSString stringWithFormat:@"%@",list.skuNo];
    //1.请求采购单

    [HttpManager sendHttpRequestForaddVirtualOrder:[NSNumber numberWithInt:1] goodsNo:goodsNo skuNo:skuNo serviceType:[NSNumber numberWithInteger:serviceType] depositAmount:self.payMoney success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        DebugLog(@"dic = %@", dic);
        if ([dic[@"code"] isEqualToString:@"000"]) {
            //2。调起起支付接口

            OrderAddDTO *orderDto = [[OrderAddDTO alloc] init];
            
            [orderDto setDictFrom:[dic objectForKey:@"data"]];
            self.paypayDTO = [[PayPayDTO alloc] init];
            self.paypayDTO.tradeNo = orderDto.tradeNo;
            self.paypayDTO.payAmount = orderDto.totalAmount;
            self.paypayDTO.useBalance = @"1";
            self.paypayDTO.balanceAmount = nil;
            self.paypayDTO.password = nil;
            self.paypayDTO.payMethod  = method;
            [self payMethod:self.paypayDTO];
            
            
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    //3。判断支付是否成功
    
}
//调用第三方支付
-(void)payMethod:(PayPayDTO *)payPayDTO
{
    
    
    if( BCSHttpRequestParameterIsLack == [HttpManager sendHttpRequestForGetPayPay:payPayDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
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
//                        //跳转到我的采购单页面
//                        [self backToOrderViewControllerwith:CSPOrderModeAll];
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
                        //是否支付成功
                        [self payFinishedpop_up];
                    }
                    
                    
                    
                    
                    
                    
                    
                    NSString *appScheme = @"leftKey";
                    //调起支付宝支付
                    
                    [[AlipaySDK defaultService] payOrder:getPayPayDTO.AlipayQuickSignData fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"memo = %@",resultDic[@"memo"]);
                        NSLog(@"    %@",resultDic);
                    
                        
                        
                        
                        
                        if (!isAliInstalled) {
                            //是否支付成功
                            [self payFinishedpop_up];
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
//                        self.aliPayButton.userInteractionEnabled  = YES;
//                        self.payButton.userInteractionEnabled = YES;
//                        self.wechatPayButton.userInteractionEnabled = YES;
//                        self.balanceButton.userInteractionEnabled = YES;
                        
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
    }])
    {
        NSLog(@"Parameter is lack\n");
    }
    
}
- (void)weChatPayfailureMethod
{
    
    [self  payFinishedpop_up];
    
//    alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
//        
//        
//        
//        [self backRootViewController];
//        
//    } dismissAction:^{
//        
//        
//        [self backRootViewController];
//        
//        
//    }];
//    [alertView show];

}
- (void)weChatPaySuccessMethod
{
    
    [self payFinishedpop_up];
    
//    alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
//        
//        
//        
//        [self backRootViewController];
//        
//    } dismissAction:^{
//        
//        
//        [self backRootViewController];
//        
//        
//    }];
//    [alertView show];

}

- (void)viewWillAppear:(BOOL)animated
{
    /**
     *  微信支付成功或失败回执行这个方法
     */
    
    self.bankView.confirmPayBtn.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatPaySuccessMethod) name:@"weChatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayfailureMethod) name:@"weChatPayfailure" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"weChatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"weChatPayfailure" object:nil];
}

- (void)backRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//支付完成以后寻问是否支付成功
- (void)payFinishedpop_up
{
    alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil  withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self backRootViewController];
    } dismissAction:^{
        
        MembershipUpgradeViewController  * member = [[MembershipUpgradeViewController alloc]init];
        member.delegate = self;
        //跳转到根试图控制器
        member.markRootVC = YES;
        
        
        [self.navigationController pushViewController:member animated:YES];
        
        
        
    }];
    [alertView show];
    
}


//会员升级（会员想要升级，调起下面的代理方法，进行参数传递）
-(void)jumpToPayInterfaceDic:(NSDictionary *)dic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    CSPPayAvailabelViewController *payAvailabelViewC = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
    payAvailabelViewC.dic = dic;
    
    [self.navigationController pushViewController:payAvailabelViewC animated:YES];
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
