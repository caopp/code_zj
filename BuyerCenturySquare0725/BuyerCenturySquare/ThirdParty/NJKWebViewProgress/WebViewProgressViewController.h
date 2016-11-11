//
//  WebViewProgressViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJKWebViewProgressView,NJKWebViewProgress;


@interface WebViewProgressViewController : UIViewController

@property (nonatomic,strong) NJKWebViewProgressView *_progressView;
@property (nonatomic,strong) NJKWebViewProgress *_progressProxy;

-(void)accordingProgressBar;

@end
