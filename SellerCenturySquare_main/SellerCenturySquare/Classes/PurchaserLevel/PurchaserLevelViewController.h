//
//  PurchaserLevelViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PurchaserLevelViewControllerDelegate <NSObject>

-(void)removeMiningRecordCache;

@end

@interface PurchaserLevelViewController : UIViewController

@property(nonatomic,weak)id<PurchaserLevelViewControllerDelegate>delegate;
@property(nonatomic,strong)UIWebView *webView;

@end
