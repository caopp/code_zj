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
/**
 *  设置弹出显示的信息
 */
#import "Toast+UIView.h"
#import "CSPUtils.h"
#import "UIColor+UIColor.h"
#define LGNOClickColor [UIColor colorWithHexValue:0xffffff alpha:0.3] //线条颜色
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条
#define LGButtonColor [UIColor colorWithHexValue:0xffffff alpha:0.7]  //点击后线条

#define time 0.5
#define FRAMR_Y_FOR_KEYBOARD_SHOW   (-70)
static NSTimeInterval timeInterval = 1;
@interface CSPSecurityCheckViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (strong,nonatomic)NSTimer *countdownTimer;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (weak, nonatomic) IBOutlet CustomButton *nextStepButton;

- (IBAction)getVerificationCodeButtonClick:(id)sender;
- (IBAction)nextButtonClick:(id)sender;
- (IBAction)backBarButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation CSPSecurityCheckViewController{
    NSInteger _countdownTime;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        //进行判断
        if (self.phoneNumTextField.text.length == 0) {
            [self.phoneNumTextField becomeFirstResponder];
        }
  
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.centerView.backgroundColor = [UIColor clearColor];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark-获取验证码倒计时
- (void)countdownTimerAction:(NSTimer *)timer{
    _countdownTime--;
    if (_countdownTime>=0) {
        self.getVerificationCodeButton.titleLabel.text = [NSString stringWithFormat:@" %ld 秒钟",(long)_countdownTime];
        
        self.getVerificationCodeButton.selected = YES;
    }else{
        //暂停计时器
        [self.countdownTimer setFireDate:[NSDate distantFuture]];
        
        //开启获取验证码按钮
        self.getVerificationCodeButton.enabled = YES;
        
        _countdownTime = 60;
        
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
        _countdownTime = 60;
        self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(countdownTimerAction:) userInfo:nil repeats:YES];
        [self.countdownTimer setFireDate:[NSDate distantFuture]];
            //启动计时器
        [self.countdownTimer setFireDate:[NSDate distantPast]];
        //注册成功，按钮变化颜色
            self.nextStepButton.selected = YES;
            self.nextStepButton.backgroundColor = [UIColor clearColor];
            
        }else{
            /**
             *  手机没有进行注册，出现的提示信息
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
        
        }else{
            [self.view makeToast:@"验证失败" duration:2.0f position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [self tipRequestFailureWithErrorCode:error.code];
    }];
}


- (IBAction)backBarButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}







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
