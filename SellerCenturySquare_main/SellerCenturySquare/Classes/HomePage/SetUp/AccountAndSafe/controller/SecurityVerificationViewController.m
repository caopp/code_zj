//
//  SecurityVerificationViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SecurityVerificationViewController.h"
#import "LoginDTO.h"
#import "HttpManager.h"

@interface SecurityVerificationViewController ()<UITextFieldDelegate>
{
    
    LoginDTO *loginDTO;
    
}
@property (nonatomic,assign) NSTimer *timer;
@property (nonatomic,assign) NSInteger Num;
@end

@implementation SecurityVerificationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // !设置键盘返回类型
    self.codeT.keyboardType = UIKeyboardTypeNumberPad;
    self.codeT.delegate = self;
    
    // !导航返回按钮
    [self customBackBarButton];

    // !改变下一步按钮的状态和颜色
    [self changeNextBtnStatues];
    
    loginDTO = [LoginDTO sharedInstance];
    _Num = 59;
    NSString *account = loginDTO.merchantAccount;
    NSString *pre = [account substringToIndex:3];
    NSString *last = [account substringFromIndex:account.length-3];
    _tipsL.text = [NSString stringWithFormat:@"请输入%@*****%@收到的短信校验码",pre,last];

    // !自动发送验证码
//    [self getCodeRequest];
//    [self checkCodetimer];
    
    
    [self.getCodeButton setBackgroundColor:[UIColor blackColor]];
    [self.getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    
}

#pragma mark 改变下一步按钮的状态和颜色
-(void)changeNextBtnStatues{

    if (self.codeT.text.length >= 5) {
        
        self.nextBtn.enabled = YES;
        
        [self.nextBtn setBackgroundColor:[UIColor blackColor]];
        
    }else{
    
        self.nextBtn.enabled = NO;
        [self.nextBtn setBackgroundColor:[UIColor colorWithHex:0xe2e2e2 alpha:1]];
        
    
    }

}
#pragma mark textfield的代理

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    
    // !改变下一步按钮的状态和颜色
    [self changeNextBtnStatues];


    return YES;
    

}

#pragma mark - HttpRequest
//验证码请求
- (void)getCodeRequest{
    
    NSString *phone = loginDTO.merchantAccount;
    NSString *type = @"15";
    

    [HttpManager sendHttpRequestForSendSmsWithPhone:phone type:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            //参数需要保存
            
            
        }else{
    
            NSLog(@"设置 修改密码 获取验证码失败！%@",[dic objectForKey:@"errorMessage"]);
        
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}

- (void)verifyCodeRequest{
    
    NSString *phone = loginDTO.merchantAccount;
    NSString *type = @"15";
    NSString *smsCode = _codeT.text;
    
    self.nextBtn.enabled = NO;
    
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:phone type:type smsCode:smsCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.nextBtn.enabled = YES;

        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
             [self checkCodeSuccess:YES];
            
        }else{
            
             [self checkCodeSuccess:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        [self.view makeMessage:@"验证失败" duration:2.0 position:@"center"];

        self.nextBtn.enabled = YES;
   
    }];
    
    
    
}

#pragma mark - Private Functions
- (void)checkCodeSuccess:(BOOL)success{

    if (success) {
        
        [self performSegueWithIdentifier:@"checkCode" sender:nil];
    }else{
        
        [self.view makeMessage:@"验证码有误" duration:2.0 position:@"center"];
        
    }
}

- (IBAction)nextButtonClicked:(id)sender {
    
    //验证验证码
    [self verifyCodeRequest];

}

- (void)checkCodetimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired{
    
    _Num--;
    
     NSString *title = [NSString stringWithFormat:@"%zi秒后可重发",_Num];
    
    if (_Num==0) {
        
        title = @"获取验证码";
        
        [_getCodeButton setBackgroundColor:[UIColor blackColor]];
        
        [_timer invalidate];
    }
    
    [_getCodeButton setTitle:title forState:UIControlStateNormal];
    [_getCodeButton setTitle:title forState:UIControlStateHighlighted];
    
}

- (IBAction)sendCode:(id)sender {
    
    if (_getCodeButton.backgroundColor ==[UIColor blackColor]) {
    
    
        _Num = 60;
        
        [self.getCodeButton setBackgroundColor:[UIColor colorWithHex:0xe2e2e2 alpha:1]];
        
        //!改变显示的时间
        [self checkCodetimer];
        
        //!请求验证码
        [self getCodeRequest];

    
    }

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self navigationBarSettingShow:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
