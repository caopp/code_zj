//
//  CSPSignUpNewAccountViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/3/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSignUpNewAccountViewController.h"
#import "CustomButton.h"
#import "CustomTextField.h"
#import "JKCountDownButton.h"
#import "CSPProtocalViewController.h"
#import "CSPUtils.h"
#import "LoginDTO.h"
#import "CSPProtocalViewController.h"
#import "SaveInfoView.h"
#import "CSPSafetyVerificationViewController.h"
#import "CSPFillAddressViewController.h"
#import "CSPCodeVerifyViewController.h"
#import "FrostedGlassPublic.h"
#import "RegisteredView.h"
#import "UserOtherInfo.h"
#import "SaveUserIofo.h"
#import "CCWebViewController.h"
#import "CityPropValueDefault.h"
#define displacement 44
#define displacementTime 0.5
#define backGroundColor [UIColor colorWithHexValue:0xffffff alpha:1]  //背景色颜色
#define lineColor [UIColor colorWithHexValue:0xf3f3f3 alpha:1]  //点击后线条
#define fontColor [UIColor colorWithHexValue:0x007aff alpha:1]  //点击后线条
@interface CSPSignUpNewAccountViewController () <UITextFieldDelegate,SaveInfoViewDelegate,RegisteredViewDelegate>

{

   // UIView *view;
    CCWebViewController *cc;
    BOOL isProtocal;
}
#pragma mark ----隐藏视图----
@property (strong, nonatomic) IBOutlet UIView *hiddenBackgrondView;
@property (strong, nonatomic) IBOutlet UIView *backgrondHideView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UILabel *firstLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *forgetPswBtn;
@property (strong, nonatomic) IBOutlet UILabel *secondLineLabel;
@property (strong, nonatomic) IBOutlet UILabel *descrbeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet CustomButton *registeredBtn;


@property(nonatomic,strong) UILabel * sendAlertLabel;



#pragma mark--分割线--
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *authPhoneNumButton;
@property (weak, nonatomic) IBOutlet CustomTextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *acceptProtocalButton;


//state control
@property (nonatomic, strong) NSString* lastPhoneNumber;
@property (nonatomic, assign) BOOL isLastPhoneNumberAuthed;

@end

@implementation CSPSignUpNewAccountViewController

static NSString* toProtocalSegueId = @"toProtocalSegueIdentifier";
static NSString* toNextSegueId = @"toAddressFillSegueIdentifier";

-(void)viewWillAppear:(BOOL)animated
{
    //国际化
    self.firstLineLabel.backgroundColor = lineColor;
    self.secondLineLabel.backgroundColor = lineColor;
    [self.loginBtn setTitleColor:fontColor forState:(UIControlStateNormal)];
    [self.forgetPswBtn setTitleColor:fontColor forState:(UIControlStateNormal)];
    [self.descrbeLabel setTextColor:fontColor];
    self.backgrondHideView.backgroundColor = backGroundColor;
    [FrostedGlassPublic settingBackgroungFrostedGlassImage:@"background" imageView:self.backImage];
    self.navigationController.navigationBar.translucent = YES;

    
}

-(void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBar.translucent = YES;

    [super viewDidDisappear:animated];

}
-(void)showSaveSuccessdTipView:(BOOL)show
{
    if (show) {
        [self.hiddenBackgrondView setHidden:NO];
        [self.view bringSubviewToFront:self.hiddenBackgrondView];
        [self.phoneNumTextField resignFirstResponder];
    }else
    {
        [self.hiddenBackgrondView setHidden:YES];
        [self.view sendSubviewToBack:self.hiddenBackgrondView];
    }
}



