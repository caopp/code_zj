//
//  DelImgDownloadDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

/**
 *  图片下载id
 */
@interface IDDTO : BasicDTO

/**
 *  图片下载历史ID
 */
@property(nonatomic,strong)NSNumber* ID;

@end

@interface DelImgDownloadDTO : BasicDTO

/**
 *  商家编号
 */
@property(nonatomic,copy)NSString* merchantNo;
/**
 *  阶梯价格数组(IDDTO)
 */
@property(nonatomic,strong)NSMutableArray *IDDTOList;

@end
