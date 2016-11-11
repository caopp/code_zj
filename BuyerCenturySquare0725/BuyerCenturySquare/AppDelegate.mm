//
//  AppDelegate.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpManager.h"
#import "LoginDTO.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LeftSlideViewController.h"

#import "CSPMerchantTableViewController.h"
#import "CSPGoodsViewController.h"
#import "CSPShoppingCartViewController.h"
#import "CSPPersonCenterMainViewController.h"
#import "CSPBlackNavigationController.h"
#import "CSPLoginViewController.h"
#import "CSPPayAvailabelViewController.h"
#import "CoreNewFeatureVC.h"
#import "CALayer+Transition.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "Reachability.h"
#import "TabBarController.h"


#import "ChatManager.h"
#import "DeviceDBHelper.h"

#import "AppInfoDTO.h"


#import "WXApi.h"
//用户其他地方登录
#import "UserOtherInfo.h"
#import "GuideViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "NSString+Hashing.h"//!MD5加密文件
#import "ErrorLogDefaults.h"//!错误日志保存文件


#import "CityPropValueDefault.h"
#define testAK @"AVftQVjnjcSBH972oevjHfeFCMKsoGjG"

#define onlineAK @"gbWHnP9o9rVf3luAzb3tV0MtPpOTQ8S1"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif
//
@interface AppDelegate ()<WXApiDelegate,BMKGeneralDelegate,UNUserNotificationCenterDelegate> {
    
    TabBarController *tabBar;
    BMKMapManager* _mapManager;
    
}

@property(strong) Reachability * localWiFiReach;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    //!不加这里，导航就会有一条分割线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //设置状态栏为白色
    [application setStatusBarHidden:NO];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //!配置聊天
    [self setChatNotification:launchOptions];
    // !判断显示 引导页还是主控制
    [self controllerShow];
    
    // 清空  bageNumb
    [self clearBadge];

    [self networkReachabilityObserverInit];
    /**
     *  注册微信客户端
     */
    [self registerWeiChat];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutMethod) name:logoutNotice object:nil];
    
    [self deleteUserInfoFirst];
   
    //使用百度地图
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret = [_mapManager start:testAK generalDelegate:self];
    
//    BOOL ret = [_mapManager start:onlineAK generalDelegate:self];

    //进行省市区版本控制
    CityPropValueDefault * propValueDefalut = [CityPropValueDefault shareManager];
    [propValueDefalut dataPropValueControl];

    
    if (!ret) {
        DebugLog(@"manager start failed!");
    }
    
    //!获取崩溃日志
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    //!上传崩溃日志
    [self upErrorLog];
    
    return YES;
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        DebugLog(@"联网成功");
    }
    else{
        DebugLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        DebugLog(@"授权成功");
    }
    else {
        DebugLog(@"onGetPermissionState %d",iError);
    }
}

//申请资料(保存的申请资料进行删除)
-(void)deleteUserInfoFirst
{
    [MyUserDefault defaultLoadAppSetting_name];
    [MyUserDefault defaultLoadAppSetting_phone];
    [MyUserDefault defaultLoadAppSetting_areaDetail];
    [MyUserDefault defaultLoadAppSetting_area];
    [MyUserDefault defaultLoadAppSetting_cityId];
    [MyUserDefault defaultLoadAppSetting_districtId];
    [MyUserDefault defaultLoadAppSetting_stateId];
}


#pragma mark 判断显示 引导页还是主控制
- (void)controllerShow
{
    
    // !获取新老版本号进行比较
    NSString *key=@"CFBundleShortVersionString";
    //加载程序中info.plist文件（获取当前软件的版本号）
    NSString *currentVerionCode=[NSBundle mainBundle].infoDictionary[key];
    
    NSString *oldVersion = [MyUserDefault defaultLoad_oldVersion];
    
    if (![currentVerionCode isEqualToString:oldVersion]) {//!显示引导页
        
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

    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];

    if (!newDic[@"tokenId"]) {
        
        [self setupViewControllers];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CSPLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPLoginViewController"];
        
        _nav = [[CSPNavigationController alloc]initWithRootViewController:loginViewController];
        [self.viewController presentViewController:_nav animated:YES completion:nil];
        
        
    }else
    {
        
        [[LoginDTO sharedInstance]setDictFrom:newDic];
        
        UserOtherInfo *userOtherInfo = [[UserOtherInfo alloc]init];
        
        [userOtherInfo assignmentPhoneNumber:[MyUserDefault defaultLoadAppSetting_loginPhone] password:[MyUserDefault defaultLoadAppSetting_loginPassword]];
        
        
        /*
         *进入主页面
         */
        [self setupViewControllers];

    }
}

