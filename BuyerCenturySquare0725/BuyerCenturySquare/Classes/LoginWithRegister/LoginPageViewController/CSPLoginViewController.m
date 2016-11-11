//
//  CSPLoginViewController.m
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPLoginViewController.h"
#import "CustomTextField.h"
#import "CustomTextField2.h"
#include "LoginDTO.h"
#import "CSPFillAddressViewController.h"

#import "CSPBaseTableViewCell.h"
#import "ChatManager.h"

#import "DeviceDBHelper.h"
#import "GetConsigneeListDTO.h"
#import "CSPUtils.h"
#import "NSString+Hashing.h"
#import "MHImageDownloadManager.h"
#import "DownloadLogControl.h"

#import "CSPSignUpNewAccountViewController.h"
#import "JSWithNativeViewController.h"

#import "CSPSafetyVerificationViewController.h"
#import "SaveUserIofo.h"

#import "CSPAccountClosedViewController.h"

#import "CSPVerifyInvitationViewController.h"

#import "CSPFillApplicationViewController.h"

#import "TextFieldViewController.h"

#import "CSPCodeVerifyViewController.h"

#import "AnotherPlaceLoginAlertView.h"
#define time 0.3
#define scrollViewLineLength 41
//重构页面头文件
#import "LoginPageView.h"
//进入注册页面


//申请通过后进行的页面
#import "CSPApplicationInfoViewController.h"

//添加聊天、会员等级、打开数据库
#import "UserOtherInfo.h"

#import "AppDelegate.h"


#import "CityPropValueDefault.h"
#define fontColor [UIColor colorWithHexValue:0xffffff alpha:0.7]

@interface CSPLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,LoginPageViewDelegate>
{
    NSArray *listArray;
    JSWithNativeViewController *jsWithNativeVC;

    UIScrollView *_scrollView;
    UITextField *_textField1;
    NSInteger _indextext;
}

- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (strong, nonatomic) IBOutlet UIButton *showListButton;

- (IBAction)showListButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (assign,nonatomic) BOOL isLocalUser;

- (IBAction)loginButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordConstraint;
@property (strong, nonatomic) IBOutlet UIButton *registeredButton;

@property (strong, nonatomic) IBOutlet UIButton *forgetPasswordButton;

//重构页面视图
@property (strong,nonatomic)LoginPageView *loginPageView;
//背景视图采用scrollview
@property (strong,nonatomic)UIScrollView *scrollView;
//设置保存电话号码数组
@property (strong,nonatomic)NSArray *phoneListArr;

@end

@implementation CSPLoginViewController
static NSString* toCheckInvitation = @"toCheckInvitation";
static NSString* toFillAddress = @"toFillAddressPage";
static NSString* toAccountClosed = @"toAccountClosedPage";
static NSString* toApplicationPassed = @"toApplicationPassedPage";
static NSString* toApplicationNotPassed = @"toApplicationNotPassedPage";
static NSString* toAccountCheck = @"toAccountCheckPage";

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"dingdongUserLogin", @"用户登录");
    self.phoneNumberTextField.placeholder = NSLocalizedString(@"phonePrompt", @"请输入手机号");
    self.passwordTextField.placeholder = NSLocalizedString(@"passwordPrompt", @"请输入密码");
    [self.loginButton setTitle:NSLocalizedString(@"login", @"登录")forState:(UIControlStateNormal)];
    [self.registeredButton setTitle:NSLocalizedString(@"registered", @"注册") forState:(UIControlStateNormal)];
    [self.forgetPasswordButton setTitle:NSLocalizedString(@"forgetPassword", @"忘记密码") forState:(UIControlStateNormal)];
    
    
    //设置字体颜色
    [self.registeredButton setTitleColor:fontColor forState:(UIControlStateNormal)];
    [self.forgetPasswordButton setTitleColor:fontColor forState:(UIControlStateNormal)];
    [self.loginButton setTitleColor:fontColor forState:(UIControlStateNormal)];
    
}

