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
    self.title = @"身份验证";
    NSAttributedString* attributeContent = [[NSAttributedString alloc]initWithString:@"去验证" attributes:@{NSUnderlineStyleAttributeName:@1, NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.7]}];

    /**
     *   这个方法就是根据按钮的优先级来进行判断，（有一种情况：setAttributedTitle 后面的settitle，改成setAttributedTitle这样采用按钮上的title才能进行切换，同样的道理是根据按钮的优先级进行判断的）。
     */
    [self.toVerifyButton setAttributedTitle:attributeContent forState:UIControlStateNormal];

    [self addCustombackButtonItem];
}

- (IBAction)logoutButtonClicked:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
