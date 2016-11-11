//
//  CSPSettingChangePasswordViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSettingChangePasswordViewController.h"
#import "CSPPasswordSuccessedViewController.h"
#import "CSPSettingsTextField.h"
#import "CSPUtils.h"
@interface CSPSettingChangePasswordViewController ()<UITextFieldDelegate>

//第一个输入框
@property (weak, nonatomic) IBOutlet CSPSettingsTextField *orginalPasswordTextField;
//第二个输入框
@property (weak, nonatomic) IBOutlet CSPSettingsTextField *secongPasswordTextField;

//显示密码
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;
- (IBAction)showPasswordButtonClicked:(id)sender;
//修改登录密码和支付密码
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;



@end

@implementation CSPSettingChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustombackButtonItem];
 

    self.nextButton.enabled = NO;
    self.nextButton.backgroundColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    
    switch (self.changePassword) {
            
        case CSPChangeLoginPassword:
            
            self.title = NSLocalizedString(@"changeloginPwd",  @"修改登录密码") ;
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"修改") forState:UIControlStateNormal];
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"修改") forState:UIControlStateHighlighted];

            [self.nextButton setTitle:NSLocalizedString(@"change", @"修改") forState:UIControlStateSelected];

            self.buttonConstraint.constant = 8;
            self.labelConstraint.constant = 11;
            self.warningLabel.hidden = YES;
     

            
            break;
        
            
        case CSPResetPayPassword:
            
            self.title = NSLocalizedString(@"changePayPwd",  @"修改支付密码") ;

            self.orginalPasswordTextField.placeholder = NSLocalizedString(@"insertOldPayPwd", @"请输入原支付密码");
            self.secongPasswordTextField.placeholder = NSLocalizedString(@"insertNewPayPwd", @"请输入新支付密码");
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"提交") forState:UIControlStateNormal];
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"提交") forState:UIControlStateHighlighted];
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"提交") forState:UIControlStateSelected];
            
            
            
            
            break;
        
        case CSPForgetPayPassword:
            
            self.title = NSLocalizedString(@"forgetPayPwd", @"忘记支付密码") ;
            
            self.orginalPasswordTextField.placeholder = NSLocalizedString(@"newPayPwd",@"新密码") ;
            self.secongPasswordTextField.placeholder = NSLocalizedString(@"reNewPayPwd",@"重复输入新密码") ;
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"提交") forState:UIControlStateNormal];
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"提交") forState:UIControlStateHighlighted];
            
            [self.nextButton setTitle:NSLocalizedString(@"change", @"提交") forState:UIControlStateSelected];
            
            break;
            
        default:
            break;
    }
    
    
    self.nextButton.layer.cornerRadius = 3.0f;
    
    self.showPasswordButton.selected = YES;
    
    self.orginalPasswordTextField.secureTextEntry = NO;
    self.secongPasswordTextField.secureTextEntry = NO;
    
    self.orginalPasswordTextField.delegate = self;
    self.secongPasswordTextField.delegate = self;
    
    // !第一个框弹出键盘
    [self.orginalPasswordTextField becomeFirstResponder];
    
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    
    // !输入第二个框的时候，判断第一个框输了没有
    if (textField == self.secongPasswordTextField && !self.orginalPasswordTextField.text.length) {
        
        // !修改登录密码
        if (self.changePassword == CSPChangeLoginPassword) {
        
            [self.view makeToast:NSLocalizedString(@"oldLoginPwd", @"请先输入原登录密码") duration:2.0f position:@"center"];

        
        }else if (self.changePassword == CSPResetPayPassword){// !支付密码
        
            
            [self.view makeToast:NSLocalizedString(@"oldPayPwd", @"请先输入原支付密码") duration:2.0f position:@"center"];

        
        }else {// !忘记密码
        
            [self.view makeToast:NSLocalizedString(@"insertNewPayPwd", @"请输入新支付密码") duration:2.0f position:@"center"];
            
        
        }
        
        return NO;
    }

    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.keyboardType =UIKeyboardTypeASCIICapable;
    
}


