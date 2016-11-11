//
//  CSPChangePasswordViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPChangePasswordViewController.h"
#import "CSPChangePasswordSuccessViewController.h"
#import "CustomButton.h"
#import "CustomTextField.h"
#import "CSPUtils.h"

@interface CSPChangePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;
- (IBAction)showPasswordButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *showPasswordLabel;
@property (weak, nonatomic) IBOutlet CustomButton *commitButton;
- (IBAction)commitButtonClicked:(id)sender;


@end

@implementation CSPChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";

    [self addCustombackButtonItem];
    
    self.passwordTextField.delegate = self;
    self.againPasswordTextField.delegate = self;
    
    self.showPasswordButton.selected = YES;
    
    self.passwordTextField.secureTextEntry = NO;
    self.againPasswordTextField.secureTextEntry = NO;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.passwordTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.passwordTextField resignFirstResponder];
    [self.againPasswordTextField resignFirstResponder];
}



- (IBAction)showPasswordButtonClicked:(id)sender {
    
    if (self.passwordTextField.secureTextEntry == YES)
    {

        self.showPasswordButton.selected = YES;
        self.passwordTextField.secureTextEntry = NO;
        self.againPasswordTextField.secureTextEntry = NO;
    }else
    {
        self.showPasswordButton.selected = NO;
        self.passwordTextField.secureTextEntry = YES;
        self.againPasswordTextField.secureTextEntry = YES;
    }
}
- (IBAction)commitButtonClicked:(id)sender {
    
    if (self.passwordTextField.text.length<1||self.againPasswordTextField.text.length<1) {
         [self.view makeToast:@"密码不能为空" duration:2 position:@"center"];
        return;
    }
    
    if ([self.passwordTextField.text isEqualToString:self.againPasswordTextField.text]) {
        
        if ([CSPUtils checkPassword:self.passwordTextField.text]) {
            NSString *mobilePhone = self.mobilePhone;
            NSString *password  = self.passwordTextField.text;
            NSString *type = @"1";          //0:注册 1:忘记密码
            
            [HttpManager sendHttpRequestForSetPasswordWithMobilePhone:mobilePhone password:password type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"dic = %@",dic);
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    
                    
                    CSPChangePasswordSuccessViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePasswordSuccessViewController"];
                    [self.navigationController pushViewController:nextVC animated:YES];
                    
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                
            }];
        }else{
            [self.view makeToast:@"密码格式错误" duration:2 position:@"center"];
        }

    }else{
        [self.view makeToast:@"两次输入的密码不一致" duration:2 position:@"center"];
    }
}


#pragma mark--
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //    [self cancelLocatePicker];
    [self.passwordTextField resignFirstResponder];
    [self.againPasswordTextField resignFirstResponder];
    
}
@end
