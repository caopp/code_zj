//
//  AppDelegate.m
//  SellerCenturySquare
//
//  Created by skyxfire on 7/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "AppDelegate.h"
#import "CSPLoginViewController.h"
#import "CSPNavigationController.h"
#import "AppInfoDTO.h"
#import "FilesDownManage.h"
#import "ChatManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "MyUserDefault.h"
#import "BaseViewController.h"
#import "LoginDTO.h"
//用户登录时候聊天和会员等级进行同步
#import "UserOtherIofo.h"
#import "PurchaserViewController.h"
#import "StatisticalViewController.h"
#import "GuideViewController.h"// !引导页
#import "NewsViewController.h"//!叮咚
#import "HttpManager.h"
#import "NSString+Hashing.h"//!MD5加密文件
#import "ErrorLogDefaults.h"//!错误日志保存文件
#import "OrderMainListViewController.h"
#import "GoodsHomeViewController.h"//!商品
#import "BussinessAreaController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif

//采购商更改成h5页面
#import "PrepaiduUpgradeViewController.h"
#import "TransactionRecordsViewController.h"
#import "CityPropValueDefault.h"

@interface AppDelegate ()<WXApiDelegate,RDVTabBarControllerDelegate,UNUserNotificationCenterDelegate>
{
    CSPLoginViewController *loginViewController;
    PrepaiduUpgradeViewController  *purchaseVC;
    StatisticalViewController *statisticalVC;
    
    
    BOOL isPurchase;
    
//    PurchaserViewController *purchaseVC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //!不加这里，导航就会有一条分割线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
    //显示界面
    [self appdelegateContent];
    //返回前台
    if ([LoginDTO sharedInstance].tokenId) {
        [self clearBadgeCount];
    }
    //!获取崩溃日志
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);

    //!上传崩溃日志
    [self upErrorLog];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushTransactionRecordsVC) name:@"BuyDownloadNotification" object:nil];
    
    return YES;

}

//appdelegate中的内容
-(void)appdelegateContent
{
    /**
     *  注册微信客户端
     */
    [self registerWeiChat];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [self.window makeKeyAndVisible];
    
    //配置聊天
    [[ChatManager shareInstance] setupStream];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@",settings);
                    
                }];
                
            }else
            {
                //点击不允许
                NSLog(@"注册失败");
                
            }
            
        }];
        
    }else{
        

       UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];;
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    
    //获取UUID
    [AppInfoDTO sharedInstance].deviceToken = [[UIDevice currentDevice]identifierForVendor].UUIDString;
    //显示页面
    [self showViewControllerPage];
    
    //进行省市区版本控制
    CityPropValueDefault * propValueDefalut = [CityPropValueDefault shareManager];
    [propValueDefalut dataPropValueControl];

}

#pragma mark ----显示页面-----
-(void)showViewControllerPage
{
    // !获取新老版本号进行比较 
    NSString *key=@"CFBundleShortVersionString";
    //加载程序中info.plist文件（获取当前软件的版本号）
    NSString *currentVerionCode=[NSBundle mainBundle].infoDictionary[key];
    
    NSString *oldVersion = [MyUserDefault defaultLoad_oldVersion];
    
    if (![currentVerionCode isEqualToString:oldVersion]) {
        
        GuideViewController *guideVC = [[GuideViewController alloc]init];
        
        guideVC.changeVCBlcok = ^(){
            
            [MyUserDefault defaultSetAppVersion:currentVerionCode];
            
            [self intoNextWindow];
            
        };
        
        self.window.rootViewController = guideVC;
        
    }else{
    
        [self intoNextWindow];
    
    }
}

-(void)intoNextWindow{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取应用程序沙盒的Documents目录
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"IofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    if (!newDic[@"tokenId"] || ![MyUserDefault getMustLoginSign]) {//!这个值用于3.0.2版本用户第一次强制登录
        loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPLoginViewController"];
        
        CSPNavigationController *navigationController = [[CSPNavigationController alloc]initWithRootViewController:loginViewController];
        
        [self.window setRootViewController:navigationController];
        
    }else
    {
        /*
         *进入主页面
         */
        [self initTabBarController];
        
        [[LoginDTO sharedInstance]setDictFrom:newDic];
        
        UserOtherIofo *userOtherIofo = [[UserOtherIofo alloc]init];
        
        [userOtherIofo assignmentPhoneNumber:[MyUserDefault defaultLoadAppSetting_phone] password:[MyUserDefault defaultLoadAppSetting_password]];
        self.window.rootViewController = self.tabBarController;
    }
    
}


