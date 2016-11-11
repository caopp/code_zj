//
//  DelImgDownloadDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "DelImgDownloadDTO.h"

@implementation DelImgDownloadDTO
- (id)init{
    self = [super init];
    if (self) {
        self.IDDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
@end
