//
//  CSPInputPayPasswordViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPInputPayPasswordViewController.h"
#import "CSPSettingSafetyVerificationViewController.h"
#import "CSPSettingsTextField.h"
#import "PayPayDTO.h"
#import "GetPayPayDTO.h"
#import "CSPOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WeChatMobilePayDTO.h"
#import "WXApi.h"
#import "Masonry.h"
#import "GUAAlertView.h"
#import "MyOrderViewController.h"

@interface CSPInputPayPasswordViewController ()<UITextFieldDelegate>
{
    NSString *account;
    NSString *recordTextField;
    
}

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet CSPSettingsTextField *passwrodTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *forgetLabel;
@property (strong,nonatomic)PayPayDTO *paypayDTO;

@end

@implementation CSPInputPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"输入支付密码";
    
    //设置返回按钮
    [self addCustombackButtonItem];
    //设置按钮边框
    self.commitButton.layer.cornerRadius = 3.0f;
    self.commitButton.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    self.commitButton.enabled = NO;

    //显示要支付的签署
    self.secondLabel.text = [NSString stringWithFormat:@"￥%@", [CSPUtils stringFromNumber:self.orderAddDTO.totalAmount]];
    //支付密码设置代理
    self.passwrodTextField.delegate = self;
    //设置键盘样式
    self.passwrodTextField.keyboardType = UIKeyboardTypePhonePad;
    
      self.passwrodTextField.secureTextEntry = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetpasswordLabelTaped:)];
    [self.forgetLabel addGestureRecognizer:tap];
    self.forgetLabel.userInteractionEnabled = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *accuntArray = [userDefaults arrayForKey:@"myArray"];
    
    if (accuntArray != nil) {
        account = accuntArray[0];
    }
    
    
    //!轻击收起键盘
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideTap];
    

}
-(void)hideKeyBoard{

    [self.view endEditing:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //添加通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatPaySuccessMethod) name:@"weChatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayfailureMethod) name:@"weChatPayfailure" object:nil];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"backToOrderViewController" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"weChatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"weChatPayfailure" object:nil];
    

    
}



//确认支付按钮
- (IBAction)commitButtonClicked:(id)sender {
    [self    hideKeyBoard];
    
    //提示确认支付
    GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定支付?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        
        self.paypayDTO = [[PayPayDTO alloc]init];
        self.paypayDTO.tradeNo = self.orderAddDTO.tradeNo;
        
        self.paypayDTO.useBalance = @"0";
        self.paypayDTO.balanceAmount = self.payBalanceDTO.availableAmount;
        
        
        self.paypayDTO.password = self.passwrodTextField.text;
        
        if (self.payType == CSPPayNone)
        {
            self.paypayDTO.payMethod = nil;
            
        }else if(self.payType == CSPAliPay)
        {
            self.paypayDTO.payMethod = @"AlipayQuick";
            
        }else
        {
            self.paypayDTO.payMethod = @"WeChatMobile";
        }
        
        self.paypayDTO.payAmount = [NSNumber numberWithDouble:self.orderAddDTO.totalAmount.doubleValue-self.payBalanceDTO.availableAmount.doubleValue];
        
        [self payMethod:self.paypayDTO];

        
    } dismissAction:^{
        
        
      
        
    }];
    
    [alertView show];
    

    
}



-(void)forgetpasswordLabelTaped:(UITapGestureRecognizer *)gesture{
    CSPSettingSafetyVerificationViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingSafetyVerificationViewController"];
    nextVC.changePassword = CSPForgetPayPassword;
    nextVC.account = account;
    [self.navigationController pushViewController:nextVC animated:YES];
}


#pragma mark --



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"%@",textField.text);
//    NSLog(@"length = %lu-location = %lu",(unsigned long)range.length,range.location);
    
    
  
    
//根据range.length判断 0添加 1 删除
    if (range.length == 0) {
        
        //判断是否已经输入6个字符
        if (self.passwrodTextField.text.length>=5) {
            //如果输入改变按钮的状态和颜色
            self.commitButton.enabled = YES;
            self.commitButton.backgroundColor = [UIColor blackColor];
        }
        else{//貌似else没有用到
            
            //如果没有依旧这样
            self.commitButton.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
            self.commitButton.enabled = NO;
            
        }
        
        //如果超过12位的话 提示不能超过12位
        if (self.passwrodTextField.text.length==12) {
            
           
            GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"支付密码不得超过12位" withMessageColor:nil oKButtonTitle:@"" withOkButtonColor:nil cancelButtonTitle:@"确定" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
            } dismissAction:^{
                
            }];
            [alertView show];
            
            
            
            
            //return NO表示不进入输入框
            return NO;
        }
        
        

    }else
    {
        //删除的时候判断是否为6个字母 如果为6个字符 则执行完这个操作就输入框变成5个字符了。。 所以要改变颜色和状态
        
        if (self.passwrodTextField.text.length==6) {
            self.commitButton.enabled = NO;
            self.commitButton.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
        }
        

    }
  
       return YES;
}

