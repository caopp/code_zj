//
//  MHImageDownloadManager.m
//  SellerCenturySquare
//
//  Created by skyxfire on 9/23/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "MHImageDownloadManager.h"
#import "ASINetworkQueue.h"
#import "LoginDTO.h"

static CGFloat      MHImageDownloadDefaultTimeOutInterval = 15;
static NSInteger    MHImageDownloadDefaultMaxMission = 5;

//static NSString *   MHImageDownLoaderDefaultTemplateFolder = @"DownLoad";

inline static NSString* keyForURL(NSURL* url) {
    return [NSString stringWithFormat:@"%@-%lu", [LoginDTO sharedInstance].memberNo, (unsigned long)[[url description] hash]];
}

@interface MHImageDownloadManager ()

@property (nonatomic, strong)NSMutableDictionary* connections;
@property (nonatomic, strong)ASINetworkQueue* networkQueue;

@end

@implementation MHImageDownloadManager

+ (MHImageDownloadManager *)sharedInstance{

    static MHImageDownloadManager *instance_;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        instance_ = [[MHImageDownloadManager alloc] init];
    });
    return instance_;
}

- (id)init {
    self = [super init];
    if(self) {
        self.connections = [NSMutableDictionary dictionary];
        self.timeoutInterval = MHImageDownloadDefaultTimeOutInterval;
        self.maxMissions = MHImageDownloadDefaultMaxMission;
    }

    return self;
}


#pragma mark -
#pragma mark Setter and Getter

- (ASINetworkQueue*)networkQueue {
    if (!_networkQueue) {
        _networkQueue = [ASINetworkQueue queue];

        [_networkQueue reset];

        [_networkQueue setMaxConcurrentOperationCount:self.maxMissions];
        
        //设置支持较高精度的进度追踪
        [_networkQueue setShowAccurateProgress:YES];

        [_networkQueue setShouldCancelAllRequestsOnFailure:NO];

        _networkQueue.delegate = self;

        //启动后，添加到队列的请求会自动执行
        [_networkQueue go];
    }

    return _networkQueue;
}

- (void)setMaxMissions:(NSInteger)maxMissions {

//    _maxMissions = maxMissions;

    _maxMissions = 1;//!让最大下载数量是1，下载完一个再下载另一个

    [self.networkQueue setMaxConcurrentOperationCount:_maxMissions];

}

#pragma mark -
#pragma mark Public Methods

+ (void)suspendAllProcessor {
    MHImageDownloadManager* downloadManager = [MHImageDownloadManager sharedInstance];
    [downloadManager suspendAllProcessor];
}

+ (void)resumeAllProcessor {
    [[MHImageDownloadManager sharedInstance] resumeAllProcessor];
}

