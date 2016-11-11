//
//  CSPDownLoadImageCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPDownLoadImageCell.h"
#import "CSPSelectedButton.h"
#import "DownloadLogControl.h"
#import "UIImageView+WebCache.h"
@interface CSPDownLoadImageCell ()
@property (nonatomic, assign)id<NSObject> paramInfoNotification;
@property (nonatomic, assign)id<NSObject> statusInfoNotification;
@end
@implementation CSPDownLoadImageCell


- (void)awakeFromNib {
    // Initialization code
    
    self.paramInfoNotification = [[NSNotificationCenter defaultCenter]addObserverForName:NotificationOfDownloadParamInfo object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        CGFloat convert = 1024.0*1024.0;
        
        DownloadParamInfoNotificationDTO *downloadParamInfoNotification = note.object;
        
        if (self.goodsNo == downloadParamInfoNotification.goodsNo) {
            
            if (downloadParamInfoNotification.figureType == DownloadFigureTypeOfWindow) {
                
                //窗口图
                
                //窗口图文件大小
                self.downLoadingWindowImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",downloadParamInfoNotification.fileContentSize/(CONVERT * CONVERT)];
                
                //窗口图进度条
                self.downLoadingWindowProgressView.progress = downloadParamInfoNotification.progress;
                //窗口图已经下载了多少
                self.downLoadingWindowProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",downloadParamInfoNotification.receivedBytes/convert,downloadParamInfoNotification.fileContentSize/convert];
                //下载速度
                self.downLoadingWindowSpeedLabel.text = [NSString stringWithFormat:@"%.2fkb/s",downloadParamInfoNotification.averageBandwidthUsedPerSecond/1024.0];
                
                //!如果没有下载：总大小、已下载的比例不显示
                if (!downloadParamInfoNotification.fileContentSize) {
                    
                    self.downLoadingWindowImageSizeLabel.text = @"";
                    self.downLoadingWindowProportionLabel.text = @"";
                    
                }
                
                
            }else if (downloadParamInfoNotification.figureType == DownloadFigureTypeOfObjective){
                
                //客观图
                
                //窗口图文件大小
                self.downLoadingObjectImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",downloadParamInfoNotification.fileContentSize/(CONVERT *CONVERT)];
                //窗口图进度条
                self.downLoadingObjectProgressView.progress = downloadParamInfoNotification.progress;
                //窗口图已经下载了多少
                self.downLoadingObjectProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",downloadParamInfoNotification.receivedBytes/convert,downloadParamInfoNotification.fileContentSize/convert];
                
                //下载速度
                self.downLoadingObjectSpeedLabel.text = [NSString stringWithFormat:@"%.2fkb/s",downloadParamInfoNotification.averageBandwidthUsedPerSecond/1024.0];
                
                
                //!如果没有下载：总大小、已下载的比例不显示
                if (!downloadParamInfoNotification.fileContentSize) {
                    
                    self.downLoadingObjectImageSizeLabel.text = @"";
                    self.downLoadingObjectProportionLabel.text = @"";
                    
                }
                
            }
        }
        
    }];
    
    self.statusInfoNotification = [[NSNotificationCenter defaultCenter]addObserverForName:NotificationOfDownloadStatusInfo object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        if ([note.object isKindOfClass:[DownloadStatusInfoNotificationDTO class]]) {
            DownloadStatusInfoNotificationDTO* notification = note.object;
            if ([notification.goodsNo isEqualToString:self.goodsNo]) {
                
                if (notification.newStatus == DownloadItemStatusForPause) {
                   
                    if (notification.figureType ==DownloadFigureTypeOfWindow) {
                        self.downLoadingWindowSelectedButton.selected = YES;
                        
                        //!暂停的时候速度为0
                        self.downLoadingWindowSpeedLabel.text = @"0kb/s";
                        
                    }else if (notification.figureType == DownloadFigureTypeOfObjective){
                        self.downLoadingObjectSelectedButton.selected = YES;
                        
                        //!暂停的时候速度为0
                        self.downLoadingObjectSpeedLabel.text = @"0kb/s";

                        
                    }
                    
                    
                    
                    
                } else if (notification.newStatus == DownloadItemStatusForInQueue ||
                           notification.newStatus == DownloadItemStatusForDownloading) {
                    
                    if (notification.figureType ==DownloadFigureTypeOfWindow) {
                        self.downLoadingWindowSelectedButton.selected = NO;
                        
                    }else if (notification.figureType == DownloadFigureTypeOfObjective){
                        self.downLoadingObjectSelectedButton.selected = NO;

                    }
                }
                
            }
        }

    }];
}

- (IBAction)windowImageSelectedButtonClick:(id)sender {
    
    if (self.viewControllerType == DownloadViewController) {
        
    }else if (self.viewControllerType == DownloadHistoryViewController){
        
        self.downloadedSelectedWindowImageBlock();
        
//        CSPSelectedButton *selectedButton = (CSPSelectedButton *)sender;
//        
//        selectedButton.selected = !selectedButton.selected;
//        
//        self.windowSelectedBlock(self.goodsNo,WindowImage,selectedButton.selected);
    }
}

