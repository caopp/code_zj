//
//  CSPSafetyVerificationViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/2/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSafetyVerificationViewController.h"
#import "CSPChangePasswordViewController.h"
#import "JKCountDownButton.h"
#import "CustomButton.h"
#import "CustomTextField.h"
#import "CSPUtils.h"
#import "CustomBarButtonItem.h"
#import "ForgetPasswordView.h"
#define time 0.5
#define scrollViewLineLength 41
@interface CSPSafetyVerificationViewController ()<UITextFieldDelegate,ForgetPasswordViewDelegate>
{
    BOOL isRegister;
}
- (IBAction)getCodeButtonClicked:(JKCountDownButton *)sender;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeButton;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet CustomTextField *codeTextField;
@property (weak, nonatomic) IBOutlet CustomButton *nextButton;

//设置显示的UI界面
@property (strong, nonatomic)ForgetPasswordView *forgetPassWordView;
//设置背景是scrollview
@property (strong,nonatomic)UIScrollView *scrollView;
- (IBAction)nextButtonClicked:(id)sender;

@end

@implementation CSPSafetyVerificationViewController

/**
 *   主要密码进行找回（密码进行找回的前提是账号已经注册成功，如果没有注册成功，点击下一步提示是）
 */

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"安全校验";

    [self addCustombackButtonItem];
    /**
     *  uitextField代理方法
     */
    self.phoneNumberTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.getCodeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.getCodeButton.layer.borderWidth = 1;
    self.getCodeButton.layer.cornerRadius = 3.0f;
    self.getCodeButton.alpha = 0.7f;
    self.nextButton.enabled = NO;
    
    //设置显示UI界面
    [self setUIPage];
    
    //文思代码进行隐藏
    [self hiddenCode];
}

//文思版本进行隐藏
-(void)hiddenCode
{    
    self.getCodeButton.hidden = YES;
    self.phoneNumberTextField.hidden = YES;
    self.codeTextField.hidden = YES;
    self.nextButton.hidden = YES;
}

//设置显示的UI界面
-(void)setUIPage
{
    //设置背景为scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.scrollView];
    //添加手势（因为手写输入法中。屏蔽touchbegin方法，采用添加手势的方法）
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    //设置忘记密码验证页面
    self.forgetPassWordView = [[ForgetPasswordView alloc]initWithFrame:CGRectMake(48, 195, self.view.frame.size.width - 96, 200)];
    self.forgetPassWordView.delegate = self;
    self.forgetPassWordView.phoneTextField.delegate = self;
    self.forgetPassWordView.codeTextField.delegate = self;
    [self.scrollView addSubview:self.forgetPassWordView];
    
}

#pragma mark =======forgetPassWordView代理方法========

-(void)hideKeyboard
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

//倒计时代理方法
-(void)countdownActionPhoneText:(NSString *)phoneText countdownButton:(JKCountDownButton *)codeButton
{
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    //对手机号码进行校验
    [self checkPhone:phoneText];
    
    
    
    //进行验证码邀请（短信校验验证码成功后进行的下一步操作）
    [self requestPhone:phoneText type:@"2" countdownButton:codeButton];
    
}


//进行下一步按钮
-(void)nextActionPhoneText:(NSString *)phoneText CodeText:(NSString *)codeText
{
    
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    
    self.forgetPassWordView.nextButton.enabled = NO;
    self.forgetPassWordView.nextButton.selected = YES;
    [self requestPhone:phoneText type:@"2" code:codeText];
}
//对手机号码和验证码进行校验
-(void)checkCode:(NSString *)code phone:(NSString *)phone
{
    //对手机号码进行校验
    [self checkPhone:phone];
}

//校验手机号码
-(void)checkPhone:(NSString *)phone
{
    if ([phone isEqualToString:@""]) {
        
        [self.view makeToast:@"手机号码不能为空" duration:2 position:@"center"];
        return;
    }
    
    if (![CSPUtils checkMobileNumber:phone]) {
        [self.view makeToast:@"手机号码格式错误" duration:2 position:@"center"];
        return;
    }


}
//校验验证码
-(void)checkCode:(NSString *)code
{
    if ([code isEqualToString:@""]) {
        [self.view makeToast:@"验证码不能为空" duration:2 position:@"center"];
        return;
    }
}
#pragma mark------textField代理方法-----------
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.forgetPassWordView.phoneTextField == textField) {
        NSLog(@"电话号码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength );
        }];
    }
    if (self.forgetPassWordView.codeTextField == textField) {
        NSLog(@"验证码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * 2);
        }];
    }
    return YES;
}

//#pragma mark----------对电话号码进行校验（判断是否注册过或者是没有注册过）------------
//-(void)checkPhone:(NSString *)phone type:(NSString *)type CodeText:(NSString *)codeText
//{
//    [HttpManager sendHttpRequestForSendSmsWithPhone:phone type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.progressHUD hide:YES];
//        NSDictionary *responseDic = [self conversionWithData:responseObject];
//        DebugLog(@"responseDic = %@", responseDic);
//        /**
//         *  判断手机有没有注册，如果没有注册，提示手机号码有误
//         * isRequestSuccessWithCode通过这个方法进行判断是否有没有注册
//         */
//        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
//            NSLog(@"短信校验验证码成功");
//            self.forgetPassWordView.nextButton.backgroundColor = [UIColor clearColor];
//            //下一步按钮成功
//            [self requestPhone:phone type:@"2" code:self.forgetPassWordView.codeTextField.text];
//
//        }else{
//            self.forgetPassWordView.nextButton.backgroundColor = LGNOClickColor;
//            NSLog(@"短信校验验证不成功");
//            [self.view makeToast:@"手机号码有误" duration:2 position:@"center"];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
//    }];
//}

