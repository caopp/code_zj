//
//  GetCartConfirmListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetCartConfirmListDTO : BasicDTO

/**
 *  获取采购单确认列表信息(CartConfirmDTO)
 */
@property(nonatomic,strong)NSMutableArray *cartConfirmDTOList;
@end
