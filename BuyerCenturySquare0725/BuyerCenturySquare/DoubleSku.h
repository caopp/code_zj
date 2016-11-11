//
//  DoubleCounterSku.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicSkuDTO.h"

@class SingleSku;

@interface DoubleSku : BasicSkuDTO

@property (nonatomic, assign)NSInteger spotValue;
@property (nonatomic, assign)NSInteger futureValue;

- (id)initWithSingleSku:(SingleSku*)singleSku;

@end
