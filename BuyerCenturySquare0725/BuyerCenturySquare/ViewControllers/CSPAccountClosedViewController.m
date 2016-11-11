//
//  CSPAccountClosedViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/12/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAccountClosedViewController.h"
#import "CSPFillApplicationViewController.h"
@interface CSPAccountClosedViewController ()

@end

@implementation CSPAccountClosedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationController.navigationBar setHidden:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyAgainButtonClicked:(id)sender {

    CSPFillApplicationViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFillApplicationViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

- (IBAction)logoutButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
