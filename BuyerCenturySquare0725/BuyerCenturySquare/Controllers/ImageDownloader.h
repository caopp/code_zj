//
//  ImageDownloader.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DTOPROTOCOL.h"

#import "AFNetworking.h"
#import "PictureDTO.h"

typedef NS_ENUM(NSInteger, ImageDownloaderStatus) {
    
    ImageDownloaderStatusAddSuccess = 1,
    ImageDownloaderStatusDownloading = 2,
    ImageDownloaderStatusHasDownloaded =3,
    
    ImageDownloaderStatusSpaceRich = 4,
    ImageDownloaderStatusSpaceLess =5,
};

typedef NS_ENUM(NSInteger, ImageDownloaderSpace) {
    
    ImageDownloaderSpaceRich = 1,
    ImageDownloaderSpaceLess =2,
};

@protocol imageDownloaderDelegate <NSObject>

- (void)imagedownloadManagerDidProgress:(float)progress;
- (void)imagedownloadManagerDidFinish:(BOOL)success response:(id)response;

@end



@interface ImageDownloader : NSObject

/**
 *  The imageDownloaderTimeout value (in seconds) for the download operation. Default: 15.0.
 */
@property (assign, nonatomic) NSTimeInterval imageDownloaderTimeout;

/**
 * Shows the current amount of downloads that still need to be downloaded
 */
@property (readonly, nonatomic) NSUInteger currentDownloadCount;

/**
 *  <#Description#>
 */
@property (strong, nonatomic) AFHTTPRequestOperation* requestOperation;

/**
 *  下载进度跟踪Block.
 */
@property(nonatomic , copy) void(^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);


@property (nonatomic,assign)id<imageDownloaderDelegate>delegate;


-(void)addToDownloadingArray:(NSMutableArray *)downloadingArray;


+ (instancetype)shareInstance;

- (ImageDownloaderStatus)downloadImages:(id<DTOPROTOCOL>)value;
- (void)downloadImageWithoutStatusReturn:(id<DTOPROTOCOL>)value;



#pragma mark -
#pragma mark 下载实现函数.
- (void)downloadImageWithImageURL:(id)urlValue;

- (void)downloadImageWithImageURL:(id)urlValue progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark -
#pragma mark 暂停，开始，取消
- (void)cancel:(id)url;
- (void)cancelAll;

- (void)start:(id)url;
- (void)startAll;

- (void)pause:(id)url;
- (void)pauseAll;

- (void)resume:(id)url;
- (void)resumeAll;

/**
 *  是否有足够的空间
 *
 *  @return ImageDownloaderSpace
 */
- (ImageDownloaderSpace)hasEnoughSpace;

- (long long)remainSpace;

- (NSMutableArray *)currentDownloadingArray;

@end
