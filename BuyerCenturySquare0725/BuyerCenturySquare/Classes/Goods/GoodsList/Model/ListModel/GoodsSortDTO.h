//
//  GoodsSortDTO.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/9/28.
//  Copyright © 2016年 pactera. All rights reserved.
//  商品排序、筛选的DTO

#import <Foundation/Foundation.h>

static NSString * orderBydesc = @"desc";
static NSString * orderByasc = @"asc";



@interface GoodsSortDTO : NSObject

//!上新时间 -15:15天内，15:15天前，20:20天前，30:30天前
@property(nonatomic,strong)NSString * upDayNum;

//!价格区间最小价格
@property(nonatomic,strong)NSString * minPrice;

//!价格区间最大价格
@property(nonatomic,strong)NSString * maxPrice;

//!排序 1按时间，2按销量，3按价格
@property(nonatomic,strong)NSString * orderByField;

//!desc降序 asc 升序
@property(nonatomic,strong)NSString * orderBy;



@end
