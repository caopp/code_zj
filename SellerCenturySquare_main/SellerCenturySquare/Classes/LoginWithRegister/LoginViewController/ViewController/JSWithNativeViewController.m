//
//  JSWithNativeViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/11.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "JSWithNativeViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
@interface JSWithNativeViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property (nonatomic,weak)AppInfoDTO *appInfo;
@property (nonatomic,strong)NSMutableDictionary *dicInfo;
@end

@implementation JSWithNativeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:statusBarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {

    // 初始化webview
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.scrollView.scrollEnabled = NO;
    //根据网络路径进行网路请求
    
    
    //采购商
//    [HttpManager memberOfTradeNetworkRequestWebView:webView];
    //商家特权
    [HttpManager privilegesNetworkRequestWebView:webView];
    
    [self.view addSubview:webView];
#pragma mark -----与h5交互写入plist文件当中-------
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
#pragma mark -----与h5交互写入plist文件当中-------
        
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

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"0",@"code":@"000"} options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        responseCallback(json);
        
}];
    
    
    
    //3.发送消息
    [_bridge registerHandler:@"getDefaultParams" handler:^(id data, WVJBResponseCallback responseCallback) {
    
//        NSMutableDictionary *aa = [NSMutableDictionary  dictionaryWithCapacity:0];
//        [aa setObject:@"1" forKey:@"screenType"];
//        
//        [aa setObject:@"9.1" forKey:@"iosVersion"];
//        
//        [aa setObject:@"1" forKey:@"appType"];
//        
//        [aa setObject:@"123456" forKey:@"appKey"];
//        
//        [aa setObject:@"87294A36-4B5D-45B8-B3DE-C384115D2559" forKey:@"deviceSn"];
//        
//        [aa setObject:@"1" forKey:@"appVersion"];
//        
//        [aa setObject:@"1" forKey:@"deviceType"];
//        
//        [aa setObject:@"SP00010003" forKey:@"memberNo"];
//        
//        [aa setObject:@"25ba2e1db9dc4f0b90787ddd2b75c6cb" forKey:@"tokenId"];
//        
//        [aa setObject:@"2015-12-03 11:31:32" forKey:@"timestamp"];
        
        NSString *timeStamp = [HttpManager getTimesTamp];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newDic options:NSJSONWritingPrettyPrinted error:nil];
        
        newDic[@"timestamp"] = timeStamp;
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        responseCallback(json);
        
    }];
    
    
    //4.加密
    [_bridge registerHandler:@"encodingParams" handler:^(id data, WVJBResponseCallback responseCallback) {
    
        NSLog(@"encodingParams ===  %@",data);
        
        NSString *digest = [HttpManager getSignWithParameter:data];
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"digest":digest} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
}






@end
