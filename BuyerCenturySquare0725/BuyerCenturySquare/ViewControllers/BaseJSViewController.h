  //
//  BaseJSViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/28.
//  Copyright © 2015年 pactera. All rights reserved.
//  h5 请求的基类

#import "BaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "SaveJSWithNativeUserIofo.h"
#import "LoadFailedView.h"


@interface BaseJSViewController : BaseViewController<NJKWebViewProgressDelegate,UIWebViewDelegate,LoadFailedDelegate>

@property (nonatomic ,strong)WebViewJavascriptBridge *bridge;
@property (nonatomic ,strong)UIWebView *webView;
@property (nonatomic ,strong) NJKWebViewProgress *progressProxy;
@property (nonatomic ,strong) UIProgressView *progressView;
@property (nonatomic ,strong)  SaveJSWithNativeUserIofo * info;
@property (nonatomic ,assign) NSUInteger loadCount;
@property (nonatomic ,strong) LoadFailedView *loadFailView;


@property (nonatomic ,copy) NSString *selfTitle;


//!提供给资料重写的方法
-(void)createWebView;


- (void)destructionSelfVC;


@end