- (IBAction)didClickRegisteredBtnAction:(id)sender {
    
    CSPSignUpNewAccountViewController *security = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSignUpNewAccountViewController"];
    
    security.phoneNum = ^(NSString *phoneNum)
    {
        self.phoneNumberTextField.text = phoneNum;
    };
    [self.navigationController pushViewController:security animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户登录";
    
    /**
     *  uitextview代理
     */
    self.phoneNumberTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    /**
     *  设置电话列表展示的按钮时关闭状态
     */
    self.showListButton.selected = NO;
    /**
     *  进行电话号码和密码保存（保存到数组中，进行展示运用）
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    listArray= [userDefaults arrayForKey:@"myArray"];
    if (listArray.count == 0) {
        [self.phoneNumberTextField becomeFirstResponder];
    }else
    {
        self.phoneNumberTextField.text = listArray[0];
        
        [self.passwordTextField becomeFirstResponder];
    }
    
//    self.passwordTextField.text = nil;
    
    /**
     *  tableView电话号码的展示
     */
    [self setupTableView];
    
    //判断注册按钮显示事件
//    [self determineRegistrationButtonDisplaysEvent];
    
    //重构页面视图
//    [self makeUI];
    //隐藏文思代码
//    [self hiddenView];
    
#pragma zxx=========电话号码的保存==============
    NSUserDefaults *phoneUserDefaults = [NSUserDefaults standardUserDefaults];
    self.phoneListArr = [phoneUserDefaults arrayForKey:@"phoneListArr"];
    if (self.phoneListArr == 0) {
        //点击电话号显示
        [self.loginPageView.phoneNumTextField becomeFirstResponder];
    }else
    {
        //设置显示保存的电话
        self.loginPageView.phoneNumTextField.text = self.phoneListArr[0];
        [self.loginPageView.passwordTextField becomeFirstResponder];
    }
    
//    CSPApplicationInfoViewController *securityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPApplicationInfoViewController"];
//    [self.navigationController pushViewController:securityVC animated:YES];
    
}

//设置文思代码进行隐藏
-(void)hiddenView
{
    
    self.tableView.hidden = YES;
    self.showListButton.hidden = YES;
    self.loginButton.hidden = YES;
    self.registeredButton.hidden = YES;
    self.registeredButton.backgroundColor = [UIColor redColor];
    [self.registeredButton removeFromSuperview];
    
    self.forgetPasswordButton.hidden = YES;
    self.phoneNumberTextField.hidden = YES;
    self.passwordTextField.hidden = YES;
    self.loginButton.hidden = YES;
    self.registeredButton.hidden = YES;
    
}

#pragma mark ==================登录页面重构=====================
-(void)makeUI
{
    //设置背景scrollview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.scrollView];
    
    //添加手势（因为手写输入法中。屏蔽touchbegin方法，采用添加手势的方法）
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGr];
    
    
    self.loginPageView = [[LoginPageView alloc]initWithFrame:CGRectMake(48, 124, self.view.frame.size.width - 96,400)];
    self.loginPageView.delegate = self;
    self.loginPageView.phoneNumTextField.delegate = self;
    self.loginPageView.passwordTextField.delegate = self;
    [self.scrollView addSubview:self.loginPageView];

}

#pragma mark =======forgetPassWordView代理方法========
-(void)hideKeyboard
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:time animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}
#pragma mark------textField代理方法-----------
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.loginPageView.phoneNumTextField == textField) {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength );
        }];
    }
    if (self.loginPageView.passwordTextField == textField) {
        [UIView  animateWithDuration:time animations:^{
            self.scrollView.contentOffset = CGPointMake(0, scrollViewLineLength * 2);
        }];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField == self.phoneNumberTextField) {
        
        self.passwordTextField.text = @"";
        self.tableView.hidden = YES;
        self.passwordTextField.text = @"";
        self.passwordConstraint.constant = 11;
        self.showListButton.selected = NO;
        
    }
        return YES;
}

