//
//  SecondaryViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/5/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
@protocol SecondaryViewControllerDelegate <NSObject>

-(void)pushTransactionRecordsVC;

-(void)clearBusinessFranchiseRecord;


@end

@interface SecondaryViewController : BaseViewController
@property(weak,nonatomic)id<SecondaryViewControllerDelegate>delegate;

@property(nonatomic,strong)NSString *titleRecord;


@property (strong, nonatomic) UIWebView *webView;

@property (strong,nonatomic) NSString *file;

@property (nonatomic ,assign)BOOL isRecond;

//采购商传进bool值
@property (nonatomic,assign) BOOL isPrepaidu;

//商家特权
@property (nonatomic,assign) BOOL isprivilege;
@end
