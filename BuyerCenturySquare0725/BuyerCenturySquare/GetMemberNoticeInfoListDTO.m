//
//  GetMemberNoticeInfoListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberNoticeInfoListDTO.h"

@implementation GetMemberNoticeInfoListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.memberNoticeInfoDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}


@end
