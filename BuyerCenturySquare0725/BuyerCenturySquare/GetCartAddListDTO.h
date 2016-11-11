//
//  GetCartAddListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetCartAddListDTO : BasicDTO

/**
 *  获取加入采购车列表信息(CartAddDTO)
 */
@property(nonatomic,strong)NSMutableArray *cartAddDTOList;

@end
