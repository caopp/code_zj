//
//  DownloadImageDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"


@interface DownloadImageDTO : BasicDTO
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;

/**
 *  获取下载图片列表信息包含PictureDTO对象
 */
@property(nonatomic,strong)NSMutableArray *pictureDTOList;


@end
