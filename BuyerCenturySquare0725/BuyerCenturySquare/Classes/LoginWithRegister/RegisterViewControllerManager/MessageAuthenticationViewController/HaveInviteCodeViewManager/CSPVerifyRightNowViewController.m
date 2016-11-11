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
    self.title = @"身份验证";

    /**
     *  同样的道理也是在storyboard上进行操作。按钮直接push到下一个页面。
     */
    [self addCustombackButtonItem];
}
- (IBAction)didClickBackRootViewControllerAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
