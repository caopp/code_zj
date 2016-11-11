//
//  GetOrderListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderListDTO.h"

@implementation GetOrderListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.getOrderDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
@end