- (void)initTabBarController{
    
    self.tabBarController = [[RDVTabBarController alloc]init];
    
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"CPSMainViewController"]];
    mainNav.navigationBar.barStyle = UIBarStyleBlack;
    mainNav.navigationBar.translucent = NO;

    
    //采购商
//    purchaseVC = [[PurchaserViewController alloc]init];
//    UINavigationController *buyerNav = [[UINavigationController alloc]initWithRootViewController:purchaseVC];
//    buyerNav.navigationBar.barStyle = UIBarStyleBlack;

    
    isPurchase = YES;
    purchaseVC = [[PrepaiduUpgradeViewController alloc]init];
    UINavigationController *buyerNav = [[UINavigationController alloc]initWithRootViewController:purchaseVC];
     buyerNav.navigationBar.barStyle = UIBarStyleBlack;
    buyerNav.navigationBar.translucent = NO;
    purchaseVC.isPurchase = isPurchase;
    purchaseVC.file = [HttpManager memberOfTradeNetworkRequestWebView];


    //!叮咚
    //NewsViewController *newsVC = [[NewsViewController alloc]init];
    UINavigationController *newsNav = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"]];
    newsNav.navigationBar.barStyle = UIBarStyleBlack;
    newsNav.navigationBar.translucent = NO;
    
    
    //!采购单
    
    OrderMainListViewController *orderListVC = [[OrderMainListViewController alloc] init];
    
    UINavigationController *orderNav = [[UINavigationController alloc]initWithRootViewController:orderListVC];

//    UINavigationController *orderNav = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"CPSOrderViewController"]];
    orderNav.navigationBar.barStyle = UIBarStyleBlack;
    orderNav.navigationBar.translucent = NO;
    
    
    //!商品
    GoodsHomeViewController * goodsHomeVC = [[GoodsHomeViewController alloc]init];
    
    UINavigationController *goodsNav = [[UINavigationController alloc]initWithRootViewController:goodsHomeVC];
    goodsNav.navigationBar.barStyle = UIBarStyleBlack;
    goodsNav.navigationBar.translucent = NO;
    

    //统计
//    StatisticalViewController *statisticalVC = [[StatisticalViewController alloc]init];
//    UINavigationController *countNav = [[UINavigationController alloc]initWithRootViewController:statisticalVC];
    
    
    NSArray *viewControllersArray = [[NSArray alloc]initWithObjects:mainNav,buyerNav,newsNav,orderNav,goodsNav, nil];
    
    [self.tabBarController setViewControllers:viewControllersArray];
    
    
    self.tabBarController.delegate = self;
    
    self.tabBarController.tabBar.backgroundView.backgroundColor = [UIColor blackColor];
    NSArray *tabBarItemImages = @[@"tabbar_main", @"tabbar_purchase", @"tabbar_news",@"tabbar_order",@"tabbar_good"];
    NSArray *tabBarSelectedImages = @[@"tabbar_mainSelected",@"tabbar_purchaseSelected",@"tabbar_newsSelected",@"tabbar_orderSelected",@"tabbar_goodSelected"];
    
    
    
    NSArray *tabBarItemTitles = @[@"主页", @"采购商",@"叮咚", @"采购单",@"商品"];
    
    NSInteger index = 0;
    
    for (int i=0; i<tabBarItemImages.count; i++) {
        
        RDVTabBarItem *item = [[self.tabBarController tabBar] items][i];
        
        UIImage *selectedimage = [UIImage imageNamed:tabBarSelectedImages[i]];
        
        
        UIImage *unselectedimage = [UIImage imageNamed:tabBarItemImages[i]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        [item setTitle:[NSString stringWithFormat:@"%@",[tabBarItemTitles objectAtIndex:index]]];
        
        index++;
        
    }
}

//清除h5缓存
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

    switch ([tabBarController selectedIndex]) {
        case 1:
        {
            //[HttpManager memberOfTradeNetworkRequestWebView:purchaseVC.webView];
            
        }
            break;
        case 2:
        {
    
        }
            break;
        case 4:
        {
//            [HttpManager statisticalNetworkRequestWebView:statisticalVC.webView];
        }
            break;
            
            
        default:
            break;
    }
}




//通知回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"test:%@",deviceToken);
#if !(TARGET_IPHONE_SIMULATOR)
    
    [AppInfoDTO sharedInstance].deviceToken = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
