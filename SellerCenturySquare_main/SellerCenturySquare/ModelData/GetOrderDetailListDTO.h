//
//  GetOrderDetailListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetOrderDetailListDTO : BasicDTO

/**
 * 采购单详情列表
 */
@property(nonatomic,strong)NSMutableArray *getOrderDetailDTOList;

@end
