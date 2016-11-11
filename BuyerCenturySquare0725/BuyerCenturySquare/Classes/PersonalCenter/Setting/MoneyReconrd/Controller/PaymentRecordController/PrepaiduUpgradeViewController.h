//
//  PrepaiduUpgradeViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@interface PrepaiduUpgradeViewController : BaseViewController

@property(nonatomic,strong)NSString *titleRecord;

@property (strong, nonatomic) UIWebView *webView;

@property (strong,nonatomic) NSString *file;

@property (nonatomic ,assign)BOOL isRecond;

@property (nonatomic,assign)BOOL isOK;



@end
