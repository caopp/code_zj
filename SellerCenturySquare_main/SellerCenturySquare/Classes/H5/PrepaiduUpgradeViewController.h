//
//  PrepaiduUpgradeViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "LoadFailedView.h"



@protocol PrepaiduUpgradeViewControllerDelegate <NSObject>

-(void)pushTransactionRecordsVC;

-(void)clearBusinessFranchiseRecord;


@end

@interface PrepaiduUpgradeViewController : BaseViewController<LoadFailedDelegate>



@property(weak,nonatomic)id<PrepaiduUpgradeViewControllerDelegate>delegate;

@property(nonatomic,strong)NSString *titleRecord;
@property (nonatomic ,strong) LoadFailedView *loadFailView;

@property (strong, nonatomic) UIWebView *webView;

@property (strong,nonatomic) NSString *file;

@property (nonatomic ,assign)BOOL isRecond;

//来自于采购商
@property (nonatomic,assign)BOOL isPurchase;

@property (nonatomic,assign)BOOL isPost;


@property (nonatomic,assign)BOOL isInvite;

@end
