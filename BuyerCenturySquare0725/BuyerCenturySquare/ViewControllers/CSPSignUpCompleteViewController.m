//
//  CSPSignUpCompleteViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/12/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSignUpCompleteViewController.h"

@interface CSPSignUpCompleteViewController ()

@end

@implementation CSPSignUpCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份验证";

    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterHomePageButtonClicked:(id)sender {
    
    
        
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];
    
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
