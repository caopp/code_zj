//
//  CSPChangePasswordSuccessViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/2/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPChangePasswordSuccessViewController.h"
#import "CustomButton.h"
#import "CustomBarButtonItem.h"
@interface CSPChangePasswordSuccessViewController ()
@property (weak, nonatomic) IBOutlet CustomButton *loginButton;
- (IBAction)loginButtonClicked:(id)sender;

@end

@implementation CSPChangePasswordSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
