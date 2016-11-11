//
//  CSPChangePwdViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPChangePwdViewController.h"
#import "CSPPwdModificationViewController.h"
#import "MyUserDefault.h"
#import "Toast+UIView.h"
#import "CustomButton.h"
#import "ChangePwdView.h"
#import "CSPUtils.h"
@interface CSPChangePwdViewController ()<UITextFieldDelegate,ChangePwdViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *displayPwdButton;


@property (strong, nonatomic) IBOutlet UILabel *passwordDescribeLabel;
@property (strong, nonatomic) IBOutlet UILabel *showPasswordLabel;

@property (strong, nonatomic) IBOutlet CustomButton *submitButton;


//显示UI视图
@property (strong, nonatomic) ChangePwdView *changePwdView;
//显示scrollview
@property (strong, nonatomic) UIScrollView *scrollView;


//#define time 0.5
#define FRAMR_Y_FOR_KEYBOARD_SHOW   (-70)

#define time 0.5
#define scrollViewLineLength 41
- (IBAction)displayPwdButtonClick:(id)sender;
- (IBAction)submitButtonClick:(id)sender;

@end

@implementation CSPChangePwdViewController{
    BOOL _isDisplayPwd;
}

//默认显示光标
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nowPwdTextField becomeFirstResponder];
    
    if (self.isOK == YES) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明.png"] forBarMetrics:UIBarMetricsDefault];
        
        NSShadow* shadow = [[NSShadow alloc]init];
        
        shadow.shadowColor = [UIColor clearColor];
        
        shadow.shadowOffset = CGSizeMake(0, 0);
        
        NSDictionary* attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]};
        
        self.navigationController.navigationBar.titleTextAttributes = attributes;
        
        [self.navigationController.navigationBar setTintColor:LGNOClickColor];
        
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                forBarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
        
        
        //设置导航栏线体的颜色
        UILabel *navLineLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        navLineLabel.backgroundColor = LGNOClickColor;
        [self.navigationController.navigationBar addSubview:navLineLabel];
        
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"修改登录密码";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    //对文思代码进行隐藏
    [self hiddenWENSICodeUI];
    //重新编辑代码
    [self makeUI];
    
    
}
#pragma mark----------------------对文思代码进行隐藏--------------------------
//对文思代码进行隐藏
-(void)hiddenWENSICodeUI
{
    
    self.nowPwdTextField.hidden = YES;
    self.pwdTextField.hidden = YES;
    self.displayPwdButton.hidden = YES;
    self.passwordDescribeLabel.hidden = YES;
    self.showPasswordLabel.hidden = YES;
    self.submitButton.hidden = YES;

}

//重新编辑代码
-(void)makeUI
{

    //设置scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.scrollView];
    
    //添加手势（因为手写输入法中。屏蔽touchbegin方法，采用添加手势的方法）
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    tapGr.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGr];

    
    //设置UI界面
    self.changePwdView = [[ChangePwdView alloc]initWithFrame:CGRectMake(48, 195, self.scrollView.frame.size.width - 96, 200)];
    self.changePwdView.delegate = self;
    self.changePwdView.secretTextField.delegate = self;
    self.changePwdView.repeatSecretTextField.delegate = self;
    [self.scrollView addSubview:self.changePwdView];
    self.changePwdView.submitButton.selected = YES;
    [self.changePwdView.secretTextField becomeFirstResponder];

}
#pragma mark========================重新设置代码================================
//添加手势方法
-(void)hideKeyboard{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}
#pragma mark------textField代理方法-----------
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.changePwdView.secretTextField == textField) {
        NSLog(@"电话号码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength );
        }];
    }
    if (self.changePwdView.repeatSecretTextField == textField) {
        
        NSLog(@"验证码");
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * 2);
        }];
        
    }
    return YES;
}



