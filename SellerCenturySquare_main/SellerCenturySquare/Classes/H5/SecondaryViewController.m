//
//  SecondaryViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/5/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SecondaryViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SaveJSWithNativeUserIofo.h"
#import "MyUserDefault.h"
#import "AppleAccountsView.h"
#import "CustomBarButtonItem.h"
#import "CustomViews.h"
#import "ThreePageViewController.h"
#import "ConversationWindowViewController.h"
#import "GUAAlertView.h"
#import "TransactionRecordsViewController.h"
#import "LoadFailedView.h"
#import "ChatManager.h"

#define WebViewNav_TintColor ([UIColor colorWithHex:0xeb301f alpha:1])

@interface SecondaryViewController ()<UIWebViewDelegate,ThreePageViewControllerDelegate,LoadFailedDelegate>
{
    BOOL _showTabBar;//显示底部tabbar
    UIWebView *webView;
    UIProgressView *progressView;
    
    
}

@property (nonatomic ,strong) LoadFailedView *loadFailView;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *homeUrl;
@property WebViewJavascriptBridge* bridge;
@property (assign, nonatomic) NSUInteger loadCount;
@end

@implementation SecondaryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[MyUserDefault defaultLoadAppSetting_phone] isEqualToString:AppleAccount]) {
        AppleAccountsView *appleView = [[[NSBundle mainBundle] loadNibNamed:@"AppleAccountsView" owner:self options:nil]lastObject];
        
        appleView.frame = CGRectMake(0, 0, 200, 100);
        appleView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
        
        [self addCustombackButtonItem];
        
        [self.view addSubview:appleView];
        
    }else
    {
        [self configUI];
    }

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addCustombackButtonItem];
    
}

- (void)configUI {
    
    SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];

    NSString *str = [self.file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _homeUrl = [NSURL URLWithString:str];

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
    webView.scrollView.scrollEnabled = NO;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_homeUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    [webView loadRequest:request];
    self.webView = webView;
    
#pragma mark -----与h5交互写入plist文件当中-------
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    [newDic setObject:[MyUserDefault JudgeUserAccount] forKey:@"isMaster"];
    
    //启动
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    
    
    //1.获取设备状态栏高度
    [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
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

    //18.顶栏导航栏与js的交互
    [_bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"da6666ta  ＝＝ %@",data);
        ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
        threePageVC.titleRecord = data[@"targetTitle"];
        threePageVC.file = [NSString stringWithFormat:@"%@%@",[HttpManager allH5ServiceRequestWebView],data[@"targetUrl"]];
        [self.navigationController pushViewController:threePageVC animated:YES];
        
    }];
    
    //19.设置原生导航栏title
    [_bridge registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        self.title = data[@"targetTitle"];
        self.navigationItem.rightBarButtonItem = [[CustomBarButtonItem alloc]initWithTitle:data[@"rightTitle"] style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickMembershipPrivilege)];
        
        if (!self.isPrepaidu) {
            self.file = [NSString stringWithFormat:@"%@%@",[HttpManager allH5ServiceRequestWebView],data[@"rightTitleUrl"]];
        }
        
        
        
        
    }];
    
    
    //9.拨打电话
    [_bridge registerHandler:@"phoneCalls" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *num = [NSString stringWithFormat:@"tel://%@",data[@"telephoneNum"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        
    }];
    
    //11.询单对话
    [_bridge registerHandler:@"chat" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data === %@",data);
        
        
        NSString *name =data[@"nickName"];
        
        NSString *JID = data[@"chatAccount"];
        _showTabBar = [data[@"showTabBar"] boolValue];
        
        [[ChatManager  shareInstance] getServerAcount:data[@"memberNo"] withName:name withController:self];
        
        
//        ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc] initWithNameWithYOffsent:name withJID:JID withMemberNO:data[@"memberNo"]];
//
//        
//        [self.navigationController pushViewController:IMVC animated:YES];
        
    }];
    
    //5.下载购买次数交易记录
    [_bridge registerHandler:@"BuyDownload" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([self.delegate respondsToSelector:@selector(pushTransactionRecordsVC)]) {
            [self.delegate pushTransactionRecordsVC];
            
        }
    }];

}

-(void)didClickMembershipPrivilege
{
    
    ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
    threePageVC.delegate = self;
    threePageVC.file = self.file;
    
    [self.navigationController pushViewController:threePageVC animated:YES];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
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





@end
