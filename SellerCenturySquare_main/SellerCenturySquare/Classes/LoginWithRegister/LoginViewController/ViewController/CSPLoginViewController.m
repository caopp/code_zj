//
//  CSPLoginViewController.m
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//


#import "CSPLoginViewController.h"
#import "CustomButton.h"
#import "ChooseView.h"
#import "CSPSecurityCheckViewController.h"
#import "LoginDTO.h"
#import "AppDelegate.h"
#import "ChatManager.h"
#import "DeviceDBHelper.h"
#import "NSString+Hashing.h"
#import "MHImageDownloadManager.h"
#import "DownloadLogControl.h"
#import "UIColor+UIColor.h"
#import "LoginLabel.h"
#import "MyUserDefault.h"
#import "CSPChangePwdViewController.h"
#import "SaveUserIofo.h"

#import "JSWithNativeViewController.h"
#import "MerchantsInController.h"//!商家入驻


#define timeShow 0.5
#define FRAMR_Y_FOR_KEYBOARD_SHOW   (-70)
#define LGNOClickColor [UIColor colorWithHexValue:0xffffff alpha:0.3] //线条颜色
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条
#define LGButtonColor [UIColor colorWithHexValue:0xffffff alpha:0.7]  //点击后线条

/**
 *  设置弹出显示的信息
 */
#import "Toast+UIView.h"
#import "CSPUtils.h"
#import "UserOtherIofo.h"
//第一登录提示框，提示用户修改密码
#import "GUAAlertView.h"
#import "CSPNavigationController.h"
#import "AppDelegate.h"
static const CGFloat iphone4height = 480.0f;
@interface CSPLoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listArray;
}

//滑动
@property (strong,nonatomic)UIScrollView *guideScrollView;
@property (strong,nonatomic)UIPageControl *pageControl;

#pragma mark -----设置table，显示账号---
@property(strong,nonatomic)UITableView *tableView;
#pragma mark --属性--------

//登录按钮
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
//电话号码列表展示按钮
@property (strong, nonatomic) IBOutlet UIButton *showListButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordConstraint;
//忘记密码按钮
@property (strong, nonatomic) IBOutlet UIButton *forgetButton;
//!商家入驻
@property (weak, nonatomic) IBOutlet UIButton *merchantsInBtn;



#pragma mark -----方法-----
//登录
- (IBAction)didClickLoginBtnAction:(id)sender;
//忘记密码
- (IBAction)didClickForgetPswAction:(id)sender;
@end

