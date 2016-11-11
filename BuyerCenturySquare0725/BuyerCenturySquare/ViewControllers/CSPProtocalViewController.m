//
//  CSPProtocalViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPProtocalViewController.h"
#import "WebViewJavascriptBridge.h"
#import "TokenLoseEfficacy.h"

#import "HttpManager.h"
#define WebViewNav_TintColor ([UIColor orangeColor])

@interface CSPProtocalViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;

@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *homeUrl;

@property(strong,nonatomic)UIImageView *backgroundImage;
@end

@implementation CSPProtocalViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    self.navigationController.navigationBar.translucent = NO;


    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {


    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCustombackButtonItem];
    
    self.navigationController.navigationBar.barTintColor=[UIColor  blackColor];

    _homeUrl = [NSURL URLWithString:self.file];

    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.scrollView.scrollEnabled = NO;
    
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view insertSubview:webView belowSubview:progressView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_homeUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];
    
    [webView loadRequest:request];

    //根据网络路径进行网路请求
    [self.view addSubview:webView];
    

    //启动
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
        
    }];
    
    
    
    //1.销毁当前页面
    [_bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        
       
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    //2.获取设备状态栏高度
    [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"20",@"code":@"000"} options:NSJSONWritingPrettyPrinted error:nil];
//        
//        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        
//        responseCallback(json);
        
    }];
    
    //5.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //6.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

#pragma mark token失效(reLogin)
    //10.回到登陆页面
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
        [tokenVC showLoginVC];
        
    }];
    
    //19.设置原生导航栏title
    [_bridge registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
       
            self.title = data[@"targetTitle"];
    }];
    
}

#pragma mark - webView代理

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        
        CGFloat newP = (1.0 - oldP) * 2 / (loadCount + 1) + oldP;
        
        [self.progressView setProgress:newP animated:YES];
        
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.loadCount --;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if([error code] == NSURLErrorCancelled)  {//!webview在之前的请求还没有加载完成，下一个请求发起了，此时webview会取消掉之前的请求，因此会回调到失败这里。此时的code ==  NSURLErrorCancelled
        
        return;
    }

    self.loadCount --;
}


@end
