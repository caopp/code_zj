//
//  CSPSecurityCheckViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPSecurityCheckViewController.h"
#import "CSPChangePwdViewController.h"
#import "CustomTextField.h"
#import "CustomButton.h"
#import "CSPLoginViewController.h"
#import "CustomBarButtonItem.h"
#import "CSPNavigationController.h"
#import "SecurityCheckView.h"
#import "JKCountDownButton.h"

/**
 *  设置弹出显示的信息
 */
#import "Toast+UIView.h"
#import "CSPUtils.h"
#import "UIColor+UIColor.h"
#import "MyUserDefault.h"
#define LGNOClickColor [UIColor colorWithHexValue:0xffffff alpha:0.3] //线条颜色
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条
#define LGButtonColor [UIColor colorWithHexValue:0xffffff alpha:0.7]  //点击后线条

//#define time 0.5
#define FRAMR_Y_FOR_KEYBOARD_SHOW   (-70)
#define time 0.5
#define scrollViewLineLength 41
static NSTimeInterval timeInterval = 1;
@interface CSPSecurityCheckViewController ()<UITextFieldDelegate,SecurityCheckViewDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (strong,nonatomic)NSTimer *countdownTimer;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (weak, nonatomic) IBOutlet CustomButton *nextStepButton;

- (IBAction)getVerificationCodeButtonClick:(id)sender;
- (IBAction)nextButtonClick:(id)sender;
- (IBAction)backBarButtonClick:(id)sender;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//重新设置UI
@property(strong,nonatomic)SecurityCheckView *securityCheckView;
//设置背景scrollview
@property(strong,nonatomic)UIScrollView *scrollView;

@end

@implementation CSPSecurityCheckViewController{
    NSInteger _countdownTime;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    //进行判断
//    if (self.phoneNumTextField.text.length == 0) {
//        [self.phoneNumTextField becomeFirstResponder];
//    }
    
    
    
    [self addCustombackButtonItem];
    self.tabBarController.tabBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}



/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    CustomBarButtonItem *backBarButton = [[CustomBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"安全校验";

      self.centerView.backgroundColor = [UIColor clearColor];
    //对文思代码进行隐藏
    [self hiddenView];
    //重新对代码进行设置
    [self makeUI];
    //页面显示
    if (self.securityCheckView.phoneTextField.text.length == 0) {
        [self.securityCheckView.phoneTextField becomeFirstResponder];
    }

}

#pragma mark ================对文思代码处理========================================
//对文思代码进行隐藏
-(void)hiddenView
{
    self.phoneNumTextField.hidden = YES;
    self.verificationCodeTextField.hidden = YES;
    self.getVerificationCodeButton.hidden = YES;
    self.centerView.hidden = YES;
    self.nextStepButton.hidden = YES;
}
-(void)makeUI
{
    //对视图背景的设置
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.scrollView];
    
    //添加手势（不用touchbegin，点击scrollview回到原来的位置）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTheOriginalLocation)];
    [self.scrollView addGestureRecognizer:tapGesture];
    
    //添加视图（视图上显示UI控件）
    self.securityCheckView = [[SecurityCheckView alloc]initWithFrame:CGRectMake(48, 195, self.view.frame.size.width - 96, 200)];
    self.securityCheckView.delegate = self;
    self.securityCheckView.phoneTextField.delegate = self;
    self.securityCheckView.codeTextField.delegate = self;
    [self.scrollView addSubview:self.securityCheckView];
    
}

#pragma mark-----------增加手势，scrollview返回原始位置-----------
-(void)backTheOriginalLocation
{
    [self.view endEditing:YES];
    //self.scrollView返回原来的位置
    [UIView animateWithDuration:time animations:^{
       
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
    }];
}
#pragma mark------textField代理方法-----------
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.securityCheckView.phoneTextField == textField) {
        NSLog(@"电话号码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength );
        }];
    }
    if (self.securityCheckView.codeTextField == textField) {
        NSLog(@"验证码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * 2);
        }];
    }
    return YES;
}
#pragma mark =======forgetPassWordView代理方法========
//倒计时代理方法
-(BOOL)countdownActionPhoneText:(NSString *)phoneText countdownButton:(JKCountDownButton *)codeButton
{
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    //对键盘进行隐藏
    [self.securityCheckView.phoneTextField resignFirstResponder];
    [self.securityCheckView.codeTextField resignFirstResponder];
    //对手机号码进行校验
    [self checkPhone:phoneText];
    if (![self checkPhone:phoneText]) {
        return NO;
    }
    
    codeButton.enabled = NO;
    //进行验证码邀请（短信校验验证码成功后进行的下一步操作）
    [self requestPhoneNumberCountdown:phoneText type:@"3" countdownButton:codeButton];
    
    return YES;
}
//校验手机号码
-(BOOL)checkPhone:(NSString *)phone
{
    if ([phone isEqualToString:@""]) {
        [self.view makeToast:@"手机号码不能为空" duration:2 position:@"center"];
        return NO;
    }
    if (![CSPUtils checkMobileNumber:phone]) {
        [self.view makeToast:@"手机号码格式错误" duration:2 position:@"center"];
        return NO;
    }
    return YES;
}

