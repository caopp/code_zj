//
//  SampleSkuInfoDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface SampleSkuInfoDTO : BasicDTO

/**
 *  Sku编码(商品编码+99)
 */
@property(nonatomic,copy)NSString* skuNo;

/**
 *  库存(固定为1,int)
 */
@property(nonatomic,strong)NSNumber* skuStock;
/**
 *  样板价(Double)
 */
@property(nonatomic,strong)NSNumber* price;

@end
