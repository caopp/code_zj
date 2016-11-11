//
//  ServiceViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 15/12/24.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "ServiceViewController.h"
#import "WebViewJavascriptBridge.h"
#import "HttpManager.h"

@interface ServiceViewController ()<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;


@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    // 初始化webview
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.scrollView.scrollEnabled = NO;
    [HttpManager serviceRequestWebView:self.webView];
    [self.view addSubview:self.webView];
    
    //启动
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(@"Response for message from ObjC");
        
    }];
    
    
    //1.销毁当前页面
    [_bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.webView removeFromSuperview];
        
        
    }];
    
    //2.获取设备状态栏高度
    [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"0"} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    

    
    //4.加密
    [_bridge registerHandler:@"encodingParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSString *digest = [HttpManager getSignWithParameter:data];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"digest":digest} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    //5.显示tap
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
    }];
    
    //6.显示tap
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
    }];
    
    
    //7.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //8.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self.view addSubview:statusBarView];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    
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
