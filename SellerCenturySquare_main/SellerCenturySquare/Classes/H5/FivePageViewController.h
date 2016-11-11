//
//  FivePageViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/5/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "LoadFailedView.h"

@protocol FivePageViewControllerDelegate <NSObject>

-(void)pushTransactionRecords;

-(void)clearBusinessFranchiseRecord;


@end
@interface FivePageViewController : BaseViewController<LoadFailedDelegate>
@property(nonatomic,strong)NSString *titleRecord;
@property(weak,nonatomic)id<FivePageViewControllerDelegate>delegate;
@property (nonatomic ,strong) LoadFailedView *loadFailView;

@property (strong, nonatomic) UIWebView *webView;

@property (strong,nonatomic) NSString *file;
@end
