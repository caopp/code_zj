//
//  ConsigneeGetListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ConsigneeGetListDTO : BasicDTO
/**
 *  数组包含了ConsigneeDTO对象
 */
@property(nonatomic,strong)NSMutableArray *list;
@end
