//
//  DownloadLogControl.m
//  ImageDownloadDemo
//
//  Created by skyxfire on 9/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "DownloadLogControl.h"
#import "MHImageDownloadManager.h"
#import "LoginDTO.h"
#import "HttpManager.h"

static const NSString *windowPicSize = @"windowPicSize";
static const NSString *objectivePicSize = @"objectivePicSize";
static const NSString *windowFinishDateStr = @"windowFinishDate";
static const NSString *objectiveFinishDateStr = @"objectiveFinishDateStr";



static const NSString* goodsNoKeyValue = @"GoodsNo";
static const NSString* goodsPictureUrlKeyValue = @"GoodsPictureUrl";
static const NSString* windowFigureUrlKeyValue = @"WindowFigureURL";
static const NSString* objectiveFigureUrlKeyValue = @"ObjectiveFigureURL";
static const NSString* windowFigureStateKeyValue = @"WindowFigureStatus";
static const NSString* objectiveFigureStateKeyValue = @"ObjectiveFigureStatus";
static const NSString* windowFigureProgressKeyValue = @"WindowFigureProgress";
static const NSString* objectiveFigureProgressKeyValue = @"ObjectiveFigureProgress";
static const NSString* windowFigureFileContentSizeKeyValue = @"WindowFigureFileContentSize";
static const NSString* objectiveFigureFileContentSizeKeyValue = @"ObjectiveFigureFileContentSize";
static const NSString* windowFigureReceivedBytesKeyValue = @"WindowFigureReceivedBytes";
static const NSString* objectiveFigureReceivedBytesKeyValue = @"ObjectiveFigureReceivedBytes";
static const NSString* windowFigureItemsKeyValue = @"WindowFigureItemsKeyValue";
static const NSString* objectiveFigureItemsKeyValue = @"ObjectiveFigureItemsKeyValue";
static const CGFloat criticalChangedValueForProgress = 0.05f;

static NSString* const plistFileName = @"downloadLog.plist";



NSString* const NotificationOfDownloadParamInfo = @"Notification_Of_Download_Param_Info";
NSString* const NotificationOfDownloadStatusInfo = @"Notification_Of_Download_Status_Info";

NSString *const NotificationOfDownloadStop = @"StopDownAnimation";


@implementation DownloadParamInfoNotificationDTO

@end

@implementation DownloadStatusInfoNotificationDTO

- (BOOL)changeToDownloading {
    if (self.lastStatus == DownloadItemStatusForIdle &&
        (self.newStatus == DownloadItemStatusForInQueue ||
         self.newStatus == DownloadItemStatusForDownloading ||
         self.newStatus == DownloadItemStatusForPause)) {
            return YES;
    }

    if (self.lastStatus == DownloadItemStatusForCompleted &&
        (self.newStatus == DownloadItemStatusForInQueue ||
         self.newStatus == DownloadItemStatusForDownloading ||
         self.newStatus == DownloadItemStatusForPause)) {
        return YES;
    }

    return NO;
}

- (BOOL)changeToCompelete {
    if (self.lastStatus != DownloadItemStatusForCompleted &&
        self.newStatus == DownloadItemStatusForCompleted) {
        return YES;
    }

    return NO;
}

- (BOOL)clear{
    if (self.lastStatus != DownloadItemStatusForIdle &&
        self.newStatus == DownloadItemStatusForIdle) {
        return YES;
    }
    return NO;
}

@end



@protocol DownloadLogFigureDelegate <NSObject>

- (void)logItemUpdated;

- (void)logFigureDownloadedForFigureType:(DownloadFigureType)figureType;

- (void)logFigureUpdatedWithProgress:(CGFloat)progress averageBandwidthUsedPerSecond:(unsigned long)averageBandwidthUsedPerSecond receivedBytes:(long long)receivedBytes fileContentSize:(long long)fileContentSize figureType:(DownloadFigureType)figureType;

@end

@interface DownloadLogFigure () <MHImageDownloadProcessorDelegate>

@property (nonatomic, assign)id<DownloadLogFigureDelegate> delegate;
//@property (nonatomic, strong)NSString* goodsNo;

@end

@implementation DownloadLogFigure

- (id)initWithFigureType:(DownloadFigureType)figureType url:(NSString*)url delegate:(id<DownloadLogFigureDelegate>)delegate {
    self = [super init];
    if (self) {
        self.type = figureType;
        self.delegate = delegate;
        self.imageItems = @"";
        [self initiate];
        [self setupWithUrl:url];
    }

    return self;
}

- (id)initWithFigureType:(DownloadFigureType)figureType logInfo:(NSDictionary*)logInfo delegate:(id<DownloadLogFigureDelegate>)delegate {
    
    self = [super init];
    if (self) {
        self.type = figureType;
        self.delegate = nil;
        self.delegate = delegate;
        self.imageItems = @"";
        [self initiate];
        [self setupWithLogInfo:logInfo];
    }

    return self;
    
}

// 下载信息重置.当重新下载,主动调用该方法,已防止下载任务处于队列中而导致的数据暂时不更新.
- (void)resetTransmissionInfo {
    
    self.averageBandwidthUsedPerSecond = 0;
    self.receivedBytes = 0;
    self.progress = 0;

    if (self.delegate && [self.delegate respondsToSelector:@selector(logFigureUpdatedWithProgress:averageBandwidthUsedPerSecond:receivedBytes:fileContentSize:figureType:)]) {
        
        [self.delegate logFigureUpdatedWithProgress:self.progress
                      averageBandwidthUsedPerSecond:self.averageBandwidthUsedPerSecond
                                      receivedBytes:self.receivedBytes
                                    fileContentSize:self.fileContentSize
                                         figureType:self.type];
        
    }
    
    
}

- (void)initiate {
    self.url = @"";
    self.downloadProcessor = nil;
    self.status = DownloadItemStatusForIdle;
    self.selected = NO;
    // reset的同时,重置文件大小,如果只是重新下载,不清楚文件大小
    self.fileContentSize = 0;
    [self resetTransmissionInfo];
}

- (void)setupWithUrl:(NSString*)url {

    [self downloadFigureWithUrl:url];
}

