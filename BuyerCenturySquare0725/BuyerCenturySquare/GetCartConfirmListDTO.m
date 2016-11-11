//
//  GetCartConfirmListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetCartConfirmListDTO.h"

@implementation GetCartConfirmListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.cartConfirmDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}


@end
