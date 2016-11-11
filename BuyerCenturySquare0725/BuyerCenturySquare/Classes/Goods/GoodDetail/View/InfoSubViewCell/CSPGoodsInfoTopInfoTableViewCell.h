//
//  CSPGoodsInfoTopInfoTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "InfiniteDownloadButton.h"
#define kDownloadButtonClickedNotification @"DownloadButtonClickedNotification"
#define kShareButtonClickedNotification @"ShareButtonClickedNotification"
#define kCollectButtonClickedNotification @"CollectButtonClickedNotification"
@interface CSPGoodsInfoTopInfoTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *navBarView;
- (void)changeBG;

//
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *memberLevel;
@property (nonatomic,strong) NSMutableArray *stepList;
@property (weak, nonatomic) IBOutlet UILabel *moneyLogoL;

@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (strong, nonatomic) IBOutlet UIView *TopBar;
@property (strong, nonatomic) IBOutlet InfiniteDownloadButton *downBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (assign, nonatomic) BOOL isShort;//伸缩界面
- (void)setModeState:(BOOL)modeState;
@end