- (void)setupWithLogInfo:(NSDictionary*)logInfo {

    self.goodsNo = [logInfo objectForKey:goodsNoKeyValue];

    // 根据保存的字典,初始化窗口图和客观图对应的URL,下载状态,文件大小,进度,已下载大小

    if (self.type == DownloadFigureTypeOfObjective) {
        self.url = [logInfo objectForKey:objectiveFigureUrlKeyValue];
        self.status = [[logInfo objectForKey:objectiveFigureStateKeyValue]integerValue];
        
        self.fileContentSize = [[logInfo objectForKey:objectiveFigureFileContentSizeKeyValue]longLongValue];
        
        self.progress = [[logInfo objectForKey:objectiveFigureProgressKeyValue]floatValue];
        self.receivedBytes = [[logInfo objectForKey:objectiveFigureReceivedBytesKeyValue]longLongValue];
        self.imageItems = [logInfo objectForKey:objectiveFigureItemsKeyValue];
//        //!下载完成时间
//        if (logInfo[objectiveFinishDateStr]) {
//            
//            self.finshDate = logInfo[objectiveFinishDateStr];
//
//        }

        
    } else {
        self.url = [logInfo objectForKey:windowFigureUrlKeyValue];
        self.status = [[logInfo objectForKey:windowFigureStateKeyValue]integerValue];
        
        self.fileContentSize = [[logInfo objectForKey:windowFigureFileContentSizeKeyValue]longLongValue];
        
        
        self.progress = [[logInfo objectForKey:windowFigureProgressKeyValue]floatValue];
        self.receivedBytes = [[logInfo objectForKey:windowFigureReceivedBytesKeyValue]longLongValue];
        self.imageItems = [logInfo objectForKey:windowFigureItemsKeyValue];
        
//        //!下载完成时间
//        if (logInfo[windowFinishDateStr]) {
//            
//            self.finshDate = logInfo[windowFinishDateStr];
//
//        }

    }
    
    
    NSLog(@"下载进度更新 < %@ > < %ld > ||  进度: %.02f  ||  下载速度: 0  ||  %llu / %llu ||",
          self.goodsNo, (long)self.type, self.progress, self.receivedBytes, self.fileContentSize);

    if (self.url && self.url.length > 0) {
        if (self.status == DownloadItemStatusForInQueue ||
            self.status == DownloadItemStatusForDownloading) {

            self.downloadProcessor = [[MHImageDownloadManager sharedInstance] fetchProcessorWithUrl:self.url downloadImmediately:YES neededState:DownloadProcessorStateOfInit];
            
            [self.downloadProcessor addUISessionDownloadProcessorDelegate:self];

        } else if (self.status == DownloadItemStatusForPause ||
                   self.status == DownloadItemStatusForFailed) {

            self.downloadProcessor = [[MHImageDownloadManager sharedInstance] fetchProcessorWithUrl:self.url downloadImmediately:NO neededState:DownloadProcessorStateOfStopped];
            [self.downloadProcessor addUISessionDownloadProcessorDelegate:self];

        } else if (self.status == DownloadItemStatusForCompleted) {
            
            self.downloadProcessor = [[MHImageDownloadManager sharedInstance] fetchProcessorWithUrl:self.url downloadImmediately:NO neededState:DownloadProcessorStateOfFinished];
            [self.downloadProcessor addUISessionDownloadProcessorDelegate:self];

        }

        
    } else {
        NSLog(@"");
    }
}

- (void)clearDownloadLogFigureInfo {

    if (self.downloadProcessor) {
        [self.downloadProcessor resetProcessor];
        [self.downloadProcessor clearUISessionDownloadProcessorDelegates];
        [[MHImageDownloadManager sharedInstance] removeProcessorByUrl:self.url];
    }

    [self initiate];
}


- (void)resetDownload{
    [self clearDownloadLogFigureInfo];
}

- (void)updateStatusByProcessorState:(DownloadProcessorState)processorState {
    switch (processorState) {
        case DownloadProcessorStateOfInit:
            self.status = DownloadItemStatusForIdle;
            break;
        case DownloadProcessorStateOfInQueue:
            self.status = DownloadItemStatusForInQueue;
            break;
        case DownloadProcessorStateOfStarted:
            self.status = DownloadItemStatusForDownloading;
            break;
        case DownloadProcessorStateOfStopped:
            self.status = DownloadItemStatusForPause;
            break;
        case DownloadProcessorStateOfDownloaded:
            self.status = DownloadItemStatusForDownloading;
            break;
        case DownloadProcessorStateOfZipped:
            self.status = DownloadItemStatusForDownloading;
            break;
        case DownloadProcessorStateOfFinished:
            self.status = DownloadItemStatusForCompleted;
            break;
        case DownloadProcessorStateOfConnectionTimeout:
        case DownloadProcessorStateOfZipFailed:
            self.status = DownloadItemStatusForFailed;
            break;
        default:
            break;
    }
}

- (NSString*)convertStatusToString:(DownloadItemStatus)status {
    NSString* description = nil;
    switch (status) {
        case DownloadItemStatusForIdle:
            description = @"Idle";
            break;
        case DownloadItemStatusForInQueue:
            description = @"InQueue";
            break;
        case DownloadItemStatusForDownloading:
            description = @"Downloading";
            break;
        case DownloadItemStatusForPause:
            description = @"Pause";
            break;
        case DownloadItemStatusForCompleted:
            description = @"Completed";
            break;
        case DownloadItemStatusForFailed:
            description = @"Failed";
            break;
        default:
            break;
    }

    return description;
}

- (void)setImageItems:(NSString *)imageItems {
    _imageItems = (imageItems == nil ? @"" : imageItems);
}

