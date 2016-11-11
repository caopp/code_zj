//
//  CSPAccountAndSaftyTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAccountAndSaftyTableViewController.h"
//#import "CSPSettingChangePasswordViewController.h"
#import "CSPSettingSafetyVerificationViewController.h"
#import "CSPResetPayPasswordViewController.h"

#import "CSPSettingPayPasswordViewController.h"
#import "CSPBaseTableViewCell.h"

@interface CSPAccountAndSaftyTableViewController ()
{
    NSString *acount;
    
    NSArray *leftNameArr ;
}

@end

@implementation CSPAccountAndSaftyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"accountSecurity", @"账户与安全");
    
    leftNameArr = @[NSLocalizedString(@"memberName", @"会员名"),
                    NSLocalizedString(@"changeLoginPwd", @"修改登录密码"),
                    NSLocalizedString(@"changPayPwd", @"重置支付密码")];
    
    
    [self addCustombackButtonItem];
   
    //!读取账号
    acount = [MyUserDefault defaultLoadAppSetting_loginPhone];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPBaseTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    
    
    if (!otherCell) {
        
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];

    }
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, (44-11)/2, 150, 11)];
//    title.text = @"会员名";
    title.textColor = HEX_COLOR(0x666666FF);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    [otherCell addSubview:title];
    
    UILabel *integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150 -15, (44-14)/2, 150, 14)];
//    integrationLabel.text = @"某某某";
    integrationLabel.textColor = HEX_COLOR(0x666666FF);
    integrationLabel.textAlignment = NSTextAlignmentRight;
    integrationLabel.font = [UIFont systemFontOfSize:14];
    

    title.text = leftNameArr[indexPath.row];
    
   
    if (indexPath.row) {
        
        otherCell.accessoryType = 1;

    }else{
        
        integrationLabel.text = acount;
        [otherCell addSubview:integrationLabel];
    
    }
    
    return otherCell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
//    acount = @"18001510012";
    if (indexPath.row == 1) {// !修改登录密码
        
        CSPSettingSafetyVerificationViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingSafetyVerificationViewController"];
        nextVC.changePassword = CSPChangeLoginPassword;
        nextVC.account = acount;
        [self.navigationController pushViewController:nextVC animated:YES];
        
    }else if(indexPath.row == 2){// !重置支付密码
        
        
        
        [HttpManager sendHttpRequestForGetIsHasPaymentPassword:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                if ([dic[@"data"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                   
                    
                    CSPResetPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPResetPayPasswordViewController"];
                    nextVC.account = acount;
                    [self.navigationController pushViewController:nextVC animated:YES];
                }else
                {
                    [self.view makeToast:@"你暂未设置支付密码" duration:2 position:@"center"];
                    
                    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
    }else{
        return;
    }
}

-(void)delayMethod
{
    CSPSettingPayPasswordViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingPayPasswordViewController"];
    nextVC.isChangePassWord = YES;
    
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
