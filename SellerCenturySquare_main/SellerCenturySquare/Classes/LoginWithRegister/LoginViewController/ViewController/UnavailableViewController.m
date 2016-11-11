//
//  UnavailableViewController.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/28.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "UnavailableViewController.h"

@interface UnavailableViewController ()

@end

@implementation UnavailableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT)];
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:_htmlStr baseURL:nil];
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