//再次下载窗口图
- (IBAction)windowImageDownLoadAgain:(id)sender {
    
    //    [self.windowDownloadLogFigure restartDownload];
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要重新下载此窗口图吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
}

//清除
- (IBAction)windowImageDowLoadDelete:(id)sender {
    
    [self.windowDownloadLogFigure resetDownload];
}

- (IBAction)objectImageSelectedButtonClick:(id)sender {
    
    if (self.viewControllerType == DownloadViewController) {
        
    }else if (self.viewControllerType == DownloadHistoryViewController){
        
        self.downloadedSelectedObjectImageBlock();

        
//        CSPSelectedButton *selectedButton = (CSPSelectedButton *)sender;
//        
//        selectedButton.selected = !selectedButton.selected;
//        
//        self.objectSelectedBlock(self.goodsNo,ObjectiveImage,selectedButton.selected);
    }
}

//再次下载客观图
- (IBAction)objectImgaeDownLoadAgain:(id)sender {
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要重新下载此客观图吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
}
//清除
- (IBAction)objectImageDownLoadDelete:(id)sender {
    
    [self.objectiveDownloadLogFigure resetDownload];
}

//正下载
- (IBAction)downLoadingWindowSelectedButtonClick:(id)sender {
    
    //窗口图
    if (self.windowDownloadLogFigure.status == DownloadItemStatusForPause) {
        
        
        //恢复下载
        [self.windowDownloadLogFigure.downloadProcessor resumeProcessor];
        
    }else{
        
        //暂停下载
        [self.windowDownloadLogFigure.downloadProcessor suspendProcessor];
    }
}

- (IBAction)downLoadingObjectSelectedButtonClick:(id)sender {
    
    //客观图
    if (self.objectiveDownloadLogFigure.status == DownloadItemStatusForPause) {
        
        
        //恢复下载
        [self.objectiveDownloadLogFigure.downloadProcessor resumeProcessor];
        
    }else{
        
        //暂停下载
        [self.objectiveDownloadLogFigure.downloadProcessor suspendProcessor];
    }
    
}


#pragma mark-
#pragma mark-DownloadLogItemDelegate
- (void)logItemUpdatedWithProgress:(CGFloat)progress averageBandwidthUsedPerSecond:(unsigned long)averageBandwidthUsedPerSecond receivedBytes:(long long)receivedBytes fileContentSize:(long long)fileContentSize forFigureType:(DownloadFigureType)figureType{
    
    CGFloat convert = 1024.0*1024.0;
    
    if (figureType == DownloadFigureTypeOfWindow) {
        //窗口图
        
        //窗口图文件大小
        self.downLoadingWindowImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",fileContentSize/convert];
        
        //窗口图进度条
        self.downLoadingWindowProgressView.progress = progress;
        
        //窗口图已经下载了多少
        self.downLoadingWindowProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",receivedBytes/convert,fileContentSize/convert];
        
        //下载速度
        self.downLoadingWindowSpeedLabel.text = [NSString stringWithFormat:@"%.2fKB/s",averageBandwidthUsedPerSecond/1024.0];
        
        
    }else if (figureType == DownloadFigureTypeOfObjective){
        //客观图
        
        //窗口图文件大小
        self.downLoadingObjectImageSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",fileContentSize/convert];
        //窗口图进度条
        self.downLoadingObjectProgressView.progress = progress;
        //窗口图已经下载了多少
        self.downLoadingObjectProportionLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",receivedBytes/convert,fileContentSize/convert];
        //下载速度
        self.downLoadingObjectSpeedLabel.text = [NSString stringWithFormat:@"%.2fKB/s",averageBandwidthUsedPerSecond/1024.0];
    }
    
    
}

#pragma mark-编辑删除
- (IBAction)downloadingWindowImageEditButtonClick:(id)sender {
    
}

- (IBAction)downloadingObjectImageEditButtonClick:(id)sender {
    
}

- (void)controlEditButtonStatusIsDisplaydownloadingEdit:(BOOL)isDisplaydownloadingEdit{
    
    if (isDisplaydownloadingEdit) {
        
        self.downLoadingWindowSelectedButton.hidden = YES;
        
        self.downLoadingObjectSelectedButton.hidden = YES;
        
        self.downloadingObjectImageEditButton.hidden = NO;
        
        self.downloadingWindowImageEditButton.hidden = NO;
        
    }else{
        
        self.downLoadingWindowSelectedButton.hidden = NO;
        
        self.downLoadingObjectSelectedButton.hidden = NO;
        
        self.downloadingObjectImageEditButton.hidden = YES;
        
        self.downloadingWindowImageEditButton.hidden = YES;
    }
}


- (void)isDownloadingAllSelected:(BOOL)isDownloadingAllSelected{
    
    if (isDownloadingAllSelected) {
        
        self.downloadingObjectImageEditButton.selected = YES;
        
        self.downloadingWindowImageEditButton.selected = YES;
        
    }else{
        
        self.downloadingObjectImageEditButton.selected = NO;
        
        self.downloadingWindowImageEditButton.selected = NO;
    }
}

