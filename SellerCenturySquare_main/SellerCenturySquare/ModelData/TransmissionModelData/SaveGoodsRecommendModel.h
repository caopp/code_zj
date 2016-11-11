//
//  SaveGoodsRecommendModel.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface SaveGoodsRecommendModel : BasicDTO

/**
 *  推荐商品数量(类型:int)
 */
@property(nonatomic,strong)NSNumber* goodsNum;
/**
 *  推荐人数量(类型:int)
 */
@property(nonatomic,strong)NSNumber* memberNum;

/**
 *  推荐内容
 */
@property(nonatomic,copy)NSString* content;

/**
 *  推荐商品编码
 */
@property(nonatomic,copy)NSString *goodsNos;

/**
 *  收件人编码
 */
@property(nonatomic,copy)NSString *memberNos;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@end
