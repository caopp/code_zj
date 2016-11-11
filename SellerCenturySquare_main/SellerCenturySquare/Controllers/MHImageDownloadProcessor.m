//
//  MHImageDownloadProcessor.m
//  SellerCenturySquare
//
//  Created by skyxfire on 9/23/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "MHImageDownloadProcessor.h"
#import "ASIHTTPRequest.h"
#import "ZipArchive.h"
#import "MHImageDownloadManager.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface MHImageDownloadProcessor ()

// 由管理器HMImageDownloadManager初始化时配置
@property (nonatomic, assign)id<MHImageDownloadRequestDelegate> managerDelegate;
// UI Section Delegates
@property (nonatomic, strong)NSMutableArray* delegates;

//下载路径
@property (nonatomic, strong)NSString* downloadPath;
//缓存路径
@property (nonatomic, strong)NSString* tempPath;
//解压路径
@property (nonatomic, strong)NSString* unzipPath;

@property (nonatomic, strong)ASIHTTPRequest* downloadRequest;

@property (nonatomic, strong)NSURL* requstURL;
@property (nonatomic, strong)NSString* fileName;

@end

@implementation MHImageDownloadProcessor

- (id)initWithUrl:(NSURL *)url fileNameForUrl:(NSString *)fileName timeoutInterval:(NSTimeInterval)interval startImmediately:(BOOL)shouldStartImmediately neededState:(DownloadProcessorState)neededState {
    
    self = [super init];

    if (self) {
        self.managerDelegate = [MHImageDownloadManager sharedInstance];

        self.fileName = fileName;
        self.timeoutInterval = interval;
        self.requstURL = url;

        [self initializePaths];

        if (shouldStartImmediately) {
            [self initializeHTTPRequest];

        } else {
            self.state = neededState;
        }
    }

    return self;
    
}

#pragma mark -
#pragma mark Setter and Getter

- (NSMutableArray*)delegates {
    if (!_delegates) {
        _delegates = [NSMutableArray array];
    }

    return _delegates;
}

- (void)setState:(DownloadProcessorState)state {
//    NSLog(@"当前状态为:%d ----> 切换为状态:%d <%@>", (int)self.state, (int)state, self.fileName);

    _state = state;

    [self publishProcessorStateChangedIncidentToDelegates];
}

#pragma mark -
#pragma mark Public Methods

//启动下载
- (void)resumeProcessor {
    
    if (self.state == DownloadProcessorStateOfStopped) {
        
//        //!现在暂停所有下载，再启动其他下载
//        if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(suspendAllDownLoadProcessor)]) {
//            
//            [self.managerDelegate suspendAllDownLoadProcessor];
//        }
        
        [self initializeHTTPRequest];

    
    } else {
    
        NSLog(@"当前状态下,恢复为无效操作 <%@>", self.fileName);
    
    }
    
    

}

//暂停下载
- (void)suspendProcessor {
    if (self.state == DownloadProcessorStateOfStarted ||
        self.state == DownloadProcessorStateOfInQueue) {
        
        [self.downloadRequest clearDelegatesAndCancel];

        self.state = DownloadProcessorStateOfStopped;
        
    } else {
        NSLog(@"当前状态下,暂停为无效操作 <%@>", self.fileName);
    }
}

//清除缓存,重启下载
- (void)restartProcessor {

    
    NSLog(@"清除缓存,重新下载 <%@>", self.fileName);

    [self clearDownloadFile:YES andTempFile:YES andUnzipPath:YES];

    [self initializeHTTPRequest];
    
    
}

//重置下载器
- (void)resetProcessor {
    if (self.state == DownloadProcessorStateOfStarted ||
        self.state == DownloadProcessorStateOfInQueue) {
        [self.downloadRequest clearDelegatesAndCancel];
    }

    [self clearDownloadFile:YES andTempFile:YES andUnzipPath:YES];
    self.state = DownloadProcessorStateOfInit;
}

#pragma mark -
#pragma mark Private Methods

- (void)initializePaths {
    //Documents路径

    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

    //下载路径

    self.downloadPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", self.fileName]];

    //要支持断点续传，缓存路径是不能少的。

    self.tempPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp", self.fileName]];

    self.unzipPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Unzip", self.fileName]];
}

- (void)initializeHTTPRequest {


    if (self.downloadRequest) {
        [self.downloadRequest clearDelegatesAndCancel];
    }

    //创建请求
    self.downloadRequest = [ASIHTTPRequest requestWithURL:self.requstURL];
    //设置代理，别忘了在头文件里添加ASIHTTPRequestDelegate协议

    self.downloadRequest.delegate = self;

    //设置下载请求失败超时时间
    [self.downloadRequest setTimeOutSeconds:self.timeoutInterval];

    [self.downloadRequest setNumberOfTimesToRetryOnTimeout:3];

    //设置下载路径

    [self.downloadRequest setDownloadDestinationPath:self.downloadPath];

    //设置缓存路径

    [self.downloadRequest setTemporaryFileDownloadPath:self.tempPath];

    //设置支持断点续传

    [self.downloadRequest setAllowResumeForFileDownloads:YES];

    //下载进度代理可以直接用UIProgressView对象，它会自动更新，如果你想做更多的处理

    //就必须用我们自定义的类，只要我们的类里实现了setPorgress:方法

    self.downloadRequest.downloadProgressDelegate = self;

    //将请求添加到之前创建的队列里，这时请求已经开始执行了
    
    //队列会retain添加进去的请求
    
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(downloadProcessor:downloadRequestCreated:)]) {
        [self.managerDelegate downloadProcessor:self downloadRequestCreated:self.downloadRequest];
    }

    self.state = DownloadProcessorStateOfInQueue;
    
    
}

