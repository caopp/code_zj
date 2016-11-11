//
//  ImageHistoryDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface HistoryPictureDTO2 : BasicDTO
@property(nonatomic,copy)NSString *goodsNO;

/**
 *  图片类型0窗口图,1客观图
 */
@property(nonatomic,copy)NSString* picType;

/**
 *数量
 */
@property(nonatomic,strong)NSNumber* picNum;

/**
 *图片大小(kb)
 */
@property(nonatomic,strong)NSNumber* picSize;
/**
 *下载次数
 */
@property(nonatomic,strong)NSNumber* count;

@end

@interface ImageHistoryDTO : BasicDTO
/**
 *  商品主图url
 */
@property(nonatomic,copy)NSString* picUrl;

/**
 *  商品编码
 */
@property(nonatomic,copy)NSString* goodsNo;

/**
 * 图片类型(HistoryPictureDTO)
 */
@property(nonatomic,strong)NSMutableArray *historyPictureDTOList;

@end


@interface DownloadHistoryDTO : BasicDTO

@property(nonatomic,strong)NSNumber *totalCount;

@property(nonatomic,strong)NSMutableArray *list;

@end
