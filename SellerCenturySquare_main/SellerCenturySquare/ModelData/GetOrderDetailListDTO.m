//
//  GetOrderDetailListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderDetailListDTO.h"

@implementation GetOrderDetailListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.getOrderDetailDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

@end
