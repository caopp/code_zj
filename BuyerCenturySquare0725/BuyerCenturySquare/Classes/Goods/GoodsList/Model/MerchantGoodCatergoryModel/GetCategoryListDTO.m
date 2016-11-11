//
//  GetCategoryListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetCategoryListDTO.h"

@implementation GetCategoryListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.getCategoryDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
@end
