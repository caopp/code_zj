//
//  CSPChangePasswordViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPChangePasswordViewController.h"
#import "CSPChangePasswordSuccessViewController.h"
//改变颜色
#import "CustomButton.h"
#import "CustomTextField.h"
//对输入的电话号码、身份证等等进行校验
#import "CSPUtils.h"
#import "CSPChangePasswordView.h"
#define time 0.5
#define scrollViewLineLength 41
@interface CSPChangePasswordViewController ()<UITextFieldDelegate,CSPChangePasswordViewDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;
- (IBAction)showPasswordButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *showPasswordLabel;
@property (weak, nonatomic) IBOutlet CustomButton *commitButton;
- (IBAction)commitButtonClicked:(id)sender;

//设置视图背景scrollview
@property (strong,nonatomic)UIScrollView *scrollView;
//设置视图UI界面
@property (strong,nonatomic)CSPChangePasswordView *changePasswordView;


@end

@implementation CSPChangePasswordViewController

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.changePasswordView.secretTextField becomeFirstResponder];
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [self.changePasswordView.secretTextField becomeFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改登录密码";
    [self addCustombackButtonItem];
    //设置代理方法
    self.passwordTextField.delegate = self;
    self.againPasswordTextField.delegate = self;
    //密码显示的状态（开启和关闭状态）
    self.showPasswordButton.selected = YES;
    
    /**
     *  设置密码的属性
     */
    self.passwordTextField.secureTextEntry = NO;
    self.againPasswordTextField.secureTextEntry = NO;
    
    //设置UI
    [self makeUI];
    //设置文思视图隐藏
    [self hiddenView];
    
    

}
//对文思代码进行隐藏
-(void)hiddenView
{
    self.passwordTextField.hidden = YES;
    self.againPasswordTextField.hidden = YES;
    self.tipLabel.hidden = YES;
    self.showPasswordButton.hidden = YES;
    self.showPasswordLabel.hidden = YES;
    self.commitButton.hidden = YES;
}

#pragma mark ==================修改登录密码=======================
#pragma mark --------设置UI----------
-(void)makeUI
{
    //设置背景scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.scrollView];
    
    //添加手势（因为手写输入法中。屏蔽touchbegin方法，采用添加手势的方法）
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGr];
    
    //设置UI界面
    self.changePasswordView = [[CSPChangePasswordView alloc]initWithFrame:CGRectMake(48, 195, self.scrollView.frame.size.width - 96, 200)];
    self.changePasswordView.delegate = self;
    self.changePasswordView.secretTextField.delegate = self;
    self.changePasswordView.repeatSecretTextField.delegate = self;
    [self.scrollView addSubview:self.changePasswordView];
}
-(void)hideKeyboard
{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    
}



#pragma mark -------设置代理方法---------
-(void)submitNewSecretText:(NSString *)newSecretText repeatSecretText:(NSString *)repeatSecretText
{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    //密码是否为空进行判断
    [self checkEmptyNewSecret:newSecretText repeatSecret:repeatSecretText];
    
    //两次密码是否一致进行判断
    [self checkConsistentNewSecret:newSecretText repeatSecret:repeatSecretText];
    
    if (![self checkSecretSame]) {
        return;
    }
    if (![self checkSecreLenght]) {
        return;
    }
    
    self.changePasswordView.submitButton.enabled = NO;
    //进行网络请求
    NSString *mobilePhone = self.mobilePhone;
    NSString *type = @"1";          //0:注册 1:忘记密码
    [self requestNetWorkPassword:newSecretText type: type phone:mobilePhone];
}
#pragma mark -------对两次输入的密码进行判断-----------
-(BOOL)checkEmptyNewSecret:(NSString *)NewSecret repeatSecret:(NSString *)repeatSecret
{
    if (NewSecret.length<1||repeatSecret.length<1) {
        [self.view makeToast:@"密码不能为空" duration:2 position:@"center"];
        return NO;
    }
    return YES;
}
-(BOOL)checkConsistentNewSecret:(NSString *)NewSecret repeatSecret:(NSString *)repeatSecret
{
    if (![NewSecret isEqualToString:repeatSecret]) {
         [self.view makeToast:@"两次输入的密码不一致" duration:2 position:@"center"];
        return NO;
    }
    return YES;
}
#pragma mark------textField代理方法-----------
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.changePasswordView.secretTextField == textField) {
        NSLog(@"电话号码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength );
        }];
    }
    if (self.changePasswordView.repeatSecretTextField == textField) {
        
        NSLog(@"验证码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * 2);
        }];
        
    }
    return YES;
}

//#pragma mark ---------设置touchBegin-------
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//    [UIView animateWithDuration:time animations:^{
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//    }];
//
//}



