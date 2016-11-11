//
//  CartStatisticalListDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/5/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@class CartMerchant;

@interface CartStatisticalMerchant : BasicDTO

@property(nonatomic, strong)NSString* merchantNo;
@property(nonatomic, assign)NSInteger quantity;
@property(nonatomic, assign)CGFloat   amount;

- (id)initWithCartMerchantInfo:(CartMerchant*)merchantInfo;

@end

@interface CartStatisticalListDTO : BasicDTO

@property (nonatomic) NSMutableArray* merchantList;

- (NSArray*)converterToCartStatisticalDictionaryList;

@end