- (BOOL)isProcessorRunningForURL:(NSString*)url {
    if (!url || url.length == 0) {
        return NO;
    }

    NSURL* requestURL = [NSURL URLWithString:url];
    NSString* key = keyForURL(requestURL);
    MHImageDownloadProcessor* processor = [self.connections objectForKey:key];
    if (processor) {
        if (processor.state == DownloadProcessorStateOfInQueue ||
            processor.state == DownloadProcessorStateOfStarted) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)resumeProcessorForURL:(NSString*)url {
    MHImageDownloadProcessor* processor = [self getProcessorIfExistByUrl:url];
    if (processor.state == DownloadProcessorStateOfStopped ||
        processor.state == DownloadProcessorStateOfZipFailed ||
        processor.state == DownloadProcessorStateOfConnectionTimeout) {
        [processor resumeProcessor];
    }
}

- (void)resumeAllProcessor {
    [self.connections enumerateKeysAndObjectsUsingBlock:^(NSString* key, MHImageDownloadProcessor* obj, BOOL *stop) {
        if (obj.state == DownloadProcessorStateOfStopped ||
            obj.state == DownloadProcessorStateOfZipFailed ||
            obj.state == DownloadProcessorStateOfConnectionTimeout) {
            [obj resumeProcessor];
        }
    }];
}

- (void)restartProcessorForURL:(NSString*)url {
    MHImageDownloadProcessor* processor = [self getProcessorIfExistByUrl:url];
    [processor restartProcessor];
}

- (void)suspendProcessorForURL:(NSString*)url {
    MHImageDownloadProcessor* processor = [self getProcessorIfExistByUrl:url];
    if (processor.state == DownloadProcessorStateOfConnectionTimeout ||
        processor.state == DownloadProcessorStateOfInQueue ||
        processor.state == DownloadProcessorStateOfStarted ||
        processor.state == DownloadProcessorStateOfZipFailed) {
        [processor suspendProcessor];
    }
}

- (void)suspendAllProcessor {
    [self.connections enumerateKeysAndObjectsUsingBlock:^(NSString* key, MHImageDownloadProcessor* obj, BOOL *stop) {
        if (obj.state == DownloadProcessorStateOfConnectionTimeout ||
            obj.state == DownloadProcessorStateOfInQueue ||
            obj.state == DownloadProcessorStateOfStarted ||
            obj.state == DownloadProcessorStateOfZipFailed) {
            [obj suspendProcessor];
        }
    }];
}

- (MHImageDownloadProcessor*)fetchProcessorWithUrl:(NSString*)url downloadImmediately:(BOOL)shouldDownloadImmediately neededState:(DownloadProcessorState)neededState {
    if (!url || url.length == 0) {
        return nil;
    }

    NSURL* requestURL = [NSURL URLWithString:url];
    NSString* key = keyForURL(requestURL);
    MHImageDownloadProcessor* processor = [self.connections objectForKey:key];
    if (!processor) {

        processor = [[MHImageDownloadProcessor alloc]initWithUrl:requestURL fileNameForUrl:key timeoutInterval:self.timeoutInterval startImmediately:shouldDownloadImmediately neededState:neededState];

        if (processor) {
            [self.connections setObject:processor forKey:key];
        } else {
            NSLog(@"Fail to create new processor");
        }
        
    }

    return processor;
    
}

- (MHImageDownloadProcessor*)getProcessorIfExistByUrl:(NSString*)url {
    if (!url || url.length == 0) {
        return nil;
    }

    NSURL* requestURL = [NSURL URLWithString:url];
    NSString* key = keyForURL(requestURL);
    MHImageDownloadProcessor* processor = [self.connections objectForKey:key];
//    if (!processor) {
//
//        processor = [[MHImageDownloadProcessor alloc]initWithUrl:requestURL fileNameForUrl:key timeoutInterval:self.timeoutInterval startImmediately:NO];
//
//        if (processor) {
//            [self.connections setObject:processor forKey:key];
//        } else {
//            NSLog(@"Fail to create new processor");
//        }
//    }

    return processor;
}

//- (MHImageDownloadProcessor*)getProcessorAndRunImmediatelyByUrl:(NSString*)url {
//    if (!url || url.length == 0) {
//        return nil;
//    }
//
//    NSURL* requestURL = [NSURL URLWithString:url];
//    NSString* key = keyForURL(requestURL);
//    MHImageDownloadProcessor* processor = [self.connections objectForKey:key];
//    if (!processor) {
//
//        processor = [[MHImageDownloadProcessor alloc]initWithUrl:requestURL fileNameForUrl:key timeoutInterval:self.timeoutInterval startImmediately:YES];
//
//        if (processor) {
//            [self.connections setObject:processor forKey:key];
//        } else {
//            NSLog(@"Fail to create new processor");
//        }
//    }
//
//    return processor;
//}


- (void)removeProcessorByUrl:(NSString*)url {
    if (!url || url.length == 0) {
        return;
    }

    NSURL* requestURL = [NSURL URLWithString:url];
    NSString* key = keyForURL(requestURL);

    [self.connections removeObjectForKey:key];
}

#pragma mark -
#pragma mark Private Methods

- (void)addDownloadProcessor:(MHImageDownloadProcessor*)downloadProcessor withKey:(NSString*)key {
    if (!key || key.length == 0 || !downloadProcessor) {
        return;
    }

    MHImageDownloadProcessor* destProcessorForKey = [self.connections objectForKey:key];
    if (destProcessorForKey) {

    } else {
        [self.connections setObject:downloadProcessor forKey:key];
    }
}

- (NSInteger)getConnectionCountForState:(DownloadProcessorState)state {
    __block NSInteger sum = 0;
    
    [self.connections enumerateKeysAndObjectsUsingBlock:^(NSString* key, MHImageDownloadProcessor* obj, BOOL *stop) {
        if (obj.state == state) {
            sum++;
        }
    }];

    return sum;
}

#pragma mark -
#pragma mark MHImageDownloadProcessorDelegate

- (void)downloadProcessor:(MHImageDownloadProcessor*)downloadProcessor downloadRequestCreated:(ASIHTTPRequest*)downloadRequest {

    for (NSOperation* operation in [self.networkQueue operations]) {
        if ([operation isEqual:downloadRequest]) {
            return;
        }
    }

    [self.networkQueue addOperation:(NSOperation*)downloadRequest];
}


- (void)downloadProcessor:(MHImageDownloadProcessor*)downloadProcessor downloadRequestDestroyed:(ASIHTTPRequest*)downloadRequest {
    // 检查队列是否为空,当下载队列为空时,表示所有下载任务全部完成,释放队列资源
    if (_networkQueue == nil || [_networkQueue requestsCount] == 0) {
        _networkQueue = nil;
    }
}



@end
