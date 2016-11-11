//
//  GoodsCollectionByMerchantDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CollectionMerchant : BasicDTO

@property (nonatomic, strong) NSString* merchantNo;
@property (nonatomic, strong) NSString* merchantName;
@property (nonatomic, strong) NSMutableArray* goodsList;

@end

@interface GoodsCollectionByMerchantDTO : BasicDTO

@property (nonatomic, strong) NSMutableArray* merchantList;

@end
