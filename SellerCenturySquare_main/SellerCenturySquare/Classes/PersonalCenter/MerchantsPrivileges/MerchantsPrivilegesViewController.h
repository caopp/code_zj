//
//  MerchantsPrivilegesViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol MerchantsPrivilegesViewControllerDelegate <NSObject>

-(void)pushTransactionRecordsVC;

-(void)clearBusinessFranchiseRecord;


@end

@interface MerchantsPrivilegesViewController : BaseViewController

@property(weak,nonatomic)id<MerchantsPrivilegesViewControllerDelegate>delegate;

@property(nonatomic,strong)UIWebView *webView;

@end
