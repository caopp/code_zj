//
//  GetDownloadImageListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetDownloadImageListDTO.h"

@implementation GetDownloadImageListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.downloadImageDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

@end
