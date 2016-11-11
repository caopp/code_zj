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
//#import "TestHttpViewController.h"
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

@interface CSPLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listArray;
}

- (IBAction)backButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet CustomTextField2 *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *showListButton;
- (IBAction)showListButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

//@property (assign,nonatomic) BOOL isLocalUser;

- (IBAction)loginButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordConstraint;

@end

@implementation CSPLoginViewController

static NSString* toCheckInvitation = @"toCheckInvitation";
static NSString* toFillAddress = @"toFillAddressPage";
static NSString* toAccountClosed = @"toAccountClosedPage";
static NSString* toApplicationPassed = @"toApplicationPassedPage";
static NSString* toApplicationNotPassed = @"toApplicationNotPassedPage";
static NSString* toAccountCheck = @"toAccountCheckPage";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"叮咚欧品商户登录";
    
    self.phoneNumberTextField.delegate = self;
    self.passwordTextField.delegate = self;
   
    self.showListButton.selected = NO;

    
#ifdef DEBUG
    self.loginButton.hidden = YES;
#else
    self.loginButton.hidden = YES;
#endif
    
    
//    self.phoneNumberTextField.text = @"18661071018";
//    self.passwordTextField.text = @"123456";
    
    
    
    
//    if (self.isLocalUser == NO) {
//        [self.phoneNumberTextField becomeFirstResponder];
//    }else{
//        [self.passwordTextField becomeFirstResponder];
//    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    listArray= [userDefaults arrayForKey:@"myArray"];
    
    if (listArray.count == 0) {
        [self.phoneNumberTextField becomeFirstResponder];
    }else
    {
        self.phoneNumberTextField.text = listArray[0];
//        self.passwordTextField.text = @"123456";
        [self.passwordTextField becomeFirstResponder];
        
    }
    
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.passwordTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    
//    [self.navigationController.rdv_tabBarController setSelectedIndex:0];
}



- (IBAction)backButtonClicked:(id)sender {
    
//    TestHttpViewController *testHttpViewController =  [[TestHttpViewController alloc] initWithNibName:@"TestHttpViewController" bundle:nil];
//    
//    [self presentViewController:testHttpViewController animated:YES completion:nil];
}
- (IBAction)loginButtonClicked:(id)sender {
    
    if (![CSPUtils checkMobileNumber:self.phoneNumberTextField.text]) {
        [self.view makeToast:@"手机号码格式错误" duration:2 position:@"center"];
        return;
    }
    
    if (![CSPUtils checkPassword:self.passwordTextField.text]) {
        [self.view makeToast:@"请输入正确密码格式" duration:2 position:@"center"];
        return;
    }
    
    [self.passwordTextField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager sendHttpRequestForLoginWithMemberAccount:self.phoneNumberTextField.text password:self.passwordTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSLog(@"登录成功");
            
            LoginDTO *loginDTO = [LoginDTO sharedInstance];
            
            [loginDTO setDictFrom:[dic objectForKey:@"data"]];
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
            
//            BOOL isFirstStarting = YES;

//            NSNumber* value = [[NSUserDefaults standardUserDefaults] valueForKey:@"KeyForAccountCheckPassed"];
//            if (value && value.boolValue == YES) {
//                isFirstStarting = NO;
//            }
            
//            switch (3) {
            switch ([loginDTO convertStatusToInteger]) {
                case 1:
                    //已注册
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
                    //审核已通过
                    if ([loginDTO.loginFlag isEqualToString:@"1"]) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self performSegueWithIdentifier:toApplicationPassed sender:self];
                    }

                    [MHImageDownloadManager sharedInstance];
                    [[DownloadLogControl sharedInstance] loadStateFromPlist];
                    
                    //获取会员信息
                    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                        
                        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                            
                            [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                    
                    //聊天登录
                    [[ChatManager shareInstance] connectToServer:[NSString stringWithFormat:@"%@_0", self.phoneNumberTextField.text] passWord:[[self.passwordTextField.text MD5Hash] lowercaseString]];
                    //打开聊天数据库
                    [[DeviceDBHelper sharedInstance] openDataBasePath:[NSString stringWithFormat:@"%@_0", self.phoneNumberTextField.text]];

                    break;
                case 5:
                    //关闭封号
                    [self performSegueWithIdentifier:toAccountClosed sender:self];
                    break;

                    
                default:
                    break;
            }
//            [self dismissViewControllerAnimated:YES completion:nil];
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
//        [self dismissViewControllerAnimated:YES completion:nil];
    
    }];
    

}

- (void)setupTableView
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

- (void)loadConsigneeInfo {
    [HttpManager sendHttpRequestForConsigneeGetListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            GetConsigneeListDTO* getConsigneeListDTO = [[GetConsigneeListDTO alloc] initWithDictionary:dic];
            if (getConsigneeListDTO.consigneeList.count > 0) {
                [self performSegueWithIdentifier:toCheckInvitation sender:self];
            } else {
                [self performSegueWithIdentifier:toFillAddress sender:self];
            }
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"查询收货地址列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0 position:@"center"];;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}


#pragma mark--
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, FRAMR_Y_FOR_KEYBOARD_SHOW, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//     [self animationForContentView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    return YES;
//}

#pragma mark--
#pragma UITableViewDataSource

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
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 24, 200, 13)];
    
    titleLabel.text = listArray[indexPath.row];
    titleLabel.font =  [UIFont fontWithName:@"SourceHanSansCN-Normal" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.alpha = 0.7;
    [cell addSubview:titleLabel];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark--
#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.phoneNumberTextField.text = listArray[indexPath.row];
    self.tableView.hidden = YES;
    self.passwordTextField.text = @"";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if (self.tableView.hidden == NO) {
        self.tableView.hidden = YES;
        self.passwordConstraint.constant = 22;
        self.showListButton.selected = NO;
    }

}



- (IBAction)showListButtonClicked:(id)sender {
    
    
    if (self.tableView.hidden == YES) {
        self.showListButton.selected = YES;
        switch (listArray.count) {
            case 0:
                
                break;
            case 1:
                self.tableView.frame = CGRectMake(self.phoneNumberTextField.frame.origin.x ,self.phoneNumberTextField.frame.origin.y + self.phoneNumberTextField.frame.size.height-1,self.phoneNumberTextField.frame.size.width,44);
                [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 66;
                break;
            case 2:
                self.tableView.frame = CGRectMake(self.phoneNumberTextField.frame.origin.x ,self.phoneNumberTextField.frame.origin.y + self.phoneNumberTextField.frame.size.height-1,self.phoneNumberTextField.frame.size.width,88);
                [self.tableView setHidden:NO];
                self.passwordConstraint.constant = 110;
                break;
            case 3:
                self.tableView.frame = CGRectMake(self.phoneNumberTextField.frame.origin.x ,self.phoneNumberTextField.frame.origin.y + self.phoneNumberTextField.frame.size.height-1,self.phoneNumberTextField.frame.size.width,132);
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
        self.passwordConstraint.constant = 22;
    }
}
@end