@implementation CSPLoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //UI显示
    [self.loginBtn setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    
    [self.forgetButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    
    [self.merchantsInBtn setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    
    [self.loginBtn setTitleColor:LGClickColor forState:(UIControlStateSelected)];
    
    [self.forgetButton setTitleColor:LGClickColor forState:(UIControlStateSelected)];
    
    [self.merchantsInBtn setTitleColor:LGClickColor forState:(UIControlStateSelected)];

    [self.navigationItem setHidesBackButton:YES];

    LoginLabel *label = [[LoginLabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    
    [label settingLoginLabelLine];
    
    [self.navigationController.view addSubview:label];

    /**
     *  进行电话号码和密码保存（保存到数组中，进行展示运用）
     */
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    listArray= [userDefault arrayForKey:@"myArray"];
    
    if (listArray.count == 0) {
        
        [self.phoneNumtextField becomeFirstResponder];
        
    }else
    {
        self.phoneNumtextField.text = listArray[0];
       [self.pswTextField becomeFirstResponder];
    }
    
    if (self.isOff == YES) {
      
        NSNotification *notification = [[NSNotification alloc]initWithName:@"notification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.view endEditing:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //题目显示
    self.title = @"用户登录";
    //设置table，显示成功登录的账号
    [self setupTable];
    [self.pswTextField setSecureTextEntry:YES];
    self.showListButton.selected = NO;
    //  按钮选中状态
    [self.showListButton setImage:[UIImage imageNamed:@"02_登录_下拉"] forState:UIControlStateNormal];
    [self.showListButton setImage:[UIImage imageNamed:@"02_登录_收回"] forState:UIControlStateSelected];
    //判断商家按钮按钮显示事件
    [self determineRegistrationButtonDisplaysEvent];
   
    
    self.phoneNumtextField.delegate = self;
    
    
//    //改变密码进行试验
//    CSPChangePwdViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPChangePwdViewController"];
//    
//    [self.navigationController pushViewController:securityCheckViewController animated:YES];

    
}
#pragma mark =================判断商家按钮按钮显示事件==================
-(void)determineRegistrationButtonDisplaysEvent
{
    self.merchantsInBtn.hidden = YES;
    //! 1的时候按钮隐藏，0的时候按钮不隐藏
    [HttpManager sendHttpRequestForSwitchsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([dic[@"data"][@"merchantInFlag"] isEqualToString:@"1"]) {
                
                self.merchantsInBtn.hidden = YES;
                
            }
            
            if ([dic[@"data"][@"merchantInFlag"] isEqualToString:@"0"]) {
                
                self.merchantsInBtn.hidden = NO;
            }
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@",error]);
        self.merchantsInBtn.selected = YES;
    }];
}

#pragma mark -----对电话号码和密码进行校验------
/**
 *  对手机号码进行检验
 */
-(BOOL)verityPhoneNum
{
    if (self.phoneNumtextField.text.length == 0 && self.phoneNumtextField.text.length > 11) {
        [self.view makeToast:@"请输入手机号" duration:2.0f position:@"center"];
        return  NO;
    }
    if (![CSPUtils checkMobileNumber:self.phoneNumtextField.text]) {
       [self.view makeToast:@"手机号码格式错误" duration:2.0f position:@"center"];
        return NO;
    }
    
    return YES;
}



/**
 *  对验证码进行检验
 */
-(BOOL)verityCode
{
    if (![CSPUtils checkPassword:self.pswTextField.text]) {
        [self.view makeToast:@"请输入正确密码格式" duration:2 position:@"center"];

        return NO;
    }
    return  YES;
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -------登录按钮执行方法------
//点击登录按钮操作行为
- (IBAction)didClickLoginBtnAction:(id)sender {
    
    [self.view endEditing:YES];

    //对手机账号进行判断
    if (![self verityPhoneNum]) {
        return;
    }
    
    //对密码进行校验
    
    //对验证码进行判断
    if (![self verityCode]) {
        return;
    }
    [self loginWithAccount:self.phoneNumtextField.text password:self.pswTextField.text];
    
}

-(void)loginWithAccount:(NSString *)account  password:(NSString *)password
{
    
    //菊花
    [self progressHUDShowWithString:@"登录中"];
     
    [HttpManager sendHttpRequestForLoginWithMemberAccount:account password:password success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            /**
             *  保存请求过来数据(采用单例)
             */
            [[LoginDTO sharedInstance]setDictFrom:[responseDic objectForKey:@"data"]];
            //保存账号
            
            //记录帐号
            SaveUserIofo *saveIofo = [[SaveUserIofo alloc]init];
            [saveIofo addIofoDTO:[responseDic objectForKey:@"data"]];
            
            //保存电话号码和密码（退出登录时候进行删除）
            [MyUserDefault defaultSaveAppSetting_password:self.pswTextField.text];
            [MyUserDefault defaultSaveAppSetting_phone:self.phoneNumtextField.text];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *accuntArray = [userDefaults arrayForKey:@"myArray"];
            
            if (accuntArray == nil) {
                accuntArray = [[NSArray alloc]init];
            }
            
            NSMutableArray *array = [accuntArray mutableCopy];
            BOOL isExisted;
            isExisted = NO;
            for (NSString *str in array) {
                if ([self.phoneNumtextField.text isEqualToString:str]) {
                    isExisted = YES;
                }
            }
            if (isExisted == YES) {
                [array removeObject:self.phoneNumtextField.text];
            }
            
            [array insertObject:self.phoneNumtextField.text atIndex:0];
            if (array.count > 3) {
                [array removeLastObject];
            }
            
            accuntArray = [array copy];
            
            //进行电话号码和密码保存
            [userDefaults setObject:accuntArray forKey:@"myArray"];

            //对用户是否第一次登录进行判断
            [MyUserDefault defaultSaveAppSetting_firstLogin:responseDic[@"data"][@"firstLogin"]];
            
            UserOtherIofo *userOtherIofo = [[UserOtherIofo alloc]init];
            
            // 根据登录账户,初始化下载器 聊天登录 打开聊天数据库
            [userOtherIofo assignmentPhoneNumber:self.phoneNumtextField.text password:self.pswTextField.text];
            
            
            
            [self getMerchantInfo];
            
            
        }else  {
            [self alertViewWithTitle:@"登录失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
          
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
    }];
    
}

-(void)enterMainTabBarViewController
{
    //更新window rootViewController
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate updateRootViewController:self.tabBarController];
    
}

//点击忘记密码操作行为
- (IBAction)didClickForgetPswAction:(id)sender {
    
    CSPSecurityCheckViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSecurityCheckViewController"];
    
    [self.navigationController pushViewController:securityCheckViewController animated:YES];
    
}



/**
 *  点击按钮出现成功登录过的账号
 *
 *  @return 返回成功登录过的账号
 */
- (IBAction)didClickBackPhoneNumsAction:(id)sender {
    
    if (self.tableView.hidden == YES) {
        self.showListButton.selected = YES;
        switch (listArray.count) {
            case 0:
                
                break;
            case 1:
                self.tableView.frame = CGRectMake(self.phoneNumtextField.frame.origin.x ,self.phoneNumtextField.frame.origin.y + self.phoneNumtextField.frame.size.height-1,self.phoneNumtextField.frame.size.width,44);
                [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 66;
                break;
            case 2:
                self.tableView.frame = CGRectMake(self.phoneNumtextField.frame.origin.x ,self.phoneNumtextField.frame.origin.y + self.phoneNumtextField.frame.size.height-1,self.phoneNumtextField.frame.size.width,88);
                [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 110;
                break;
            case 3:
                self.tableView.frame = CGRectMake(self.phoneNumtextField.frame.origin.x ,self.phoneNumtextField.frame.origin.y + self.phoneNumtextField.frame.size.height-1,self.phoneNumtextField.frame.size.width,132);
                    [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 154;
                break;
                
            default:
                break;
        }
    }
    else{
        self.showListButton.selected = NO;
        self.tableView.hidden = YES;
        self.passwordConstraint.constant = 16;
    }
}


// !大B商家信息接口
- (void)getMerchantInfo{
    
    
    [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                // !是否是主账号
                [MyUserDefault setJudgeUserAccount:dic[@"data"][@"isMaster"]];
                
                //!标志用户登录过，以后就不强制用户登录（主要用于3.0.2版本）
                [MyUserDefault saveMustLoginSign];
                
                
                GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                
            }
            //进入tabbar控制器
            [self enterMainTabBarViewController];
            
        }else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    } ];
    
    
    
    
}

#pragma mark --------设置table显示显示账号----
/**
 *  进行table的设置
 *
 *  @return 返回table显示的账号
 */
-(void)setupTable
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] init];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}

#pragma UITableViewDataSource(电话号码列表的展示数据)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 22, 200, 13)];
    
    //线条
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, cell.frame.size.width, 1)];
    lineLabel.backgroundColor = LGButtonColor;
    [cell addSubview:lineLabel];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    
    titleLabel.text = listArray[indexPath.row];
    titleLabel.font =  [UIFont systemFontOfSize:13];
    [titleLabel setTextColor:LGButtonColor];
    [cell addSubview:titleLabel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma UITableViewDelegate（点击电话列表，点击后进行电话号码的替换）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.phoneNumtextField.text = listArray[indexPath.row];
    self.tableView.hidden = YES;
    self.passwordConstraint.constant = 16;
     self.showListButton.selected = NO;

    
}

