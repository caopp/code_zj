//
//  UpLoadPhotosViewController.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 15/12/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BussinessAreaController.h"
@protocol UpLoadPhotosDelegate <NSObject>

/**
 *  暂无用处
 *
 *  @param url 传递URL
 */
- (void)UpLoadPhotosUrl:(NSString *)url;
/**
 *  如果发布成功则调用此方法
 *
 *  @param isLoading yes：不刷新，no:刷新主页
 */
- (void)UpLoadPhotosLoading:(BOOL)isLoading;

@end

@interface UpLoadPhotosViewController : BaseViewController

@property (nonatomic ,strong) NSString *releaseType;
@property (nonatomic ,assign) id<UpLoadPhotosDelegate>delegate;

//show显示引导页， hide隐藏引导页
@property (nonatomic ,copy) NSString *mark;

@end

