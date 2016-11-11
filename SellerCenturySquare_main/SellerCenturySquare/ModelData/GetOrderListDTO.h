//
//  GetOrderListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicDTO.h"

@interface GetOrderListDTO : BasicDTO

/**
 *  采购单列表
 */
@property(nonatomic,strong)NSMutableArray *getOrderDTOList;

@end