#pragma mark --------------视图加载代理事件delegate----------
//点击注册按钮事件
-(void)registeredButtonAction
{
    CSPSignUpNewAccountViewController *securityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSignUpNewAccountViewController"];
//    security.phoneNum = ^(NSString *phoneNum)
//    {
//        self.phoneNumberTextField.text = phoneNum;
//    };
    [self.navigationController pushViewController:securityVC animated:YES];
}
//点击忘记密码按钮事件
-(void)forgetPasswordButtonAction
{

    CSPSafetyVerificationViewController *safetyVerificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSafetyVerificationViewController"];
    [self.navigationController pushViewController:safetyVerificationVC animated:YES];

}
//点击显示电话号码按钮事件
-(void)showPhonesListButtonAction:(UIButton *)showListButton
{
    showListButton.selected =! showListButton.selected;
    [self showListButtonClick];
    //显示电话号码列表
}
//点击登陆按钮事件
-(void)loginButtonActionPhoneNumberText:(NSString *)phoneNumTextField  passwordText:(NSString *)passwordTextField
{
    //对电话号码进行校验
    if (![CSPUtils checkMobileNumber:self.phoneNumberTextField.text]) {
        [self.view makeToast:@"手机号码格式错误" duration:2 position:@"center"];
        return;
    }
//    //对密码进行校验
//    if (![CSPUtils checkPassword:self.passwordTextField.text]) {
//        [self.view makeToast:@"登录密码格式错误" duration:2 position:@"center"];
//        return;
//    }
//    
    // 进行网络请求
    [self netWorkRequestPhone:phoneNumTextField password:passwordTextField];
    
}

#pragma mark --------------展示电话保存列表--------------
-(void)showListButtonClick
{
 
    

}
#pragma mark -------------------网络请求------------------

