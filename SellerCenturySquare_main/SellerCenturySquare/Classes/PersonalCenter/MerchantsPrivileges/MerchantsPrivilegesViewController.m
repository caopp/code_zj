//
//  MerchantsPrivilegesViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MerchantsPrivilegesViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
#import "GUAAlertView.h"
#import "TransactionRecordsViewController.h"
#import "TokenLoseEfficacy.h"
#import "MyUserDefault.h"
#import "AppleAccountsView.h"
#import "CustomBarButtonItem.h"
#import "CustomViews.h"

@interface MerchantsPrivilegesViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;

@end

@implementation MerchantsPrivilegesViewController
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if ([[MyUserDefault defaultLoadAppSetting_phone] isEqualToString:AppleAccount])
    {
        self.navigationController.navigationBarHidden = NO;
        
    }else
    {
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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[MyUserDefault defaultLoadAppSetting_phone] isEqualToString:AppleAccount]) {
        AppleAccountsView *appleView = [[[NSBundle mainBundle] loadNibNamed:@"AppleAccountsView" owner:self options:nil]lastObject];
        
        appleView.frame = CGRectMake(0, 0, 200, 100);
        appleView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
        
        [self addCustombackButtonItem];
        
        [self.view addSubview:appleView];
        
    }else
    {
        SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];

#pragma mark -----与h5交互写入plist文件当中-------
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
        NSMutableDictionary *newDic;
        newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
        
        [newDic setObject:[MyUserDefault JudgeUserAccount] forKey:@"isMaster"];
        
//        isMaster
        
        
        
        // 初始化webview
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.webView.scrollView.scrollEnabled = NO;
        //根据网络路径进行网路请求
        //商家特权
        [HttpManager privilegesNetworkRequestWebView:self.webView];
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
            
            if ([self.delegate respondsToSelector:@selector(clearBusinessFranchiseRecord)]) {
                [self.delegate performSelector:@selector(clearBusinessFranchiseRecord)];
            }
            
            
            
            [self.navigationController popViewControllerAnimated:YES];
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
        
        
        
        //5.下载购买次数交易记录
        [_bridge registerHandler:@"BuyDownload" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            if ([self.delegate respondsToSelector:@selector(pushTransactionRecordsVC)]) {
                [self.delegate pushTransactionRecordsVC];
                
            }
            
            
            
            
        }];
        
        //6.进行加载
        [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
        }];
        
        //7.加载进行隐藏
        [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
        
        
        
        //8.弹出提示窗口
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
                    
                    //                NSLog(@"右边按钮（第一个按钮）的事件");
                    //                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"true"} options:NSJSONWritingPrettyPrinted error:nil];
                    //
                    //                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    //
                    //                responseCallback(json);
                    
                    
                } dismissAction:^{
                    
                    //                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"false"} options:NSJSONWritingPrettyPrinted error:nil];
                    //                
                    //                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    //                //进入修改登录密码页面
                    //                NSLog(@"左边按钮（第二个按钮）的事件");
                    //                responseCallback(json);
                    
                }]show];
            }
        }];
        
#pragma mark token失效(reLogin)
        //10.回到登陆页面
        [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
            [tokenVC showLoginVC];
            
        }];
        
    
    }

    
    self.view.backgroundColor = [UIColor whiteColor];

   
    
    
    

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
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
