//
//  CSPResetPayPasswordViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPResetPayPasswordViewController.h"
#import "CSPSettingSafetyVerificationViewController.h"
#import "CSPBaseTableViewCell.h"

@interface CSPResetPayPasswordViewController ()

@end

@implementation CSPResetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = NSLocalizedString(@"resetPayPwd",@"重置支付密码");
    
    [self addCustombackButtonItem];
    
        
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPBaseTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    
    
    if (!otherCell) {
        
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        
    }
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, (44-11)/2, 150, 11)];
    //    title.text = @"会员名";
    title.textColor = HEX_COLOR(0x999999FF);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    [otherCell addSubview:title];
    
    otherCell.accessoryType = 1;
    
    
    if (indexPath.row == 0) {
        
        title.text = NSLocalizedString(@"changePayPwd", @"修改支付密码");

    }else {
        
        title.text = NSLocalizedString(@"forgetPayPwd",@"忘记支付密码");
       
    }
    return otherCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSPSettingSafetyVerificationViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPSettingSafetyVerificationViewController"];
    if (indexPath.row == 0) {// !修改支付密码
        
        nextVC.changePassword = CSPResetPayPassword;
        
        
    }else{// !忘记支付密码
        
        nextVC.changePassword = CSPForgetPayPassword;
    }
    nextVC.account =  self.account;
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