-(void)netWorkRequestPhone:(NSString *)phone password:(NSString *)pasaword
{
    /**
     *  注册响应
     */
    [self.passwordTextField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /**
     *  进行请求
     */
    [HttpManager sendHttpRequestForLoginWithMemberAccount:phone password:pasaword success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            //进行登录信息的保存
            LoginDTO *loginDTO = [LoginDTO sharedInstance];
            [loginDTO setDictFrom:[dic objectForKey:@"data"]];
            //进行tokenID和menberNo保存
            [MyUserDefault defaultSaveAppSetting_merchantNo:dic[@"data"][@"merchantNo"]];
            [MyUserDefault defaultSaveAppSetting_token:dic[@"data"][@"tokenId"]];
            
            
             [MyUserDefault defaultSaveAppSetting_loginPhone:self.phoneNumberTextField.text];
            
            
            loginDTO.memberAccount = self.phoneNumberTextField.text;
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
                if ([self.phoneNumberTextField.text isEqualToString:str]) {
                    isExisted = YES;
                }
            }
            if (isExisted == YES) {
                [array removeObject:self.phoneNumberTextField.text];
            }
            [array insertObject:self.phoneNumberTextField.text atIndex:0];
            if (array.count > 3) {
                [array removeLastObject];
            }
            accuntArray = [array copy];
            [userDefaults setObject:accuntArray forKey:@"myArray"];
            
            
            
            
            //!记录该用户是从登录界面进入，刷新商家列表
            [MyUserDefault defaultSave_logined];
            /**
             *  调方法，来进行判断进入那个页面
             */
            switch ([loginDTO convertStatusToInteger]) {
                    
                case 1:
                    //已注册
                    
                    //进行密码和账号保存
                    [MyUserDefault defaultSaveAppSetting_loginPassword:self.passwordTextField.text];
                
                    [self loadConsigneeInfo];
                    break;
                    
                case 2:
                    //等待审核
                    [self performSegueWithIdentifier:toAccountCheck sender:self];
                    break;
                case 3:
                    //审核未通过
                    [self performSegueWithIdentifier:toApplicationNotPassed sender:self];
                    break;
                case 4:
                {
                    //审核已通过  token过期弹出登录界面，登录界面移除也是需要用dissmiss方法的
                    //保存信息到plist文件中  h5交互需要用到
                    SaveUserIofo *saveIofo = [[SaveUserIofo alloc]init];
                    [saveIofo addIofoDTO:[dic objectForKey:@"data"]];
                    
                    
                    //进行密码和账号保存
                    [MyUserDefault defaultSaveAppSetting_loginPassword:self.passwordTextField.text];
                    
                    [MyUserDefault defaultSaveAppSetting_loginPhone:self.phoneNumberTextField.text];
                    
                    //用户通过后进行其他地方登录 //聊天登录
                    //聊天登录
                    UserOtherInfo *userOtherIofo = [[UserOtherInfo alloc]init];
                    [userOtherIofo assignmentPhoneNumber:self.phoneNumberTextField.text password:self.passwordTextField.text];
                    
                    //!是从token失效 过来的
                    if (self.isFromTokenLoseEfficacy) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];
                        return ;
                    }
                    //!0是 1否
                    if ([loginDTO.loginFlag isEqualToString:@"1"]) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    else {
                        [self performSegueWithIdentifier:toApplicationPassed sender:self];
                    }
                }
                    break;
                case 5:
                    /**
                     *   只是简单的关闭封号的页面
                     */
                    //关闭封号
                {
                    CSPAccountClosedViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAccountClosedViewController"];
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else{
            
            NSLog(@"登录失败errorMessage = %@",[dic objectForKey:@"errorMessage"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"手机号或登录密码有误" duration:2 position:@"center"];
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
        
    }];
}


#pragma mark ===============重构页面分界线==================

#pragma mark =================判断注册开关按钮==================
/*
-(void)determineRegistrationButtonDisplaysEvent
{
    
    self.registeredButton.hidden = YES;
    self.registeredButton.selected = NO;
    
    [HttpManager sendHttpRequestForSwitchsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //0开启、1关闭
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.registeredButton.selected = YES;

            
            if ([dic[@"data"][@"registFlag"] isEqualToString:@"1"]) {
                
                self.registeredButton.hidden = YES;
                
            }
            
            if ([dic[@"data"][@"registFlag"] isEqualToString:@"0"]) {
                
                self.registeredButton.hidden = NO;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.registeredButton.selected = YES;

    }];
}
*/




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /**
     *  注册第一响应者
     */
    [self.passwordTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
}



- (IBAction)backButtonClicked:(id)sender {
}


/**
 *  点击登录按钮，进行对textfield进行判断
 *
 *  @param sender  点击登录按钮，进行对textfield进行判断
 */

- (IBAction)loginButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    self.loginButton.selected = NO;
    
    if (![CSPUtils checkMobileNumber:self.phoneNumberTextField.text]) {
        [self.view makeToast:@"手机号码格式错误" duration:2 position:@"center"];
        return;
    }
    
    if (![CSPUtils checkPassword:self.passwordTextField.text]) {
        [self.view makeToast:@"登录密码格式错误" duration:2 position:@"center"];
        return;
    }
    
    /**
     *  注册响应
     */
    [self.passwordTextField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /**
     *  进行请求
     */
    [HttpManager sendHttpRequestForLoginWithMemberAccount:self.phoneNumberTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.loginButton.selected = YES;

            NSLog(@"登录成功");
            
            LoginDTO *loginDTO = [LoginDTO sharedInstance];
            
            [loginDTO setDictFrom:[dic objectForKey:@"data"]];
            
            //进行省市区版本控制 
            CityPropValueDefault * propValueDefalut = [CityPropValueDefault shareManager];
            [propValueDefalut dataPropValueControl];
            
            //!判断是否是苹果审核账号
            if ([self.phoneNumberTextField.text isEqualToString:AppleAccount]) {
                
                //!是
                [MyUserDefault saveIsAppleAcount];
                
            }else{
                
                //!不是，移除本地保存的判断值
                [MyUserDefault removeIsAppleAccount];

            }
            
            //进行tokenID和menberNo保存
            [MyUserDefault defaultSaveAppSetting_merchantNo:dic[@"data"][@"merchantNo"]];
            
            [MyUserDefault defaultSaveAppSetting_token:dic[@"data"][@"tokenId"]];
            
            loginDTO.memberAccount = self.phoneNumberTextField.text;
            

            
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
                
                if ([self.phoneNumberTextField.text isEqualToString:str]) {
                    
                    isExisted = YES;
                }
            }
            if (isExisted == YES) {
                
                [array removeObject:self.phoneNumberTextField.text];
            }
            
            [array insertObject:self.phoneNumberTextField.text atIndex:0];
            
            if (array.count > 3) {
                
                [array removeLastObject];
                
            }
            
            accuntArray = [array copy];
            
            [userDefaults setObject:accuntArray forKey:@"myArray"];
            
            
            //!记录该用户是从登录界面进入，刷新商家列表
            [MyUserDefault defaultSave_logined];
            
            /**
             *  调方法，来进行判断进入那个页面
             */
            switch ([loginDTO convertStatusToInteger]) {
                    
                case 1:
                    //已注册
                    
                    //进行密码和账号保存
                    [MyUserDefault defaultSaveAppSetting_loginPassword:self.passwordTextField.text];
                    [MyUserDefault defaultSaveAppSetting_loginPhone:self.phoneNumberTextField.text];
                    
                    [self loadConsigneeInfo];
                    break;
                    
                case 2:
                    //等待审核
                    [self performSegueWithIdentifier:toAccountCheck sender:self];
                    break;
                case 3:
                    //审核未通过
                    [self performSegueWithIdentifier:toApplicationNotPassed sender:self];
                    break;
                case 4:
                {
                    
                    //审核已通过  token过期弹出登录界面，登录界面移除也是需要用dissmiss方法的
                    //保存信息到plist文件中  h5交互需要用到
                    SaveUserIofo *saveIofo = [[SaveUserIofo alloc]init];
                    [saveIofo addIofoDTO:[dic objectForKey:@"data"]];
                    
                    
                    //进行密码和账号保存
                    [MyUserDefault defaultSaveAppSetting_loginPassword:self.passwordTextField.text];
                    
                    [MyUserDefault defaultSaveAppSetting_loginPhone:self.phoneNumberTextField.text];
                    
                    
                    
                    //用户通过后进行其他地方登录 //聊天登录
                    //聊天登录
                    UserOtherInfo *userOtherIofo = [[UserOtherInfo alloc]init];
                    [userOtherIofo assignmentPhoneNumber:self.phoneNumberTextField.text password:self.passwordTextField.text];
                    
                    //!是从token失效 过来的
                    if (self.isFromTokenLoseEfficacy && ![loginDTO.loginFlag isEqualToString:@"0"]) {
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];

                        
                        return ;
                    
                    }
                    
                   
                    
                    
                    //!0是 1否
                    if ([loginDTO.loginFlag isEqualToString:@"1"]) {
                       
//                        [self dismissViewControllerAnimated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];

                    }
                    else {
                       
                        [self performSegueWithIdentifier:toApplicationPassed sender:self];
                        
                    }
                    
                    
                }
                    /**
                     *  审核通过以后进行会员信心的申请
                     */
                    //                    [MHImageDownloadManager sharedInstance];
                    //                    [[DownloadLogControl sharedInstance] loadStateFromPlist];
                    //
                    //                    //获取会员信息
                    //                    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //                        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    //
                    //                        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    //
                    //                            [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
                    //
                    //                        }
                    //                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //
                    //                    }];
                    //
                    //                    /**
                    //                     *  聊天登录链接
                    //                     */
                    //                    //聊天登录
                    //                    [[ChatManager shareInstance] connectToServer:[NSString stringWithFormat:@"%@_0", self.phoneNumberTextField.text] passWord:[[self.passwordTextField.text MD5Hash] lowercaseString]];
                    //
                    //
                    //                    /**
                    //                     * 代开聊天的数据库进行判断
                    //                     */
                    //                    //打开聊天数据库
                    //                    [[DeviceDBHelper sharedInstance] openDataBasePath:[NSString stringWithFormat:@"%@_0", self.phoneNumberTextField.text]];
                    
                    break;
                    
                    
                case 5:
                    /**
                     *   只是简单的关闭封号的页面
                     */
                    //关闭封号
                    
                {
                    CSPAccountClosedViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPAccountClosedViewController"];
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else{
            
            NSLog(@"登录失败errorMessage = %@",[dic objectForKey:@"errorMessage"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"手机号或登录密码有误" duration:2 position:@"center"];
        }
        
        NSLog(@"dic = %@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.loginButton.selected = YES;

        [self.view makeToast:@"无法连接到服务器" duration:2 position:@"center"];
        //        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
}
/**
 *  保存的电话号码进行展示用
 */
- (void)setupTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] init];
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.7].CGColor;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
        
    
}



