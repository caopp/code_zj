//
//  ModPasswordViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ModPasswordViewController.h"
#import "HttpManager.h"
#import "LoginDTO.h"
#import "MyUserDefault.h"
@interface ModPasswordViewController ()<UITextFieldDelegate>
{
    NSString *account;
    
    LoginDTO * loginDTO;
    
}

@end

@implementation ModPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!设置输入框类型
    self.oldLoginPwdT.keyboardType = UIKeyboardTypeASCIICapable;
    self.freshLoginPwdT.keyboardType = UIKeyboardTypeASCIICapable;
    
    // !启动键盘
    [self.oldLoginPwdT becomeFirstResponder];
    
    // !代理
    self.oldLoginPwdT.delegate = self;
    self.freshLoginPwdT.delegate = self;
    
    
    // !显示密码
    self.showPwdButton.selected = YES;
    _oldLoginPwdT.secureTextEntry = NO;
    _freshLoginPwdT.secureTextEntry = NO;
    
    
    loginDTO = [LoginDTO sharedInstance];

    account = loginDTO.merchantAccount;
    
//     NSMutableArray *historyAccount = [[NSMutableArray alloc] initWithContentsOfFile:[self getHistoricalAccountListPath]];
    
//    account = [historyAccount lastObject];
    
    // !导航返回按钮
    [self customBackBarButton];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    // !点击新登录密码
    if (textField == self.freshLoginPwdT) {
        
        if (self.oldLoginPwdT.text.length < 6) {
            
         
            [self.view makeMessage:@"请先输入原登录密码" duration:2.0f position:@"center"];
            
            
            return NO;
            
        }
        
        
    }
    

    return YES;
    
}


#pragma mark - Private Functions

- (IBAction)showPwdButtonClicked:(id)sender {
    
    _showPwdButton.selected = !_showPwdButton.selected;
    
    if (_showPwdButton.selected) {
        
        _oldLoginPwdT.secureTextEntry = NO;
        _freshLoginPwdT.secureTextEntry = NO;
        
    }else{
        
        _oldLoginPwdT.secureTextEntry = YES;
        _freshLoginPwdT.secureTextEntry = YES;
        
    }
    
}

- (BOOL)checkPassword:(NSString*)password{
    
    if (password.length>=6&&password.length<=26) {
        
        NSString *pattern = @"[^A-Z0-9a-z._%+-]";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL result = [pred evaluateWithObject:password];
        
        return result;
        
    }else{
        
        return YES;
    }

}

- (IBAction)modifyButton:(id)sender {
    
    [self.view endEditing:YES];
    
    if (_freshLoginPwdT.text.length==0||_oldLoginPwdT.text.length==0) {
        
      
        
        [self.view makeMessage:@"密码不能为空" duration:2 position:@"center"];
        
        
        return;
        
        
        
    }else{
        
        
        BOOL f = [self checkPassword:_freshLoginPwdT.text];
        BOOL o = [self checkPassword:_oldLoginPwdT.text];
        
        if (o) {
            
            [self.view makeMessage:@"原密码格式有误" duration:2 position:@"center"];

            
            return;
            
        }
        
        
        if (f) {
            
            [self.view makeMessage:@"新密码格式有误" duration:2 position:@"center"];

            return;
        }
        
        
    }
    
    self.mobileBtn.enabled = NO;
    
    [HttpManager sendHttpRequestForUpdatePassword:account passwd:_freshLoginPwdT.text oldpwd:_oldLoginPwdT.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        NSString *result = responseDic[@"code"];
        if ([result integerValue]==0) {
            
            //保存电话号码和密码（退出登录时候进行删除）
            [MyUserDefault defaultSaveAppSetting_password:_freshLoginPwdT.text];
            //成功
            [self performSegueWithIdentifier:@"ModPwdSuccess" sender:self];
        }else{
            //Error
            
            NSString *errorMessage = responseDic[@"errorMessage"];
            
            [self.view makeMessage:errorMessage duration:4 position:@"center"];
            
            
        }
        
        self.mobileBtn.enabled = YES;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.mobileBtn.enabled = YES;

    }];
    

    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self navigationBarSettingShow:YES];
}


@end
