//
//  MHImageDownloadProcessor.h
//  SellerCenturySquare
//
//  Created by skyxfire on 9/23/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZipArchive.h"

typedef NS_ENUM(NSUInteger, DownloadImageType) {
    DownloadImageTypeForWindow,
    DownloadImageTypeForObjective,
};

typedef NS_ENUM(NSUInteger, DownloadProcessorState) {
    DownloadProcessorStateOfInit,
    DownloadProcessorStateOfInQueue,
    DownloadProcessorStateOfStarted,    //开始下载
    DownloadProcessorStateOfStopped,    //暂停下载
    DownloadProcessorStateOfDownloaded,   //下载完成
    DownloadProcessorStateOfZipped,     //解压完成
    DownloadProcessorStateOfZipFailed,  //解压失败
    DownloadProcessorStateOfConnectionTimeout,  //request申请链接超时
    DownloadProcessorStateOfFinished
};

@class MHImageDownloadProcessor;
@class ASIHTTPRequest;

@protocol MHImageDownloadRequestDelegate <NSObject>

@optional

#pragma mark -
#pragma mark Delegate for download manager

//-(void)suspendAllDownLoadProcessor;

- (void)downloadProcessor:(MHImageDownloadProcessor*)downloadProcessor downloadRequestCreated:(ASIHTTPRequest*)downloadRequest;

- (void)downloadProcessor:(MHImageDownloadProcessor*)downloadProcessor downloadRequestDestroyed:(ASIHTTPRequest*)downloadRequest;

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor processorStateChanged:(DownloadProcessorState)processorState;




@end


@protocol MHImageDownloadProcessorDelegate <NSObject>

#pragma mark -
#pragma mark Delegate For UI or Manager
@optional

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor startProcessor:(BOOL)isStarted;

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor updatedProcess:(CGFloat)process averageBandwidthUsedPerSecond:(unsigned long)averageBandwidthUsedPerSecond;

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor finishProcessor:(BOOL)isFinished;

- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor processorStateChanged:(DownloadProcessorState)processorState;

//- (void)downloadProcessor:(MHImageDownloadProcessor *)downloadProcessor receivedBytes:(long long)receivedBytes;

@end

@interface MHImageDownloadProcessor : NSObject

// 由下载处理申请者初始化时配置,在管理器返回有效的MHImageDownloadProcessor句柄之后
//@property (nonatomic, assign)id<MHImageDownloadProcessorDelegate> visitorDelegate;

//下载器的下载进度
@property (nonatomic, assign) CGFloat downloadProgress;

//当前下载器的状态
@property (nonatomic, assign) DownloadProcessorState state;

//文件大小,单位Byte
@property (nonatomic, assign) unsigned long long fileContentSize;

@property (nonatomic, assign) long long receivedBytes;

@property (nonatomic, assign, getter=isValid) BOOL valid;

@property (nonatomic, assign)NSTimeInterval timeoutInterval;

- (id)initWithUrl:(NSURL*)url fileNameForUrl:(NSString*)fileName timeoutInterval:(NSTimeInterval)interval startImmediately:(BOOL)shouldStartImmediately neededState:(DownloadProcessorState)neededState;

#pragma mark -
#pragma mark 下载器控制接口

//恢复下载
- (void)resumeProcessor;
//暂停下载
- (void)suspendProcessor;
//清除缓存,重启下载
- (void)restartProcessor;
//重置下载器,关闭下载,清除缓存,状态恢复为Init状态
- (void)resetProcessor;

#pragma mark -
#pragma mark DelegateForUISession
//管理UI对应的Delegate

- (void)addUISessionDownloadProcessorDelegate:(id<MHImageDownloadProcessorDelegate>)downloadProcessorDelegate;
- (void)removeUISessionDownloadProcessorDelegate:(id<MHImageDownloadProcessorDelegate>)downloadProcessorDelegate;
- (void)clearUISessionDownloadProcessorDelegates;

@end
