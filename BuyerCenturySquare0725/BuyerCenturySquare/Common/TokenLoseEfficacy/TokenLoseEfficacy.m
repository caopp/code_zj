//
//  TokenLoseEfficacy.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/5.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TokenLoseEfficacy.h"
#import "CSPLoginViewController.h"
#import "CSPNavigationController.h"
#import "SaveUserIofo.h"
#import "ChatManager.h"
#import "DownloadLogControl.h"
#import "SaveJSWithNativeUserIofo.h"
#import "SWRevealViewController.h"


@implementation TokenLoseEfficacy

-(void)showLoginVC{
    
   //!先把以前的都置为nil
    [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];
    
    // !获取当前展现的vc
    UIViewController *nowVC = [self getCurrentVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    

    CSPLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPLoginViewController"];
    loginVC.isFromTokenLoseEfficacy = YES;//!标注是从这个页面过去的
    
    CSPNavigationController *loginNav = [[CSPNavigationController alloc]initWithRootViewController:loginVC];
    
    [nowVC presentViewController:loginNav animated:YES completion:nil];
    
    loginVC.passwordTextField.text = nil;
    
    
    //删除用户信息
    SaveUserIofo *userInfo = [[SaveUserIofo alloc]init];
    [userInfo deleteIofoDTO];
    
    
    //删除用户信息
//    SaveJSWithNativeUserIofo *saveInfo = [[SaveJSWithNativeUserIofo alloc]init];
//    [saveInfo deleteUserIofoDTO];


    //进行密码和账号删除
    [MyUserDefault removeLoginPhone];
    [MyUserDefault removeLoginPassword];
    
    
    [ChatManager shareInstance].xmppUserName = nil;
    [ChatManager shareInstance].xmppPassWord = nil;
    //发送离线请求
    [[ChatManager shareInstance] disconnectToServer];
    

    //!暂停所有下载
    [[DownloadLogControl sharedInstance] suspendAllDownLoad];
    
    
    
}



#pragma mark 获取当前屏幕显示的viewcontroller lyt
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        result = nextResponder;
    
    else
        result = window.rootViewController;
    
    return result;
}

@end
