//
//  DownloadLogControl.h
//  ImageDownloadDemo
//
//  Created by skyxfire on 9/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHImageDownloadProcessor.h"

//下载记录的条目的下载状态
typedef NS_ENUM(NSInteger, DownloadItemStatus) {
    DownloadItemStatusForIdle, // 未配置下载任务的状态
    DownloadItemStatusForInQueue, //已配置下载任务,且加入下载队列等待下载
    DownloadItemStatusForDownloading,   //已配置下载任务,且正在下载
    DownloadItemStatusForPause,         //暂停下载
    DownloadItemStatusForCompleted,     //下载完成
    DownloadItemStatusForFailed         //下载报错
};

//下载图片的图片类型
typedef NS_ENUM(NSInteger, DownloadFigureType) {
    DownloadFigureTypeOfWindow,     //窗口图
    DownloadFigureTypeOfObjective,  //客观图

};



extern NSString* const NotificationOfDownloadParamInfo;
extern NSString* const NotificationOfDownloadStatusInfo;

@interface DownloadParamInfoNotificationDTO : NSObject

@property (nonatomic, strong) NSString* goodsNo;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) unsigned long averageBandwidthUsedPerSecond;
@property (nonatomic, assign) long long receivedBytes;
@property (nonatomic, assign) long long fileContentSize;
@property (nonatomic, assign) DownloadFigureType figureType;

@end


@interface DownloadStatusInfoNotificationDTO : NSObject

@property (nonatomic, strong) NSString* goodsNo;
@property (nonatomic, assign) DownloadFigureType figureType;
@property (nonatomic, assign) DownloadItemStatus lastStatus;
@property (nonatomic, assign) DownloadItemStatus newStatus;

- (BOOL)changeToDownloading;
- (BOOL)changeToCompelete;
- (BOOL)clear;

@end


@interface DownloadLogFigure : NSObject

@property (nonatomic, strong)NSString* goodsNo;

@property (nonatomic, assign) DownloadFigureType type;
// URL
@property (nonatomic, strong) NSString* url;
// 下载器
@property (nonatomic, weak)MHImageDownloadProcessor* downloadProcessor;
// 下载状态
@property (nonatomic, assign) DownloadItemStatus status;
// 选中状态,用于区分需要批处理的对象
@property (nonatomic, assign, getter=isSelected) BOOL selected;
// 待下载文件的大小,单位Byte
@property (nonatomic, assign) unsigned long long fileContentSize;
// 已接收部分的大小,单位Byte
@property (nonatomic, assign) long long receivedBytes;
// 进度, 0.0 ~ 1.0
@property (nonatomic, assign) CGFloat progress;
//下载速度,单位Byte/s
@property (nonatomic, assign) unsigned long averageBandwidthUsedPerSecond;

@property (nonatomic, strong) NSString* imageItems;

@property (nonatomic,copy)NSDate * addDate;//!添加到下载队列的时间

//!下载完成的时间 lyt
@property(nonatomic,strong)NSDate * finshDate;


// 是否正在下载
- (BOOL)isDownloading;
// 是否下载完成或处于空闲状态,当只下载客观图或窗口图,另外一项未下载对象处于空闲状态
- (BOOL)isDownloadedOrIdle;

// 是否处于下载完成状态
- (BOOL)isDownloaded;

// 重新下载
- (void)restartDownload;

// 恢复下载
- (void)resumeDownload;
// 暂停下载
- (void)suspendDownload;
//清除下载
- (void)resetDownload;

//!移除所有代理
-(void)removeAllDelegate;


@end



@protocol DownloadLogItemDelegate <NSObject>

- (void)logItemUpdatedWithProgress:(CGFloat)progress averageBandwidthUsedPerSecond:(unsigned long)averageBandwidthUsedPerSecond receivedBytes:(long long)receivedBytes fileContentSize:(long long)fileContentSize forFigureType:(DownloadFigureType)figureType;

@end

@interface DownloadLogItem : NSObject

@property (nonatomic, weak) id<DownloadLogItemDelegate> delegate;

@property (nonatomic, strong) NSString* goodsNo;

@property (nonatomic, strong) NSString* pictureUrl;

@property (nonatomic, strong) DownloadLogFigure* windowFigure;

@property (nonatomic, strong) DownloadLogFigure* objectiveFigure;

@property(nonatomic,strong)NSDate * maxDate;//!窗口图、客观图加入时间对比，maxDate = 最新加入的那一个时间

