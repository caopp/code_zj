//
//  MembershipUpgradeViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MembershipUpgradeViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
#import "CSPPayAvailabelViewController.h"
#import "TokenLoseEfficacy.h"
#import "BalanceChargeViewController.h"
#import "AppleAccountsView.h"
#import "CustomBarButtonItem.h"
#import "PrepaiduUpgradeViewController.h"

#define WebViewNav_TintColor ([UIColor orangeColor])

@interface MembershipUpgradeViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *homeUrl;


@end

@implementation MembershipUpgradeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     if ([MyUserDefault loadIsAppleAccount])
     {
         self.navigationController.navigationBarHidden = NO;
     
     }else
     {
         self.view = nil;
         self.navigationController.navigationBarHidden = NO;
         self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
         UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
         statusBarView.backgroundColor=[UIColor blackColor];
         
         [self.view addSubview:statusBarView];

     }
 
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self onPageRefresh];
    
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
}

-(void)onPageRefresh
{
    
    
    [self addCustombackButtonItem];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleVC;
    _homeUrl = [NSURL URLWithString:self.file];
  
    
    
     if ([MyUserDefault loadIsAppleAccount]) {
        
        AppleAccountsView *appleView = [[[NSBundle mainBundle] loadNibNamed:@"AppleAccountsView" owner:self options:nil]lastObject];
       
        appleView.frame = CGRectMake(0,0 , 200, 100);
         appleView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
        
        [self addCustombackButtonItem];
        
        [self.view addSubview:appleView];
        
    
    }else
    {
        
        // 进度条
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        progressView.tintColor = WebViewNav_TintColor;
        progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:progressView];
        self.progressView = progressView;
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        [self.view insertSubview:webView belowSubview:progressView];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_homeUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];
        
        [webView loadRequest:request];
        self.webView = webView;
        
        SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];
        // 初始化webview
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.webView.scrollView.scrollEnabled = NO;
        [HttpManager membershipUpgradeNetworkRequestWebView:self.webView];
        [self.view addSubview:self.webView];

        
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
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@"Response for message from ObjC");
        }];
        
        
        //1.销毁当前页面
        [_bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {

//            if (self.markRootVC) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                
//            }else
//            {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            
        }];
        
        //2.获取设备状态栏高度
        [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"20",@"code":@"000"} options:NSJSONWritingPrettyPrinted error:nil];
            
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
        
        
        
        
        
        //6.跳到商家列表
        [_bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            
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
        
        
        //11.进行付款
        [_bridge registerHandler:@"recharge" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            if ([self.delegate respondsToSelector:@selector(jumpToPayInterfaceDic:)]) {
                [self.delegate jumpToPayInterfaceDic:data];
            }
            
            [self jumpToPayInterfaceDic:data];
            
            
        }];
        
        [_bridge registerHandler:@"prepaidRecharge" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            
            BalanceChargeViewController *balance = [[BalanceChargeViewController alloc] init];
            [self.navigationController pushViewController:balance animated:YES];
            
            
        }];
        
        //18.顶栏导航栏与js的交互
        [_bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
            prepaiduUpgradeVC.titleRecord = data[@"targetTitle"];
            prepaiduUpgradeVC.file = [NSString stringWithFormat:@"%@%@",[HttpManager nextPageInterface],data[@"targetUrl"]];
            [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
            
        }];
        //19.设置原生导航栏title
        [_bridge registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
            
                self.title = data[@"targetTitle"];
            
        }];

        
#pragma mark token失效(reLogin)
        //10.回到登陆页面
        [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
            [tokenVC showLoginVC];
            
        }];
        
        //11.充值
        [_bridge registerHandler:@"prepaidRecharge" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            BalanceChargeViewController *balance = [[BalanceChargeViewController alloc] init];
            
            [self.navigationController pushViewController:balance animated:YES];
            
            
        }];
        
    }
}
//!升级
-(void)jumpToPayInterfaceDic:(NSDictionary *)dic
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    CSPPayAvailabelViewController *payAvailabelViewC = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
    payAvailabelViewC.dic = dic;
    
    [self.navigationController pushViewController:payAvailabelViewC animated:YES];
    
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
    
    
    if (self.markRootVC) {
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[BalanceChargeViewController class]]) {
                
                [self.navigationController popToViewController:controller animated:YES];
                
            }
            
        }
    }else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
    
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
