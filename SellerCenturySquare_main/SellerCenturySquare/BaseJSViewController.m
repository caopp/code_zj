//
//  BaseJSViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/28.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BaseJSViewController.h"
#import "GUAAlertView.h"
#import "SaveJSWithNativeUserIofo.h"
#import "TokenLoseEfficacy.h"
#import "BussinessAreaController.h"

#define WebViewNav_TintColor ([UIColor colorWithHexValue:0xeb301f alpha:1])
@interface BaseJSViewController ()

@end

@implementation BaseJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark -----与h5交互写入plist文件当中-------
    SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];

    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    
    // 初始化webview
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.delegate = self;
    
    //根据网络路径进行网路请求

    [self.view addSubview:self.webView];
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;

    
    // Do any additional setup after loading the view.
    
    
#pragma mark -----与h5交互写入plist文件当中-------
    //启动
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
#pragma mark 1.销毁当前页面(closeWebView)
    
    //1.销毁当前页面
    [_bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self destructionSelfVC];
        
    }];
    
    

    #pragma mark 2.获取设备状态栏高度(getStatusBarHeight)
    //2.获取设备状态栏高度
    [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"20",@"code":@"000"} options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
       #pragma mark  获取当前设备的，app,账户信息(getDefaultParams)
    //3.发送消息
    [_bridge registerHandler:@"getDefaultParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data  ====%@",data);
        DebugLog(@"getDefaultParams = %@", data);
        DebugLog(@"newDict = %@", newDic);
        
        
        NSString *timeStamp = [HttpManager getTimesTamp];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newDic options:NSJSONWritingPrettyPrinted error:nil];
        
        newDic[@"timestamp"] = timeStamp;
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
    }];
    
#pragma mark 加密参数得到sign (加密参数得到sign)
    //4.加密
    [_bridge registerHandler:@"encodingParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        DebugLog(@"encodingParams = %@", data);
        
        
        NSString *digest = [HttpManager getSignWithParameter:data];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"digest":digest} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
    }];
    
#pragma mark 弹出提示窗口 (dialog)
    
    //5.弹出提示窗口
    [_bridge registerHandler:@"dialog" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        
        DebugLog(@"dialog = %@", data);
        
        if ([data[@"type"] isEqualToString:@"1"]) {
            [self.view makeMessage:data[@"msg"] duration:1.0f position:@"center"];
        }
        
        if ([data[@"type"] isEqualToString:@"2"]) {
            [self setPopUpBoxStyleTitle:@"温馨提示" message:data[@"msg"] buttonTitle:@"确定" canceButtonTitle:nil type:data[@"type"]];
            
        }
        
        if ([data[@"type"] isEqualToString:@"3"]) {
            
            
            //1、创建
            [[GUAAlertView alertViewWithTitle:@"温馨提示" withTitleClor:nil message:data[@"msg"] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"true"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                responseCallback(json);
                
                
            } dismissAction:^{
                
                
                
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"false"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                responseCallback(json);
                
                
                
            }]show];
        }
    }];
    
#pragma mark 进行加载(showLoading)
    //6.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
#pragma mark 加载进行隐藏(hideLoading)
    //7.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
#pragma mark 显示tap(showTap)
   
    //8.显示tap
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
    }];
#pragma mark 隐藏tap(showTap)
  
    //9.隐藏tap
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }];
    
#pragma mark token失效(reLogin)
    //10.回到登陆页面
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
        [tokenVC showLoginVC];
        
    }];
    
//#pragma mark 设置原生导航栏的title(setNavBarTitle)
    [_bridge  registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.title = data[@"targetTitle"];
//        BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
//        bussinessVC.rightItemTitle = data[@"rightTitle"];
//        bussinessVC.rightItemUrl = data[@"rightTitleUrl"];
//
//        [self.navigationController pushViewController:bussinessVC animated:YES];
//        
        
        
    }];
//
//    

    
    
    
    
}


-(void)setPopUpBoxStyleTitle:(NSString *)title  message:(NSString *)message buttonTitle:(NSString *)buttonTitle canceButtonTitle:(NSString *)canceButtonTitle  type:(NSString *)type
{
    
    //1、创建
    [[GUAAlertView alertViewWithTitle:title withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:buttonTitle withOkButtonColor:nil cancelButtonTitle:canceButtonTitle withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        //对type返回过来的值进行处理
        if ([type isEqualToString:@"2"])
        {
            
            
        }
        
        NSLog(@"右边按钮（第一个按钮）的事件");
        
    } dismissAction:^{
        
        //进入修改登录密码页面
        NSLog(@"左边按钮（第二个按钮）的事件");
        
        
    }]show];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //清除cookies
//    
//    NSHTTPCookie *cookie;
//    
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    
//    for (cookie in [storage cookies])
//        
//    {
//        
//        [storage deleteCookie:cookie];
//        
//    }
//    
//    //    清除webView的缓存
//    
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//}
//
- (void)destructionSelfVC
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



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
    self.loadFailView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.webView.frame.size.height);
    
    
    [self.webView addSubview:self.loadFailView];
    
}

#pragma mark - LoadFailedDelegate

- (void)loadFailedAgainRequest
{
    
    [self.loadFailView removeFromSuperview];
    
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
