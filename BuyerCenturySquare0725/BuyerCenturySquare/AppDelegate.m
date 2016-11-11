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

#import "CSPBlackNavigationController.h"
#import "CSPNavigationController.h"
#import "CSPLoginViewController.h"
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

#import "SWRevealViewController.h"
#import "LeftSlideViewController.h"

@interface AppDelegate ()<WXApiDelegate> {
    
    TabBarController *tabBar;
    
}

@property(strong) Reachability * localWiFiReach;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //!配置聊天
    [self setChatNotification:launchOptions];

    //设置状态栏为白色
    [application setStatusBarHidden:NO];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    // !判断显示 引导页还是主控制
    [self controllerShow];

    [self networkReachabilityObserverInit];
    
    /**
     *  注册微信客户端
     */
    [self registerWeiChat];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutMethod) name:logoutNotice object:nil];
    
    
    [self deleteUserInfoFirst];
    
    return YES;
    
    
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
        CSPNavigationController *nav = [[CSPNavigationController alloc]initWithRootViewController:loginViewController];
        [self.viewController presentViewController:nav animated:YES completion:nil];
        
    }else
    {
        /*
         *进入主页面
         */
        [self setupViewControllers];
        
        [[LoginDTO sharedInstance]setDictFrom:newDic];
        
        UserOtherInfo *userOtherInfo = [[UserOtherInfo alloc]init];
        [userOtherInfo assignmentPhoneNumber:[MyUserDefault defaultLoadAppSetting_loginPhone] password:[MyUserDefault defaultLoadAppSetting_loginPassword]];
        
    }
}

-(void)updateRootViewController
{
    
    [self setupViewControllers];

}

#pragma mark 配置聊天
-(void)setChatNotification:(NSDictionary *)launchOptions{
    
    [[ChatManager shareInstance] setupStream];
    
    UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [AppInfoDTO sharedInstance].deviceToken = [[UIDevice currentDevice]identifierForVendor].UUIDString;
    
    MyLog(@"My token is NSString: %@", [AppInfoDTO sharedInstance].deviceToken);
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        MyLog(@"从消息启动:%@",userInfo);
    }
    
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
    
    NSLog(@"My token is NSString: %@", [AppInfoDTO sharedInstance].deviceToken);
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
//    NSLog(@"userInfo == %@",userInfo);
//    NSString *messageShow = [NSString stringWithFormat:@""]];
//    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    [alert show];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"userInfo == %@",userInfo);
//    NSString *messageShow = [NSString stringWithFormat:@"%@",userInfo];
//    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageShow delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    [alert show];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWNEWS object:nil];
}
// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"leftKey"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
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
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //返回前台
    if ([ChatManager shareInstance].xmppUserName != nil) {
        
        [[ChatManager shareInstance] connectToServer:[ChatManager shareInstance].xmppUserName passWord:[ChatManager shareInstance].xmppPassWord];
    }    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"allowInteraction" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatPaySuccess" object:nil];
//                [self.window makeToast:@"支付成功" duration:2 position:@"center"];

                
                
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
    
    self.viewController = nil;
    tabBar = nil;
    [self setupViewControllers];
    
}


@end
