//
//  PrepaiduUpgradeViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PrepaiduUpgradeViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SaveJSWithNativeUserIofo.h"
#import "BalanceChargeViewController.h"
#import "AppleAccountsView.h"
#import "UIColor+UIColor.h"
#import "LoadFailedView.h"
#import "SettingModel.h"
#define WebViewNav_TintColor ([UIColor colorWithHexValue:0xfd4f57 alpha:1])

@interface PrepaiduUpgradeViewController ()<UIWebViewDelegate,LoadFailedDelegate>
{
    UIWebView *webView;
    UIProgressView *progressView;
}

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *homeUrl;
@property WebViewJavascriptBridge* bridge;
@property (assign, nonatomic) NSUInteger loadCount;
@property (nonatomic ,strong) LoadFailedView *loadFailView;

@end

@implementation PrepaiduUpgradeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCustombackButtonItem];
    self.title = self.titleRecord;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *str = [self.file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _homeUrl = [NSURL URLWithString:str];
    

    //根据接口进行苹果账号判断
    SettingModel *settingModel = [[SettingModel alloc]init];
    
    [settingModel setShowMoneyPage:^(NSString *str) {
        
        if ([str isEqualToString:@"1"]) {
            
            AppleAccountsView *appleView = [[[NSBundle mainBundle] loadNibNamed:@"AppleAccountsView" owner:self options:nil]lastObject];
            
            appleView.frame = CGRectMake(0,0 , 200, 100);
            
            appleView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
            
            [self addCustombackButtonItem];
            
            [self.view addSubview:appleView];
            
        }else
        {
            [self configUI];
        }
        
    }];
    
}


- (void)configUI {
    
    // 进度条
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view insertSubview:webView belowSubview:progressView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_homeUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];
    
    [webView loadRequest:request];
    
    self.webView = webView;
    
    SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    //启动
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    
    
    //1.获取设备状态栏高度
    [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"0"} options:NSJSONWritingPrettyPrinted error:nil];
        //
        //        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //
        //        responseCallback(json);
        
    }];
    
    //2.发送消息
    [_bridge registerHandler:@"getDefaultParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data  ====%@",data);
        
        NSString *timeStamp = [HttpManager getTimesTamp];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newDic options:NSJSONWritingPrettyPrinted error:nil];
        
        newDic[@"timestamp"] = timeStamp;
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
    }];
    
    //3.加密
    [_bridge registerHandler:@"encodingParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
        
        NSString *digest = [HttpManager getSignWithParameter:data];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"digest":digest} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    //4.显示tap
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
    }];
    
    //5.显示tap
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
    }];
    
    
    //6.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //7.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
    //18.顶栏导航栏与js的交互
    [_bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data  ＝＝ %@",data);
        PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
        prepaiduUpgradeVC.titleRecord = data[@"targetTitle"];
        prepaiduUpgradeVC.file = [NSString stringWithFormat:@"%@%@",[HttpManager nextPageInterface],data[@"targetUrl"]];
        [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
        
    }];
    
    //19.设置原生导航栏title
    [_bridge registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (self.isOK == YES) {
            self.title = data[@"targetTitle"];
        }
        
        
    }];
    
    //17.充值
    [_bridge registerHandler:@"prepaidRecharge" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BalanceChargeViewController *balance = [[BalanceChargeViewController alloc] init];
        
        [self.navigationController pushViewController:balance animated:YES];
        
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.loadCount --;
    NSLog(@"webViewDidFinishLoad");
    [self.loadFailView removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if([error code] == NSURLErrorCancelled)  {//!webview在之前的请求还没有加载完成，下一个请求发起了，此时webview会取消掉之前的请求，因此会回调到失败这里。此时的code ==  NSURLErrorCancelled
        
        return;
    }

    self.loadCount --;
    NSLog(@"didFailLoadWithError:%@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.loadFailView = [[[NSBundle mainBundle] loadNibNamed:@"LoadFailedView" owner:self options:nil]lastObject];
    
    self.loadFailView.delegate = self;
    
    self.loadFailView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    self.loadFailView.center = CGPointMake(self.view.center.x, self.view.center.y - 139);
    
    [self.view addSubview:self.loadFailView];
    
}

#pragma mark - LoadFailedDelegate

- (void)loadFailedAgainRequest
{
    [self.loadFailView removeFromSuperview];
    
    [webView removeFromSuperview];
    [progressView removeFromSuperview];
    
    [self configUI];
    
}

@end
