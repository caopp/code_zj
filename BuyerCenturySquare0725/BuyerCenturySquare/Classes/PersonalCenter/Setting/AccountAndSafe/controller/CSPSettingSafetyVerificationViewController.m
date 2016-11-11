//
//  CSPSettingSafetyVerificationViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  安全验证（修改登录密码）

#import "CSPSettingSafetyVerificationViewController.h"
#import "CSPSettingChangePasswordViewController.h"
#import "JKCountDownButton.h"
#import "CSPSettingsTextField.h"
#import "CSPSettingPayPasswordViewController.h"
#import "CSPPasswordSuccessedViewController.h"

@interface CSPSettingSafetyVerificationViewController ()<UITextFieldDelegate>{
    BOOL isRegister;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CSPSettingsTextField *codeLabel;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeButton;
- (IBAction)getCodeButtonClicked:(JKCountDownButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonClicked:(id)sender;

@end

@implementation CSPSettingSafetyVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"safetyVerification", @"安全验证");
    [self addCustombackButtonItem];
   

    NSString *header = [self.account substringToIndex:3];
    NSString *footer = [self.account substringFromIndex:8];
    NSString *phoneNumber = [NSString stringWithFormat:@"%@*****%@",header,footer];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"pleaserInsert",@"请输入"),phoneNumber,NSLocalizedString(@"verificate", @"收到的短信校验码")];
    [self.codeLabel becomeFirstResponder];
    self.codeLabel.delegate = self;
    
    self.getCodeButton.layer.cornerRadius = 2.0f;
    self.nextButton.layer.cornerRadius = 2.0f;
    self.nextButton.enabled = NO;
    [self.nextButton setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [_getCodeButton setTitleColor:HEX_COLOR(0xffffffFF) forState:(UIControlStateNormal)];
    isRegister = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取验证码
- (IBAction)getCodeButtonClicked:(JKCountDownButton*)sender {
    
    NSString *type;
    
    if (self.changePassword  == 1) {
        
        type = @"14";
    
    }else if(self.changePassword == 2)
    {
    
        type = @"5";
    
    }else
    {
    
        type = @"4";
    
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.getCodeButton.enabled = NO;

    [HttpManager sendHttpRequestForSendSmsWithPhone:self.account type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.getCodeButton.enabled = YES;

        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            sender.enabled = NO;
            [self.nextButton setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];

            //button type要 设置成custom 否则会闪动
            
            [sender startWithSecond:60];
            
            NSString *senderTitle = [NSString stringWithFormat:@"%@60%@",NSLocalizedString(@"surplus", @"剩余"),NSLocalizedString(@"second",@"秒")];
            
            [sender setTitle:senderTitle forState:UIControlStateNormal];
            
            [sender setBackgroundColor:HEX_COLOR(0x999999FF)];
          
            
            
            [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                
                NSString *title = [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"surplus", @"剩余"),second,NSLocalizedString(@"second",@"秒")];
                
                return title;
                
                
            }];
            
            [sender setTitle:senderTitle forState:UIControlStateNormal];
            
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                [sender setBackgroundColor:[UIColor blackColor]];
            
                return  NSLocalizedString(@"reGet", @"点击重新获取");
            
            }];
            
            // !修改“下一步”按钮的状态
            
            [self codeSure];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
//            self.nextButton.enabled = YES;
//            [self.nextButton setBackgroundColor:[UIColor blackColor]];

            
            [self.view makeToast:NSLocalizedString(@"verificateHasSend", @"验证码已发送") duration:2 position:@"center"];
            
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.nextButton.enabled = NO;
            [self.nextButton setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2 alpha:1]];

            [self.view makeToast:NSLocalizedString(@"verificateSendFailed", @"验证码发送失败") duration:2 position:@"center"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        self.getCodeButton.enabled = YES;

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:NSLocalizedString(@"connectFailed", @"连接失败") duration:2 position:@"center"];
   
    
    }];
    
 
}
- (IBAction)nextButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *type;
    
    if (self.changePassword  == 1) {
        type = @"14";
    }else if(self.changePassword == 2)
    {
        type = @"5";
    }else
    {
        type = @"4";
    }
  
    self.nextButton.enabled = NO;
    
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:self.account type:type smsCode:self.codeLabel.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.nextButton.enabled = YES;

        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
         
                
                CSPSettingChangePasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingChangePasswordViewController"];
                nextVC.changePassword = self.changePassword;
                nextVC.account = self.account;

                [self.navigationController pushViewController:nextVC animated:YES];
            
            
            
        
            
        
        }else{
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"requestError", @"请求失败")   message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"sure", @"确定") , nil];
//            [alert show];
            
            GUAAlertView *al = [GUAAlertView alertViewWithTitle:NSLocalizedString(@"requestError", @"请求失败") withTitleClor:nil message:[dic objectForKey:@"errorMessage"] withMessageColor:nil oKButtonTitle:NSLocalizedString(@"sure", @"确定")  withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
            } dismissAction:^{
                
            }];
            [al show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.nextButton.enabled = YES;

        [self.view makeToast:NSLocalizedString(@"connectFailed", @"连接失败") duration:2 position:@"center"];
        
        
    }];
}


// !结束输入验证码的时候
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self codeSure];
}

//!输入内容改变时候的通知
-(void)textFieldChanged{
    [self codeSure];
}

-(void)codeSure{
    
    if (self.codeLabel.text.length == 6) {
        
        self.nextButton.enabled = YES;
        [self.nextButton setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        
    }else{
        
        self.nextButton.enabled = NO;
        [self.nextButton setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.codeLabel resignFirstResponder];
}


@end