- (void)setStatus:(DownloadItemStatus)status {

    DownloadItemStatus lastStatus = _status;

    if (self.goodsNo) {
        
        DebugLog(@"下载状态更新 < %@ > < %ld > ||  %@ ====> %@", self.goodsNo, (long)self.type, [self convertStatusToString:self.status], [self convertStatusToString:status]);
    }

    _status = status;

    DownloadStatusInfoNotificationDTO* notification = [[DownloadStatusInfoNotificationDTO alloc]init];
    notification.goodsNo = self.goodsNo;
    notification.lastStatus = lastStatus;
    notification.newStatus = _status;
    notification.figureType = self.type;

    //!如果状态是完成了，则记录下载完成的时间
    if ([notification changeToCompelete]) {
        
//        self.finshDate = [NSDate date];
//       
//        DebugLog(@"self.finshDate:%@", self.finshDate);
        
    }
    
    DebugLog(@"===>PostNotificationOfDownloadStatusInfo<===");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOfDownloadStatusInfo object:notification];
    
    
    
}

- (void)downloadFigureWithUrl:(NSString*)url figureItems:(NSString*)figureItems {
    if (!url || url.length == 0) {
        return;
    }
    
    self.imageItems = figureItems;

    [self downloadFigureWithUrl:url];
}

- (void)downloadFigureWithUrl:(NSString*)url {
    if (!url || url.length == 0) {
        return;
    }
    
    if (!self.url || self.url.length == 0) {
        self.url = url;
        self.status = DownloadItemStatusForIdle;
    } else {
        if ([self.url isEqualToString:url]) {
            // Do nothing
        } else {
            [self clearDownloadLogFigureInfo];
        }
    }
    
    if (!self.downloadProcessor) {
        self.downloadProcessor = [[MHImageDownloadManager sharedInstance] fetchProcessorWithUrl:self.url downloadImmediately:YES neededState:DownloadProcessorStateOfInit];
        [self.downloadProcessor addUISessionDownloadProcessorDelegate:self];
        self.status = DownloadItemStatusForInQueue;
    }
    
    [self changeDownloadStateForCommand];


}



- (void)changeDownloadStateForCommand {
    switch (self.status) {
        case DownloadItemStatusForIdle:
            break;
        case DownloadItemStatusForInQueue:
            //Do nothing
            break;
        case DownloadItemStatusForDownloading:
            //Do nothing
            break;
        case DownloadItemStatusForPause:
            [self resumeDownload];
            break;
        case DownloadItemStatusForCompleted:
            [self restartDownload];
            break;
        case DownloadItemStatusForFailed:
            [self restartDownload];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)isDownloading {
    return (self.status == DownloadItemStatusForDownloading ||
            self.status == DownloadItemStatusForInQueue ||
            self.status == DownloadItemStatusForPause);
}

- (BOOL)isDownloadedOrIdle {
    return (self.status == DownloadItemStatusForCompleted ||
            self.status == DownloadItemStatusForIdle);
}

- (BOOL)isDownloaded {
    return (self.status == DownloadItemStatusForCompleted);
}

- (void)restartDownload {
    
    //!再次下载的时候，添加加入的时间
    self.addDate = [self getTimesTamp];

    
    if (self.downloadProcessor) {
        
        [self resetTransmissionInfo];
        [self.downloadProcessor restartProcessor];
        
    } else {
        
        [self downloadFigureWithUrl:self.url];
        
    }
    
    
    
}
/**
 *  获取当前时间戳
 *
 *  @return 返回当前时间戳
 */
- (NSDate *)getTimesTamp{
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    
    //    return [dateFormatter stringFromDate:nowDate];
    
    NSString * timeStr = [dateFormatter stringFromDate:nowDate];
    
    NSDate *getDate = [dateFormatter dateFromString:timeStr];
    
    
    return getDate;
}

- (void)resumeDownload {
    if (self.downloadProcessor) {
        [self.downloadProcessor resumeProcessor];
    } else {
        [self downloadFigureWithUrl:self.url];
    }
}

- (void)suspendDownload {
    if (self.downloadProcessor) {
        [self.downloadProcessor suspendProcessor];
    } else {

    }
}

#pragma mark -
#pragma mark MHImageDownloadProcessorDelegate

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor updatedProcess:(CGFloat)process averageBandwidthUsedPerSecond:(unsigned long)averageBandwidthUsedPerSecond {
    
    if (downloadProcessor == self.downloadProcessor) {
        if (ABS(process - self.progress) >= criticalChangedValueForProgress || process == 1.0) {
            self.progress = process;
            if (self.delegate && [self.delegate respondsToSelector:@selector(logItemUpdated)]) {
                [self.delegate logItemUpdated];
            }
        }

        self.averageBandwidthUsedPerSecond = averageBandwidthUsedPerSecond;

        self.fileContentSize = downloadProcessor.fileContentSize;
        self.receivedBytes = (unsigned long)(self.fileContentSize * process);

        if (self.delegate && [self.delegate respondsToSelector:@selector(logFigureUpdatedWithProgress:averageBandwidthUsedPerSecond:receivedBytes:fileContentSize:figureType:)]) {
            
            [self.delegate logFigureUpdatedWithProgress:process
                          averageBandwidthUsedPerSecond:averageBandwidthUsedPerSecond
                                          receivedBytes:self.receivedBytes
                                        fileContentSize:self.fileContentSize
                                             figureType:self.type];
            
        }
    }
}

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor processorStateChanged:(DownloadProcessorState)processorState {

    if (processorState == DownloadProcessorStateOfZipFailed ||
        processorState == DownloadProcessorStateOfZipped ||
        processorState == DownloadProcessorStateOfConnectionTimeout) {
        return;
    }

    if (downloadProcessor == self.downloadProcessor) {
        [self updateStatusByProcessorState:processorState];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(logItemUpdated)]) {
        
        [self.delegate logItemUpdated];
        
    }

    

}

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor finishProcessor:(BOOL)isFinished {
    
    
    if (downloadProcessor == self.downloadProcessor ) {
        //TODO: 修正发送完成接口调用
        
        if (downloadProcessor == self.downloadProcessor ) {
            
            DebugLog(@"告诉服务器下载完毕了！！！！！！！！！！！！！！！！！！！！！！！");
            
            //!告诉服务器下载完毕
            [self requestForDownloadComplete];
            
//            [HttpManager sendHttpRequestForDownloadCompleteWithGoodsNo:self.goodsNo picType:[NSString stringWithFormat:@"%ld",(long)self.type] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//                
//                if ([[responseDic objectForKey:CODE]isEqualToString:@"000"]) {
//                    
//                    //通知刷新
//                    [[NSNotificationCenter defaultCenter]postNotificationName:(NSString *)K_NOTICE_RELOADDOWNLOADCOUNT object:nil userInfo:nil];
//                    
//                    
//                }
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(logFigureDownloadedForFigureType:)]) {
            [self.delegate logFigureDownloadedForFigureType:self.type];
            }
        }
    }
    
    
}

