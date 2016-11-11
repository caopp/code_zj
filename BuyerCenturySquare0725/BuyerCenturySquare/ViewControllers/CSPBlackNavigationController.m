//
//  CSPBlackNavigationController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/20/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPBlackNavigationController.h"

@interface CSPBlackNavigationController ()

@end

@implementation CSPBlackNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationBar.translucent = NO;
    
//    self.navigationBar.barTintColor = [UIColor blackColor];
    

    self.navigationBar.barStyle = UIBarStyleBlack;



    
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

@end
