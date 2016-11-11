//
//  CSPPasswordSuccessedViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPasswordSuccessedViewController.h"
#import "CSPAccountAndSaftyTableViewController.h"
#import "CSPResetPayPasswordViewController.h"
#import "CSPPayAvailabelViewController.h"

@interface CSPPasswordSuccessedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)confirmButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titlImageView;

@end

@implementation CSPPasswordSuccessedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"changeSuccess",  @"完成修改");
    
    if (self.changePassword == CSPChangeLoginPassword) {
        
        self.titleLabel.text = NSLocalizedString(@"changeLoginPwdSuccess", @"登录密码修改成功") ;
    
    }else{
    
        self.titleLabel.text = NSLocalizedString(@"changePayPwdSuccess", @"支付密码修改成功") ;
    
    }
    self.confirmButton.layer.cornerRadius = 3.0f;
    
    [self.confirmButton setTitle:NSLocalizedString(@"sure", @"确定") forState:UIControlStateNormal];
    
    
    //!去掉左返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 0, 0);
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    
}



- (IBAction)confirmButtonClicked:(id)sender {
    
    if (self.changePassword == CSPChangeLoginPassword) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[CSPAccountAndSaftyTableViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else{
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[CSPResetPayPasswordViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[CSPPayAvailabelViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
    }
    

}

@end
