//
//  CSPApplicationNotPassedViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/12/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPApplicationNotPassedViewController.h"
#import "LoginDTO.h"
#import "CSPFillApplicationViewController.h"
@interface CSPApplicationNotPassedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *errorTypeLabel;

@property(nonatomic,assign)BOOL isFill;
@end

@implementation CSPApplicationNotPassedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"身份验证";

    self.errorTypeLabel.text = [[LoginDTO sharedInstance]refuseContent];

    [self.navigationItem setHidesBackButton:YES];
    self.isFill = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyAgainButtonClicked:(id)sender {
    
    
    CSPFillApplicationViewController *fillApplicationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFillApplicationViewController"];
    
    
    [self.navigationController pushViewController:fillApplicationVC animated:YES];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