- (IBAction)didClickLoginAction:(id)sender {
    //采用block进行回调
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickForgetAction:(id)sender {
    
    CSPSafetyVerificationViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSafetyVerificationViewController"];
    [self.navigationController pushViewController:securityCheckViewController animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户注册";
    
    
    isProtocal = YES;
    self.acceptProtocalButton.selected = YES;
    [self showSaveSuccessdTipView:NO];
    
    self.authPhoneNumButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.authPhoneNumButton.layer.borderWidth = 1;
    self.authPhoneNumButton.layer.cornerRadius = 3.0f;
    self.authPhoneNumButton.alpha = 0.7f;
    
    self.authCodeTextField.delegate = self;
    self.passwdTextField.delegate = self;
    [self.phoneNumTextField becomeFirstResponder];
    
    [self addCustombackButtonItem];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)authPhoneNumButtonClicked:(JKCountDownButton*)sender {
   
    if (![self verifyPhoneNumber]) {
        
        return;
    
    }
    
    sender.enabled = NO;
    
    
    __weak CSPSignUpNewAccountViewController * vc = self;
    
    [HttpManager sendHttpRequestForRegisterMobile:self.phoneNumTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if (!self.sendAlertLabel) {
                
                vc.sendAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 40)];
                vc.sendAlertLabel.center = self.view.center;

                [vc.sendAlertLabel setBackgroundColor:[UIColor blackColor]];
                [vc.sendAlertLabel setTextColor:[UIColor whiteColor]];
                vc.sendAlertLabel.font = [UIFont systemFontOfSize:14];
                vc.sendAlertLabel.textAlignment = NSTextAlignmentCenter;
                
                vc.sendAlertLabel.layer.masksToBounds = YES;
                vc.sendAlertLabel.layer.cornerRadius = 2;
                
               
                [self.view addSubview:vc.sendAlertLabel];
                
            }

            NSString* message = [NSString stringWithFormat:@"已向您的手机%@发送验证码", self.phoneNumTextField.text];
            [vc.sendAlertLabel setText:message];
            
            vc.sendAlertLabel.hidden = NO;

            
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideAlertLabel) userInfo:nil repeats:NO];
            
            
//            [self.view makeToast:message duration:2.0f position:@"center"];
            
            
            
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
            
        } else if ([[dic objectForKey:@"code"]isEqualToString:@"101"]) {
            
            sender.enabled = YES;

            [self.view makeToast:[dic objectForKey:@"errorMessage"] duration:2.0f position:@"center"];
            
        } else if ([[dic objectForKey:@"code"]isEqualToString:@"102"]) {
            
            sender.enabled = YES;

            [self.phoneNumTextField resignFirstResponder];
            //1、创建
            GUAAlertView *al=[GUAAlertView alertViewWithTitle:@"手机号码已注册，您可以使用此号码登录" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"忘记登录密码" withOkButtonColor:nil cancelButtonTitle:@"登录" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
                NSLog(@"右边按钮（第一个按钮）的事件");
                CSPSafetyVerificationViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSafetyVerificationViewController"];
                
                [self.navigationController pushViewController:securityCheckViewController animated:YES];
                
                
            } dismissAction:^{
                
                NSLog(@"左边按钮（第二个按钮）的事件");
                self.phoneNum(self.phoneNumTextField.text);
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            //2、显示
            [al show];
            
        } else {
            
            sender.enabled = YES;

            [self.view makeToast:[NSString stringWithFormat:@"短信发送异常"] duration:2.0f position:@"center"];
            
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        sender.enabled = YES;

        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
        
        
    }];
  
}

//!隐藏“已经发生验证码”的提示框
-(void)hideAlertLabel{

    self.sendAlertLabel.hidden = YES;

}

