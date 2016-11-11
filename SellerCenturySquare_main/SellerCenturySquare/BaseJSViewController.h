//
//  BaseJSViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/28.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "LoadFailedView.h"


@interface BaseJSViewController : BaseViewController<UIWebViewDelegate, LoadFailedDelegate>

//JS交互
@property (nonatomic ,strong)WebViewJavascriptBridge *bridge;
//显示H5视图
@property (nonatomic ,strong)UIWebView *webView;
//进度条
@property (nonatomic ,strong) UIProgressView *progressView;
//计算个数
@property (nonatomic ,assign) NSUInteger loadCount;

@property (nonatomic ,strong) LoadFailedView *loadFailView;


- (void)destructionSelfVC;


@end
