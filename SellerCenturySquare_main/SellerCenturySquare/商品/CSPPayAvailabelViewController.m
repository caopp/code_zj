//
//  CSPPayAvailabelViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPayAvailabelViewController.h"
#import "GetPayPayDTO.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "CSPOrderViewController.h"
#import "WeChatMobilePayDTO.h"
#import "GUAAlertView.h"


@interface CSPPayAvailabelViewController ()<WXApiDelegate>

{    GUAAlertView *alertView ;
    PayPayDTO *paypayDTO_;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollowVie;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *payValueView;
@property (weak, nonatomic) IBOutlet UILabel *paytitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payValueLabel;
@property (weak, nonatomic) IBOutlet UIView *balanceView;
@property (weak, nonatomic) IBOutlet UIImageView *balanceImageView;
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *balanceButton;
- (IBAction)balanceButtonClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdPayConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdPadHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *thirdPayView;
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;
- (IBAction)aliPayButtonClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *wechatPayButton;
- (IBAction)wechatPayButtonClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UILabel *balancePayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdPayLabel;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
- (IBAction)payButtonClicked:(UIButton *)sender;

@property (nonatomic,strong)PayPayDTO *paypayDTO;

@end

@implementation CSPPayAvailabelViewController
@synthesize isAvailable = isAvailable_,paypayDTO = paypayDTO_;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"支付";
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    
    self.isAvailable = NO;
    
    [self setUI];
}
- (void)backBarButtonClick:(UIBarButtonItem *)sender

{
    if (alertView) {
        [alertView removeFromSuperview];
        
    }
    alertView = [GUAAlertView alertViewWithTitle:@"确定放弃本次支付？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
    [self.navigationController popViewControllerAnimated:YES];
    
    
} dismissAction:^{
    
}];
    
    [alertView show];
    
}

- (void)setUI
{
    self.payValueLabel.text =  [NSString stringWithFormat:@"%@",self.orderAddDTO.totalAmount.stringValue];

    self.balanceView.hidden = YES;
    self.thirdPayConstraint.constant = 10;
    self.thirdPadHeightConstraint.constant = 1000;
    self.payButton.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}


- (IBAction)balanceButtonClicked:(UIButton *)sender {

    
}
- (IBAction)aliPayButtonClicked:(UIButton *)sender {

    self.payButton.enabled = YES;
    sender.selected = YES;
    self.wechatPayButton.selected = NO;
    
    
}
- (IBAction)wechatPayButtonClicked:(UIButton *)sender {
    
    self.payButton.enabled = YES;
    sender.selected = YES;
    self.aliPayButton.selected = NO;
    
}

- (IBAction)payButtonClicked:(UIButton *)sender {


    
    BOOL isAliPay = NO;
    
    BOOL isweChatPay = NO;
    

    if (self.aliPayButton.selected == YES) {
        isAliPay = YES;
    }
    if (self.wechatPayButton.selected == YES) {
        isweChatPay = YES;
    }
    

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
        }else{
            //微信支付
            
            self.paypayDTO.payMethod = @"WeChatMobile";
            [self payMethod:self.paypayDTO];
        }

    
    
}


-(void)payMethod:(PayPayDTO *)payPayDTO
{
    //    payPayDTO.tradeNo = @"sM000000053-1442387701230";
    //    payPayDTO.useBalance = @"0";
    //    payPayDTO.balanceAmount = [[NSNumber alloc] initWithDouble:405.0];
    //    payPayDTO.password = @"";
    //    payPayDTO.payMethod = nil;
    //    payPayDTO.payAmount = nil;
    //payPayDTO.payAmount =[[NSNumber alloc] initWithDouble:405.0];
    
//    payPayDTO.payAmount = [[NSNumber alloc]initWithDouble:0.01];
    
    
    [self progressHUDShowWithString:@"支付中"];
    
    if( BCSHttpRequestParameterIsLack == [HttpManager sendHttpRequestForGetPayPay:payPayDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        DebugLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetPayPayDTO* getPayPayDTO = [[GetPayPayDTO alloc] init];
                
                [getPayPayDTO setDictFrom:[dic objectForKey:@"data"]];
              
                
                if([getPayPayDTO.payMethod isEqualToString:@"AlipayQuick"]){
                    NSString *appScheme = @"leftKey2";
                    [[AlipaySDK defaultService] payOrder:getPayPayDTO.AlipayQuickSignData fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        
                        
                        if (alertView) {
                            [alertView removeFromSuperview];
                            
                        }
                        
                        alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            
                        } dismissAction:^{
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }];
                        
                        [alertView show];

                        
                    }];
                    
                }else{
                    
                    /**
                     *  微信支付
                     */

                    if ([WXApi isWXAppInstalled]) {
                        
                 
 
                        
                        
                        
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
                        
                        
                        if (alertView) {
                            [alertView removeFromSuperview];
                            
                        }
                        
                        alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            
                        } dismissAction:^{
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }];
                        
                        [alertView show];
                    }else{
                        [self alertViewWithTitle:@"付款失败" message:@"没有安装最新的微信客户端"];
                        return ;
                    }
                }
                
            }
        }else{
            
            [self alertViewWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"]];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
        
        DebugLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        
    }]){
        
        DebugLog(@"Parameter is lack\n");
    }
}


-(void) onReq:(BaseReq*)req
{
    DebugLog(@"***REQ");
}



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    DebugLog(@"***RESP");
 
}



@end
