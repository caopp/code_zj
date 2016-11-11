//
//  GetCartListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetCartListDTO : BasicDTO
/**
 *  获取采购车列表信息(CartDTO)
 */
@property(nonatomic,strong)NSMutableArray *cartDTOList;
@end
