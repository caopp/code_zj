//
//  wholesaleConditionDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface SaleMerchantCondition : BasicDTO

@property(nonatomic, strong)NSString* merchantNo;
@property(nonatomic, strong)NSString* isSatisfy;
@property(nonatomic, strong)NSString* batchNumFlag;
@property(nonatomic, assign)NSInteger batchNumLimit;
@property(nonatomic, strong)NSString* batchAmountFlag;
@property(nonatomic, assign)CGFloat   batchAmountLimit;

- (BOOL)isMerchantSatisfy;

@end

@interface WholeSaleConditionDTO : BasicDTO

@property (nonatomic) NSMutableArray* merchantList;

- (BOOL)isAllMerchantsSatisfy;

@end
