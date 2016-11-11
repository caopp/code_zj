//
//  GetOrderSalesPerDaysDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetOrderSalesPerDaysDTO : BasicDTO

//开始时间
@property(nonatomic,copy)NSString* beginTime;
//结束时间
@property(nonatomic,copy)NSString* endTime;
//总金额
@property(nonatomic,strong)NSNumber* totalAmount;
//总数量
@property(nonatomic,strong)NSNumber* totalNum;
//销量数组
@property(nonatomic,strong)NSArray *salesDTOList;

@end

@interface SalesDTO : BasicDTO

//日期
@property(nonatomic,copy)NSString* createTime;
//金额总量
@property(nonatomic,strong)NSNumber* totalAmount;
//采购单量
@property(nonatomic,strong)NSNumber* orders;
@end