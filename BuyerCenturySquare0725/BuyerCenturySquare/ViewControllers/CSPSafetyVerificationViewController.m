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

@interface CSPSafetyVerificationViewController ()<UITextFieldDelegate>
{
    BOOL isRegister;
}
- (IBAction)getCodeButtonClicked:(JKCountDownButton *)sender;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeButton;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet CustomTextField *codeTextField;

@property (weak, nonatomic) IBOutlet CustomButton *nextButton;
- (IBAction)nextButtonClicked:(id)sender;

@end

@implementation CSPSafetyVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全校验";

    [self addCustombackButtonItem];
    self.phoneNumberTextField.delegate = self;
    self.codeTextField.delegate = self;
    
    
    

    self.getCodeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.getCodeButton.layer.borderWidth = 1;
    self.getCodeButton.layer.cornerRadius = 3.0f;
    self.getCodeButton.alpha = 0.7f;
    
     self.nextButton.enabled = NO;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.phoneNumberTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.phoneNumberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
}



- (IBAction)getCodeButtonClicked:(JKCountDownButton *)sender {
    
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
        [HttpManager sendHttpRequestForSendSmsWithPhone:phone type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"dic = %@",dic);
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                sender.enabled = NO;
                //button type要 设置成custom 否则会闪动
                
                [sender startWithSecond:60];
                [sender setTitle:@"剩余60秒" forState:UIControlStateNormal];
                
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
                
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.nextButton.enabled = NO;
                [self.view makeToast:@"手机号码有误" duration:2 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
        }];


    

}
- (IBAction)nextButtonClicked:(id)sender {
    
    
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:self.phoneNumberTextField.text type:@"2" smsCode:self.codeTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            CSPChangePasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePasswordViewController"];
            nextVC.mobilePhone = self.phoneNumberTextField.text;
            [self.navigationController pushViewController:nextVC animated:YES];
            
        }else{
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.view makeToast:@"验证码有误" duration:2 position:@"center"];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
    }];
    

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
    [self.phoneNumberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
}


@end
