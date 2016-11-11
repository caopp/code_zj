//
//  ImgDownloadDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface PictureDTO : BasicDTO
/**
 *  图片路径
 */
@property(nonatomic,copy)NSString *picUrl;
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  0:窗口图1:客观图
 */
@property(nonatomic,copy)NSString *picType;
/**
 *  图片名称
 */
@property(nonatomic,copy)NSString *picName;
/**
 *  图片大小(int 单位 (kb))
 */
@property(nonatomic,strong)NSNumber *picSize;

@end

@interface ImgDownloadDTO : BasicDTO
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  图片类型 :0窗口图，1客观图
 */
@property(nonatomic,copy)NSString *picType;
/**
 *  图片总大小(double)
 */
@property(nonatomic,strong)NSNumber *picSize;
/**
 *  数量
 */
@property(nonatomic,copy)NSString *qty;

/**
 * 图片列表(PictureDTO)
 */
@property(nonatomic,strong)NSMutableArray *pictureDTOList;

@end
