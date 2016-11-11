//
//  GetPortalStatisticsDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetPortalStatisticsDTO : BasicDTO

//最近3天销售总金额
@property(nonatomic,strong) NSNumber* threeDaysStatistics;
//最近7天销售总金额
@property(nonatomic,strong) NSNumber* sevenDayStatistics;
//最近30天销售总金额
@property(nonatomic,strong) NSNumber* thirtyDaysStatistics;
//总金额
@property(nonatomic,strong) NSNumber* allDaysStatistics;

//采购商排行
@property(nonatomic,strong) NSArray* memberDTOList;

//单商品销量数组
@property(nonatomic,strong) NSArray* goodsSellDTOList;

@end
