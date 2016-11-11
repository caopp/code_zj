//
//  GetRestockedListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetRestockedListDTO.h"
#import "RestockedDTO.h"


@implementation GetRestockedListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.restockedDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

@end
