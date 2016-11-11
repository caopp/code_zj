//
//  CSPDownLoadImageCell.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"

#import "FileModel.h"

#import "CSPPicInfoDTO.h"

#import "MHImageDownloadProcessor.h"

#import "DownloadLogControl.h"

#import "CSPSelectedButton.h"

#import "ImageHistoryDTO.h"

typedef NS_ENUM(NSInteger, ViewControllerType) {
    DownloadViewController,
    DownloadHistoryViewController
};

typedef NS_ENUM(NSInteger, DownLoadType) {
    WindowImage = 0,
    ObjectiveImage,
    AllImage
};

typedef void(^DownloadedSelectedWindowImageBlock)();
typedef void(^DownloadedSelectedObjectImageBlock)();

@interface CSPDownLoadImageCell : CSPBaseTableViewCell<DownloadLogItemDelegate>

@property(assign,nonatomic)ViewControllerType viewControllerType;

@property (weak, nonatomic) IBOutlet CSPSelectedButton *windowSelectedBtn;

@property (weak, nonatomic) IBOutlet CSPSelectedButton *objectiveSelectedBtn;

@property(strong, nonatomic)DownloadLogFigure *objectiveDownloadLogFigure;

@property(strong, nonatomic)DownloadLogFigure *windowDownloadLogFigure;

@property(copy,nonatomic)NSString *goodsNo;

//已下载
//窗口图
@property (weak, nonatomic) IBOutlet UIImageView *windowDefaultImgaeView;

@property (weak, nonatomic) IBOutlet UIView *downLoadWindowImageBackView;

@property (weak, nonatomic) IBOutlet UIView *downLoadWindowImageRightBackView;

@property (weak, nonatomic) IBOutlet UILabel *windowImageSizeLabel;

@property (weak, nonatomic) IBOutlet CSPSelectedButton *windowImageSelectedButton;

@property (weak, nonatomic) IBOutlet CSPSelectedButton *windowImageDownLoadAgain;

@property (weak, nonatomic) IBOutlet UIButton *windowImageDowLoadDelete;

- (IBAction)windowImageSelectedButtonClick:(id)sender;

- (IBAction)windowImageDownLoadAgain:(id)sender;

- (IBAction)windowImageDowLoadDelete:(id)sender;

@property(nonatomic,copy)DownloadedSelectedWindowImageBlock downloadedSelectedWindowImageBlock;
@property(nonatomic,copy)DownloadedSelectedObjectImageBlock downloadedSelectedObjectImageBlock;
//客观图

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLoadObjectImageBackViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *downLoadObjectImageBackView;

@property (weak, nonatomic) IBOutlet UIView *downLoadObjectImageRightBackView;

@property (weak, nonatomic) IBOutlet UILabel *objectImageSizeLabel;

@property (weak, nonatomic) IBOutlet CSPSelectedButton *objectImageSelectedButton;

@property (weak, nonatomic) IBOutlet CSPSelectedButton *objectImgaeDownLoadAgain;

@property (weak, nonatomic) IBOutlet UIButton *objectImageDownLoadDelete;

- (IBAction)objectImageSelectedButtonClick:(id)sender;

- (IBAction)objectImgaeDownLoadAgain:(id)sender;

- (IBAction)objectImageDownLoadDelete:(id)sender;


@property (nonatomic,copy)void (^windowSelectedBlock)(NSString *goodsNo,DownLoadType downLoadType,BOOL isAdd);

@property (nonatomic,copy)void (^objectSelectedBlock)(NSString *goodsNo,DownLoadType downLoadType,BOOL isAdd);


//正下载
@property (weak, nonatomic) IBOutlet CSPSelectedButton *downloadingObjectImageEditButton;

- (IBAction)downloadingObjectImageEditButtonClick:(id)sender;


@property (weak, nonatomic) IBOutlet CSPSelectedButton *downloadingWindowImageEditButton;


- (IBAction)downloadingWindowImageEditButtonClick:(id)sender;

//窗口图
@property (weak, nonatomic) IBOutlet UIImageView *downLoadingDefaultImgaeView;

@property (weak, nonatomic) IBOutlet UIView *downLoadingWindownImageBackView;

@property (weak, nonatomic) IBOutlet UILabel *downLoadingWindowImageSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *downLoadingWindowSpeedLabel;

@property (weak, nonatomic) IBOutlet UILabel *downLoadingWindowProportionLabel;

@property (weak, nonatomic) IBOutlet UIButton *downLoadingWindowSelectedButton;

@property (weak, nonatomic) IBOutlet UIProgressView *downLoadingWindowProgressView;

- (IBAction)downLoadingWindowSelectedButtonClick:(id)sender;

//客观图
@property (weak, nonatomic) IBOutlet UIView *downLoadingObjectImageBackView;
@property (weak, nonatomic) IBOutlet UILabel *downLoadingObjectImageSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLoadingObjectSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLoadingObjectProportionLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *downLoadingObjectProgressView;

@property (weak, nonatomic) IBOutlet UIButton *downLoadingObjectSelectedButton;

@property (weak, nonatomic) IBOutlet UILabel *alreadyDownloadWindowImageItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *alreadyDownloadObjectImageItemsLabel;

@property (weak, nonatomic) IBOutlet UILabel *windowImageItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *objectImageItemsLabel;


- (IBAction)downLoadingObjectSelectedButtonClick:(id)sender;

- (void)controlEditButtonStatusIsDisplaydownloadingEdit:(BOOL)isDisplaydownloadingEdit;

- (void)isDownloadingAllSelected:(BOOL)isDownloadingAllSelected;

- (void)isAlreadyDownloadEdit:(BOOL)isAlreadyDownloadEdit;

- (void)isAlreadSelectedAll:(BOOL)isAlreadSelectedAll;

//下载历史
- (void)showCellWithImageHistoryDto:(ImageHistoryDTO *)imageHistoryDto downloadedSelectedWindowImageBlock:(DownloadedSelectedWindowImageBlock)downloadedSelectedWindowImageBlock downloadedSelectedObjectImageBlock:(DownloadedSelectedObjectImageBlock)downloadedSelectedObjectImageBlock;

@end
