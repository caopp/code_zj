//
//  GetOrderDetailListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetOrderDetailListDTO : BasicDTO
/**
 *  获取采购单详情列表信息(OrderDetailDTO)
 */
@property(nonatomic,strong)NSMutableArray *orderDetailDTOList;

@end