//!告诉服务器下载完毕
-(void)requestForDownloadComplete{

    DebugLog(@"self.goodsNo:%@,(long)self.type:%ld",self.goodsNo,(long)self.type);
    
   
    [HttpManager sendHttpRequestForDownloadCompleteWithGoodsNo:self.goodsNo picType:[NSString stringWithFormat:@"%ld",(long)self.type] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[responseDic objectForKey:CODE]isEqualToString:@"000"]) {
            
            //通知刷新
            [[NSNotificationCenter defaultCenter]postNotificationName:(NSString *)K_NOTICE_RELOADDOWNLOADCOUNT object:nil userInfo:nil];
            
        }else{
            
            //!请求失败，再次请求
            [self requestForDownloadComplete];
            DebugLog(@"告诉服务器下载完毕失败");

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //!请求失败，再次请求
        [self requestForDownloadComplete];
        DebugLog(@"告诉服务器下载完毕失败");

    }];
    

}

@end

@protocol DownloadLogItemControlDelegate <NSObject>

- (void)logItemUpdated;
- (void)logItemDownloadedWithGoodsNo:(NSString*)goodsNo figureType:(DownloadFigureType)figureType;

@end


#pragma mark -
#pragma mark DownloadLogItem


@interface DownloadLogItem () <DownloadLogFigureDelegate>

@property (nonatomic, assign)id<DownloadLogItemControlDelegate> logControlDelegate;

@end



@implementation DownloadLogItem

- (id)initWithGoodsNo:(NSString*)goodsNo objectiveFigureUrl:(NSString*)objectiveFigureUrl objectiveFigureItems:(NSString*)objectiveFigureItems windowFigureUrl:(NSString*)windowFigureUrl windowFigureItems:(NSString*)windowFigureItems pictureUrl:(NSString*)pictureUrl {
    self = [super init];
    if (self) {
        self.goodsNo = goodsNo;
        self.pictureUrl = pictureUrl;

        [self updateLogItemInfoByObjectiveFigureUrl:objectiveFigureUrl objectiveFigureItems:objectiveFigureItems windowFigureUrl:windowFigureUrl windowFigureItems:windowFigureItems];
    }

    return self;
}
//!lyt 增加了图片大小

- (id)initWithGoodsNo:(NSString*)goodsNo objectiveFigureUrl:(NSString*)objectiveFigureUrl objectiveFigureItems:(NSString*)objectiveFigureItems windowFigureUrl:(NSString*)windowFigureUrl windowFigureItems:(NSString*)windowFigureItems pictureUrl:(NSString*)pictureUrl withWindowPicSize:(NSNumber *)windowPicSize withObjectivePicSize:(NSNumber *)objectivePicSize{
    
    self = [super init];
    if (self) {
        self.goodsNo = goodsNo;
        self.pictureUrl = pictureUrl;
        
        //!图片大小
        self.windowPicSize = windowPicSize;
        self.objectivePicSize = objectivePicSize;
        
        [self updateLogItemInfoByObjectiveFigureUrl:objectiveFigureUrl objectiveFigureItems:objectiveFigureItems windowFigureUrl:windowFigureUrl windowFigureItems:windowFigureItems];
    }
    
    return self;
}



- (id)initWithLogInfo:(NSDictionary*)logInfo {
    self = [super init];
    if (self) {
        self.goodsNo = [logInfo objectForKey:goodsNoKeyValue];
        self.pictureUrl = [logInfo objectForKey:goodsPictureUrlKeyValue];
        
        if ([logInfo objectForKey:windowFigureUrlKeyValue]) {
            self.windowFigure = [[DownloadLogFigure alloc]initWithFigureType:DownloadFigureTypeOfWindow logInfo:logInfo delegate:self];
        }
        
        if ([logInfo objectForKey:objectiveFigureUrlKeyValue]) {
            
            self.objectiveFigure = [[DownloadLogFigure alloc]initWithFigureType:DownloadFigureTypeOfObjective logInfo:logInfo delegate:self];
            
        }
        
        
        //!窗口图大小
        if (logInfo[windowPicSize]) {
            
            self.windowPicSize = logInfo[windowPicSize];
        
        }
        
        //!客观图大小
        if (logInfo[objectivePicSize]) {
            
            self.objectivePicSize = logInfo[objectivePicSize];
            
        }
        
    }

    return self;
    
}

