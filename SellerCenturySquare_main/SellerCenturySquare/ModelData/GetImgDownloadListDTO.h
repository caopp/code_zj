//
//  GetImgDownloadListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
//  3.20	大B商品下载图片列表接口
#import "BasicDTO.h"

@interface GetImgDownloadListDTO : BasicDTO
/**
 *  返回大B商品下载列表明细信息(ImgDownloadListDTO)
 */
@property(nonatomic,strong)NSMutableArray *imgDownloadListDTOList;
@end
