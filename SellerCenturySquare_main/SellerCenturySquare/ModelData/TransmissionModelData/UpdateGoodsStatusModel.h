//
//  UpdateGoodsStatusModel.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface UpdateGoodsStatusModel : BasicDTO

/**
 *  商品编码(必填(多个编码之间用逗号隔开))
 */
@property(nonatomic,copy)NSString* goodsNo;

/**
 *  商品状态()
 */
@property(nonatomic,copy)NSString* goodsStatus;


@end
