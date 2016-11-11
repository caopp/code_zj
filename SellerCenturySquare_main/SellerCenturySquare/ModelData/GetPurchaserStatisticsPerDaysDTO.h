//
//  GetPurchaserStatisticsPerDaysDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetPurchaserStatisticsPerDaysDTO : BasicDTO
@property(nonatomic,copy) NSString* betweenTime;
@property(nonatomic,strong)NSNumber* memberNum;
@property(nonatomic,strong)NSArray* salesStatisticsDTOList;
@end

@interface SalesStatisticsDTO : BasicDTO
@property(nonatomic,copy) NSString* memberNo;
@property(nonatomic,copy) NSString* memberName;
@property(nonatomic,copy) NSString* mobile;
@property(nonatomic,strong)NSNumber* amount;
@property(nonatomic,copy) NSString* provinceName;
@property(nonatomic,copy) NSString* cityName;
@property(nonatomic,copy) NSString* countryName;
@property(nonatomic,copy) NSString* detailAddress;
@property(nonatomic,strong) NSNumber* sort;

@end