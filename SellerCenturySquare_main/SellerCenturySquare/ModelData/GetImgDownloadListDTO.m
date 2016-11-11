//
//  GetImgDownloadListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetImgDownloadListDTO.h"

@implementation GetImgDownloadListDTO
- (id)init{
    self = [super init];
    if (self) {
        self.imgDownloadListDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
@end
