//
//  BasicSkuDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface BasicSkuDTO : BasicDTO

@property (nonatomic, strong)NSString* skuNo;
@property (nonatomic, strong)NSString* skuName;
@property (nonatomic, assign)NSInteger sort;
//未达到起批量，需要添加的数量
@property (nonatomic ,assign) NSInteger totalNub;


@end