- (IBAction)showPasswordButtonClicked:(id)sender {

    if (self.orginalPasswordTextField.secureTextEntry == YES)
    {
        self.showPasswordButton.selected = YES;
        self.orginalPasswordTextField.secureTextEntry = NO;
        self.secongPasswordTextField.secureTextEntry = NO;
        [self.showPasswordButton setBackgroundImage:[UIImage imageNamed:@"setting_changePwd_select"] forState:UIControlStateNormal];
    }else
    {
        self.showPasswordButton.selected = NO;
        self.orginalPasswordTextField.secureTextEntry = YES;
        self.secongPasswordTextField.secureTextEntry = YES;
        [self.showPasswordButton setBackgroundImage:[UIImage imageNamed:@"setting_changePwd_unselect"] forState:UIControlStateNormal];
    }

}
- (IBAction)nextButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    switch (self.changePassword) {
        case CSPChangeLoginPassword:
        {
            NSString *phone = self.account;
            NSString *oldpwd = self.orginalPasswordTextField.text;
            NSString *passwd = self.secongPasswordTextField.text;
            
            if (passwd.length == 0) {
                
                [self.view makeToast:NSLocalizedString(@"pwdNil", @"密码不能为空") duration:2.0f position:@"center"];
                
                return;
                
            }
            
            if (![CSPUtils checkPassword:passwd]) {
                
                [self.view makeToast:NSLocalizedString(@"pwdError", @"密码格式有误") duration:2.0f position:@"center"];
                return;
                
            }
            
            [self progressHUDShowWithString:@"请求中"];
            self.nextButton.enabled = NO;
            
            [HttpManager sendHttpRequestForModifyPasswordWithPhone:phone passwd:passwd oldpwd:oldpwd success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self progressHUDHiddenWidthString:@""];
                self.nextButton.enabled = YES;

                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
              
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    [MyUserDefault defaultSaveAppSetting_loginPassword:passwd];
                    
                    CSPPasswordSuccessedViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPasswordSuccessedViewController"];
                    nextVC.changePassword = self.changePassword;
                    [self.navigationController pushViewController:nextVC animated:YES];
                    
                    
                }else{
                    
                    [self.view makeToast:NSLocalizedString(@"newPwdError", @"新密码格式有误") duration:2.0f position:@"center"];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self progressHUDHiddenWidthString:@"请求失败"];
                self.nextButton.enabled = YES;

                MyLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                
            }];
            
        }
            
            break;
        case CSPResetPayPassword:
        {
            NSString *phone = self.account;
            NSString *originalPassword = self.orginalPasswordTextField.text;
            NSString *password = self.secongPasswordTextField.text;
            
            if (password.length == 0) {
                
                [self.view makeToast:NSLocalizedString(@"pwdNil", @"密码不能为空") duration:2.0f position:@"center"];
                
                return;
            }
            if (![CSPUtils checkPassword:password]) {
                
                [self.view makeToast:NSLocalizedString(@"newPwdError", @"新密码格式有误") duration:2.0f position:@"center"];
                return;
                
            }

            [self progressHUDShowWithString:@"请求中"];
            self.nextButton.enabled = NO;

            [HttpManager sendHttpRequestForPayPasswdUpdateWithPhone:phone password:password originalPassword:originalPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self progressHUDHiddenWidthString:@""];
                self.nextButton.enabled = YES;

                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    CSPPasswordSuccessedViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPasswordSuccessedViewController"];
                    nextVC.changePassword = self.changePassword;
                    [self.navigationController pushViewController:nextVC animated:YES];
                    
                    
                }else{
                    
                    
                    MyLog(@"用户修改支付密码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
                    
                    [self.view makeToast:dic[@"errorMessage"] duration:2.0f position:@"center"];
                    
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
                [self progressHUDHiddenWidthString:@"请求失败"];
                self.nextButton.enabled = YES;

                
            }];

        }

            break;
        case CSPForgetPayPassword:
        {
        
            NSString *password = self.orginalPasswordTextField.text;
            NSString *repeatPassword = self.secongPasswordTextField.text;
            
            if (password.length == 0) {
                [self.view makeToast:NSLocalizedString(@"pwdNil", @"密码不能为空") duration:2.0f position:@"center"];

                return;
            }
            if (![CSPUtils checkPassword:password]) {
                [self.view makeToast:NSLocalizedString(@"pwdError", @"密码格式有误") duration:2.0f position:@"center"];

                return;
            }
            if (repeatPassword.length == 0) {
                [self.view makeToast:NSLocalizedString(@"pwdNil", @"密码不能为空") duration:2.0f position:@"center"];

                return;
            }
            if (![CSPUtils checkPassword:repeatPassword]) {
                [self.view makeToast:NSLocalizedString(@"pwdError", @"密码格式有误") duration:2.0f position:@"center"];

                return;
            }
            
            if (![password isEqualToString:repeatPassword]) {
                [self.view makeToast:NSLocalizedString(@"pwdNotSame", @"两次输入密码不一致") duration:2.0f position:@"center"];
                return;
            }
            
            [self progressHUDShowWithString:@"请求中"];
            self.nextButton.enabled = NO;
            
            [HttpManager sendHttpRequestForPaypasswdAddWithPassword:password repeatPassword:repeatPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self progressHUDHiddenWidthString:@""];
                self.nextButton.enabled = YES;
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    CSPPasswordSuccessedViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPasswordSuccessedViewController"];
                    nextVC.changePassword = self.changePassword;
                    [self.navigationController pushViewController:nextVC animated:YES];
                    
                }else{
                    
                    [self.view makeToast:dic[@"errorMessage"] duration:2.0f position:@"center"];
                    
                }
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self progressHUDHiddenWidthString:@"请求失败"];
                self.nextButton.enabled = YES;
            }];
        }
            

            break;
            
        default:
            break;
    }
 
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    NSLog(@"%@",textField.text);
    //    NSLog(@"length = %lu-location = %lu",(unsigned long)range.length,range.location);
    
    
    
    
    //根据range.length判断 0添加 1 删除
    if (range.length == 0) {
        
        //判断是否已经输入6个字符
        if (self.orginalPasswordTextField.text.length>=5&&self.secongPasswordTextField.text.length>=5) {
            //如果输入改变按钮的状态和颜色
            self.nextButton.enabled = YES;
            self.nextButton.backgroundColor = [UIColor blackColor];
        }
        else{//貌似else没有用到
            
            //如果没有依旧这样
            self.nextButton.backgroundColor = [UIColor colorWithHexValue:0x666666 alpha:1];
            self.nextButton.enabled = NO;
            
        }
        
        //如果超过12位的话 提示不能超过12位
        if (self.orginalPasswordTextField.text.length==12&&textField==self.orginalPasswordTextField) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付密码不得超过12位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            
            
            //return NO表示不进入输入框
            return NO;
        }
        
        if (self.secongPasswordTextField.text.length == 12&&textField == self.secongPasswordTextField) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付密码不得超过12位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            
            
            //return NO表示不进入输入框
            return NO;

        }
        
        
        
    }else
    {
        //删除的时候判断是否为6个字母 如果为6个字符 则执行完这个操作就输入框变成5个字符了。。 所以要改变颜色和状态
        
        if (self.orginalPasswordTextField.text.length==6 ||self.secongPasswordTextField.text.length == 6) {
            self.nextButton.enabled = NO;
            self.nextButton.backgroundColor = [UIColor colorWithHexValue:0x666666 alpha:1];
        }
        
        
    }
    
    return YES;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.orginalPasswordTextField resignFirstResponder];
    [self.secongPasswordTextField resignFirstResponder];
}
@end
