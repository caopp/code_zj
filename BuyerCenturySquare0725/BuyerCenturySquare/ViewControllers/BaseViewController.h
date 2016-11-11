//
//  BaseViewController.h
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "marco.h"
#import "MBProgressHUD.h"

@class NJKWebViewProgress,NJKWebViewProgressView;

@interface BaseViewController : UIViewController


@property(nonatomic,strong)MBProgressHUD *progressHUD;

//商品详情接口－imageList获取特定类型的图片
- (NSArray *)siftImagesFromImageList:(NSArray *)imageList withType:(CSPImageListType)type;

- (UIBarButtonItem *)barButtonWithtTitle:(NSString *)title font:(UIFont*)font;

- (void)progressHUDShowWithString:(NSString *)string;

- (void)progressHUDHiddenWidthString:(NSString *)string;

- (NSDictionary *)conversionWithData:(NSData *)data;

- (void)progressHUDHiddenTipSuccessWithString:(NSString *)string;

- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (BOOL)isRequestSuccessWithCode:(NSString*)code;

- (BOOL)checkData:(id)data class:(Class)Class;

- (void)alertWithAlertTip:(NSString*)msg;

-(void)setExtraCellLineHidden: (UITableView *)tableView;

- (NSString *)transformationData:(id)data;

-(void)addCustombackButtonItem;

- (void)animationForContentView:(CGRect)rect;

//!点击空白收起键盘的事件
-(void)addTapHideKeyBoard;

//导航栏上添加加载线条
-(void)accordingProgressBar;

- (void)backBarButtonClick:(UIBarButtonItem *)sender;


@end