#else
    
    [AppInfoDTO sharedInstance].deviceToken = [[UIDevice currentDevice]identifierForVendor].UUIDString;
#endif
    
    NSLog(@"My token is NSString: %@", [AppInfoDTO sharedInstance].deviceToken);
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

//直接采用窗口进行调
- (void)updateRootViewController:(id)rootViewController{
    self.tabBarController = rootViewController;
    self.window.rootViewController = nil;
    
    self.window.rootViewController = rootViewController;
    
}





- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"userInfo == %@",userInfo);
    //    NSString *messageShow = [NSString stringWithFormat:@"%@",userInfo];
    //    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageShow delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //
    //    [alert show];
    NSDictionary *dict = userInfo;
    NSString *typeStr = dict[@"type"];
    NSInteger type = typeStr.integerValue;
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送内容" message:[NSString stringWithFormat:@"%@-%ld",dict,(long)type] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
    
    if (application.applicationState == UIApplicationStateActive) return;

    
    if (application.applicationState == UIApplicationStateInactive) {

    if ([dict[@"type"] isEqualToString:@"7"]) {//商品
        
        
    }else
        if ([dict[@"type"] isEqualToString:@"8"])//商圈
        {
            if (self.tabBarController.selectedIndex == 0) {
                UINavigationController *nav1 = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
                bussinessVC.rightItemUrl = @"zone/ddopIndex.html";
                //标记此类的为叮咚官方
                bussinessVC.makrRightNav = @"right";
                //添加通知
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImgNotification" object:nil];
                //            self.isLoading = NO;
                [nav1 pushViewController:bussinessVC animated:YES];
                
                
            }else {
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 0;
                UINavigationController *nav1 = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
                bussinessVC.rightItemUrl = @"zone/ddopIndex.html";
                //标记此类的为叮咚官方
                bussinessVC.makrRightNav = @"right";
                //添加通知
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImgNotification" object:nil];
                //            self.isLoading = NO;
                [nav1 pushViewController:bussinessVC animated:YES];
                
            }
            
        }else if (type <= 5)
        {
            
            if (self.tabBarController.selectedIndex ==2) {
                
            }else {
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 2;
            }
        }
        else if (type == 6)
        {
            if (self.tabBarController.selectedIndex ==2) {
                
            }else {
                
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 2;
            }
            
        }else if (type == 9)
        {
            if (self.tabBarController.selectedIndex ==2) {
                
            }else {
                
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 2;
            }
        }

    }
    
//    if (self.tabBarController.selectedIndex == 2) {
//        
//    }else{
//        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
//        
//        [nav popToRootViewControllerAnimated:YES];
//        self.tabBarController.selectedIndex = 2;
//    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //退到后台
    if ([ChatManager shareInstance].xmppUserName != nil) {
        
        [[ChatManager shareInstance] disconnectToServer];
    }
    
    
    
    
}
//禁用第三方键盘
- (BOOL)application:(UIApplication *)application

shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier

{
    
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        if (_showThridKeyboard) {
            _showThridKeyboard = NO;

            return YES;
        }else{
            return NO;
        }
        
        
    }
    
    return YES;
 
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //返回前台
    if ([LoginDTO sharedInstance].tokenId) {
        [self clearBadgeCount];
        // [self available:@"available"];
    }
    //!发送通知，获取 系统时间
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMerchantChatNo" object:nil];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //杀死进程不要弹出修改密码的提示框
    //设置通知杀死进程
    //刚进入程序的时候设置
//    [MyUserDefault  defaultSaveAppSetting_Popup:@"2"];
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"leftKey2"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }else
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
}


#pragma mark -
#pragma mark WeiChat


