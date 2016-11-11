//
//  MerchantHotLabelDTO.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/28.
//  Copyright © 2016年 pactera. All rights reserved.
//!热门标签

#import "BasicDTO.h"

@interface MerchantHotLabelDTO : BasicDTO

//!标签分类名称
@property(nonatomic,strong)NSString * labelCategory;

//!分类编码
@property(nonatomic,strong)NSString * categoryNo;


//!标签集合
@property(nonatomic,strong)NSArray * list;

//!排序字段
@property(nonatomic,strong)NSNumber * sort;


@end
