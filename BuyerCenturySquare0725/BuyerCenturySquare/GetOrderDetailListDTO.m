//
//  GetOrderDetailListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderDetailListDTO.h"

@implementation GetOrderDetailListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.orderDetailDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}


@end
