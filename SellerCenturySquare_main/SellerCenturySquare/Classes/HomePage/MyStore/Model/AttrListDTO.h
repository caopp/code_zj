//
//  AttrListDTO.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface AttrListDTO : BasicDTO
/**
 *  规格ID
 */
@property(nonatomic,strong)NSNumber *id;
/**
 *  规格 名称
 */
@property(nonatomic,strong)NSString *attrName;
/**
 *  规格 值
 */
@property(nonatomic,strong)NSString *attrValText;
@end
