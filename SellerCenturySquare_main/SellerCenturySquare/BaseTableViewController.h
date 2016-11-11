//
//  BaseTableViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/12.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpManager.h"
#import "RDVTabBarController.h"
#import "Toast+UIView.h"

@interface BaseTableViewController : UITableViewController

/**
 *  显示或者隐藏黑色透明NavigationBar
 *
 *  @param show 是否显示
 */
- (void)navigationBarSettingShow:(BOOL)show;

- (NSDictionary *)conversionWithData:(NSData *)data;

- (BOOL)isRequestSuccessWithCode:(NSString*)code;

- (BOOL)checkData:(id)data class:(Class)class;

- (void)customBackBarButton;

- (void)tabbarHidden:(BOOL)hide;

- (void)alertWithAlertTip:(NSString*)msg;


@end
