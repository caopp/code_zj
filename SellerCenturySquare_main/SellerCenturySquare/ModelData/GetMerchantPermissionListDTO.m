//
//  GetMerchantPermissionListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMerchantPermissionListDTO.h"

@implementation GetMerchantPermissionListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.merchantPermissionDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

@end
