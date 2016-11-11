//
//  BaseTableViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/12.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseTableViewController.h"

static NSString * const successfulOperation = @"000";


@interface BaseTableViewController ()

@end

@implementation BaseTableViewController


//显示或隐藏黑色透明NavigationBar
- (void)navigationBarSettingShow:(BOOL)show{
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationController.navigationBarHidden = !show;
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    
    /*更改返回按钮图片
     [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
     */
    
    self.navigationItem.backBarButtonItem=backItem;
    

}

- (NSDictionary *)conversionWithData:(NSData *)data{
    
    return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

- (BOOL)isRequestSuccessWithCode:(NSString*)code{
    
    if ([code isEqualToString:successfulOperation]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}

- (BOOL)checkData:(id)data class:(Class)class{
    
    if (data && [data isKindOfClass:class]){
        return YES;
    }else{
        return NO;
    }
}

- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//Tabbar显示和隐藏
- (void)tabbarHidden:(BOOL)hide{
    
    [[self rdv_tabBarController] setTabBarHidden:hide animated:YES];
    
}

- (void)alertWithAlertTip:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
}

- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

@end
