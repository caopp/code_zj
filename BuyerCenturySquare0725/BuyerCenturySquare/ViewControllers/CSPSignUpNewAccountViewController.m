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

typedef NS_ENUM(NSInteger, CSPSignUpNewAccountStep) {
    CSPSignUpNewAccountStepVerifyPhoneNumber,
    CSPSignUpNewAccountStepVerifyAuthCode,
    CSPSignUpNewAccountStepVerifyPassword,
    CSPSignUpNewAccountStepVerifyProtocalAgreement,
    CSPSignUpNewAccountStepDone
};

@interface CSPSignUpNewAccountViewController () <CSPProtocalViewControllerDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *authPhoneNumButton;
@property (weak, nonatomic) IBOutlet CustomTextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *acceptProtocalButton;

//state control
@property (nonatomic, assign) CSPSignUpNewAccountStep step;
@property (nonatomic, strong) NSString* lastPhoneNumber;
@property (nonatomic, assign) BOOL isLastPhoneNumberAuthed;

@end

@implementation CSPSignUpNewAccountViewController

static NSString* toProtocalSegueId = @"toProtocalSegueIdentifier";
static NSString* toNextSegueId = @"toAddressFillSegueIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"安全检验";
    self.acceptProtocalButton.selected = YES;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.authPhoneNumButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.authPhoneNumButton.layer.borderWidth = 1;
    self.authPhoneNumButton.layer.cornerRadius = 3.0f;
    self.authPhoneNumButton.alpha = 0.7f;

    [self addCustombackButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepButtonClicked:(id)sender {
    self.step = CSPSignUpNewAccountStepVerifyPhoneNumber;
    [self checkCurrentStep];
//    self.step = CSPSignUpNewAccountStepDone;
}


- (IBAction)authPhoneNumButtonClicked:(JKCountDownButton*)sender {

    if (![self verifyPhoneNumber]) {
        return;
    }

    [HttpManager sendHttpRequestForRegisterMobile:self.phoneNumTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSString* message = [NSString stringWithFormat:@"已向您的手机%@发送验证码", self.phoneNumTextField.text];
            [self.view makeToast:message duration:2.0f position:@"center"];

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


        } else if ([[dic objectForKey:@"code"]isEqualToString:@"101"]) {
            [self.view makeToast:[dic objectForKey:@"errorMessage"] duration:2.0f position:@"center"];
        } else if ([[dic objectForKey:@"code"]isEqualToString:@"102"]) {
            [self.view makeToast:@"手机号已注册" duration:2.0f position:@"center"];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"注册手机失败,请联系服务器,%@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];


}


#pragma mark -
#pragma mark Private Methods

- (void)loginWithCurrentUser {
    [HttpManager sendHttpRequestForLoginWithMemberAccount:self.phoneNumTextField.text password:self.passwdTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            LoginDTO *loginDTO = [LoginDTO sharedInstance];

            [loginDTO setDictFrom:[dic objectForKey:@"data"]];
            
            loginDTO.memberAccount = self.phoneNumTextField.text;
            
            [self performSegueWithIdentifier:toNextSegueId sender:self];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"登录失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}

- (void)checkCurrentStep {
    BOOL result = NO;
    switch (self.step) {
        case CSPSignUpNewAccountStepVerifyPhoneNumber:
            result = [self verifyPhoneNumber];
            break;
        case CSPSignUpNewAccountStepVerifyAuthCode:
            result = [self verifyAuthCode];
            break;
        case CSPSignUpNewAccountStepVerifyPassword:
            result = [self verifyPassword];
            break;
        case CSPSignUpNewAccountStepVerifyProtocalAgreement:
            result = [self verifyProtocalAgreement];
            break;
        case CSPSignUpNewAccountStepDone:
            [self loginWithCurrentUser];
            break;
        default:
            break;
    }

    if (result) {
        [self checkCurrentStep];
    }
}

- (BOOL)verifyPhoneNumber {
    BOOL result = NO;
    NSString* phoneNum = self.phoneNumTextField.text;

    if (phoneNum.length < 11) {
        //手机号码格式错误,弹出提示
        [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];
        return result;
    }
    //判断是否为手机号码
    if (![CSPUtils checkMobileNumber:self.phoneNumTextField.text]) {
        //手机号码格式错误,弹出提示
        [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];

        return result;
    }

    //判断手机号码是否已注册
    if ([self isPhoneNumRegisteredBefore]) {
        [self.view makeToast:@"手机号已注册" duration:2.0f position:@"center"];

        return result;

    } else {
        self.step = CSPSignUpNewAccountStepVerifyAuthCode;
        result = YES;
    }

    return result;
}

- (BOOL)verifyAuthCode {
    NSString* authCode = self.authCodeTextField.text;
    if (authCode.length < 4) {
        [self.view makeToast:@"验证码输入错误" duration:2.0f position:@"center"];
        return NO;
    } else {
        if (self.lastPhoneNumber.length > 0) {
            if ([self.lastPhoneNumber isEqualToString:self.phoneNumTextField.text] && self.isLastPhoneNumberAuthed) {

                self.step = CSPSignUpNewAccountStepVerifyPassword;
                return YES;
            }
        }

        self.isLastPhoneNumberAuthed = NO;
        [self sendAuthCodeVerifyRequest];

        return NO;
    }
}

- (void)sendAuthCodeVerifyRequest {
    [HttpManager sendHttpRequestForVerifySmsCodeWithPhone:self.phoneNumTextField.text type:@"1" smsCode:self.authCodeTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            self.lastPhoneNumber = self.phoneNumTextField.text;
            self.isLastPhoneNumberAuthed = YES;

            self.step = CSPSignUpNewAccountStepVerifyPassword;
            [self checkCurrentStep];
        } else if ([[dic objectForKey:@"code"]isEqualToString:@"001"]) {
            [self.view makeToast:[dic objectForKey:@"errorMessage"] duration:2.0f position:@"center"];
        } else {
            [self.view makeToast:@"验证码错误" duration:2.0f position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}

- (BOOL)verifyPassword {
    if (self.passwdTextField.text.length == 0) {
        [self.view makeToast:@"密码不能为空" duration:2.0f position:@"center"];
        return NO;
    }
    if (![CSPUtils checkPassword:self.passwdTextField.text]) {
        [self.view makeToast:@"密码格式有误" duration:2.0f position:@"center"];
        return NO;
    }

    [HttpManager sendHttpRequestForSetPasswordWithMobilePhone:self.phoneNumTextField.text password:self.passwdTextField.text type:@"0" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self.view makeToast:@"设置密码成功" duration:2.0f position:@"center"];
            self.step = CSPSignUpNewAccountStepVerifyProtocalAgreement;
            [self checkCurrentStep];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"设置密码失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];

    return NO;
}

- (BOOL)verifyProtocalAgreement {
    if (self.acceptProtocalButton.selected) {
        self.step = CSPSignUpNewAccountStepDone;
        return YES;
    } else {
        [self.view makeToast:@"请勾选同意用户协议" duration:2.0f position:@"center"];
        return NO;
    }
}

#pragma mark -
#pragma mark DoWithNetwork

- (BOOL)isPhoneNumRegisteredBefore {
    //TODO: 发送请求查看手机号码是否已注册
    return NO;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:toProtocalSegueId]) {
        return YES;
    } else if ([identifier isEqualToString:toNextSegueId]) {
        return self.step == CSPSignUpNewAccountStepDone ? YES : NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toProtocalSegueId]) {
        CSPProtocalViewController* protocalViewController = segue.destinationViewController;
        protocalViewController.delegate = self;
    }
}

- (void)acceptProtocal {
    self.acceptProtocalButton.selected = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
