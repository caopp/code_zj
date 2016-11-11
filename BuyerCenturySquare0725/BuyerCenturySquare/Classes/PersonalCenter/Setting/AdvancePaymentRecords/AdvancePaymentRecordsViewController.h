//
//  AdvancePaymentRecordsViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdvancePaymentRecordsViewControllerDelegate <NSObject>

-(void)removeTradingWaterCache;

@end


@interface AdvancePaymentRecordsViewController : UIViewController

@property (weak,nonatomic)id<AdvancePaymentRecordsViewControllerDelegate>delegate;

@property(nonatomic,strong)UIWebView *webView;

@end
