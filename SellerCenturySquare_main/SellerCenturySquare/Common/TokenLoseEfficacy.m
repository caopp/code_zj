//
//  TokenLoseEfficacy.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/1/5.
//  Copyright © 2016年 pactera. All rights reserved.
// token失效的时候显示 登录界面

#import "TokenLoseEfficacy.h"
#import "CSPLoginViewController.h"// !登录
#import "CSPNavigationController.h"
#import "SaveUserIofo.h"
#import "MyUserDefault.h"
#import "ChatManager.h"

@implementation TokenLoseEfficacy

// token失效的时候显示 登录界面
-(void)showLoginVC{

    UIViewController *nowVC = [self getCurrentVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CSPLoginViewController * loginVC =[storyboard instantiateViewControllerWithIdentifier:@"CSPLoginViewController"];
    
    CSPNavigationController *loginNav = [[CSPNavigationController alloc]initWithRootViewController:loginVC];
    
    loginVC.pswTextField.text = nil;
    
    //删除用户信息
    SaveUserIofo *userIofo = [[SaveUserIofo alloc]init];
    [userIofo deleteIofoDTO];
    
    //删除用户登录时候采用的密码和账号
    [MyUserDefault removePassword];
    [MyUserDefault removePhone];
    [MyUserDefault removeFirstLogin];
    
    
    [ChatManager shareInstance].xmppUserName = nil;
    [ChatManager shareInstance].xmppPassWord = nil;
    
    //发送离线请求
    [[ChatManager shareInstance] disconnectToServer];
    
  
    
    
    [nowVC presentViewController:loginNav animated:YES completion:nil];
    

    

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