- (NSDictionary*)convertToDictonaryForSavingAsPlist {
    
    NSMutableDictionary* logItemInfo = [NSMutableDictionary dictionary];

    [logItemInfo setObject:self.goodsNo forKey:goodsNoKeyValue];
    [logItemInfo setObject:self.pictureUrl forKey:goodsPictureUrlKeyValue];
    
    //!窗口图 客观图
    if ([self.windowPicSize floatValue]) {
        
        [logItemInfo setObject:self.windowPicSize forKey:windowPicSize];
    }
    
    if ([self.objectivePicSize floatValue]) {
        
        [logItemInfo setObject:self.objectivePicSize forKey:objectivePicSize];
        
    }
    
    
    if (self.objectiveFigure && self.objectiveFigure.url.length > 0) {
        
        [logItemInfo setObject:self.objectiveFigure.url forKey:objectiveFigureUrlKeyValue];
        
        [logItemInfo setObject:[NSNumber numberWithInteger:self.objectiveFigure.status] forKey:objectiveFigureStateKeyValue];
        
        [logItemInfo setObject:[NSNumber numberWithFloat:self.objectiveFigure.progress] forKey:objectiveFigureProgressKeyValue];
        
        [logItemInfo setObject:[NSNumber numberWithLongLong:self.objectiveFigure.fileContentSize] forKey:objectiveFigureFileContentSizeKeyValue];
        
        [logItemInfo setObject:[NSNumber numberWithLongLong:self.objectiveFigure.receivedBytes] forKey:objectiveFigureReceivedBytesKeyValue];
        
        [logItemInfo setObject:self.objectiveFigure.imageItems forKey:objectiveFigureItemsKeyValue];
        
        self.objectiveFigure.finshDate = [NSDate date];
        
        if (self.objectiveFigure.status == DownloadItemStatusForCompleted && self.objectiveFigure.finshDate) {
            
            [logItemInfo setObject:self.objectiveFigure.finshDate forKey:objectiveFinishDateStr];

        }
        

    }
    
    if (self.windowFigure && self.windowFigure.url.length > 0) {
        
        [logItemInfo setObject:self.windowFigure.url forKey:windowFigureUrlKeyValue];
        [logItemInfo setObject:[NSNumber numberWithInteger:self.windowFigure.status] forKey:windowFigureStateKeyValue];
        [logItemInfo setObject:[NSNumber numberWithFloat:self.windowFigure.progress] forKey:windowFigureProgressKeyValue];
        [logItemInfo setObject:[NSNumber numberWithFloat:self.windowFigure.fileContentSize] forKey:windowFigureFileContentSizeKeyValue];
        
        [logItemInfo setObject:[NSNumber numberWithLongLong:self.windowFigure.receivedBytes] forKey:windowFigureReceivedBytesKeyValue];
        
        [logItemInfo setObject:self.windowFigure.imageItems forKey:windowFigureItemsKeyValue];
        
        self.windowFigure.finshDate = [NSDate date];

        //!下载完成时间
        if (self.windowFigure.status == DownloadItemStatusForCompleted && self.windowFigure.finshDate) {
            
            [logItemInfo setObject:self.windowFigure.finshDate forKey:windowFinishDateStr];
        }
        
    }
    return logItemInfo;
}

- (void)clearObjectiveFigureInfo {

    [self.objectiveFigure clearDownloadLogFigureInfo];

    if (self.logControlDelegate && [self.logControlDelegate respondsToSelector:@selector(logItemUpdated)]) {
        [self.logControlDelegate logItemUpdated];
    }
}


- (void)clearWindowFigureInfo {

    [self.windowFigure clearDownloadLogFigureInfo];

    if (self.logControlDelegate && [self.logControlDelegate respondsToSelector:@selector(logItemUpdated)]) {
        [self.logControlDelegate logItemUpdated];
    }
}

- (void)updateLogItemInfoByObjectiveFigureUrl:(NSString*)objectiveFigureUrl objectiveFigureItems:(NSString*)objectiveFigureItems windowFigureUrl:(NSString*)windowFigureUrl windowFigureItems:(NSString*)windowFigureItems {

    
    if (self.windowFigure) {
        [self.windowFigure downloadFigureWithUrl:windowFigureUrl figureItems:windowFigureItems];
    } else {
        self.windowFigure = [[DownloadLogFigure alloc]initWithFigureType:DownloadFigureTypeOfWindow url:windowFigureUrl delegate:self];
        self.windowFigure.goodsNo = self.goodsNo;
        self.windowFigure.imageItems = windowFigureItems;
    }
    
    
    if (self.objectiveFigure) {
        [self.objectiveFigure downloadFigureWithUrl:objectiveFigureUrl figureItems:objectiveFigureItems];
    } else {
        self.objectiveFigure = [[DownloadLogFigure alloc]initWithFigureType:DownloadFigureTypeOfObjective url:objectiveFigureUrl delegate:self];
        self.objectiveFigure.goodsNo = self.goodsNo;
        self.objectiveFigure.imageItems = objectiveFigureItems;
    }

    //!添加加入的时间戳
    self.windowFigure.addDate = [self getTimesTamp];
    self.objectiveFigure.addDate = [self getTimesTamp];
    
}
/**
 *  获取当前时间戳
 *
 *  @return 返回当前时间戳
 */
- (NSDate *)getTimesTamp{
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    
    //    return [dateFormatter stringFromDate:nowDate];
    
    NSString * timeStr = [dateFormatter stringFromDate:nowDate];
    
    NSDate *getDate = [dateFormatter dateFromString:timeStr];
    
    
    return getDate;
}

- (BOOL)isExistDownloadingFigure {
    
    if ([self isDownloadingFigureType:DownloadFigureTypeOfWindow]) {
        return YES;
    }

    if ([self isDownloadingFigureType:DownloadFigureTypeOfObjective]) {
        return YES;
    }

    return NO;
}

- (BOOL)isExistDownloadedFigure {
    if ([self.windowFigure isDownloaded] || [self.objectiveFigure isDownloaded]) {
        return YES;
    }

    return NO;
}

- (BOOL)isAllFigureDownloaded {
    if ([self.windowFigure isDownloadedOrIdle] && [self.objectiveFigure isDownloadedOrIdle] &&
        ([self.windowFigure isDownloaded] || [self.objectiveFigure isDownloaded])) {
        return YES;
    }

    return NO;
}

- (BOOL)isDownloadingFigureType:(DownloadFigureType)figureType {
    if (figureType == DownloadFigureTypeOfObjective) {
        return [self.objectiveFigure isDownloading];
    } else if (figureType == DownloadFigureTypeOfWindow) {
        return [self.windowFigure isDownloading];
    }

    return NO;
}