#pragma mark -----点击键盘消失----
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.phoneNumtextField resignFirstResponder];
    [self.pswTextField resignFirstResponder];
    
    if (self.tableView.hidden == NO) {
        self.tableView.hidden = YES;
        
        self.passwordConstraint.constant = 18;
        self.showListButton.selected = NO;
        
    }
}
#pragma UITextFieldDelegate(点击textfield对frame的大小进行改变)
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.pswTextField) {
        [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.pswTextField) {
        [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumtextField) {
        self.pswTextField.text = nil;
        self.tableView.hidden = YES;
        self.passwordConstraint.constant = 16;
        self.showListButton.selected = NO;
    }
    
    return YES;
}


//动画
- (void)animationForContentView:(CGRect)rect{
    NSTimeInterval animationDuration = timeShow;
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma mark-立即体验
- (void)enterButton:(UIButton *)sender{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:NOFIRSTLOGIN];
    [userDefaults synchronize];
    
    [self.guideScrollView removeFromSuperview];
    self.guideScrollView = nil;
    
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
    
}
#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}




- (IBAction)didClickJS:(id)sender {
    
    JSWithNativeViewController *js = [[JSWithNativeViewController alloc]init];
    [self.navigationController pushViewController:js animated:YES];
}

#pragma mark 商家入驻

- (IBAction)merchantsInClick:(id)sender {
    
    MerchantsInController *inVc = [[MerchantsInController alloc]init];
    
    [self.navigationController pushViewController:inVc animated:YES];
    
    
    
    
}


@end
