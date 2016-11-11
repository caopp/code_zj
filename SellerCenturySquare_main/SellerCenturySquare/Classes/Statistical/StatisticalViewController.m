//
//  StatisticalViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "StatisticalViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
#import "GUAAlertView.h"
#import "TokenLoseEfficacy.h"
#import "ConversationWindowViewController.h"
#import "LoadFailedView.h"
#define WebViewNav_TintColor ([UIColor colorWithHexValue:0xeb301f alpha:1])

@interface StatisticalViewController ()<UIWebViewDelegate ,LoadFailedDelegate>
@property WebViewJavascriptBridge* bridge;

@property (nonatomic ,assign) NSUInteger loadCount;

@property (nonatomic ,strong) LoadFailedView *loadFailView;



@property (nonatomic ,strong) UIProgressView *progressView;


@end

@implementation StatisticalViewController
- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    statusBarView.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:statusBarView];
//    
    if ([self.markHideNav isEqualToString:@"hide"]) {
        self.navigationController.navigationBar.hidden = YES;
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
    
    

    
    self.title = self.selfTitle;
    
    SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];
    
    
    //设置返回按钮
    [self customBackBarButton];
    


#pragma mark -----与h5交互写入plist文件当中-------
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    
    // 初始化webview
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    self.webView.scrollView.scrollEnabled = NO;
    //根据网络路径进行网路请求
    //商家特权
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

    
    //5.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //6.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
    
#pragma mark ---------隐藏------
    
    //7.加载进行隐藏
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
    }];
    

    
    
    //8.加载进行隐藏
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
    }];
    
    
    //9.弹出提示窗口
    [_bridge registerHandler:@"dialog" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
        
        if ([data[@"type"] isEqualToString:@"1"]) {
            
            [self.view makeMessage:data[@"msg"] duration:2.0f position:@"center"];
            
        }
        
        if ([data[@"type"] isEqualToString:@"2"]) {
           
            [self setPopUpBoxStyleTitle:@"温馨提示" message:data[@"msg"] buttonTitle:@"确定" canceButtonTitle:nil type:data[@"type"]];
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
#pragma mark token失效(reLogin)
    //10.回到登陆页面
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
        [tokenVC showLoginVC];
        
    }];
    
    //!聊天
    [_bridge registerHandler:@"chat" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data === %@",data);
        
        
        NSString *name =data[@"nickName"];
        
        NSString *JID = data[@"chatAccount"];
        
        ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc] initWithNameWithYOffsent:name withJID:JID withMemberNO:data[@"memberNo"]];

        
        [self.navigationController pushViewController:IMVC animated:YES];
        
        
    }];

    
    [_bridge registerHandler:@"phoneCalls" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    
        NSString *num = [NSString stringWithFormat:@"tel://%@",data[@"telephoneNum"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        
    }];
     
    
    if (self.requestUrl!=nil &&self.requestUrl.length>0) {
        [HttpManager statisticalNetworkRequestWebView:self.webView requestUrl:self.requestUrl];
        
    }else
    {
        [HttpManager statisticalNetworkRequestWebView:self.webView];

    }
    
    //13。跳转新的页面
     [_bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
         
         StatisticalViewController *statisticalVC = [[StatisticalViewController alloc] init];
         statisticalVC.selfTitle = data[@"targetTitle"];;
         statisticalVC.requestUrl =data[@"targetUrl"];
         NSString *requestUrl = data[@"targetUrl"];
         NSArray *urls = [requestUrl componentsSeparatedByString:@"?"];
         if ([[urls lastObject] isEqualToString:@"_=sign"]) {
             statisticalVC.markHideNav = @"hide";
         }
         
         
         [self.navigationController pushViewController:statisticalVC animated:YES];
    }];
    
//    [_bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
//        
//        StatisticalViewController *statisticalVC = [[StatisticalViewController alloc] init];
//        statisticalVC.selfTitle = data[@"targetTitle"];;
//        statisticalVC.requestUrl =data[@"targetUrl"];
//        
//        [self.navigationController pushViewController:statisticalVC animated:YES];
//    }];
//    
    [_bridge registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.title = data[@"targetTitle"];
        
        if (data[@"rightTitle"]) {
            
            NSMutableString  *str = [[NSMutableString alloc] initWithString:data[@"rightTitle"]];
            
            
        NSString *titleStr  =   [str stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titleStr forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 80, 40);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.titleLabel.textAlignment = NSTextAlignmentRight;
            [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
            UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem =btnItem;
        }
        

    }];
    

    
    
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;

    
}


- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}



//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setPopUpBoxStyleTitle:(NSString *)title  message:(NSString *)message buttonTitle:(NSString *)buttonTitle canceButtonTitle:(NSString *)canceButtonTitle  type:(NSString *)type
{
    
    //1、创建
    [[GUAAlertView alertViewWithTitle:title withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:buttonTitle withOkButtonColor:nil cancelButtonTitle:canceButtonTitle withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        //对type返回过来的值进行处理
        if ([type isEqualToString:@"2"])
        {
            
            
            
        }else
        {
            
            
            
        }
        
        
        NSLog(@"右边按钮（第一个按钮）的事件");
        
    } dismissAction:^{
        
        //进入修改登录密码页面
        NSLog(@"左边按钮（第二个按钮）的事件");
        
    }]show];
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.loadCount --;
    NSLog(@"webViewDidFinishLoad");
    [self.loadFailView removeFromSuperview];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if([error code] == NSURLErrorCancelled)  {//!webview在之前的请求还没有加载完成，下一个请求发起了，此时webview会取消掉之前的请求，因此会回调到失败这里。此时的code ==  NSURLErrorCancelled
        
        return;
    }

    self.loadCount --;
    NSLog(@"didFailLoadWithError:%@", error);
    
    self.loadFailView = [[[NSBundle mainBundle] loadNibNamed:@"LoadFailedView" owner:self options:nil]lastObject];
    self.loadFailView.delegate = self;
    self.loadFailView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.webView.frame.size.height);
    
    
    [self.webView addSubview:self.loadFailView];
    
}






- (void)loadFailedAgainRequest
{
    

    [self.loadFailView removeFromSuperview];
    
    
    if (self.requestUrl!=nil &&self.requestUrl.length>0) {
        [HttpManager statisticalNetworkRequestWebView:self.webView requestUrl:self.requestUrl];
        
    }else
    {
        [HttpManager statisticalNetworkRequestWebView:self.webView];
        
    }

}




@end