- (BOOL)isObjectiveFigureByDownloadProcessor:(MHImageDownloadProcessor*)downloadProcessor {
    if (self.objectiveFigure && self.objectiveFigure.downloadProcessor &&
        (self.objectiveFigure.downloadProcessor == downloadProcessor)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isWindowFigureByDownloadProcessor:(MHImageDownloadProcessor*)downloadProcessor {
    if (self.windowFigure && self.windowFigure.downloadProcessor &&
        (self.windowFigure.downloadProcessor == downloadProcessor)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)clearDownloadingInfoIfSelected {
    if (self.objectiveFigure.isSelected && [self.objectiveFigure isDownloading]) {
        [self clearObjectiveFigureInfo];
    }

    if (self.windowFigure.isSelected && [self.windowFigure isDownloading]) {
        [self clearWindowFigureInfo];
    }
}

- (void)clearDownloadedInfoIfSelected {
    if (self.objectiveFigure.isSelected && [self.objectiveFigure isDownloaded]) {
        [self clearObjectiveFigureInfo];
    }

    if (self.windowFigure.isSelected && [self.windowFigure isDownloaded]) {
        [self clearWindowFigureInfo];
    }
}

- (void)restartDownloadedProcessorIfSelected {
    

    if (self.windowFigure.isSelected && [self.windowFigure isDownloaded]) {

        [self.windowFigure restartDownload];
        
        self.windowFigure.selected = NO;


    }
    
    if (self.objectiveFigure.isSelected && [self.objectiveFigure isDownloaded]) {
        
        
        [self.objectiveFigure restartDownload];
        
        self.objectiveFigure.selected = NO;
        
    }
    
    
}

- (void)resetSelectedState {
    if (self.objectiveFigure) {
        self.objectiveFigure.selected = NO;
    }

    if (self.windowFigure) {
        self.windowFigure.selected = NO;
    }
}

- (void)setGoodsNo:(NSString *)goodsNo {
    if (!goodsNo) {
        _goodsNo = @"";
    } else {
        _goodsNo = goodsNo;
    }
}

- (void)setPictureUrl:(NSString *)pictureUrl {
    if (!pictureUrl) {
        _pictureUrl = @"";
    } else {
        _pictureUrl = pictureUrl;
    }
}

#pragma mark -
#pragma mark Public Methods

// 根据图片类型,恢复窗口图或客观图的下载
- (void)resumeDownloadWithFigureType:(DownloadFigureType)figureType {
    if (figureType == DownloadFigureTypeOfObjective) {
        [self.objectiveFigure resumeDownload];
    } else {
        [self.windowFigure resumeDownload];
    }
}

// 根据图片类型,暂停窗口图或客观图的下载
- (void)suspendDownloadWithFigureType:(DownloadFigureType)figureType {
    if (figureType == DownloadFigureTypeOfObjective) {
        [self.objectiveFigure suspendDownload];
    } else {
        [self.windowFigure suspendDownload];
    }
}

// 根据图片类型,重新下载客观图或窗口图
- (void)restartDownloadWithFigureType:(DownloadFigureType)figureType {
    if (figureType == DownloadFigureTypeOfObjective) {
        [self.objectiveFigure restartDownload];
    } else {
        [self.windowFigure restartDownload];
    }

}

- (void)resetDownloadWithFigureType:(DownloadFigureType)figureType {
    if (figureType == DownloadFigureTypeOfObjective) {
        [self.objectiveFigure clearDownloadLogFigureInfo];
    } else {
        [self.windowFigure clearDownloadLogFigureInfo];
    }
}



#pragma mark - 
#pragma mark DownloadLogFigureDelegate

- (void)logItemUpdated {
    if (self.logControlDelegate && [self.logControlDelegate respondsToSelector:@selector(logItemUpdated)]) {
        [self.logControlDelegate logItemUpdated];
    }
}

- (void)logFigureDownloadedForFigureType:(DownloadFigureType)figureType {
    if (self.logControlDelegate && [self.logControlDelegate respondsToSelector:@selector(logItemDownloadedWithGoodsNo:figureType:)]) {
        [self.logControlDelegate logItemDownloadedWithGoodsNo:self.goodsNo figureType:figureType];
    }
}

- (void)logFigureUpdatedWithProgress:(CGFloat)progress averageBandwidthUsedPerSecond:(unsigned long)averageBandwidthUsedPerSecond receivedBytes:(long long)receivedBytes fileContentSize:(long long)fileContentSize figureType:(DownloadFigureType)figureType {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(DownloadLogItemDelegate)] && [self.delegate respondsToSelector:@selector(logItemUpdatedWithProgress:averageBandwidthUsedPerSecond:receivedBytes:fileContentSize:forFigureType:)]) {
        
        [self.delegate logItemUpdatedWithProgress:progress
                    averageBandwidthUsedPerSecond:averageBandwidthUsedPerSecond
                                    receivedBytes:receivedBytes
                                  fileContentSize:fileContentSize
                                    forFigureType:figureType];
    }

    DownloadParamInfoNotificationDTO* notification = [[DownloadParamInfoNotificationDTO alloc]init];
    notification.goodsNo = self.goodsNo;
    notification.progress = progress;
    notification.averageBandwidthUsedPerSecond = averageBandwidthUsedPerSecond;
    notification.receivedBytes = receivedBytes;
    notification.fileContentSize = fileContentSize;
    notification.figureType = figureType;
    

    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOfDownloadParamInfo object:notification];

    NSLog(@"下载进度更新 < %@ > < %ld > ||  进度: %.02f  ||  下载速度: %lu  ||  %llu / %llu ||",
          self.goodsNo, (long)figureType, progress, averageBandwidthUsedPerSecond, receivedBytes, fileContentSize);
    
}

@end



@interface DownloadLogControl () <DownloadLogItemControlDelegate>

@end

@implementation DownloadLogControl

#pragma mark -
#pragma mark Public Methods

+ (DownloadLogControl *)sharedInstance {

    static DownloadLogControl *instance_;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        instance_ = [[DownloadLogControl alloc] init];
    });
    return instance_;
}


- (id)init {
    self = [super init];
    if (self) {
//        [self loadStateFromPlist];
    }

    return self;
}

- (NSArray*)downloadedLogItems {
    NSMutableArray* downloadedList = [NSMutableArray array];
    for (DownloadLogItem* logItem in self.downloadLogList) {
        if ([logItem isExistDownloadedFigure]) {
            [downloadedList addObject:logItem];
        }
    }
    return downloadedList;
}