-(void)updateRootViewController
{
    
    [self setupViewControllers];
    
//    //获取应用程序沙盒的Documents目录
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    
//    NSString *plistPath1 = [paths objectAtIndex:0];
//    
//    //得到完整的文件名
//    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
//    
//    NSMutableDictionary *newDic;
//    
//    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
//    
//    [[LoginDTO sharedInstance]setDictFrom:newDic];
//    
//    
//    UserOtherInfo *userOtherInfo = [[UserOtherInfo alloc]init];
//    
//    [userOtherInfo assignmentPhoneNumber:[MyUserDefault defaultLoadAppSetting_loginPhone] password:[MyUserDefault defaultLoadAppSetting_loginPassword]];
//    
    
    
}

#pragma mark 配置聊天
-(void)setChatNotification:(NSDictionary *)launchOptions{
    
    [[ChatManager shareInstance] setupStream];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
//                DebugLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    DebugLog(@"%@",settings);
                    
                }];
                
            }else
            {
                //点击不允许
                DebugLog(@"注册失败");
                
            }
            
        }];
        
    }else{
    
    UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [AppInfoDTO sharedInstance].deviceToken = [[UIDevice currentDevice]identifierForVendor].UUIDString;
    
    MyLog(@"My token is NSString: %@", [AppInfoDTO sharedInstance].deviceToken);
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        MyLog(@"从消息启动:%@",userInfo);
    }
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
   
}

//通知回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    [AppInfoDTO sharedInstance].deviceToken = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
#else
    
    [AppInfoDTO sharedInstance].deviceToken = [[UIDevice currentDevice]identifierForVendor].UUIDString;
#endif
    
    DebugLog(@"My token is NSString: %@", [AppInfoDTO sharedInstance].deviceToken);
    
}

// 处理推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    
    
    
    DebugLog(@"userInfo == %@",userInfo);
//    NSString *messageShow = [NSString stringWithFormat:@""]];
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
//
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    DebugLog(@"userInfo == %@",userInfo);
    
    if (userInfo) {


    // 在这里写跳转代码
    // 如果是应用程序在前台,依然会收到通知,但是收到通知之后不应该跳转
    if (application.applicationState == UIApplicationStateActive) return;
    
    if (application.applicationState == UIApplicationStateInactive) {
        // 当应用在后台收到本地通知时执行的跳转代码
            [[NSNotificationCenter defaultCenter]postNotificationName:SHOWNEWS object:nil userInfo:userInfo];
    }
        
}
    
    
//    completionHandler(UIBackgroundFetchResultNewData);
    

}
// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DebugLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DebugLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    else
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
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
    //!发送通知，收起侧面
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideLeft" object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //返回前台
    if ([LoginDTO sharedInstance].tokenId) {
        
       // [self available:@"available"];
        [self clearBadgeCount];
    }
    //!发送通知，获取 系统时间
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMerchantChatNo" object:nil];
}
//禁用第三方键盘
- (BOOL)application:(UIApplication *)application

shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier

{
    
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        if (_showThridKeyboard) {
//            _showThridKeyboard = NO;
            
            return YES;
        }else{
            return NO;
        }
        
        
    }
    return YES;
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"allowInteraction" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicatio nDidEnterBackground:.
}

- (void)setupViewControllers {
    
    tabBar= [[TabBarController alloc] init];
    
    self.viewController = tabBar;
    
    //左侧菜单栏
    LeftSlideViewController *leftViewController = [[LeftSlideViewController alloc] init];
    
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController frontViewController:self.viewController];
    
    revealViewController.rearViewRevealWidth = SCREEN_WIDTH *0.4f;
    
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [self.window setRootViewController:revealViewController];
    
    [self.window makeKeyAndVisible];

}

#pragma mark -
#pragma mark extra function

