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
#import "SaveJSWithNativeUserIofo.h"
#import "TokenLoseEfficacy.h"
@interface JSWithNativeViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property (nonatomic,weak)AppInfoDTO *appInfo;
@property (nonatomic,strong)NSMutableDictionary *dicInfo;
@end

@implementation JSWithNativeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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



- (void)viewDidLoad {
    
    // 初始化webview
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.scrollView.scrollEnabled = NO;
    //根据网络路径进行网路请求

    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://116.31.82.98:8289/ddop/buyer/index.html"]]];
    
    
    
    
    

    [self.view addSubview:webView];

#pragma mark -----与h5交互写入plist文件当中-------
    
#pragma mark -----与h5交互写入plist文件当中-------
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    
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
        
        NSLog(@"data  ====%@",data);
        
        NSString *timeStamp = [HttpManager getTimesTamp];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newDic options:NSJSONWritingPrettyPrinted error:nil];
        
        newDic[@"timestamp"] = timeStamp;
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
    }];
    
    
    
    //4.加密
    [_bridge registerHandler:@"encodingParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
        
        NSString *digest = [HttpManager getSignWithParameter:data];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"digest":digest} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    
    //5.弹出提示窗口
    [_bridge registerHandler:@"dialog" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
        
        if ([data[@"type"] isEqualToString:@"1"]) {
            [self.view makeMessage:data[@"msg"] duration:1.0f position:@"center"];
        }
        
        if ([data[@"type"] isEqualToString:@"2"]) {
         
            
        }
        
        if ([data[@"type"] isEqualToString:@"3"]) {
            
            
            //1、创建
            [[GUAAlertView alertViewWithTitle:@"温馨提示" withTitleClor:nil message:data[@"msg"] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
                NSLog(@"右边按钮（第一个按钮）的事件");
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"true"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                responseCallback(json);
                
                
            } dismissAction:^{
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"false"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //进入修改登录密码页面
                NSLog(@"左边按钮（第二个按钮）的事件");
                responseCallback(json);
                
            }]show];
        }
    }];
    
    
    
    
    
    //6.跳到商家列表
    [_bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"data ==== %@",data);
        
    }];
    
    
    //7.显示tap
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
    }];
    
    //8.显示tap
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
    }];
    
    
    //9.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //10.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
#pragma mark token失效(reLogin)
    //10.回到登陆页面
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
        [tokenVC showLoginVC];
        
    }];
    
    
}












@end