- (void)clearDownloadFile:(BOOL)isDFNeedClear andTempFile:(BOOL)isTFNeedClear andUnzipPath:(BOOL)isUPNeedClear {

    NSFileManager *defaultManager = [NSFileManager defaultManager];

    if (isDFNeedClear) {
        [defaultManager removeItemAtPath:self.downloadPath error:nil];
    }

    if (isTFNeedClear) {
        [defaultManager removeItemAtPath:self.tempPath error:nil];
    }

    if (isUPNeedClear) {
        [defaultManager removeItemAtPath:self.unzipPath error:nil];
    }
}

- (void)unzipImageZipFileToUnzipPath {

#ifndef USE_GITHUB_ZIPARCHIVE
    ZipArchive* zipArchive = [[ZipArchive alloc]init];
    if ([zipArchive UnzipOpenFile:self.downloadPath]) {
        if ([zipArchive UnzipFileTo:self.unzipPath overWrite:YES]) {
            NSLog(@"图片解压完成 <%@>", self.fileName);
            self.state = DownloadProcessorStateOfZipped;

            [self saveImagesUnderDirectory:self.unzipPath];
        } else {
            NSLog(@"小伙伴,!!!解压出错了!!!");
        }
    }
    
#else
    if ([ZipArchive unzipFileAtPath:self.downloadPath toDestination:self.unzipPath]) {
//        NSLog(@"图片解压完成 <%@>", self.fileName);
        
        self.state = DownloadProcessorStateOfZipped;

        [self saveImagesUnderDirectory:self.unzipPath];
        
    } else {
        NSLog(@"小伙伴,!!!解压出错了!!!");
    }
#endif
}

- (void)saveImagesUnderDirectory:(NSString*)directory {
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray* imageFiles = [defaultManager subpathsOfDirectoryAtPath:directory error:nil];
    
    [self saveImages:imageFiles];
    
  
    /*
    for (NSString* imageFile in imageFiles) {
        NSString* imageDirectory = [self.unzipPath stringByAppendingPathComponent:imageFile];
        NSData *imageData = [NSData dataWithContentsOfFile:imageDirectory options:0 error:nil];

        UIImage* image = [UIImage imageWithData:imageData];
    
        //!保存到系统相册
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
        //!保存到自定义相册
//        [self saveImageToAblum:image];
        
        
        __weak MHImageDownloadProcessor * imageProcessor = self;
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
        [assetsLibrary saveImage:image toAlbum:app_Name completion:^(NSURL *assetURL, NSError *error) {
            
            //!告诉调用完成
            [imageProcessor image:image didFinishSavingWithError:error contextInfo:nil];
            
        } failure:^(NSError *error) {
           
            //!告诉调用完成
            [imageProcessor image:image didFinishSavingWithError:error contextInfo:nil];
            
        }];
        

    }

     */
    
//    self.state = DownloadProcessorStateOfFinished;
//
//    [self publishCompleteIncidentToDelegates];
//
//    [self clearDownloadFile:YES andTempFile:YES andUnzipPath:YES];
    
}

#pragma mark 保存图片到自定义相册
-(void)saveImages:(NSArray *)imageFiles{

    //!判断当前是否有保存到相册的权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
    {
        //!发出没有权限的通知，让界面显示 打开权限的提示
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NoAuthorNotification" object:nil];
        
        return;
        
    }

    
    //!读取app名称，让自定义相册名称同app名称
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    
    NSMutableArray * copyImageFiles = [NSMutableArray arrayWithArray:imageFiles];
    
    //!取出第0个
    NSString* imageDirectory = [self.unzipPath stringByAppendingPathComponent:copyImageFiles[0]];
    NSData *imageData = [NSData dataWithContentsOfFile:imageDirectory options:0 error:nil];
    
    UIImage* image = [UIImage imageWithData:imageData];
    
    __weak MHImageDownloadProcessor * imageProcessor = self;
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary saveImage:image toAlbum:app_Name completion:^(NSURL *assetURL, NSError *error) {
        
        //!告诉调用完成
        [imageProcessor image:image didFinishSavingWithError:error contextInfo:nil];
        
        //!去除第0张图片
        [copyImageFiles removeObjectAtIndex:0];
        
        //!保存完毕，就更新状态
        if (copyImageFiles.count == 0) {
            
            self.state = DownloadProcessorStateOfFinished;
            
            [self publishCompleteIncidentToDelegates];
            
            [self clearDownloadFile:YES andTempFile:YES andUnzipPath:YES];
            
        }else{//!还没有保存完，就再进行请求
        
            [self saveImages:copyImageFiles];
        
        }
        
        
    } failure:^(NSError *error) {
        
        //!告诉调用完成
        [imageProcessor image:image didFinishSavingWithError:error contextInfo:nil];
        
    }];


}


- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    if(error != nil){
        
        NSLog(@"图片保存失败 <%@>~~~~error：%@", self.fileName,error);

        
    } else{
        
        NSLog(@"图片保存成功 <%@>", self.fileName);
    
    }
    
}

#pragma mark -
#pragma mark DelegateForUISession

- (void)addUISessionDownloadProcessorDelegate:(id<MHImageDownloadProcessorDelegate>)downloadProcessorDelegate {

    if (!downloadProcessorDelegate) {
        return;
    }

    for (id delegate in self.delegates) {
        if ([delegate isEqual:downloadProcessorDelegate]) {
            return;
        }
    }

    [self.delegates addObject:downloadProcessorDelegate];
}

- (void)removeUISessionDownloadProcessorDelegate:(id<MHImageDownloadProcessorDelegate>)downloadProcessorDelegate {
    if (!downloadProcessorDelegate) {
        return;
    }

    id<MHImageDownloadProcessorDelegate> destDelegate = nil;
    for (id delegate in self.delegates) {
        if ([delegate isEqual:downloadProcessorDelegate]) {
            destDelegate = delegate;
            break;
        }
    }

    if (destDelegate) {
        [self.delegates removeObject:destDelegate];
    }
}

- (void)clearUISessionDownloadProcessorDelegates {
    [self.delegates removeAllObjects];
}

- (void)publishStartIncidentToDelegates {

    for (id<MHImageDownloadProcessorDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(downloadProcessor:startProcessor:)]) {
            [delegate downloadProcessor:self startProcessor:YES];
        }
    }
}

- (void)publishUpdateIncidentToDelegatesByProcess:(CGFloat)process averageBandwidthUsedPerSecond:(unsigned long)averageBandwidthUsedPerSecond {

    for (id<MHImageDownloadProcessorDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(downloadProcessor:updatedProcess:averageBandwidthUsedPerSecond:)]) {
            [delegate downloadProcessor:self updatedProcess:process averageBandwidthUsedPerSecond:averageBandwidthUsedPerSecond];
        }
    }
}

- (void)publishCompleteIncidentToDelegates {

    for (id<MHImageDownloadProcessorDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(downloadProcessor:finishProcessor:)]) {
            [delegate downloadProcessor:self finishProcessor:YES];
        }
    }
}

- (void)publishProcessorStateChangedIncidentToDelegates {

    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(downloadProcessor:processorStateChanged:)]) {
        [self.managerDelegate downloadProcessor:self processorStateChanged:self.state];
    }

    for (id<MHImageDownloadProcessorDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(downloadProcessor:processorStateChanged:)]) {
            [delegate downloadProcessor:self processorStateChanged:self.state];
        }
    }
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

//请求开始

- (void)requestStarted:(ASIHTTPRequest *)request {

    self.state = DownloadProcessorStateOfStarted;
    
    [self publishStartIncidentToDelegates];
}

//请求收到响应的头部，主要包括文件大小信息，下面会用到

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    if (self.fileContentSize == 0) {
        self.fileContentSize = request.contentLength;
        NSLog(@"File content size is %ld Bytes <%@>", (long)self.fileContentSize, self.fileName);
    }
}

//请求将被重定向

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {

}

//请求完成

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(downloadProcessor:downloadRequestDestroyed:)]) {
        [self.managerDelegate downloadProcessor:self downloadRequestDestroyed:request];
    }

    self.state = DownloadProcessorStateOfDownloaded;

    [self unzipImageZipFileToUnzipPath];
    
    
}

//请求失败

- (void)requestFailed:(ASIHTTPRequest *)request {
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(downloadProcessor:downloadRequestDestroyed:)]) {
        [self.managerDelegate downloadProcessor:self downloadRequestDestroyed:request];
    }

    self.state = DownloadProcessorStateOfConnectionTimeout;
}

//请求已被重定向

- (void)requestRedirected:(ASIHTTPRequest *)request {

}

#pragma mark -
#pragma mark ASIProgressDelegate

- (void)setProgress:(float)newProgress {
//    NSLog(@"============ %.04f ====== %lu ======= <%@>", newProgress, [ASIHTTPRequest averageBandwidthUsedPerSecond], self.fileName);
    _downloadProgress = newProgress;

    [self publishUpdateIncidentToDelegatesByProcess:_downloadProgress averageBandwidthUsedPerSecond:[ASIHTTPRequest averageBandwidthUsedPerSecond]];
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    self.receivedBytes = bytes;
}

@end