+ (AppDelegate *)currentAppDelegate{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -
#pragma mark    Reachability

- (void)networkReachabilityObserverInit{
    
    //    __weak __block typeof(self) weakself = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.localWiFiReach = [Reachability reachabilityForLocalWiFi];
    
    [self.localWiFiReach startNotifier];
}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if (reach == self.localWiFiReach)
    {
        BOOL reachWithWiFi = [reach isReachableViaWiFi];
        
        if (YES == reachWithWiFi) {
            
            //            [self.window makeToast:@"you connect with your Wi-Fi."];
        }else{
            
            //            [self.window makeToast:@"you lost connect with your Wi-Fi."];
        }
    }
}

- (BOOL)isWifiReach{
    
    return [self.localWiFiReach isReachableViaWiFi];
}


#pragma mark -
#pragma mark WeiChat

- (void)registerWeiChat{
    
    [WXApi registerApp:@"wxa5cbc8c1d2521bbd"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}


- (void) onReq:(BaseReq*)req{
    DebugLog(@"调起方法 = %@", @"onReq");
    
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
                DebugLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatPaySuccess" object:nil];
                break;
                
            default:
                DebugLog(@"失败%d", resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatPayfailure" object:nil];

//                [self.window makeToast:@"支付失败" duration:2 position:@"center"];
                

                break;
        }
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        switch (resp.errCode) {
//                WXSuccess           = 0,    /**< 成功    */
//                WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//                WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//                WXErrCodeSentFail   = -3,   /**< 发送失败    */
//                WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//                WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
            case WXSuccess:
                [self.window makeMessage:@"分享成功" duration:2.0f position:@"center"];

                break;
            case WXErrCodeCommon:
                [self.window makeMessage:@"分享错误" duration:2.0f position:@"center"];
                
                break;
            case WXErrCodeUserCancel:
                [self.window makeMessage:@"分享取消" duration:2.0f position:@"center"];
                
                break;
            case WXErrCodeUnsupport:
                [self.window makeMessage:@"微信不支持" duration:2.0f position:@"center"];
                
                break;
            case WXErrCodeAuthDeny:
                [self.window makeMessage:@"授权失败" duration:2.0f position:@"center"];
                
                break;
            default:
                [self.window makeMessage:@"分享失败" duration:2.0f position:@"center"];

                break;
                
        }
    }
}

-(void)logoutMethod{
    
    //!因为登录后新建tabbr，原来的tabbar里面的CustomGoodsListViewController（商品列表）也会接收到通知；例如点击CustomGoodsListViewController的筛选时，原来的商品列表和现在的商品列表同时接到通知，导致弹出两个筛选界面；
    //!如果登录后进入的app首界面不再是 商品列表，则这里的移除观察代码就可以去除
    CSPBlackNavigationController * blackNav = [tabBar viewControllers][1];
    CustomGoodsListViewController * goodsListVC = blackNav.viewControllers[0];
    [goodsListVC removeAllNotification];
    [goodsListVC removeGoodListObserver];
    
    self.viewController = nil;
    tabBar = nil;
    [self setupViewControllers];
    
    
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
    //!错误信息
    NSData *errorArrData = [NSJSONSerialization dataWithJSONObject:errorArr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *errorArrStr=[[NSString alloc]initWithData:errorArrData encoding:NSUTF8StringEncoding];
    
    NSString * errorMsg = [NSString stringWithFormat:@"%@  %@",errorReason,errorArrStr];
    
    if (model.length > 250) {
        
       model =  [model substringToIndex:249];
        
    }
    
    
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


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DebugLog(@"result = %@",resultDic);
        }];
        return YES;

    }
    
    return  [WXApi handleOpenURL:url delegate:self];

}


/*
 *判断 是否 被提出
 */
-(void)available:(NSString *)start{
    if ([start  isEqualToString:@"available"]) {
        
        //获取会员信息
        [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}
#pragma mark sendHttpRequestForclearBadgeCountSuccess
-(void)clearBadge{
    if ([LoginDTO sharedInstance].tokenId) {
        
        // [self available:@"available"];
        [self clearBadgeCount];
    }
}
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

#pragma mark -  UNUserNotificationCenterDelegate
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
        DebugLog(@"iOS10 前台收到远程通知:%@", userInfo);
//        [[NSNotificationCenter defaultCenter]postNotificationName:SHOWNEWS object:nil userInfo:userInfo];

        
    }
    else {
        // 判断为本地通知
        DebugLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
        NSDictionary * userInfo = response.notification.request.content.userInfo;
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOWNEWS object:nil userInfo:userInfo];

    
//    NSDictionary * userInfo = notification.request.content.userInfo;

        completionHandler();  // 系统要求执行这个方法
}


@end
