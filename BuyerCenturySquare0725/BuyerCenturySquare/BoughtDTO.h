//
//  BoughtDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface BoughtDTO : BasicDTO

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString* merchantNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString* merchantName;
/**
 *  商家图片url
 */
@property(nonatomic,copy)NSString* picUrl;

/**
 *  分类编码
 */
@property(nonatomic,copy)NSString *categoryNo;

/**
 *  商品类别名称
 */
@property(nonatomic,copy)NSString* categoryName;

/**
 *  3日内上架商品数量(类型为int)
 */
@property(nonatomic,strong)NSNumber* goodsNum;

@property(nonatomic,strong)NSString* stallNo;

@end
