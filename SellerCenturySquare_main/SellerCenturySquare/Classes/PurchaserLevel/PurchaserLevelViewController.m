//
//  PurchaserLevelViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "PurchaserLevelViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
#import "MyUserDefault.h"
#import "AppleAccountsView.h"
#import "CustomBarButtonItem.h"
#import "CustomViews.h"
@interface PurchaserLevelViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;

@end

@implementation PurchaserLevelViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[MyUserDefault defaultLoadAppSetting_phone] isEqualToString:AppleAccount])
    {
        self.navigationController.navigationBarHidden = NO;
        
    }else
    {
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:statusBarView];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[MyUserDefault defaultLoadAppSetting_phone] isEqualToString:AppleAccount])
    {
        
        AppleAccountsView *appleView = [[[NSBundle mainBundle] loadNibNamed:@"AppleAccountsView" owner:self options:nil]lastObject];
        
        appleView.frame = CGRectMake(0, 0, 200, 100);
        appleView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
        
        [self addCustombackButtonItem];
        
        [self.view addSubview:appleView];

        
    }else
    {
        // 初始化webview
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.webView.scrollView.scrollEnabled = NO;
        //根据网络路径进行网路请求
        //商家特权
        [HttpManager purchaserLevelNetworkRequestWebView:self.webView];
        [self.view addSubview:self.webView];
        
        
#pragma mark -----与h5交互写入plist文件当中-------
        //启动
        [WebViewJavascriptBridge enableLogging];
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@"Response for message from ObjC");
        }];
        
        //1.销毁当前页面
        [_bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            if ([self.delegate respondsToSelector:@selector(removeMiningRecordCache)]) {
                [self.delegate performSelector:@selector(removeMiningRecordCache)];
            }
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        //2.获取设备状态栏高度
        [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"0",@"code":@"000"} options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            responseCallback(json);
        }];
        

    
    }
    
}
/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