/**
 *  进行注册，调用请求数据
 */
- (void)loadConsigneeInfo {
    
    [HttpManager sendHttpRequestForConsigneeGetListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
          
            NSArray *arr = dic[@"data"];
            
            if (arr.count != 0) {
                /**
                 *  用户注册成功后，进行信息保存
                 */
                
                //详细地址
                [MyUserDefault defaultSaveAppSetting_areaDetail:[NSString stringWithFormat:@"%@ %@ %@",dic[@"data"][0][@"provinceName"],dic[@"data"][0][@"cityName"],dic[@"data"][0][@"countyName"]]];
                
                
                //保存名字
                [MyUserDefault defaultSaveAppSetting_name:dic[@"data"][0][@"consigneeName"]];
                
                //保存电话号码
                [MyUserDefault  defaultSaveAppSetting_phone:dic[@"data"][0][@"consigneePhone"]];
                
                //省id
                [MyUserDefault defaultSaveAppSetting_stateId:dic[@"data"][0][@"provinceNo"]];
                //市id
                [MyUserDefault defaultSaveAppSetting_cityId:dic[@"data"][0][@"cityNo"]];
                //区ID
                [MyUserDefault defaultSaveAppSetting_districtId:dic[@"data"][0][@"countyNo"]];
                
                //详细地址
                [MyUserDefault defaultSaveAppSetting_area:dic[@"data"][0][@"detailAddress"]];
                
            }
            
            
            GetConsigneeListDTO* getConsigneeListDTO = [[GetConsigneeListDTO alloc] initWithDictionary:dic];
            
    
            CSPCodeVerifyViewController *codeVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPCodeVerifyViewController"];
            codeVerify.isAddress = getConsigneeListDTO.consigneeList.count;
            codeVerify.islogin = YES;
            [self.navigationController pushViewController:codeVerify animated:YES];
                //[self performSegueWithIdentifier:toFillAddress sender:self];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"查询收货地址列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
    
}



/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}
*/

