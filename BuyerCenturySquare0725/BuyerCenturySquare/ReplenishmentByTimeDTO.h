//
//  ReplenishmentByTimeDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ReplenishmentByTimeDTO : BasicDTO

@property(nonatomic,strong)NSMutableArray *goodsList;

- (NSArray*)goodsListForAddingCart;

@end