#pragma mark--------进行邀请码邀请验证--------
-(void)requestPhoneNumberCountdown:(NSString *)phone type:(NSString *)type countdownButton:(JKCountDownButton *)countdownButton
{
    [self.securityCheckView.phoneTextField resignFirstResponder];
    [self.securityCheckView.codeTextField resignFirstResponder];
    
    [HttpManager sendHttpRequestForSendSmsWithPhone:phone type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
                        //button type要 设置成custom 否则会闪动
                        [countdownButton startWithSecond:60];
                        [countdownButton setTitle:@"剩余60秒" forState:UIControlStateNormal];
            
                        // 单独的对秒数倒计时进行 封装一个类（经典案例）JKCountDownButton
                        [countdownButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                            return title;
                        }];
                        [countdownButton setTitle:@"剩余60秒" forState:UIControlStateNormal];
                        [countdownButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                            countDownButton.enabled = YES;
                            return @"点击重新获取";
                        }];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.view makeToast:[NSString stringWithFormat:@"已向您的手机%@发送验证码",self.securityCheckView.phoneTextField.text] duration:2 position:@"center"];
                        self.securityCheckView.nextButton.backgroundColor = [UIColor clearColor];
        }else{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                        self.securityCheckView.nextButton.backgroundColor = LGNOClickColor;
                        [self.view makeToast:@"手机号没有注册" duration:2 position:@"center"];
        }
        countdownButton.enabled = YES;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
        countdownButton.enabled = YES;

    }];
}


//进行下一步按钮
-(BOOL)nextActionPhoneText:(NSString *)phoneText CodeText:(NSString *)codeText
{
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];

    //对手机号码进行校验
    [self.securityCheckView.phoneTextField resignFirstResponder];
    [self.securityCheckView.codeTextField resignFirstResponder];
    if (![self checkPhone:phoneText]) {
        return NO;
    }
    
    self.securityCheckView.nextButton.enabled = NO;
    self.securityCheckView.nextButton.selected = YES;
    
    //下一步按钮进行操作（先对验证码和电话号码进行校验）
    [self checkVerificationPhone:phoneText type:@"3" code:codeText];
    
    return YES;
}


//校验验证码
-(void)checkCode:(NSString *)code
{
    if ([code isEqualToString:@""]) {
        [self.view makeToast:@"验证码不能为空" duration:2 position:@"center"];
        return;
    }
}
#pragma mark -----------对验证码和电话号码进行验证--------
-(void)checkVerificationPhone:(NSString *)phone type:(NSString *)type code:(NSString *)code
{
   
    //安全校验验证码是否正确
    [self progressHUDShowWithString:@"验证中"];
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:phone type:type smsCode:code success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.progressHUD hide:YES];
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            //验证成功进入下一个页面以及把电话号码传递给下一个页面
            CSPChangePwdViewController *changePwdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePwdViewController"];
            changePwdViewController.phoneNum = self.securityCheckView.phoneTextField.text;
            
            [self.navigationController pushViewController:changePwdViewController animated:YES];
            //保存电话号码
            [MyUserDefault defaultSaveAppSetting_phone:self.phoneNumTextField.text];
            
        }else{
            
            [self.view makeToast:@"验证码有误" duration:2.0f position:@"center"];
        }
        
        self.securityCheckView.nextButton.enabled = YES;
        self.securityCheckView.nextButton.selected = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.securityCheckView.nextButton.enabled = YES;
        self.securityCheckView.nextButton.selected = NO;
        [self tipRequestFailureWithErrorCode:error.code];

    }];
    
}

