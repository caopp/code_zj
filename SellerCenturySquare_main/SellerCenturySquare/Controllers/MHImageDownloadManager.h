//
//  MHImageDownloadManager.h
//  SellerCenturySquare
//
//  Created by skyxfire on 9/23/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHImageDownloadProcessor.h"

@class MHImageDownloadProcessor;

@interface MHImageDownloadManager : NSObject <MHImageDownloadRequestDelegate>

+ (MHImageDownloadManager*)sharedInstance;

//恢复所有暂停的下载,超过最大下载线程数的进入等待
+ (void)resumeAllProcessor;

//暂停所有下载,包括正在下载和等待下载
+ (void)suspendAllProcessor;

#pragma mark -
#pragma mark Download manager property

@property (nonatomic, assign)NSInteger maxMissions;
@property (nonatomic, assign)NSTimeInterval timeoutInterval;
//@property (nonatomic, strong)NSString* templateFolder;

#pragma mark -
#pragma mark Public Methods

//若URL对应的下载正在等待,或者正在下载,则返回YES,否则返回NO
- (BOOL)isProcessorRunningForURL:(NSString*)url;
//恢复指定的URL对应的下载
- (void)resumeProcessorForURL:(NSString*)url;
- (void)resumeAllProcessor;
- (void)restartProcessorForURL:(NSString*)url;
- (void)suspendProcessorForURL:(NSString*)url;
- (void)suspendAllProcessor;

//如果已经加入队列过,则返回有效的句柄,否则返回nil,可以通过isProcessorRunningForURL:判断
- (MHImageDownloadProcessor*)fetchProcessorWithUrl:(NSString*)url downloadImmediately:(BOOL)shouldDownloadImmediately neededState:(DownloadProcessorState)neededState;
- (MHImageDownloadProcessor*)getProcessorIfExistByUrl:(NSString*)url;
//- (MHImageDownloadProcessor*)getProcessorAndRunImmediatelyByUrl:(NSString*)url;

- (void)removeProcessorByUrl:(NSString*)url;

@end