- (NSArray*)downloadingLogItems {
    
    NSMutableArray* downloadingList = [NSMutableArray array];
    for (DownloadLogItem* logItem in self.downloadLogList) {
       
        if ([logItem isExistDownloadingFigure]) {
            
            [downloadingList addObject:logItem];
            
            
        }
    
    }
    
    //!对正在下载的商品进行排序，按照加入下载队列的时间进行排序
    for (DownloadLogItem * loadingItem in downloadingList) {
        
        //!客观图和窗口图加入的时间进行比较，取最新的那个
        NSDate * windowFigureAddTime = loadingItem.windowFigure.addDate;
        NSDate * objectFigureAddTime = loadingItem.objectiveFigure.addDate;
        
        NSComparisonResult result = [windowFigureAddTime compare:objectFigureAddTime];
        
        switch (result)
        {
                //date02比date01大
            case NSOrderedAscending: loadingItem.maxDate = objectFigureAddTime; break;
                //date02比date01小
            case NSOrderedDescending:  loadingItem.maxDate = windowFigureAddTime; break;
                //date02=date01
            case NSOrderedSame: loadingItem.maxDate = objectFigureAddTime; break;
                
        }
        
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"maxDate" ascending:YES];
    
    [downloadingList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return downloadingList;
}


- (NSInteger)downloadingItems {
    
    NSInteger totoalDownloadingItems = 0;
    NSArray* downloadingLogItems = [self downloadingLogItems];
    
    for (DownloadLogItem* logItem in downloadingLogItems) {
        if ([logItem.windowFigure isDownloading]) {
            totoalDownloadingItems++;
        }
        
        if ([logItem.objectiveFigure isDownloading]) {
            totoalDownloadingItems++;
        }
    }
    
    return totoalDownloadingItems;
}


- (void)addLogItemByGoodsNo:(NSString *)goodsNo objectiveFigureUrl:(NSString *)objectiveFigureUrl objectiveFigureItems:(NSString*)objectiveFigureItems windowFigureUrl:(NSString *)windowFigureUrl windowFigureItems:(NSString*)windowFigureItems pictureUrl:(NSString *)pictureUrl {
    
    for (DownloadLogItem* logItem in self.downloadLogList) {
        
        if ([logItem.goodsNo isEqualToString:goodsNo]) {
            if (!logItem.pictureUrl || logItem.pictureUrl.length == 0) {
                logItem.pictureUrl = pictureUrl;
            }
            //!在此方法里面添加加入的时间戳
            [logItem updateLogItemInfoByObjectiveFigureUrl:objectiveFigureUrl objectiveFigureItems:objectiveFigureItems windowFigureUrl:windowFigureUrl windowFigureItems:windowFigureItems];

            return;
        }
    }

    DownloadLogItem* logItem = [[DownloadLogItem alloc]initWithGoodsNo:goodsNo objectiveFigureUrl:objectiveFigureUrl objectiveFigureItems:objectiveFigureItems windowFigureUrl:windowFigureUrl windowFigureItems:windowFigureItems pictureUrl:pictureUrl];
    logItem.logControlDelegate = self;
    
    [self.downloadLogList addObject:logItem];
    
    
}

//lyt 和上面的方法相比，增加了一个下载图片的大小 用于个人中心 下载页面 读取图片大小
- (void)addLogItemByGoodsNo:(NSString*)goodsNo objectiveFigureUrl:(NSString*)objectiveFigureUrl objectiveFigureItems:(NSString*)objectiveFigureItems windowFigureUrl:(NSString*)windowFigureUrl windowFigureItems:(NSString*)windowFigureItems pictureUrl:(NSString*)pictureUrl withWindowPicSize:(NSNumber *)windowPicSize withObjectivePicSize:(NSNumber *)objectivePicSize{

    for (DownloadLogItem* logItem in self.downloadLogList) {
        
        if ([logItem.goodsNo isEqualToString:goodsNo]) {
            if (!logItem.pictureUrl || logItem.pictureUrl.length == 0) {
                
                logItem.pictureUrl = pictureUrl;
                
            }
            //!窗口图 客观图 大小
            logItem.windowPicSize = windowPicSize;
            logItem.objectivePicSize = objectivePicSize;
            
            [logItem updateLogItemInfoByObjectiveFigureUrl:objectiveFigureUrl objectiveFigureItems:objectiveFigureItems windowFigureUrl:windowFigureUrl windowFigureItems:windowFigureItems];
            
            return;
        }
    }
    //!多传了窗口图 客观图 大小
    DownloadLogItem* logItem = [[DownloadLogItem alloc]initWithGoodsNo:goodsNo objectiveFigureUrl:objectiveFigureUrl objectiveFigureItems:objectiveFigureItems windowFigureUrl:windowFigureUrl windowFigureItems:windowFigureItems pictureUrl:pictureUrl withWindowPicSize:windowPicSize withObjectivePicSize:objectivePicSize];
    
    logItem.logControlDelegate = self;
    
    [self.downloadLogList addObject:logItem];
    
    


}

- (void)removeLogItemByGoodsNo:(NSString*)goodsNo objectiveDownloader:(BOOL)shouldRemoveObjectiveDownloader windowDownloader:(BOOL)shouldRemoveWindowDownloader {
    
    for (DownloadLogItem* logItem in self.downloadLogList) {
        if ([logItem.goodsNo isEqualToString:goodsNo]) {
            if (shouldRemoveObjectiveDownloader) {
                [logItem clearObjectiveFigureInfo];
            }

            if (shouldRemoveObjectiveDownloader) {
                [logItem clearWindowFigureInfo];
            }
        }
    }
}

- (void)resetAllDownloadLogSelectedState {
    for (DownloadLogItem* logItem in self.downloadLogList) {
        [logItem resetSelectedState];
    }
}

- (void)removeAllSelectedDownloadedLogItems {
    for (DownloadLogItem* logItem in self.downloadLogList) {
        [logItem clearDownloadedInfoIfSelected];
    }
}

- (void)removeAllSelectedDownloadingLogItems {
    for (DownloadLogItem* logItem in self.downloadLogList) {
        [logItem clearDownloadingInfoIfSelected];
    }
}

- (void)resetAllDelegates {
    
    
    for (DownloadLogItem* logItem in self.downloadLogList) {
    
        logItem.delegate = nil;
        
    }

    self.delegate = nil;

}

- (void)restartAllSelectedDownloadedLogItems {
    
    for (DownloadLogItem* logItem in self.downloadLogList) {
        [logItem restartDownloadedProcessorIfSelected];
        
    }
}

#pragma mark -
#pragma mark Private Methods

- (NSArray*)convertToDictionariesForSavingAsPlist {
    NSMutableArray* logList = [NSMutableArray array];
    for (DownloadLogItem* logItem in self.downloadLogList) {
        
        [logList addObject:[logItem convertToDictonaryForSavingAsPlist]];
        
    }

    return [NSArray arrayWithArray:logList];
}

- (void)convertFromDictionariesInPlist:(NSArray*)array {

    for (NSDictionary* logInfo in array) {
        
        DownloadLogItem* logItem = [[DownloadLogItem alloc]initWithLogInfo:logInfo];
        
        logItem.logControlDelegate = self;

        [self.downloadLogList addObject:logItem];
        
    }
    
}

- (void)loadStateFromPlist {
    
    [self.downloadLogList removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath1= [paths objectAtIndex:0];

    //得到完整的路径名
    NSString *fileName = [plistPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", [LoginDTO sharedInstance].memberNo, plistFileName]];

    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fileName]) {
        
        NSArray* content = [NSArray arrayWithContentsOfFile:fileName];
        [self convertFromDictionariesInPlist:content];
        
    }
    
    
}

- (void)saveCurrentStateToPlist {
    
    //把数据保存到沙盒里的plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath1= [paths objectAtIndex:0];

    //得到完整的路径名
    NSString *fileName = [plistPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", [LoginDTO sharedInstance].memberNo, plistFileName]];

    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fileName]) {
        
        NSArray* content = [self convertToDictionariesForSavingAsPlist];
        [content writeToFile:fileName atomically:YES];
        
    } else {
        
        if ([fm createFileAtPath:fileName contents:nil attributes:nil]) {

            NSArray* content = [self convertToDictionariesForSavingAsPlist];
            [content writeToFile:fileName atomically:YES];
        } else {
            NSLog(@"创建下载日志文件失败");
        }
    }
}

