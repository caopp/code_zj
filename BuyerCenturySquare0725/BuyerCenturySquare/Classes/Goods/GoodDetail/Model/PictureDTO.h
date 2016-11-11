//
//  PictureDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface PictureDTO : BasicDTO

/**
 *  压缩图片路径
 */
@property(nonatomic,copy)NSString *zipUrl;
/**
 *  0:窗口图1:客观图
 */
@property(nonatomic,copy)NSString *picType;
/**
 *  数量
 */
@property(nonatomic,copy)NSString *qty;

/**
 *  图片大小(int 单位 (kb))
 */
@property(nonatomic,strong)NSNumber *picSize;

@end
