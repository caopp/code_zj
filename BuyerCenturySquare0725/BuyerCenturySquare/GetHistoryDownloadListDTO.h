//
//  GetHistoryDownloadListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetHistoryDownloadListDTO : BasicDTO

/**
 *  总数量(类型为int)
 */
@property(nonatomic,strong)NSNumber* totalCount;
/**
 *  获取下载历史查询列表信息(HistoryDownloadDTO)
 */
@property(nonatomic,strong)NSMutableArray *historyDownloadDTOList;

@end