- (NSMutableArray*)downloadLogList {
    
    if (!_downloadLogList) {
    
        
        _downloadLogList = [NSMutableArray array];
    }

    return _downloadLogList;
}

#pragma mark -
#pragma mark DownloadLogItemControlDelegate

- (void)logItemUpdated {
    
    [self saveCurrentStateToPlist];

}

- (void)logItemDownloadedWithGoodsNo:(NSString *)goodsNo figureType:(DownloadFigureType)figureType {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(DownloadLogControlDelegate)] && [self.delegate respondsToSelector:@selector(figureDownloadedWithGoodsNo:type:)]) {
        
        [self.delegate figureDownloadedWithGoodsNo:goodsNo type:figureType];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOfDownloadStop object:nil];
    //addObserver:self selector:@selector(stopDownloadingNotification) name:kStopDownAnimation object:nil];
    
    
    
    NSLog(@"===========下载完成========= goodsNo: %@, figureType: %ld", goodsNo, figureType);
}

#pragma mark 暂停、开启下载
//!暂停所有下载
-(void)suspendAllDownLoad{
    
    [self isSuspendDownload:YES];
    
}

//!开启所有下载
-(void)resumeAllDownLoad{
    
    [self isSuspendDownload:NO];
    
}

-(void)isSuspendDownload:(BOOL)isSuspend{//!isSuspend 是否是暂停
    
    //!得到所有正在下载的内容
    NSArray * downLoadingArray = [self downloadingLogItems];
    
    //!对正在下载的商品进行排序，按照加入下载队列的时间进行排序
    for (DownloadLogItem * loadingItem in downLoadingArray) {
        
        //!客观图和窗口图加入的时间进行比较，取最新的那个
        DownloadLogFigure * windowFigure = loadingItem.windowFigure;
        DownloadLogFigure * objectFigure = loadingItem.objectiveFigure;
        
        if (isSuspend) {
            
            [windowFigure.downloadProcessor suspendProcessor];
            [objectFigure.downloadProcessor suspendProcessor];
            
        }else{
            
            [windowFigure.downloadProcessor resumeProcessor];
            [objectFigure.downloadProcessor resumeProcessor];
            
        }
        
    }
    
}

#pragma mark 判断《正在下载》里面 是否都处于暂停状态
-(BOOL)downloadingIsAllPause{
    
    //!得到所有正在下载的内容
    NSArray * downLoadingArray = [self downloadingLogItems];
    
    //!对正在下载的商品进行排序，按照加入下载队列的时间进行排序
    for (DownloadLogItem * loadingItem in downLoadingArray) {
        
        //!客观图和窗口图加入的时间进行比较，取最新的那个
        DownloadLogFigure * windowFigure = loadingItem.windowFigure;
        DownloadLogFigure * objectFigure = loadingItem.objectiveFigure;
        
        DebugLog(@"%lu~~~~~~~~~%lu", (unsigned long)windowFigure.status,(unsigned long)objectFigure.status);
        
        if (!windowFigure  && windowFigure.status != DownloadItemStatusForPause) {
            
            return NO;//!不处于暂停状态，返回no
            
            
        }
        
        if (!objectFigure && objectFigure.status != DownloadItemStatusForPause ) {
            
            return NO;//!不处于暂停状态，返回no
            
        }
        
        
    }
    
    return YES;//!都处于暂停状态，返回yes
    
    
}
#pragma mark !移除figure里面的progress的代理
-(void)removeAlleFigureDelegate{

    for (DownloadLogItem * loadingItem in self.downloadLogList) {
        
        //!客观图和窗口图加入的时间进行比较，取最新的那个
        DownloadLogFigure * windowFigure = loadingItem.windowFigure;
        DownloadLogFigure * objectFigure = loadingItem.objectiveFigure;
        
        if (!windowFigure) {
            
            windowFigure.delegate = nil;
        }
        
        if (!objectFigure ) {
            
            objectFigure.delegate = nil;
            
        }
        
        
    }


}


@end