#pragma mark--
#pragma UITableViewDataSource(电话号码列表的展示数据)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSPBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell) {
        cell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 21, 200, 13)];
    
    titleLabel.text = listArray[indexPath.row];
    titleLabel.font =  [UIFont systemFontOfSize:13];
    titleLabel.textColor = fontColor;
    titleLabel.alpha = 0.7;
    [cell addSubview:titleLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40.5, cell.frame.size.width, 1)];
    lineLabel.backgroundColor = fontColor;
    [cell addSubview:lineLabel];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}


#pragma mark--
#pragma UITableViewDelegate（点击电话列表，点击后进行电话号码的替换）

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.phoneNumberTextField.text = listArray[indexPath.row];
    self.tableView.hidden = YES;
    self.passwordTextField.text = @"";
    self.passwordConstraint.constant = 11;
    self.showListButton.selected = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if (self.tableView.hidden == NO) {
        self.tableView.hidden = YES;
        self.passwordConstraint.constant = 11;
        self.showListButton.selected = NO;
    }
}

/**
 *  点击三角按钮，进行电话号码的列表的展示（主要求frame，根据数据中电话号码的个数进行列表展示frame的尺寸）
 *
 *  @param sender
 */
- (IBAction)showListButtonClicked:(id)sender {
    
    
    if (self.tableView.hidden == YES) {
        self.showListButton.selected = YES;
        switch (listArray.count) {
            case 0:
                
                break;
            case 1:
                self.tableView.frame = CGRectMake(self.phoneNumberTextField.frame.origin.x ,self.phoneNumberTextField.frame.origin.y + self.phoneNumberTextField.frame.size.height-1,self.phoneNumberTextField.frame.size.width,41);
                [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 52;
                break;
            case 2:
                self.tableView.frame = CGRectMake(self.phoneNumberTextField.frame.origin.x ,self.phoneNumberTextField.frame.origin.y + self.phoneNumberTextField.frame.size.height-1,self.phoneNumberTextField.frame.size.width,82);
                [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 93;
                break;
            case 3:
                self.tableView.frame = CGRectMake(self.phoneNumberTextField.frame.origin.x ,self.phoneNumberTextField.frame.origin.y + self.phoneNumberTextField.frame.size.height-1,self.phoneNumberTextField.frame.size.width,123);
                [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 134;
                break;
                
            default:
                break;
        }
        
    }
    else{
        self.showListButton.selected = NO;
        self.tableView.hidden = YES;
        self.passwordConstraint.constant = 11;
    }
}



#pragma mark --------js-----
//点击进入下一个页面
- (IBAction)didClickJSBtnAction:(id)sender {
//    TextFieldViewController *text = [[TextFieldViewController alloc]init];
//    [self.navigationController pushViewController:text animated:YES];
}
@end