@property(nonatomic,strong)NSNumber * windowPicSize;//!窗口图大小

@property(nonatomic,strong)NSNumber * objectivePicSize;//!客观图大小



// 通过图片类型,判断对应的下载是否正在下载中,下载中的状态包括正在下载,等待下载,暂停下载
- (BOOL)isDownloadingFigureType:(DownloadFigureType)figureType;

// 判断是都有正在下载的或者正在队列中等待下载的,或是暂停的下载控制器
- (BOOL)isExistDownloadingFigure;

// 判断存在下载完成项
- (BOOL)isExistDownloadedFigure;

// 判断是否存在已下载完的,且不存在下载中的下载控制器.包括状态为至少有一个下载完成,且另一个为下载完成或空闲,即未进行下载配置
- (BOOL)isAllFigureDownloaded;

// 根据图片类型,恢复窗口图或客观图的下载
- (void)resumeDownloadWithFigureType:(DownloadFigureType)figureType;

// 根据图片类型,暂停窗口图或客观图的下载
- (void)suspendDownloadWithFigureType:(DownloadFigureType)figureType;

// 根据图片类型,重新下载客观图或窗口图
- (void)restartDownloadWithFigureType:(DownloadFigureType)figureType;

- (void)resetDownloadWithFigureType:(DownloadFigureType)figureType;

@end


@protocol DownloadLogControlDelegate <NSObject>

@optional
- (void)figureDownloadedWithGoodsNo:(NSString*)goodsNo type:(DownloadFigureType)figureType;

@end

//控制本地记录下载列表,存盘及获取信息
@interface DownloadLogControl : NSObject

//用于ViewController的回调,反馈已下载完成的图片GoodsNo和图片类型,已进行下载完成的反馈,调用服务器接口
@property (nonatomic, weak)id<DownloadLogControlDelegate> delegate;

//下载列表,包括所有下载记录.清楚过状态的记录,保留goodsNo,只清除URL和下载器资源,初始化记录状态.
@property (nonatomic, strong)NSMutableArray* downloadLogList;

+ (DownloadLogControl *)sharedInstance;
- (void)loadStateFromPlist;


- (NSArray*)downloadedLogItems;
- (NSArray*)downloadingLogItems;
- (NSInteger)downloadingItems;

- (void)resetAllDownloadLogSelectedState;

//添加一条下载记录,商品编号不能为空,下载窗口图时,传递windowFigureUrl;下载客观图时,传递objectiveFigureUrl,不需要下载项,传nil.
- (void)addLogItemByGoodsNo:(NSString*)goodsNo objectiveFigureUrl:(NSString*)objectiveFigureUrl objectiveFigureItems:(NSString*)objectiveFigureItems windowFigureUrl:(NSString*)windowFigureUrl windowFigureItems:(NSString*)windowFigure pictureUrl:(NSString*)pictureUrl;


//lyt 和上面的方法相比，增加了一个下载图片的大小 用于个人中心 下载页面 读取图片大小
- (void)addLogItemByGoodsNo:(NSString*)goodsNo objectiveFigureUrl:(NSString*)objectiveFigureUrl objectiveFigureItems:(NSString*)objectiveFigureItems windowFigureUrl:(NSString*)windowFigureUrl windowFigureItems:(NSString*)windowFigureItems pictureUrl:(NSString*)pictureUrl withWindowPicSize:(NSNumber *)windowPicSize withObjectivePicSize:(NSNumber *)objectivePicSize;



//清除一条下载记录,商品标号不能为空,需要清除窗口图时,shouldRemoveWindowDownloader置为TRUE, 需要清除客观图时,shouldRemoveObjectiveDownloader置为TRUE
- (void)removeLogItemByGoodsNo:(NSString*)goodsNo objectiveDownloader:(BOOL)shouldRemoveObjectiveDownloader windowDownloader:(BOOL)shouldRemoveWindowDownloader;
//清除所有已下载完成的记录
- (void)removeAllSelectedDownloadedLogItems;
//清除所有正在下载的记录,包括下载中,等待下载和暂停下载
- (void)removeAllSelectedDownloadingLogItems;

- (void)restartAllSelectedDownloadedLogItems;

- (void)resetAllDelegates;


//!暂停所有下载
-(void)suspendAllDownLoad;

//!开启所有下载
-(void)resumeAllDownLoad;

//判断《正在下载》里面 是否都处于暂停状态
-(BOOL)downloadingIsAllPause;

//!移除figure里面的progress的代理
-(void)removeAlleFigureDelegate;






@end
