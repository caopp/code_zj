//
//  GetCartAddListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetCartAddListDTO.h"

@implementation GetCartAddListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.cartAddDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
@end