//控制编辑按钮
- (void)isAlreadyDownloadEdit:(BOOL)isAlreadyDownloadEdit{
    
    if (isAlreadyDownloadEdit) {
        
        self.downLoadWindowImageRightBackView.hidden = YES;
        
        self.downLoadObjectImageRightBackView.hidden = YES;
        
    }else{
        
        self.downLoadWindowImageRightBackView.hidden = NO;
        
        self.downLoadObjectImageRightBackView.hidden = NO;
    }
    
}

- (void)isAlreadSelectedAll:(BOOL)isAlreadSelectedAll{
    
    if (isAlreadSelectedAll) {
        self.windowImageSelectedButton.selected = YES;
        self.objectImageSelectedButton.selected = YES;
    }else{
        self.windowImageSelectedButton.selected = NO;
        self.objectImageSelectedButton.selected = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self.statusInfoNotification];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self.paramInfoNotification];
}

- (NSString *)calculationPicSize:(CGFloat)picSize{
    
    return [NSString stringWithFormat:@"%.2fMB",picSize / CONVERT];
    
    
    
    
}
/*
 不满足1MB，显示为kb
 不满足1GB，显示mb
 不满足1TB,显示G
 
 fileContentSize 单位:kb
 1T = 1024G
 1G = 1024MB
 1MB = 1024kb
 1kb = 1024b
 
 */
-(NSString *)getPicSize:(long long)fileContentSize{
    
    NSString * sizeStr = @"";
    
    // 1T = 1024G = 1024 * 1024 MB = 1024*1024*1024 kb
    double tbSize = pow(CONVERT, 3);//!转换成kb
    double gbSize = pow(CONVERT, 2);
    double mbSize = CONVERT;
    
    if (fileContentSize>=tbSize) {//!大于T
        
        sizeStr = [NSString stringWithFormat:@"%.2fTB",fileContentSize/tbSize];
        
    }else if (fileContentSize>=gbSize){//!大于GB
        
        sizeStr = [NSString stringWithFormat:@"%.2fGB",fileContentSize/gbSize];
        
    }else if (fileContentSize>=mbSize){
        
        sizeStr = [NSString stringWithFormat:@"%.2fMB",fileContentSize/mbSize];
        
    }else{
    
        CGFloat size = fileContentSize;
        
        sizeStr = [NSString stringWithFormat:@"%.2fkb",size];

    }
    
    
    return sizeStr;
    
}


#pragma mark-再次下载
- (void)showCellWithImageHistoryDto:(ImageHistoryDTO *)imageHistoryDto downloadedSelectedWindowImageBlock:(DownloadedSelectedWindowImageBlock)downloadedSelectedWindowImageBlock downloadedSelectedObjectImageBlock:(DownloadedSelectedObjectImageBlock)downloadedSelectedObjectImageBlock{
    
    //历史下载用不到-隐藏掉
    self.downLoadWindowImageRightBackView.hidden = YES;
    self.downLoadObjectImageRightBackView.hidden = YES;
    
    self.downLoadWindowImageBackView.hidden = YES;
    
    self.downLoadObjectImageBackView.hidden = YES;
    
    //image
    [self.windowDefaultImgaeView sd_setImageWithURL:[NSURL URLWithString:imageHistoryDto.picUrl] placeholderImage:[UIImage imageNamed:DOWNLOAD_DEFAULTIMAGE]];
    
    
    for (HistoryPictureDTO2 *historyPictureDto in imageHistoryDto.historyPictureDTOList) {
        
        if (historyPictureDto.picType.integerValue == 0) {
            
            //窗口图
            self.downLoadWindowImageBackView.hidden = NO;
            
            //filesize
//            self.windowImageSizeLabel.text = [self calculationPicSize:historyPictureDto.picSize.floatValue];
            
            self.windowImageSizeLabel.text = [self getPicSize:historyPictureDto.picSize.floatValue];
            

            //picNum
            self.alreadyDownloadWindowImageItemsLabel.text = [NSString stringWithFormat:@"窗口图(%ld张)",(long)historyPictureDto.picNum.integerValue];
            
            
        }else if(historyPictureDto.picType.integerValue == 1){
            //客观图
            
            self.downLoadObjectImageBackView.hidden = NO;
            
            //filesize
//            self.objectImageSizeLabel.text = [self calculationPicSize:historyPictureDto.picSize.floatValue];
            
            self.objectImageSizeLabel.text = [self getPicSize:historyPictureDto.picSize.floatValue];

            
            //picNum
            self.alreadyDownloadObjectImageItemsLabel.text = [NSString stringWithFormat:@"客观图(%ld张)",(long)historyPictureDto.picNum.integerValue];
            
            
        }
        
        if (self.downLoadWindowImageBackView.hidden) {
            //如果客观图没有下载,那么移动客观图的位置
            self.downLoadObjectImageBackViewTopConstraint.constant = 15.0f;
        }else{
            self.downLoadObjectImageBackViewTopConstraint.constant = 40.0f;
        }
    }
    
    self.downloadedSelectedObjectImageBlock = downloadedSelectedObjectImageBlock;
    self.downloadedSelectedWindowImageBlock = downloadedSelectedWindowImageBlock;
}



@end
