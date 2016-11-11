//
//  CSPApplyOnlineViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPApplyOnlineViewController.h"

@interface CSPApplyOnlineViewController ()

@property (weak, nonatomic) IBOutlet UIButton *toVerifyButton;

@end

@implementation CSPApplyOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份验证";
    NSAttributedString* attributeContent = [[NSAttributedString alloc]initWithString:@"去验证" attributes:@{NSUnderlineStyleAttributeName:@1, NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.7]}];

    [self.toVerifyButton setAttributedTitle:attributeContent forState:UIControlStateNormal];

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
