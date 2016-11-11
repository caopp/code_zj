//
//  GetDownloadImageListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  !商品图片下载

#import "BasicDTO.h"

@interface GetDownloadImageListDTO : BasicDTO

/**
 *  获取下载图片列表信息包含DownloadImageDTO对象
 */
@property(nonatomic,strong)NSMutableArray *downloadImageDTOList;

@end
