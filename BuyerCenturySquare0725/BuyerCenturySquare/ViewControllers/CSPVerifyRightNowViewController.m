//
//  CSPVerifyRightNowViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPVerifyRightNowViewController.h"

@interface CSPVerifyRightNowViewController ()

@end

@implementation CSPVerifyRightNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份验证";

    [self addCustombackButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
