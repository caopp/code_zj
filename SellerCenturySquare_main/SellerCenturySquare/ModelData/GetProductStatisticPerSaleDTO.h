//
//  GetProductStatisticPerSaleDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetProductStatisticPerSaleDTO : BasicDTO

@property(nonatomic,copy)NSString* goodsName;
@property(nonatomic,copy)NSString* goodsNo;
@property(nonatomic,copy)NSString* picUrl;
@property(nonatomic,copy)NSString* goodsWillNo;
@property(nonatomic,copy)NSString* color;
@property(nonatomic,strong)NSNumber* price;
@property(nonatomic,strong)NSNumber* totalAmount;
@property(nonatomic,strong)NSNumber* totalQuantity;

@end