//将要弹出键盘的时候 设置键盘样式
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    
    textField.keyboardType =UIKeyboardTypeASCIICapable;

}

//允许编辑
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
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
    
    
    if( BCSHttpRequestParameterIsLack == [HttpManager sendHttpRequestForGetPayPay:payPayDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetPayPayDTO* getPayPayDTO = [[GetPayPayDTO alloc] init];
                
                [getPayPayDTO setDictFrom:[dic objectForKey:@"data"]];
                
                
                if ([getPayPayDTO.payMethod isEqualToString:@"Balance"]) {
                    if (getPayPayDTO.payStatus == YES) {
                        
                        
                        [self.view makeMessage:@"支付成功" duration:2 position:@"center"];
                        
                        //!2秒后跳转到待发货列表
                        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backToOrder) userInfo:nil repeats:NO];
                        
                        
                    
                    }else
                    {
                        //余额支付失败
                        
                         [self.view makeMessage:@"支付密码错误"  duration:2.0f position:@"center"];
                        
                       
                    }
                    
                }else if([getPayPayDTO.payMethod isEqualToString:@"AlipayQuick"]){
                    
                    BOOL isAliInstalled;
                    
                    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
                    
                    isAliInstalled =[[UIApplication sharedApplication] canOpenURL:myURL_APP_A];
                    if (isAliInstalled) {
//                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否支付成功?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//                        
//                        [alertView show];
                        
                        GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"否" withOkButtonColor:nil cancelButtonTitle:@"是" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                            
                            [self backToOrderViewControllerwith:CSPOrderModeToPay];

                            
                        } dismissAction:^{
                            [self backToOrderViewControllerwith:CSPOrderModeAll];

                            
                        }];
                        [alertView show];
                    }
                    
                    NSString *appScheme = @"leftKey";
                    [[AlipaySDK defaultService] payOrder:getPayPayDTO.AlipayQuickSignData fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
//                        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                        if (!isAliInstalled) {
                            GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"否" withOkButtonColor:nil cancelButtonTitle:@"是" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                                
                                [self backToOrderViewControllerwith:CSPOrderModeToPay];
                                
                                
                            } dismissAction:^{
                                [self backToOrderViewControllerwith:CSPOrderModeAll];
                                
                                
                            }];
                            [alertView show];
                        }
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
                    }else{
                        
                          [self.view makeMessage:@"没有安装微信客户端"  duration:2.0f position:@"center"];
                       
                        return ;
                    }
                }
                
            }
        }else if([[dic objectForKey:@"code"]isEqualToString:@"121"])
        {
            
             [self.view makeMessage:@"支付密码错误"  duration:2.0f position:@"center"];
        }else if([[dic objectForKey:@"code"]isEqualToString:@"126"]){
            [self.view makeMessage:@"输入错误次数过多，请稍后再试"  duration:2.0f position:@"center"];

        }else{
             [self.view makeMessage:@"支付失败"  duration:2.0f position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }])
    {
        NSLog(@"Parameter is lack\n");
    }
    
}

-(void)backToOrderViewControllerwith:(CSPOrderMode)mode
{
//    CSPOrderViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPOrderViewController"];
//    nextVC.orderMode = mode;
//    [self.navigationController pushViewController:nextVC animated:YES];
    
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
    myOrderVC.currentOrderState = mode;
    if (self.isGoods) {
    myOrderVC.goodsShopping = @"shopping";
    }

    [self.navigationController pushViewController:myOrderVC animated:YES];
    
    
}

/**
 *  通知调用调用的方法
 */
-(void)weChatPaySuccessMethod
{
    GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"否" withOkButtonColor:nil cancelButtonTitle:@"是" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self backToOrderViewControllerwith:CSPOrderModeToPay];
        
        
    } dismissAction:^{
        [self backToOrderViewControllerwith:CSPOrderModeAll];
        
        
    }];
    [alertView show];

    
    
    [HttpManager sendHttpRequestForGetPaymentStatus:self.orderAddDTO.tradeNo payMethod:@"WeChatMobile"   success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
        }else{
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
//    [self backToOrderViewController];
}

//!支付成功，进入待发货列表
-(void)backToOrder{

    [self backToOrderViewControllerwith:CSPOrderModeToDispatch];
}


- (void)weChatPayfailureMethod
{
    
    GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:@"是否支付成功?" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"否" withOkButtonColor:nil cancelButtonTitle:@"是" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self backToOrderViewControllerwith:CSPOrderModeToPay];
        
        
    } dismissAction:^{
        [self backToOrderViewControllerwith:CSPOrderModeAll];
        
        
    }];
    [alertView show];

}


-(void)allowInteractionMethod
{
    
}


@end
