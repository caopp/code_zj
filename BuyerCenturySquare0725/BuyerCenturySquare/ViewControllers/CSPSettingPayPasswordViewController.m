//
//  CSPSettingPayPasswordViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSettingPayPasswordViewController.h"
#import "CSPInputPayPasswordViewController.h"
#import "CSPSettingsTextField.h"
#import "CSPUtils.h"

@interface CSPSettingPayPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet CSPSettingsTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonClicked:(id)sender;

@end

@implementation CSPSettingPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title= @"设置支付密码";
    self.nextButton.layer.cornerRadius = 3.0f;
    
    self.passwordTextField.delegate = self;

    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.secureTextEntry = YES;

    self.nextButton.enabled = NO;
    [self addCustombackButtonItem];

}


- (IBAction)nextButtonClicked:(id)sender {
    

    if (![CSPUtils checkPassword:self.passwordTextField.text]) {
        [self.view makeToast:@"密码格式有误" duration:2 position:@"center"];
    }else{
        NSString *password = self.passwordTextField.text;
        NSString *repeatPassword = self.passwordTextField.text;
        
        
//        [HttpManager sendHttpRequestForPaypasswdVerifyWithPassword:password success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            
//            NSLog(@"dic = %@",dic);
//            
//            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [HttpManager sendHttpRequestForPaypasswdAddWithPassword:password repeatPassword:repeatPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    NSLog(@"dic = %@",dic);
                    
                    if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                        [self.view makeToast:@"设置支付密码成功" duration:2 position:@"center"];
  
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:NO];
                        
                    }else{
                        
                        [self.view makeToast:dic[@"errorMessage"] duration:2 position:@"center"];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
                
//            }else{
//                
//                [self.view makeToast:@"密码格式有误" duration:2 position:@"center"];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
//        }];
        
    }
    
   
}

- (void)timer
{
    
    
    //如果是从设置过来的
    if (self.isChangePassWord) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else
    {
        
        CSPInputPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPInputPayPasswordViewController"];
        nextVC.orderAddDTO = self.orderAddDTO;
        nextVC.payBalanceDTO = self.payBalanceDTO;
        nextVC.isGoods = self.isGoods;
        
        nextVC.payType = self.payType;
        [self.navigationController pushViewController:nextVC animated:YES];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    NSLog(@"%@",textField.text);
    //    NSLog(@"length = %lu-location = %lu",(unsigned long)range.length,range.location);
    
    
    
    
    //根据range.length判断 0添加 1 删除
    if (range.length == 0) {
        
        //判断是否已经输入6个字符
        if (self.passwordTextField.text.length>=5) {
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
        if (self.passwordTextField.text.length==12) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付密码不得超过12位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            
            
            //return NO表示不进入输入框
            return NO;
        }
        
        
        
    }else
    {
        //删除的时候判断是否为6个字母 如果为6个字符 则执行完这个操作就输入框变成5个字符了。。 所以要改变颜色和状态
        
        if (self.passwordTextField.text.length==6) {
            self.nextButton.enabled = NO;
            self.nextButton.backgroundColor = [UIColor colorWithHexValue:0x666666 alpha:1];
        }
        
        
    }
    
    return YES;
    
}

@end
