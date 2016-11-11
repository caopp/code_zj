//
//  CSPGoodsInfoSubViewController.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GoodsInfoDetailsDTO.h"
#import "RefreshControl.h"
#import "InfiniteDownloadButton.h"

#define kDownloadButtonClickedNotification @"DownloadButtonClickedNotification"
#define kShareButtonClickedNotification @"ShareButtonClickedNotification"
#define kGoodsInfoShopTableViewCellClicked @"GoodsInfoShopTableViewCellClicked"
#define kCollectButtonClickedNotification @"CollectButtonClickedNotification"
#define kMJRefreshDataNotification @"MJRefreshDataNotification"
#define kMJRefreshDataFinishNotification @"MJRefreshDataFinishNotification"
#define kWMPanEnable @"WMPanEnable"
#define kStopDownAnimation @"StopDownAnimation"
@interface CSPGoodsInfoSubViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) IBOutlet UITableView *bottomTableView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UILabel *noticeL;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (nonatomic,copy) NSString *goodsNo;
@property (nonatomic,strong)GoodsInfoDetailsDTO *goodsInfoDetailsDTO;
@property (nonatomic,strong)NSMutableDictionary *goodsList;
@property (weak, nonatomic) IBOutlet InfiniteDownloadButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
//@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *downloadView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *startNumL;
@property (weak, nonatomic) IBOutlet UILabel *hasSelectedNumL;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIView *objBackView;
@property (weak, nonatomic) IBOutlet UILabel *objL;
@property (weak, nonatomic) IBOutlet UIView *refBackView;
@property (weak, nonatomic) IBOutlet UILabel *refL;

@property (weak, nonatomic) IBOutlet UIButton *backToTopButton;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraintAdTop;
//@property (weak,nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraintTop;
- (void)setButtonBarHide:(BOOL)hide;
- (void)threeButtonSetAlphaToShow;

@end
