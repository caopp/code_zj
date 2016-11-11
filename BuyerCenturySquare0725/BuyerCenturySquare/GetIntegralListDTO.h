//
//  GetIntegralListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetIntegralListDTO : BasicDTO

/**
 *  获取小B消费积分记录查询列表信息(IntegralDTO)
 */
@property(nonatomic,strong)NSMutableArray *integralDTOList;

@end