-(BOOL)checkSecretSame
{
     if (![self.changePasswordView.secretTextField.text isEqualToString:self.changePasswordView.repeatSecretTextField.text]) {
     [self.view makeToast:@"两次输入的密码不一致" duration:2 position:@"center"];
         return NO;
     }
    
    
    return YES;
    
}

-(BOOL)checkSecreLenght
{
    
    if (![CSPUtils checkPassword:self.changePasswordView.secretTextField.text]||![CSPUtils checkPassword:self.changePasswordView.repeatSecretTextField.text] )
    {
    
        [self.view makeToast:@"登录密码格式错误" duration:2 position:@"center"];

        return NO;
    }
    return YES;
}


#pragma mark ----------设置网络请求-----------
-(void)requestNetWorkPassword:(NSString *)password type:(NSString *)type phone:(NSString *)phone
{
   
            //设置好的密码进行上传到服务器，通过返回code的值进行判断上传是否成功。
            [HttpManager sendHttpRequestForSetPasswordWithMobilePhone:phone password:password type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"dic = %@",dic);
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    

                    
                    //设置密码成功上传后，进行到下一个页面
                    CSPChangePasswordSuccessViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePasswordSuccessViewController"];
                    [self.navigationController pushViewController:nextVC animated:YES];
                    
                }else{
                    
                    /**
                     请求是否提示信息
                     */
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];

                    [alert show];
                }
                
                self.changePasswordView.submitButton.enabled = YES;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                
                self.changePasswordView.submitButton.selected = YES;
                self.changePasswordView.submitButton.enabled = YES;
                self.changePasswordView.submitButton.selected = NO;
                
            }];
            
    

}
//consistent
#pragma mark ==================修改登录密码分解线==================
////对键盘显示的判断
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self.passwordTextField becomeFirstResponder];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.passwordTextField resignFirstResponder];
//    [self.againPasswordTextField resignFirstResponder];
//}



////选择不同的textfield进行判断
//- (IBAction)showPasswordButtonClicked:(id)sender {
//    
//    if (self.passwordTextField.secureTextEntry == YES)
//    {
//        self.showPasswordButton.selected = YES;
//        self.passwordTextField.secureTextEntry = NO;
//        self.againPasswordTextField.secureTextEntry = NO;
//    }else
//    {
//        self.showPasswordButton.selected = NO;
//        self.passwordTextField.secureTextEntry = YES;
//        self.againPasswordTextField.secureTextEntry = YES;
//    }
//}
////提交设置的密码（假如两个密码的输入的不一致，提示信息，没有输入进行信息提示等等的判断）
//- (IBAction)commitButtonClicked:(id)sender {
//    
//    if (self.passwordTextField.text.length<1||self.againPasswordTextField.text.length<1) {
//         [self.view makeToast:@"密码不能为空" duration:2 position:@"center"];
//        return;
//    }
//    
//    if ([self.passwordTextField.text isEqualToString:self.againPasswordTextField.text]) {
//        
//        if ([CSPUtils checkPassword:self.passwordTextField.text]) {
//            NSString *mobilePhone = self.mobilePhone;
//            NSString *password  = self.passwordTextField.text;
//            NSString *type = @"1";          //0:注册 1:忘记密码
//            
//            //设置好的密码进行上传到服务器，通过返回code的值进行判断上传是否成功。
//            [HttpManager sendHttpRequestForSetPasswordWithMobilePhone:mobilePhone password:password type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//                
//                NSLog(@"dic = %@",dic);
//                
//                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//                    
//                    //设置密码成功上传后，进行到下一个页面
//                    CSPChangePasswordSuccessViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePasswordSuccessViewController"];
//                    [self.navigationController pushViewController:nextVC animated:YES];
//                    
//                    
//                }else{
//                    
//                    /**
//                     请求是否提示信息
//                     */
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    
//                    [alert show];
//                }
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//                NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
//                
//            }];
//        }else{
//            [self.view makeToast:@"密码格式错误" duration:2 position:@"center"];
//        }
//
//    }else{
//        [self.view makeToast:@"两次输入的密码不一致" duration:2 position:@"center"];
//    }
//}
//
//
#pragma mark--
#pragma UITextFieldDelegate（同样采用的是对输入textfield的值，来改变不同的frame的位置）
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
////    textField.keyboardType =UIKeyboardTypeASCIICapable;
////    
////    [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
////    [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//}
//
//
//
////touchbegin 来进行键盘的回收。
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    //    [self cancelLocatePicker];
//    [self.passwordTextField resignFirstResponder];
//    [self.againPasswordTextField resignFirstResponder];
//    
//}
@end
