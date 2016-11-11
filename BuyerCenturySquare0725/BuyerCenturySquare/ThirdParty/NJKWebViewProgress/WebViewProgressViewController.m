//
//  WebViewProgressViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WebViewProgressViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface WebViewProgressViewController ()<NJKWebViewProgressDelegate>
@end

@implementation WebViewProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)accordingProgressBar
{
    self._progressProxy = [[NJKWebViewProgress alloc] init];
    //    _webView.delegate = _progressProxy;
    //    _progressProxy.webViewProxyDelegate = self;
    self._progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self._progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self._progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

}


//-(void)loadGoogle
//{
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    [_webView loadRequest:req];
//}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self._progressView setProgress:progress animated:YES];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
@end