#pragma mark ================对文思代码处理分界线===================================


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-获取验证码倒计时
- (void)countdownTimerAction:(NSTimer *)timer{
    
    //    self.getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _countdownTime--;
    if (_countdownTime>=0) {
        self.getVerificationCodeButton.titleLabel.text = [NSString stringWithFormat:@"        %ld秒",(long)_countdownTime];
        
        
        
        //         self.adressTextView.font = [UIFont systemFontOfSize:13];
        
        
        
        //        self.getVerificationCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        //
        //        self.getVerificationCodeButton.selected = YES;
    }else{
        //暂停计时器
        [self.countdownTimer setFireDate:[NSDate distantFuture]];
        
        //开启获取验证码按钮
        self.getVerificationCodeButton.enabled = YES;
        
        _countdownTime = 61;
        
        self.getVerificationCodeButton.titleLabel.text = @"获取验证码";
    }
}
/**
 *  对手机号码进行检验
 */
-(BOOL)verityPhoneNum
{
    if (self.phoneNumTextField.text.length == 0) {
        [self.view makeToast:@"手机号码有误" duration:2.0f position:@"center"];
        return NO;
    }
    if (![CSPUtils  checkMobileNumber:self.phoneNumTextField.text]) {
        [self.view makeToast:@"手机号码有误" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}
/**
 * 对验证码进行判断
 */
-(BOOL)verityCode
{
    if (self.verificationCodeTextField.text.length == 0 && self.verificationCodeTextField.text.length > 6) {
        [self.view makeToast:@"验证码有误" duration:2.0f position:@"center"];
        return  NO;
    }
    return YES;
}

#pragma mark
- (IBAction)getVerificationCodeButtonClick:(id)sender {
    
    /**
     *  键盘进行隐藏
     */
    [self.phoneNumTextField resignFirstResponder];
    
    /**
     *  如果是没有注册的手机号，提示“手机号码有误”
     */
    if (![self verityPhoneNum]) {
        return;
    }
    
    [self progressHUDShowWithString:@"获取中"];
    //先禁用获取验证码
    [HttpManager sendHttpRequestForSendSmsWithPhone:self.phoneNumTextField.text type:@"3" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.progressHUD hide:YES];
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        DebugLog(@"responseDic = %@", responseDic);
        /**
         *  判断手机有没有注册，如果没有注册，提示手机号码有误
         * isRequestSuccessWithCode通过这个方法进行判断是否有没有注册
         */
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            //手机注册成功，计时器开始计时
            /**
             *  计时器
             */
            _countdownTime = 61;
            self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(countdownTimerAction:) userInfo:nil repeats:YES];
            [self.countdownTimer setFireDate:[NSDate distantFuture]];
            //启动计时器
            [self.countdownTimer setFireDate:[NSDate distantPast]];
            //注册成功，按钮变化颜色
            self.nextStepButton.selected = YES;
            self.nextStepButton.backgroundColor = [UIColor clearColor];
            
        }else{
            /**
             *  手机没有进行注册，出现的提示信息hu
             */
            [self.view makeToast:[responseDic objectForKey:ERRORMESSAGE] duration:2.0f position:@"center"];
            self.nextStepButton.enabled = NO;
            self.nextStepButton.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:0.3];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        /**
         *  判断网络连接状态
         */
        [self tipRequestFailureWithErrorCode:error.code];
    }];
}

#pragma mark-下一步
- (IBAction)nextButtonClick:(id)sender {
    
    /**
     * 先进行验证校验
     */
    
    //再次对输入的电话号码进行校验
    if (![self verityPhoneNum]) {
        return;
    }
    //再次对验证码进行核对
    if (![self verityCode]) {
        return;
    }
    
    //安全校验验证码是否正确
    [self progressHUDShowWithString:@"验证中"];
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:self.phoneNumTextField.text type:@"3" smsCode:self.verificationCodeTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.progressHUD hide:YES];
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"responseDic = %@", responseDic);
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            //验证成功进入下一个页面以及把电话号码传递给下一个页面
            CSPChangePwdViewController *changePwdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePwdViewController"];
            changePwdViewController.phoneNum = self.phoneNumTextField.text;
            [self.navigationController pushViewController:changePwdViewController animated:YES];
            //保存电话号码
            [MyUserDefault defaultSaveAppSetting_phone:self.phoneNumTextField.text];
            
        }else{
            [self.view makeToast:@"验证码有误" duration:2.0f position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
    }];
}
//- (IBAction)backBarButtonClick:(id)sender {
//
//     CSPLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPLoginViewController"];
//    [self.navigationController popToViewController:loginVC animated:YES];
//
//}



#pragma UITextFieldDelegate(点击textfield对frame的大小进行改变)
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.verificationCodeTextField) {
        [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.verificationCodeTextField) {
        [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
}

- (void)animationForContentView:(CGRect)rect{
    
    NSTimeInterval animationDuration = time;
    
    [UIView beginAnimations:@"contentViewResizeAnimation" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
}

@end
