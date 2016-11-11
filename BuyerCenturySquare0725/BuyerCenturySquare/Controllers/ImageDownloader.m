//
//  ImageDownloader.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ImageDownloader.h"
#import "UIImage+Save.h"
#import "GoodsInfoDetailsDTO.h"


@import Darwin.sys.mount;

static ImageDownloader *imageDownloaderInstance_;

@interface ImageDownloader()
{

    BOOL haveToCheckStatus;
    NSMutableArray *downloadingArray_;
    NSMutableArray *downloadedArray_;
    
}

@property (nonatomic,strong)NSMutableArray *downloadingArray;
@property (nonatomic,strong)NSMutableArray *downloadedArray;

@end

@implementation ImageDownloader

@synthesize downloadingArray = downloadingArray_,downloadedArray = downloadedArray_;
+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == imageDownloaderInstance_) {
            
            imageDownloaderInstance_ = [[ImageDownloader alloc]init];
            
            imageDownloaderInstance_.imageDownloaderTimeout = 15;
        }
    });
    return imageDownloaderInstance_;
}

- (ImageDownloaderStatus)downloadImages:(id<DTOPROTOCOL>)value{
    
    if ([value isKindOfClass:[GoodsInfoDetailsDTO class]]) {
        
        
    }else{
        
        
    }
    
    return ImageDownloaderStatusAddSuccess;
}

- (void)downloadImageWithoutStatusReturn:(id<DTOPROTOCOL>)value{

    
}

-(void)addToDownloadingArray:(NSMutableArray *)downloadingArray
{
    if (!self.downloadingArray) {
        self.downloadingArray  = [[NSMutableArray alloc]init];
    }
    [self.downloadingArray addObjectsFromArray:downloadingArray];
}


- (void)downloadImageWithImageURL:(id)urlValue{

//    [self downloadImageWithImageURL:urlValue progressBlock:nil success:nil failure:nil];

}

- (void)downloadImageWithImageURL:(id)urlValue progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *cachePath;
    
    long long cacheLength = [self cacheDataLengthWithPath:cachePath];
    
    NSMutableURLRequest* request = [[self class] createURLRequestWith:urlValue Range:cacheLength];
    
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    /**
     *  从缓存中读取下载进度.
     */
    [self AFHTTPRequestOperation:self.requestOperation readCacheDataToOutStreamFromPath:cachePath];
    
    /**
     *  下载暂停监听.
     */
    [self.requestOperation addObserver:self forKeyPath:@"isPaused" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    // 下载进度的block赋值.
    
    self.progressBlock = progressBlock;
    // 修正进度.
    
    [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength]];
    
    /**
     *  下载成功callback.
     */
    void (^newSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseHead = %@",[operation.response allHeaderFields]);
        
        success(operation,responseObject);
    };
    
    /**
     *  下载失败callback.
     */
    [self.requestOperation setCompletionBlockWithSuccess:newSuccess
                                                 failure:failure];
}

/**
 *  读取缓存的数据
 *
 *  @param filePath 文件路径
 *
 *  @return 缓存文件的大小
 */
- (long long)cacheDataLengthWithPath:(NSString*)filePath
{
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    
    NSData* fileData = [fileHandle readDataToEndOfFile];
    
    return fileData ? fileData.length : 0;
    
}

#pragma mark - 读取本地缓存入流

- (void)AFHTTPRequestOperation:(AFHTTPRequestOperation *)value readCacheDataToOutStreamFromPath:(NSString*)path
{
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData* currentData = [fh readDataToEndOfFile];
    
    if (currentData.length) {
        //打开流，写入data ， 未打卡查看 streamCode = NSStreamStatusNotOpen
        [value.outputStream open];
        
        NSInteger       bytesWritten;
        NSInteger       bytesWrittenSoFar;
        
        NSInteger  dataLength = [currentData length];
        const uint8_t * dataBytes  = [currentData bytes];
        
        bytesWrittenSoFar = 0;
        
        do {
            bytesWritten = [value.outputStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
            
            assert(bytesWritten != 0);
            
            if (bytesWritten == -1) {
            
                break;
            } else {
                
                bytesWrittenSoFar += bytesWritten;
            }
            
        } while (bytesWrittenSoFar != dataLength);
    }
}


#pragma mark - 建立请求

- (NSMutableURLRequest*)createURLRequestWith:(id)value Range:(long long)length
{
    NSURL* requestUrl = [value isKindOfClass:[NSURL class]] ? value : [NSURL URLWithString:value];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:self.imageDownloaderTimeout];
    
    
    if (length) {
        
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",length] forHTTPHeaderField:@"Range"];
    }
    
    NSLog(@"request.head = %@",request.allHTTPHeaderFields);
    
    return request;
}


//
//#pragma mark -
//
//- (void)createDownloadTask{
//
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//   
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
//                                                                     progress:nil
//                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//                                                                      
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//                                                                      
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//                                                                      
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//    
//    [downloadTask resume];
//}
//
//- (void)createBatchDownloadTask{
//    
//    NSMutableArray *mutableOperations = [NSMutableArray array];
//    
//    NSArray *filesToUpload;
//    
//    for (NSURL *fileURL in filesToUpload) {
//        
//        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileURL:fileURL name:@"images[]" error:nil];
//        }];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        
//        [mutableOperations addObject:operation];
//    }
//    
//    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:@[@1] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
//        
//        NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
//        
//    } completionBlock:^(NSArray *operations) {
//        
//        NSLog(@"All operations in batch complete");
//    }];
//    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
//}
#pragma mark -
#pragma mark 暂停，开始，取消
- (void)cancel:(id)url{

    
}
- (void)cancelAll{
    
    
}

- (void)start:(id)url{
    
    
}
- (void)startAll{
    
    
}

- (void)pause:(id)url{
    
    
}
- (void)pauseAll{
    
    
}

- (void)resume:(id)url{
    
    
}
- (void)resumeAll{
    
    
}

/**
 *  是否有足够的空间
 *
 *  @return ImageDownloaderSpace
 */
- (ImageDownloaderSpace)hasEnoughSpace{
    
    return ImageDownloaderSpaceRich;
}

- (long long)remainSpace{
    
    struct statfs buf;
    long long freespace = 0;
    if (statfs("/", &buf) >= 0) {
        freespace = (long long)buf.f_bsize * buf.f_blocks;
    }
    if (statfs("/private/var", &buf) >= 0) {
        freespace += (long long)buf.f_bsize * buf.f_blocks;
    }
    
    return freespace;
}


- (NSMutableArray *)currentDownloadingArray
{
    return self.downloadingArray;
}

#pragma mark - 重组进度块
-(void(^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))getNewProgressBlockWithCacheLength:(long long)cachLength
{
    typeof(self)newSelf = self;
    void(^newProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        
        NSString *cachePath;
        
        NSData* data = [NSData dataWithContentsOfFile:cachePath];
        
        [self.requestOperation setValue:data forKey:@"responseData"];
        
        newSelf.progressBlock(bytesRead,totalBytesRead + cachLength,totalBytesExpectedToRead + cachLength);
    };
    
    return newProgressBlock;
}



@end