#pragma mark ======SaveInfoView代理方法=======
-(void)didClickLoginAction
{
    NSNotification *notification = [NSNotification notificationWithName:@"back" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}

#pragma mark Private Methods
- (void)loginWithCurrentUser {
    
    [HttpManager sendHttpRequestForLoginWithMemberAccount:self.phoneNumTextField.text password:self.passwdTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
           
           
            LoginDTO *loginDTO = [LoginDTO sharedInstance];
            
            [loginDTO setDictFrom:[dic objectForKey:@"data"]];
            
           
            loginDTO.status = @"0";
            loginDTO.memberAccount = self.phoneNumTextField.text;
            [MyUserDefault defaultSaveAppSetting_merchantNo:dic[@"data"][@"memberNo"]];
            [MyUserDefault defaultSaveAppSetting_token:dic[@"data"][@"tokenId"]];
          
            
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
}


- (BOOL)verifyPhoneNumber {
    NSString* phoneNum = self.phoneNumTextField.text;
    
    if (phoneNum.length < 11) {
        //手机号码格式错误,弹出提示
        [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];
        return NO;
    }
    //判断是否为手机号码
    if (![CSPUtils checkMobileNumber:self.phoneNumTextField.text]) {
        //手机号码格式错误,弹出提示
        [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

//校验验证码
- (BOOL)verifyAuthCode {
    NSString* authCode = self.authCodeTextField.text;
    if (authCode.length < 6) {
        [self.view makeToast:@"验证码输入错误" duration:2.0f position:@"center"];
        return NO;
    }
    return YES;
}

//校验密码
-(BOOL)verityPaw
{
    if (self.passwdTextField.text.length == 0) {
        
        [self.view makeToast:@"密码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    
    return YES;
}



//验证码进行校验请求
- (void)sendAuthCodeVerifyRequest {
    

    [self.view endEditing:YES];
    if ([CSPUtils checkPassword:self.passwdTextField.text]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:self.phoneNumTextField.text type:@"1" smsCode:self.authCodeTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                self.lastPhoneNumber = self.phoneNumTextField.text;
               // [self verifyPasswordAction];//
                [self verifyPasswordActionPass];
                
            } else if ([[dic objectForKey:@"code"]isEqualToString:@"001"]) {
                [self.view makeToast:@"验证码错误,可重新获取" duration:2.0f position:@"center"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }
            

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
            

        }];

    }else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        [self.view makeToast:@"登录密码格式错误" duration:2.0f position:@"center"];
    }

    }


- (void)verifyPasswordAction {
    
    
    [HttpManager sendHttpRequestForSetPasswordWithMobilePhone:self.phoneNumTextField.text password:self.passwdTextField.text type:@"0" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self.view makeToast:@"设置密码成功" duration:2.0f position:@"center"];
            
         
            
            //调用登录接口采用的方法
            [self loginWithCurrentUser];
            
            [MyUserDefault defaultSaveAppSetting_loginPassword:self.passwdTextField.text];
            
            [MyUserDefault defaultSaveAppSetting_loginPhone:self.phoneNumTextField.text];
            
            //验证  页面
            
            CSPCodeVerifyViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPCodeVerifyViewController"];
            //[view removeFromSuperview];
            [self.navigationController pushViewController:securityCheckViewController animated:YES];
            
//            //注册成功后进入注册页面
//            CSPFillAddressViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFillAddressViewController"];
//            [view removeFromSuperview];
//            [self.navigationController pushViewController:securityCheckViewController animated:YES];
           
            
            
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"设置密码失败"] duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
    
    
}

#pragma mark  3.13	小B新增注册接口
/*
 *小B新增注册接口，状态直接为审核通过
 */
- (void)verifyPasswordActionPass {
    
    
    [HttpManager sendHttpRequestPassSetPasswordWithMobilePhone:self.phoneNumTextField.text password:self.passwdTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self.view makeToast:@"注册成功" duration:2.0f position:@"center"];
            LoginDTO *loginDTO = [LoginDTO sharedInstance];
            
            [loginDTO setDictFrom:[dic objectForKey:@"data"]];
            
//            //进行省市区版本控制
//            CityPropValueDefault * propValueDefalut = [CityPropValueDefault shareManager];
//            [propValueDefalut dataPropValueControl];

            [self available];
            //进行省市区版本控制
            CityPropValueDefault * propValueDefalut = [CityPropValueDefault shareManager];
            [propValueDefalut dataPropValueControl];
           
 
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [self.view makeToast:[NSString stringWithFormat:@"设置密码失败"] duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
    
    
}



- (BOOL)verifyProtocalAgreement {
    if (self.acceptProtocalButton.selected) {
        return YES;
    } else {
        [self.view makeToast:@"请勾选同意用户协议" duration:2.0f position:@"center"];
        return NO;
    }
}

- (IBAction)userProtocolBtnAction:(id)sender {
    
    CSPProtocalViewController *protocalVC = [[CSPProtocalViewController alloc]init];
    protocalVC.file = [HttpManager serviceRequestWebView];
    [self.navigationController pushViewController:protocalVC animated:YES];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.phoneNumTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
}

#pragma UITextFieldDelegate（代理方法中进行判断，以及进行的动画展示
/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}
*/
//下一步按钮（注册）
- (IBAction)nextStepButtonClicked:(id)sender {
    
//    CSPCodeVerifyViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPCodeVerifyViewController"];
//   // [view removeFromSuperview];
//    [self.navigationController pushViewController:securityCheckViewController animated:YES];
//    
    
    
    if (![self verifyPhoneNumber]) {
        return;
    }
    
    if (![self verityPaw]) {
        return;
    }

   
       [self sendAuthCodeVerifyRequest];

}
-(void)available{
    
        //获取会员信息
        [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                [self saveUserDefaults];
                LoginDTO *loginDTO = [LoginDTO sharedInstance];
                
                [loginDTO setDictFrom:[dic objectForKey:@"data"]];
                
                NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"data"]];
                [dicInfo setObject:loginDTO.tokenId forKey:@"tokenId"];
                SaveUserIofo *saveIofo = [[SaveUserIofo alloc]init];
                [saveIofo addIofoDTO:dicInfo];
                
                //进行密码和账号保存
                [MyUserDefault defaultSaveAppSetting_loginPassword:self.passwdTextField.text];
                
                [MyUserDefault defaultSaveAppSetting_loginPhone:self.phoneNumTextField.text];
                
                
                //用户通过后进行其他地方登录 //聊天登录
                //聊天登录
                UserOtherInfo *userOtherIofo = [[UserOtherInfo alloc]init];
                [userOtherIofo assignmentPhoneNumber:self.phoneNumTextField.text password:self.passwdTextField.text];
                
                //!是从token失效 过来的
                [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];
                
            }else{
           
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }];
    
  
}
-(void)saveUserDefaults{
    //记录帐号
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *accuntArray = [userDefaults arrayForKey:@"myArray"];
    
    if (accuntArray == nil) {
        
        accuntArray = [[NSArray alloc]init];
    }
    
    NSMutableArray *array = [accuntArray mutableCopy];
    
    BOOL isExisted;
    
    isExisted = NO;
    
    for (NSString *str in array) {
        
        if ([self.phoneNumTextField.text isEqualToString:str]) {
            
            isExisted = YES;
        }
    }
    if (isExisted == YES) {
        
        [array removeObject:self.phoneNumTextField.text];
    }
    
    [array insertObject:self.phoneNumTextField.text atIndex:0];
    
    if (array.count > 3) {
        
        [array removeLastObject];
        
    }
    
    accuntArray = [array copy];
    
    [userDefaults setObject:accuntArray forKey:@"myArray"];
    
    
    //!记录该用户是从登录界面进入，刷新商家列表
    [MyUserDefault defaultSave_logined];

}
@end
