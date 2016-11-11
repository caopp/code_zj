//
//  PhotoPreviewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/31.
//  Copyright © 2015年 pactera. All rights reserved.
// !图片预览

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PhotoPreviewController : BaseViewController

//!点击的是第几个图片进入的
@property(nonatomic,assign)NSInteger intoNum;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,copy) void (^delegateBlock)();


@end
