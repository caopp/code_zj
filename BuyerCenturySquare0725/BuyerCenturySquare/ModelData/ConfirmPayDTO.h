//
//  ConfirmPayDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ConfirmPayDTO : BasicDTO

@property(nonatomic,strong)NSNumber *totalAmount;
@property(nonatomic,copy) NSString *tradeNo;

@end