- (void)registerWeiChat{
    
    [WXApi registerApp:@"wx0269c86f1c395f2b"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return  [WXApi handleOpenURL:url delegate:self];
//}

- (void) onReq:(BaseReq*)req{
    
    
}
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
}

#pragma mark 获取崩溃日志
void UncaughtExceptionHandler(NSException *exception) {
    
    NSArray *errorArr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *errorReason = [exception reason];//非常重要，就是崩溃的原因
    NSString *errorName = [exception name];//异常类型
        
    //!手机型号
    NSString * iphoneMode = @"iphone";
    //!功能模块
    NSString * model = [NSString stringWithFormat:@"iOS-%@",errorName];
    if (model.length > 250) {
        
        model =  [model substringToIndex:249];
        
    }

    
    //!错误信息
    NSData *errorArrData = [NSJSONSerialization dataWithJSONObject:errorArr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *errorArrStr=[[NSString alloc]initWithData:errorArrData encoding:NSUTF8StringEncoding];
    
    NSString * errorMsg = [NSString stringWithFormat:@"%@  %@",errorReason,errorArrStr];
    
    //!错误信息的md5
    NSString * errorMsgMD5 = [errorMsg MD5Hash];
   
    //!错误时间
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString * errorDateStr = [dateFormatter stringFromDate:nowDate];
    
    //!保存崩溃日志
    NSDictionary * errorDic = @{@"iphoneModel":iphoneMode,
                                @"model":model,
                                @"errorMsg":errorMsg,
                                @"md5Summary":errorMsgMD5,
                                @"occurDate":errorDateStr
                                };

    ErrorLogDefaults * errorDefaults = [ErrorLogDefaults shareManager];
    [errorDefaults.errorLogArray addObject:errorDic];
    [errorDefaults errorLog_save];
    
    
}


/*
 *判断 是否 被提出
 */

-(void)available:(NSString *)start{
    if ([start  isEqualToString:@"available"]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        //获取会员信息
        [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                
                
            }else{
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        } ];
        
    }
}
#pragma mark sendHttpRequestForclearBadgeCountSuccess
-(void)clearBadgeCount{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        //清空消息badge
        [HttpManager sendHttpRequestForclearBadgeCountSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                
                
            }else{
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        } ];
        
}
#pragma mark 上传崩溃日志
-(void)upErrorLog{

    ErrorLogDefaults * errorDefaults = [ErrorLogDefaults shareManager];
    NSMutableArray * errorLogArray = errorDefaults.errorLogArray;
    
    //!没有登录、没有数据就不上传
    if (errorLogArray && errorLogArray.count && [LoginDTO sharedInstance].tokenId) {
        
        [HttpManager sendHttpRequestForApperrorAddWithList:errorLogArray Success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([responseDic[@"code"] isEqualToString:@"000"]) {
                
                DebugLog(@"上传错误日志成功");
                
                ErrorLogDefaults * errorDefaults = [ErrorLogDefaults shareManager];

                [errorDefaults removePlistInfo];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];

        
    }

}

#pragma makr -  UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        //        [[NSNotificationCenter defaultCenter]postNotificationName:SHOWNEWS object:nil userInfo:userInfo];
        
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSDictionary * dict = response.notification.request.content.userInfo;
    NSString *typeStr = dict[@"type"];
    NSInteger type = typeStr.integerValue;

    if ([dict[@"type"] isEqualToString:@"7"]) {//商品
        
        
    }else
        if ([dict[@"type"] isEqualToString:@"8"])//商圈
        {
            if (self.tabBarController.selectedIndex == 0) {
                UINavigationController *nav1 = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
                bussinessVC.rightItemUrl = @"zone/ddopIndex.html";
                //标记此类的为叮咚官方
                bussinessVC.makrRightNav = @"right";
                //添加通知
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImgNotification" object:nil];
                //            self.isLoading = NO;
                [nav1 pushViewController:bussinessVC animated:YES];
                
                
            }else {
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 0;
                UINavigationController *nav1 = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
                bussinessVC.rightItemUrl = @"zone/ddopIndex.html";
                //标记此类的为叮咚官方
                bussinessVC.makrRightNav = @"right";
                //添加通知
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImgNotification" object:nil];
                //            self.isLoading = NO;
                [nav1 pushViewController:bussinessVC animated:YES];
                
            }
            
        }else if (type <= 5)
        {
            
            if (self.tabBarController.selectedIndex ==2) {
                
            }else {
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 2;
            }
        }
        else if (type == 6)
        {
            if (self.tabBarController.selectedIndex ==2) {
                
            }else {
                
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 2;
            }
            
        }else if (type == 9)
        {
            if (self.tabBarController.selectedIndex ==2) {
                
            }else {
                
                //推送进入
                //            [self setTabBarHidden:NO];
                UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                
                [nav popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 2;
            }
        }

//    [[NSNotificationCenter defaultCenter]postNotificationName:SHOWNEWS object:nil userInfo:userInfo];
    
    
    //    NSDictionary * userInfo = notification.request.content.userInfo;
    
    completionHandler();  // 系统要求执行这个方法
}



@end
