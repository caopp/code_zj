//
//  CSPChangePwdViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPChangePwdViewController.h"
#import "CSPPwdModificationViewController.h"


@interface CSPChangePwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *displayPwdButton;
#define time 0.5
#define FRAMR_Y_FOR_KEYBOARD_SHOW   (-70)

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
    
   
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"修改登录密码";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)leftBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark-显示密码
- (IBAction)displayPwdButtonClick:(id)sender {
    
    //判断有没有输入密码
    _isDisplayPwd = !_isDisplayPwd;
    
    if (_isDisplayPwd) {
        
        [self.pwdTextField setSecureTextEntry:NO];
        
        [self.nowPwdTextField setSecureTextEntry:NO];
        
        [self.displayPwdButton setImage:[UIImage imageNamed:@"03_商家商品详情页_选中"] forState:UIControlStateNormal];
    }else{
        
        [self.nowPwdTextField setSecureTextEntry:YES];
        
        [self.pwdTextField setSecureTextEntry:YES];
        
        [self.displayPwdButton setImage:[UIImage imageNamed:@"03_商家商品详情页_未选中"] forState:UIControlStateNormal];
    }
}

#pragma mark-设置密码
- (IBAction)submitButtonClick:(id)sender {
    
    [self progressHUDShowWithString:@"修改中"];
    
    //判断网络状态
    if (![self isConnecNetWork]) {
        
        [self progressHUDHiddenWidthString:@"请检查您的网络状态"];
        
        return;
    }
    
    if (self.nowPwdTextField.text.length<1 || self.pwdTextField.text.length<1) {
        
        [self progressHUDHiddenWidthString:@"请输入密码"];
        
        return;
    }
    if (![self.nowPwdTextField.text isEqualToString:self.pwdTextField.text]) {
         [self progressHUDHiddenWidthString:@"密码不一致"];
        return;
    }
    
    [HttpManager sendHttpRequestForLoginPasswordWithMobilePhone:self.phoneNum passwd:self.nowPwdTextField.text type:@"1" Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            //操作成功
            CSPPwdModificationViewController *pwdModificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPwdModificationViewController"];
            
            pwdModificationViewController.phoneNumber = self.phoneNum;
            
            pwdModificationViewController.loginPassword = self.nowPwdTextField.text;
            
            [self.navigationController pushViewController:pwdModificationViewController animated:YES];
            
        }else{
            
            [self alertViewWithTitle:@"修改失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];

    }];

}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)animationForContentView:(CGRect)rect{
    
    NSTimeInterval animationDuration = time;
    
    [UIView beginAnimations:@"contentViewResizeAnimation" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
#pragma UITextFieldDelegate(点击textfield对frame的大小进行改变)

#pragma UITextFieldDelegate(点击textfield对frame的大小进行改变)
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.pwdTextField) {
        
        [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];

    }
   }

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.pwdTextField) {
        [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.nowPwdTextField resignFirstResponder];
    
    [self.pwdTextField resignFirstResponder];
}
@end
