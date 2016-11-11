//
//  GetConsigneeListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@class ConsigneeDTO;

@interface GetConsigneeListDTO : BasicDTO

/**
 *  获取查询收货地址列表信息(ConsigneeDTO)
 */
@property(nonatomic,strong)NSMutableArray *consigneeDTOList;

// 存放实体的ConsigneeDTO对象
@property(nonatomic,strong)NSMutableArray *consigneeList;

- (ConsigneeDTO*)defaultConsignee;

@end
