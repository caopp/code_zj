//
//  GetGoodsCategoryListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetGoodsCategoryListDTO.h"

@implementation GetGoodsCategoryListDTO

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.goodsCategoryDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
@end
