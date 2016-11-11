//
//  GetImageHistoryListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//3.22	大B商品图片下载历史查询接口
#import "BasicDTO.h"

@interface GetImageHistoryListDTO : BasicDTO
/**
 *  总数量
 */
@property(nonatomic,copy)NSString *totalCount;
/**
 *  下载列表明细(ImageHistoryDTO)
 */
@property(nonatomic,strong)NSMutableArray *imageHistoryDTOList;
@end