#pragma mark-------------视图代理方法--------------------
-(void)submitNewSecretText:(NSString *)newSecretText repeatSecretText:(NSString *)repeatSecretText
{
    
//    //判断网络状态
//    if (![self isConnecNetWork]) {
//        [self progressHUDHiddenWidthString:@"请检查您的网络状态"];
//        return;
//    }
    
    //密码是否为空进行判断
//    [self checkEmptyNewSecret:newSecretText repeatSecret:repeatSecretText];
   

    //网络请求，进行密码输入，提交新密码
    [self submitSecret:newSecretText  repeatSecretText:repeatSecretText];
    
    //提交进行键盘的隐藏
    [self.changePwdView.secretTextField resignFirstResponder];
    [self.changePwdView.repeatSecretTextField resignFirstResponder];
    [self.view endEditing:YES];
    
    
}
-(BOOL)checkSecretSame
{
    if (![self.changePwdView.secretTextField.text isEqualToString:self.changePwdView.repeatSecretTextField.text]) {
        [self.view makeToast:@"两次输入的密码不一致" duration:2 position:@"center"];
        return NO;
    }
    
    
    return YES;
    
}
-(BOOL)checkSecreLenght
{
    if (![CSPUtils checkPassword:self.changePwdView.secretTextField.text]||![CSPUtils checkPassword:self.changePwdView.repeatSecretTextField.text] )
    {
        
        [self.view makeToast:@"请输入正确密码格式" duration:2 position:@"center"];
        
        return NO;
    }
    return YES;
}


#pragma mark -----------------进行网络请求（提交新输入的密码）---------------------
-(void)submitSecret:(NSString *)newSecretText  repeatSecretText:(NSString *)repeatSecretText
{
    
    if (newSecretText.length<1 || repeatSecretText.length<1) {
        
        [self progressHUDHiddenWidthString:@"请输入密码"];
        
        return;
    }
 
    if (![self checkSecretSame]) {
        return;
    }
    
    if (![self checkSecreLenght]) {
        return;
    }
    
    self.changePwdView.submitButton.enabled = NO;
    if (self.isOK == YES) {
        
        [HttpManager sendHttpRequestForLoginPasswordWithMobilePhone:[MyUserDefault defaultLoadAppSetting_phone] passwd:newSecretText type:@"1" Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self.progressHUD hide:YES];
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                //操作成功
                CSPPwdModificationViewController *pwdModificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPwdModificationViewController"];
                
                pwdModificationViewController.iseEnter = self.isOK;
                
                pwdModificationViewController.phoneNumber = self.phoneNum;
                
                pwdModificationViewController.loginPassword = self.changePwdView.secretTextField.text;
                
                [self.navigationController pushViewController:pwdModificationViewController animated:YES];
                
                //保存密码
                [MyUserDefault defaultSaveAppSetting_password:self.nowPwdTextField.text];
            }else{
                
//                [self alertViewWithTitle:@"修改失败" message:[responseDic objectForKey:ERRORMESSAGE]];
                
            }
            
            self.changePwdView.submitButton.enabled = YES;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.changePwdView.submitButton.enabled = YES;
            [self tipRequestFailureWithErrorCode:error.code];
            
        }];
        
    }else
    {
        
        [HttpManager sendHttpRequestForLoginPasswordWithMobilePhone:self.phoneNum passwd:newSecretText type:@"1" Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.progressHUD hide:YES];
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
//            self.changePwdView.submitButton.selected = YES;

            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                //操作成功
                CSPPwdModificationViewController *pwdModificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPwdModificationViewController"];
                
                pwdModificationViewController.phoneNumber = self.phoneNum;
                
                pwdModificationViewController.loginPassword = self.changePwdView.secretTextField.text;
                
                [self.navigationController pushViewController:pwdModificationViewController animated:YES];
                
                //保存密码
                [MyUserDefault defaultSaveAppSetting_password:self.nowPwdTextField.text];
            }else{
                
//                [self alertViewWithTitle:@"修改失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            }
            self.changePwdView.submitButton.enabled = YES;

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            self.changePwdView.submitButton.selected = YES;

            [self tipRequestFailureWithErrorCode:error.code];
            self.changePwdView.submitButton.enabled = YES;

            
        }];
        
        
    }


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


#pragma mark========================重新设置代码分界线===========================
- (void)leftBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//

