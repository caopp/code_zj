//
//  MembershipGradeRulesViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/2.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MembershipGradeRulesViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
#import "TokenLoseEfficacy.h"
#import "BalanceChargeViewController.h"
#import "AppleAccountsView.h"
#import "CustomBarButtonItem.h"

@interface MembershipGradeRulesViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;

@end

@implementation MembershipGradeRulesViewController
- (void)viewWillAppear:(BOOL)animated {
    
    //!判断是否是苹果审核账号
     if ([MyUserDefault loadIsAppleAccount])
     {
         self.navigationController.navigationBarHidden = NO;
         
     }else
     {
         self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
         UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
         statusBarView.backgroundColor=[UIColor blackColor];
         
         
         [self.view addSubview:statusBarView];
         self.navigationController.navigationBarHidden = YES;
         

     }
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    
   }

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    
}


- (void)viewDidLoad {
    
    
    self.view.backgroundColor = [UIColor whiteColor];
     if ([MyUserDefault loadIsAppleAccount]) {
         
        AppleAccountsView *appleView = [[[NSBundle mainBundle] loadNibNamed:@"AppleAccountsView" owner:self options:nil]lastObject];
        
        appleView.frame = CGRectMake(0, 0, 200, 100);
        appleView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
        
        [self addCustombackButtonItem];
        
        [self.view addSubview:appleView];

    }else
    {
    
        SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];
        // 初始化webview
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.webView.scrollView.scrollEnabled = NO;
        [HttpManager membershipNetworkRequestWebView:self.webView];
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
                [self setPopUpBoxStyleTitle:@"温馨提示" message:data[@"msg"] buttonTitle:@"确定" canceButtonTitle:nil type:data[@"type"]];
                
            }
            
            if ([data[@"type"] isEqualToString:@"3"]) {
                [self setPopUpBoxStyleTitle:@"温馨提示" message:data[@"msg"] buttonTitle:@"确定" canceButtonTitle:@"取消" type:data[@"type"]];
            }
            
        }];
        
        
        //6.显示tap
        [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
            
        }];
        
        //7.显示tap
        [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
            
        }];
        
        
        //8.进行加载
        [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
        }];
        
        //9.加载进行隐藏
        [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
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
