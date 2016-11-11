//
//  ScoreQueryViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/15.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScoreQueryViewControllerDelegate <NSObject>

-(void)removalOfTurnoverIntegralCache;

@end


@interface ScoreQueryViewController : UIViewController

@property (nonatomic,weak)id<ScoreQueryViewControllerDelegate>delegate;

@property (nonatomic,strong)UIWebView *webView;
@end
