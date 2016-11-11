//
//  ConsigneeGetListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ConsigneeGetListDTO.h"

@implementation ConsigneeGetListDTO
- (id)init{
    self = [super init];
    if (self) {
        self.list = [[NSMutableArray alloc]init];
    }
    
    return self;
}
@end
