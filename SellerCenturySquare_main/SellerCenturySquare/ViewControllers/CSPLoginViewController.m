//
//  CSPLoginViewController.m
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPLoginViewController.h"
#import "CustomTextField.h"
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
#import "CustomTextField2.h"
#import "UIColor+UIColor.h"
#import "LoginLabel.h"
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

@property (strong, nonatomic) IBOutlet CustomTextField2 *phoneNumtextField;

@property (strong, nonatomic) IBOutlet CustomTextField *pswTextField;

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *showListButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordConstraint;
@property (strong, nonatomic) IBOutlet UIButton *forgetButton;



#pragma mark -----方法-----

//登录
- (IBAction)didClickLoginBtnAction:(id)sender;

//忘记密码
- (IBAction)didClickForgetPswAction:(id)sender;
@end

@implementation CSPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置table，显示成功登录的账号
    [self setupTable];
    
    self.title = @"叮咚管家商户登录";
 
    self.pswTextField.delegate = self;

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
        [self.pswTextField setSecureTextEntry:YES];
    }
    self.showListButton.selected = NO;

    //  按钮选中状态
    [self.showListButton setImage:[UIImage imageNamed:@"02_登录_下拉"] forState:UIControlStateNormal];
    [self.showListButton setImage:[UIImage imageNamed:@"good_categoryUp"] forState:UIControlStateSelected];

    
    
    

    //添加引导页面（引导页面）
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isNoFirstLogin = [userDefaults objectForKey:NOFIRSTLOGIN];
    if (!isNoFirstLogin) {
        //展示引导页面
        UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];

        NSMutableArray *imagesArray;
        
        if (screenWindow.frame.size.height == iphone4height) {
            
            imagesArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"引导1_iphone4"],[UIImage imageNamed:@"引导2_iphone4"],[UIImage imageNamed:@"引导3_iphone4"],[UIImage imageNamed:@"引导4_iphone4"],[UIImage imageNamed:@"引导5_iphone4"], nil];

        }else{
            imagesArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"引导1"],[UIImage imageNamed:@"引导2"],[UIImage imageNamed:@"引导3"],[UIImage imageNamed:@"引导4"],[UIImage imageNamed:@"引导5"], nil];
        }
        
        self.guideScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWindow.frame.size.width, screenWindow.frame.size.height)];
        
        self.guideScrollView.contentSize = CGSizeMake(screenWindow.frame.size.width*5, screenWindow.frame.size.height);
        
        self.guideScrollView.pagingEnabled = YES;
        
        self.guideScrollView.bounces = NO;
        
        self.guideScrollView.showsHorizontalScrollIndicator = NO;
        
        self.guideScrollView.showsVerticalScrollIndicator = NO;
        
        for (int i = 0; i < imagesArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*screenWindow.frame.size.width, 0, screenWindow.frame.size.width, screenWindow.frame.size.height)];
            
            imageView.image = [imagesArray objectAtIndex:i];
            
            [self.guideScrollView addSubview:imageView];
            
            if (i == imagesArray.count-1) {
                //添加立即体验按钮
                UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                enterButton.frame = CGRectMake(20, screenWindow.frame.size.height-120, screenWindow.frame.size.width-40, 80);
                enterButton.backgroundColor = [UIColor redColor];
                enterButton.alpha = 0.5;
                
                [enterButton addTarget:self action:@selector(enterButton:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:enterButton];
                imageView.userInteractionEnabled = YES;
            }
        }
        
        self.guideScrollView.delegate = self;
        [screenWindow addSubview:self.guideScrollView];
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, screenWindow.frame.size.height-50, screenWindow.frame.size.width-40, 30)];
        self.pageControl.numberOfPages = imagesArray.count;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [screenWindow addSubview:self.pageControl];
    }
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
    if (self.pswTextField.text.length == 0) {
        [self.view makeToast:@"请输入密码" duration:2.0f position:@"center"];
        return NO;
    }
    return  YES;
}
#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//点击登录按钮操作行为
- (IBAction)didClickLoginBtnAction:(id)sender {
    //对手机账号进行判断
    if (![self verityPhoneNum]) {
        return;
    }
    //对验证码进行判断
    if (![self verityCode]) {
        return;
    }
    //菊花
    [self progressHUDShowWithString:@"登录中"];
    
    [HttpManager sendHttpRequestForLoginWithMemberAccount:self.phoneNumtextField.text password:self.pswTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            /**
             *  保存请求过来数据(采用单例)
             */
            [[LoginDTO sharedInstance]setDictFrom:[responseDic objectForKey:@"data"]];
            //保存账号
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
            
            [userDefaults setObject:accuntArray forKey:@"myArray"];
            
            
            
            
            // 根据登录账户,初始化下载器
            [MHImageDownloadManager sharedInstance];
            [[DownloadLogControl sharedInstance] loadStateFromPlist];
            //聊天登录
            [[ChatManager shareInstance] connectToServer:[NSString stringWithFormat:@"%@_1", self.phoneNumtextField.text] passWord:[[self.phoneNumtextField.text MD5Hash] lowercaseString]];
            //打开聊天数据库
            [[DeviceDBHelper sharedInstance] openDataBasePath:[NSString stringWithFormat:@"%@_1", self.phoneNumtextField.text]];
            //更新window rootViewController
            AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            [delegate updateRootViewController:self.tabBarController];
            
        }else{
            
            [self alertViewWithTitle:@"登录失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
    }];
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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 24, 200, 13)];
    titleLabel.text = listArray[indexPath.row];
    titleLabel.font =  [UIFont fontWithName:@"SourceHanSansCN-Normal" size:13];
    [titleLabel setTextColor:LGNOClickColor];
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
    
}

#pragma mark -----点击键盘消失----
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.pswTextField resignFirstResponder];
    [self.phoneNumtextField resignFirstResponder];
    if (self.tableView.hidden == NO) {
        self.tableView.hidden = YES;
        self.passwordConstraint.constant = 18;
        self.showListButton.selected = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [super viewWillAppear:animated];
        
        [self.loginBtn setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
        [self.forgetButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
        [self.loginBtn setTitleColor:LGClickColor forState:(UIControlStateSelected)];
        [self.forgetButton setTitleColor:LGClickColor forState:(UIControlStateSelected)];
    

    LoginLabel *label = [[LoginLabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    [label settingLoginLabelLine];
//    [self.view addSubview:label];
    [self.navigationController.view addSubview:label];
    
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

- (void)animationForContentView:(CGRect)rect{
    
    NSTimeInterval animationDuration = timeShow;
    
    [UIView beginAnimations:@"Animation" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}











@end