#pragma mark--------进行邀请码邀请验证--------
-(void)requestPhone:(NSString *)phone type:(NSString *)type countdownButton:(JKCountDownButton *)countdownButton
{
    
    
    [self.forgetPassWordView.phoneTextField resignFirstResponder];
    [self.forgetPassWordView.codeTextField resignFirstResponder];

    [HttpManager sendHttpRequestForSendSmsWithPhone:phone type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
        
            countdownButton.enabled = NO;
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
            [self.view makeToast:[NSString stringWithFormat:@"已向您的手机%@发送验证码",self.forgetPassWordView.phoneTextField.text] duration:2 position:@"center"];
            
            self.forgetPassWordView.nextButton.backgroundColor = [UIColor clearColor];
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.forgetPassWordView.nextButton.backgroundColor = [UIColor clearColor];
           self.forgetPassWordView.nextButton.backgroundColor = LGNOClickColor;
          [self.view makeToast:@"手机号没有注册" duration:2 position:@"center"];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
    }];
}

#pragma mark -----------对验证码和电话号码进行验证--------
-(void)requestPhone:(NSString *)phone type:(NSString *)type code:(NSString *)code
{
    
    
         [self.forgetPassWordView.phoneTextField resignFirstResponder];
         [self.forgetPassWordView.codeTextField resignFirstResponder];
         
         [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:phone type:type smsCode:code success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

             NSLog(@"dic = %@",dic);
             
             if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                 
                 CSPChangePasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePasswordViewController"];
                 nextVC.mobilePhone = self.forgetPassWordView.phoneTextField.text;
                 [self.navigationController pushViewController:nextVC animated:YES];
                 
             }
             if (self.forgetPassWordView.codeTextField.text.length == 0) {
                 [self.view makeToast:@"验证码不能为空" duration:2 position:@"center"];
                 
             }else{
                 [self.view makeToast:[NSString stringWithFormat:@"%@",dic[@"errorMessage"]] duration:2 position:@"center"];
                 
             }
             
             self.forgetPassWordView.nextButton.enabled = YES;
             self.forgetPassWordView.nextButton.selected = NO;

             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
             [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
             self.forgetPassWordView.nextButton.enabled = YES;
             self.forgetPassWordView.nextButton.selected = NO;
         }];
    

         
    

    }

#pragma mark ========新视图分界线============
/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.phoneNumberTextField becomeFirstResponder];
    [self.forgetPassWordView.phoneTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.phoneNumberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}


//请求邀请码
- (IBAction)getCodeButtonClicked:(JKCountDownButton *)sender {
    
    /**
     *  请求的时候进行对输出文字进行提示
     */
    if ([self.phoneNumberTextField.text isEqualToString:@""]) {
         [self.view makeToast:@"手机号码不能为空" duration:2 position:@"center"];
        return;
    }

    if (![CSPUtils checkMobileNumber:self.phoneNumberTextField.text]) {
         [self.view makeToast:@"手机号码格式错误" duration:2 position:@"center"];
        return;
    }
    
        NSString *phone = self.phoneNumberTextField.text;
        NSString *type = @"2";
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /**
     *  进行数据请求（验证码进行请求）
     */
        [HttpManager sendHttpRequestForSendSmsWithPhone:phone type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"dic = %@",dic);
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                sender.enabled = NO;
                //button type要 设置成custom 否则会闪动
                
                [sender startWithSecond:60];
                [sender setTitle:@"剩余60秒" forState:UIControlStateNormal];
                
                // 单独的对秒数倒计时进行 封装一个类（经典案例）JKCountDownButton
                
                [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                    return title;
                }];
                [sender setTitle:@"剩余60秒" forState:UIControlStateNormal];
                [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    return @"点击重新获取";
                    
                }];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.nextButton.enabled = YES;
                [self.view makeToast:@"验证码已发送" duration:2 position:@"center"];
                
                self.nextButton.enabled = YES;
                self.nextButton.backgroundColor = [UIColor clearColor];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.nextButton.enabled = NO;
                [self.view makeToast:@"手机号码有误" duration:2 position:@"center"];
                self.nextButton.backgroundColor = LGNOClickColor;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
        }];
}




//下一步
- (IBAction)nextButtonClicked:(id)sender {
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:self.phoneNumberTextField.text type:@"2" smsCode:self.codeTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
    
            CSPChangePasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePasswordViewController"];
            nextVC.mobilePhone = self.phoneNumberTextField.text;
            [self.navigationController pushViewController:nextVC animated:YES];
            
        }
        if (self.forgetPassWordView.codeTextField.text.length == 0) {
            
            [self.view makeToast:@"验证码不能为空" duration:2 position:@"center"];
 
        }else{
            
             [self.view makeToast:@"验证码有误" duration:2 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
    }];
}



#pragma UITextFieldDelegate(点击textfield对frame的大小进行改变)
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

/**
 *  进行键盘的回收
 */
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self.phoneNumberTextField resignFirstResponder];
//    [self.codeTextField resignFirstResponder];
//    
//}


@end