//#pragma mark-显示密码
//- (IBAction)displayPwdButtonClick:(id)sender {
//    
//    //判断有没有输入密码
//    _isDisplayPwd = !_isDisplayPwd;
//    
//    if (_isDisplayPwd) {
//        
//        [self.pwdTextField setSecureTextEntry:NO];
//        
//        [self.nowPwdTextField setSecureTextEntry:NO];
//        
//        [self.displayPwdButton setImage:[UIImage imageNamed:@"03_商家商品详情页_选中"] forState:UIControlStateNormal];
//    }else{
//        
//        [self.nowPwdTextField setSecureTextEntry:YES];
//        
//        [self.pwdTextField setSecureTextEntry:YES];
//        
//        [self.displayPwdButton setImage:[UIImage imageNamed:@"03_商家商品详情页_未选中"] forState:UIControlStateNormal];
//    }
//}
//
//#pragma mark-设置密码
//- (IBAction)submitButtonClick:(id)sender {
//    
////    [self progressHUDShowWithString:@"修改中"];
//    
//    //判断网络状态
//    if (![self isConnecNetWork]) {
//        
//        [self progressHUDHiddenWidthString:@"请检查您的网络状态"];
//        
//        return;
//    }
//    
//    if (self.nowPwdTextField.text.length<1 || self.pwdTextField.text.length<1) {
//        
//        [self progressHUDHiddenWidthString:@"请输入密码"];
//        
//        return;
//    }
//    if (![self.nowPwdTextField.text isEqualToString:self.pwdTextField.text]) {
////         [self progressHUDHiddenWidthString:@"密码不一致"];
//        [self.view makeToast:@"密码不一致" duration:2 position:@"center"];
//        return;
//    }
//    
//    
//    if (self.isOK == YES) {
//        
//        [HttpManager sendHttpRequestForLoginPasswordWithMobilePhone:[MyUserDefault defaultLoadAppSetting_phone] passwd:self.nowPwdTextField.text type:@"1" Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            [self.progressHUD hide:YES];
//            
//            NSDictionary *responseDic = [self conversionWithData:responseObject];
//            
//            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
//                
//                //操作成功
//                CSPPwdModificationViewController *pwdModificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPwdModificationViewController"];
//                pwdModificationViewController.iseEnter = self.isOK;
//                
//                pwdModificationViewController.phoneNumber = self.phoneNum;
//                
//                pwdModificationViewController.loginPassword = self.nowPwdTextField.text;
//                
//                [self.navigationController pushViewController:pwdModificationViewController animated:YES];
//                
//                //保存密码
//                [MyUserDefault defaultSaveAppSetting_password:self.nowPwdTextField.text];
//            }else{
//                
//                [self alertViewWithTitle:@"修改失败" message:[responseDic objectForKey:ERRORMESSAGE]];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            [self tipRequestFailureWithErrorCode:error.code];
//            
//        }];
//  
//    }else
//    {
//    
//        [HttpManager sendHttpRequestForLoginPasswordWithMobilePhone:self.phoneNum passwd:self.nowPwdTextField.text type:@"1" Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            [self.progressHUD hide:YES];
//            
//            NSDictionary *responseDic = [self conversionWithData:responseObject];
//            
//            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
//                
//                //操作成功
//                CSPPwdModificationViewController *pwdModificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPwdModificationViewController"];
//                
//                pwdModificationViewController.phoneNumber = self.phoneNum;
//                
//                pwdModificationViewController.loginPassword = self.nowPwdTextField.text;
//                
//                [self.navigationController pushViewController:pwdModificationViewController animated:YES];
//                
//                //保存密码
//                [MyUserDefault defaultSaveAppSetting_password:self.nowPwdTextField.text];
//            }else{
//                
//                [self alertViewWithTitle:@"修改失败" message:[responseDic objectForKey:ERRORMESSAGE]];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            [self tipRequestFailureWithErrorCode:error.code];
//            
//        }];
//
//    
//    }
//    
//    
//
//}
//
//#pragma mark-UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}
//
//
//- (void)animationForContentView:(CGRect)rect{
//    
//    NSTimeInterval animationDuration = time;
//    
//    [UIView beginAnimations:@"contentViewResizeAnimation" context:nil];
//    
//    [UIView setAnimationDuration:animationDuration];
//    
//    self.view.frame = rect;
//    
//    [UIView commitAnimations];
//}
//#pragma UITextFieldDelegate(点击textfield对frame的大小进行改变)
//
//#pragma UITextFieldDelegate(点击textfield对frame的大小进行改变)
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    
//    if (textField == self.pwdTextField) {
//        
//        [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
//
//    }
//   }
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField == self.pwdTextField) {
//        [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    }
//}
//
//
//
//
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
////    [self.view endEditing:YES];
//
//    [self.nowPwdTextField resignFirstResponder];
//    
//    [self.pwdTextField resignFirstResponder];
//}
@end
